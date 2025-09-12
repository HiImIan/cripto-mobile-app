import 'package:brasilcripto/app/data/repositories/crypto_repository.dart';
import 'package:brasilcripto/app/data/repositories/favorites_respository.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:flutter/material.dart';

// Extension to remove duplicates by ID
extension CryptoListExtensions on List<Crypto> {
  List<Crypto> get uniqueById {
    Map<String, Crypto> uniqueMap = {};
    for (Crypto crypto in this) {
      uniqueMap[crypto.id] = crypto;
    }
    return uniqueMap.values.toList();
  }

  void addUniqueById(Crypto crypto) {
    if (!any((c) => c.id == crypto.id)) {
      add(crypto);
    }
  }

  void addAllUniqueById(List<Crypto> cryptos) {
    for (Crypto crypto in cryptos) {
      addUniqueById(crypto);
    }
  }
}

class CryptosViewModel extends ChangeNotifier {
  final CryptoRepository _cryptoRepository;
  final FavoritesRepository _favoritesRepository;

  // Internal state
  final List<Crypto> _cryptos = [];
  final List<Crypto> _searchedCryptos = [];
  int _currentPage = 0;
  bool _isLoading = false;
  String? _error;

  final TextEditingController searchController;

  // Public getters
  List<Crypto> get cryptos => _searchedCryptos.isNotEmpty
      ? List.unmodifiable(_searchedCryptos)
      : List.unmodifiable(_cryptos);
  List<Crypto> get favoriteCryptos =>
      cryptos.where((crypto) => crypto.isFavorite).toList();

  bool get isLoading => _isLoading;
  bool get hasMoreItems => cryptos.isEmpty || _currentPage != -1;
  bool get hasSearchResults => _searchedCryptos.isNotEmpty;
  String? get error => _error;
  int get favoritesCount => favoriteCryptos.length;
  List<String> get favoriteIds => favoriteCryptos.map((c) => c.id).toList();

  CryptosViewModel({
    required CryptoRepository cryptoRepository,
    required FavoritesRepository favoritesRepository,
  }) : _cryptoRepository = cryptoRepository,
       _favoritesRepository = favoritesRepository,
       searchController = TextEditingController();

  //=======================================================
  //---------------- Main Methods -------------------------
  //=======================================================

  /// Loads more cryptos (pagination)
  Future<void> loadMore() async {
    if (_shouldSkipLoad()) return;

    await _performLoad();
  }

  /// Updates the complete list (refresh)
  Future<void> refresh() async {
    _resetState();
    await _performLoad();
  }

  /// Toggles favorite status of a crypto
  Future<void> toggleFavorite(String cryptoId) async {
    final index = _findCryptoIndex(cryptoId);
    if (index == -1) return;

    final currentCrypto = cryptos[index];
    final isCurrentlyFavorite = await _favoritesRepository.isFavorite(cryptoId);

    if (isCurrentlyFavorite) {
      await _removeFavorite(cryptoId, index, currentCrypto);
    } else {
      await _addFavorite(cryptoId, index, currentCrypto);
    }

    // Also update in filtered list if it exists
    _updateFilteredCryptoFavoriteStatus(cryptoId, !isCurrentlyFavorite);

    notifyListeners();
  }

  /// Removes all favorites
  Future<void> deleteAllFavorites() async {
    await _favoritesRepository.clearAllFavorites();
    _updateAllCryptosAsFavorite(false);

    // Also update filtered list
    _updateAllFilteredCryptosAsFavorite(false);

    notifyListeners();
  }

  //=======================================================
  //---------------- Search Methods ----------------------
  //=======================================================

  /// Searches cryptos from API by name/ID or symbol
  Future<void> searchCryptos() async {
    final query = searchController.text;
    if (query.isEmpty) {
      clearSearchResults();
      return;
    }

    if (_isLoading) return;

    _setLoadingState(true);

    // First, search locally
    final localResults = _filterCryptosByQuery(_cryptos, query);
    _searchedCryptos.clear();
    _searchedCryptos.addAll(localResults);

    // Then search from API
    final search = await _cryptoRepository.search(query);
    late final List<String> searchedCryptosId;
    search.fold((error) => _error = error.message, (searchedCryptos) async {
      // Extrai apenas os IDs dos resultados da API
      searchedCryptosId = searchedCryptos.map((c) => c.id).toList();
    });

    final result = await _cryptoRepository.get(ids: searchedCryptosId);

    result.fold((error) => _error = error.message, (cryptos) {
      _searchedCryptos.addAllUniqueById(cryptos);

      // Sync favorites status for search results
    });
    await _syncSearchResultsFavorites();
    _setLoadingState(false);
  }

  /// Searches cryptos locally by name or symbol
  void searchByName(String query) {
    if (query.isEmpty) {
      refresh();
      return;
    }
    _searchedCryptos.clear();
    _searchedCryptos.addAll(_filterCryptosByQuery(_cryptos, query));
    notifyListeners();
  }

  /// Searches only favorites by name or symbol
  List<Crypto> searchFavoritesByName(String query) {
    if (query.isEmpty) return favoriteCryptos;
    return _filterCryptosByQuery(favoriteCryptos, query);
  }

  /// Clears search results and shows all cryptos
  void clearSearchResults() {
    _searchedCryptos.clear();
    notifyListeners();
  }

  //=======================================================
  //---------------- State Queries -----------------------
  //=======================================================

  /// Checks if a crypto is in favorites
  bool isCryptoFavorite(String cryptoId) {
    final crypto = _findCrypto(cryptoId);
    return crypto?.isFavorite ?? false;
  }

  /// Searches for a specific crypto by ID
  Crypto? getCrypto(String cryptoId) => _findCrypto(cryptoId);

  /// Searches for a specific favorite crypto
  Crypto? getFavoriteCrypto(String cryptoId) {
    return favoriteCryptos.where((c) => c.id == cryptoId).firstOrNull;
  }

  //=======================================================
  //---------------- Private Methods ---------------------
  //=======================================================

  /// Checks if loading should be skipped
  bool _shouldSkipLoad() => _isLoading || _currentPage == -1;

  /// Resets state for refresh
  void _resetState() {
    _currentPage = 0;
    _cryptos.clear();
    _searchedCryptos.clear();
    _error = null;
  }

  /// Executes main loading process
  Future<void> _performLoad() async {
    _setLoadingState(true);

    try {
      final newCryptos = await _fetchNewCryptos();
      if (newCryptos.isEmpty) {
        _currentPage = -1;
        return;
      }

      await _processAndUpdateCryptos(newCryptos);
    } catch (e) {
      _error = 'Unexpected error: $e';
    } finally {
      _setLoadingState(false);
    }
  }

  /// Fetches new cryptos from API
  Future<List<Crypto>> _fetchNewCryptos() async {
    _currentPage += 1;
    final result = await _cryptoRepository.get(page: _currentPage);

    return result.fold((error) {
      _error = error.message;
      return <Crypto>[];
    }, (cryptos) => cryptos);
  }

  /// Processes and updates list with new cryptos
  Future<void> _processAndUpdateCryptos(List<Crypto> newCryptos) async {
    // Adds new cryptos without duplicates
    _cryptos.addAllUniqueById(newCryptos);

    // Loads and syncs favorites
    await _syncFavoritesWithRepository();

    // Removes final duplicates
    _removeDuplicatesFromList();
  }

  /// Syncs favorites status with repository
  Future<void> _syncFavoritesWithRepository() async {
    // Loads saved favorites and adds to list
    await _loadSavedFavorites();

    // Updates status of all cryptos
    final favoriteIds = await _favoritesRepository.getAllFavorites();
    final favoriteIdsSet = Set<String>.from(favoriteIds);

    _updateCryptosWithFavoriteStatus(favoriteIdsSet);
  }

  /// Loads saved favorites from API
  Future<void> _loadSavedFavorites() async {
    final favoriteIds = await _favoritesRepository.getAllFavorites();
    if (favoriteIds.isEmpty) return;

    final result = await _cryptoRepository.get(ids: favoriteIds);

    result.fold((error) => _error = error.message, (favoriteCryptos) {
      final favoritesWithFlag = favoriteCryptos
          .map((crypto) => crypto.copyWith(isFavorite: true))
          .toList();
      _cryptos.addAllUniqueById(favoritesWithFlag);
    });
  }

  /// Updates favorite status based on ID set
  void _updateCryptosWithFavoriteStatus(Set<String> favoriteIds) {
    for (int i = 0; i < _cryptos.length; i++) {
      final isFavorite = favoriteIds.contains(_cryptos[i].id);
      _cryptos[i] = _cryptos[i].copyWith(isFavorite: isFavorite);
    }

    // Also sync the filtered list if it has items
    _syncFilteredCryptosWithMainList();
  }

  /// Removes duplicates from main list
  void _removeDuplicatesFromList() {
    final uniqueCryptos = _cryptos.uniqueById;
    _cryptos.clear();
    _cryptos.addAll(uniqueCryptos);
  }

  /// Sets loading state
  void _setLoadingState(bool loading) {
    _isLoading = loading;
    if (loading) _error = null;
    notifyListeners();
  }

  /// Finds crypto index in the list
  int _findCryptoIndex(String cryptoId) {
    return cryptos.indexWhere((crypto) => crypto.id == cryptoId);
  }

  /// Finds crypto by ID
  Crypto? _findCrypto(String cryptoId) {
    try {
      return cryptos.firstWhere((c) => c.id == cryptoId);
    } catch (e) {
      return null;
    }
  }

  /// Adds crypto to favorites
  Future<void> _addFavorite(String cryptoId, int index, Crypto crypto) async {
    await _favoritesRepository.addToFavorites(cryptoId);
    if (hasSearchResults) {
      _searchedCryptos[index] = crypto.copyWith(isFavorite: true);
      return;
    }
    _cryptos[index] = crypto.copyWith(isFavorite: true);
  }

  /// Removes crypto from favorites
  Future<void> _removeFavorite(
    String cryptoId,
    int index,
    Crypto crypto,
  ) async {
    await _favoritesRepository.removeFromFavorites(cryptoId);
    if (hasSearchResults) {
      _searchedCryptos[index] = crypto.copyWith(isFavorite: false);
      return;
    }
    _cryptos[index] = crypto.copyWith(isFavorite: false);
  }

  /// Updates all cryptos with a favorite status
  void _updateAllCryptosAsFavorite(bool isFavorite) {
    for (int i = 0; i < _cryptos.length; i++) {
      if (_cryptos[i].isFavorite != isFavorite) {
        _cryptos[i] = _cryptos[i].copyWith(isFavorite: isFavorite);
      }
    }
  }

  /// Updates all filtered cryptos with a favorite status
  void _updateAllFilteredCryptosAsFavorite(bool isFavorite) {
    for (int i = 0; i < _searchedCryptos.length; i++) {
      if (_searchedCryptos[i].isFavorite != isFavorite) {
        _searchedCryptos[i] = _searchedCryptos[i].copyWith(
          isFavorite: isFavorite,
        );
      }
    }
  }

  /// Updates favorite status of a specific crypto in filtered list
  void _updateFilteredCryptoFavoriteStatus(String cryptoId, bool isFavorite) {
    final filteredIndex = _searchedCryptos.indexWhere(
      (crypto) => crypto.id == cryptoId,
    );
    if (filteredIndex != -1) {
      _searchedCryptos[filteredIndex] = _searchedCryptos[filteredIndex]
          .copyWith(isFavorite: isFavorite);
    }
  }

  /// Syncs favorites status for search results
  Future<void> _syncSearchResultsFavorites() async {
    final favoriteIds = await _favoritesRepository.getAllFavorites();
    final favoriteIdsSet = Set<String>.from(favoriteIds);

    for (int i = 0; i < _searchedCryptos.length; i++) {
      final isFavorite = favoriteIdsSet.contains(_searchedCryptos[i].id);
      _searchedCryptos[i] = _searchedCryptos[i].copyWith(
        isFavorite: isFavorite,
      );
    }
  }

  /// Syncs favorite status between main and filtered lists
  void _syncFilteredCryptosWithMainList() {
    if (_searchedCryptos.isEmpty) return;

    for (int i = 0; i < _searchedCryptos.length; i++) {
      final mainCrypto = _findCrypto(_searchedCryptos[i].id);
      if (mainCrypto != null &&
          mainCrypto.isFavorite != _searchedCryptos[i].isFavorite) {
        _searchedCryptos[i] = _searchedCryptos[i].copyWith(
          isFavorite: mainCrypto.isFavorite,
        );
      }
    }
  }

  /// Filters cryptos by search query
  List<Crypto> _filterCryptosByQuery(List<Crypto> cryptoList, String query) {
    final lowerQuery = query.toLowerCase();
    return cryptoList
        .where(
          (crypto) =>
              crypto.name.toLowerCase().contains(lowerQuery) ||
              crypto.symbol.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  //=======================================================
  //---------------- Utilities/Debug ---------------------
  //=======================================================

  /// Forces favorites status update (useful for debug)
  Future<void> refreshFavoritesStatus() async {
    final favoriteIds = await _favoritesRepository.getAllFavorites();
    final favoriteIdsSet = Set<String>.from(favoriteIds);
    _updateCryptosWithFavoriteStatus(favoriteIdsSet);
    notifyListeners();
  }

  /// Debug information
  String get debugInfo =>
      '''
  Total cryptos: ${_cryptos.length}
  Filtered cryptos: ${_searchedCryptos.length}
  Favorites: $favoritesCount
  Current page: $_currentPage
  Loading: $isLoading
  Error: ${_error ?? 'None'}
  ''';

  /// Sorts cryptos with favorites first
  void sortFavoritesFirst() {
    _cryptos.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return 0;
    });

    // Also sort filtered list if it has items
    if (_searchedCryptos.isNotEmpty) {
      _searchedCryptos.sort((a, b) {
        if (a.isFavorite && !b.isFavorite) return -1;
        if (!a.isFavorite && b.isFavorite) return 1;
        return 0;
      });
    }

    notifyListeners();
  }
}
