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
  // Repositories
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
  List<Crypto> get favoriteCryptos {
    final Map<String, Crypto> uniqueFavorites = {};
    for (final crypto in _cryptos) {
      if (crypto.isFavorite) uniqueFavorites[crypto.id] = crypto;
    }
    for (final crypto in _searchedCryptos) {
      if (crypto.isFavorite) uniqueFavorites[crypto.id] = crypto;
    }
    return uniqueFavorites.values.toSet().toList();
  }

  bool get isLoading => _isLoading;
  bool get hasMoreItems => cryptos.isEmpty || _currentPage != -1;
  bool get hasSearchResults => _searchedCryptos.isNotEmpty;
  String? get error => _error;

  CryptosViewModel({
    required CryptoRepository cryptoRepository,
    required FavoritesRepository favoritesRepository,
  }) : _cryptoRepository = cryptoRepository,
       _favoritesRepository = favoritesRepository,
       searchController = TextEditingController();

  //=======================================================
  //---------------- Métodos Existentes ------------------
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

  /// Retorna informações necessárias para confirmação de remoção
  /// A View usa isso para mostrar o dialog, mas não decide a lógica
  Crypto? getRemoveFavoriteInfo(String cryptoId) {
    final crypto = _findCrypto(cryptoId);
    if (crypto == null || !crypto.isFavorite) return null;

    return crypto;
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

    _updateFilteredCryptoFavoriteStatus(cryptoId, !isCurrentlyFavorite);
    notifyListeners();
  }

  /// Removes all favorites
  Future<void> deleteAllFavorites() async {
    await _favoritesRepository.clearAllFavorites();
    _updateAllCryptosAsFavorite(false);
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

    final localResults = _filterCryptosByQuery(_cryptos, query);
    _searchedCryptos.clear();
    _searchedCryptos.addAll(localResults);

    final search = await _cryptoRepository.search(query);
    late final List<String> searchedCryptosId;
    search.fold((error) => _error = error.message, (searchedCryptos) async {
      searchedCryptosId = searchedCryptos.map((c) => c.id).toList();
    });

    final result = await _cryptoRepository.get(ids: searchedCryptosId);
    result.fold((error) => _error = error.message, (cryptos) {
      _searchedCryptos.addAllUniqueById(cryptos);
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

  /// Clears search results and shows all cryptos
  void clearSearchResults() {
    if (searchController.text.isNotEmpty) searchController.clear();
    _searchedCryptos.clear();
    notifyListeners();
  }

  //=======================================================
  //---------------- Private Methods ---------------------
  //=======================================================

  bool _shouldSkipLoad() => _isLoading || _currentPage == -1;

  void _resetState() {
    _currentPage = 0;
    _cryptos.clear();
    _searchedCryptos.clear();
    searchController.clear();
    _error = null;
  }

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

  Future<List<Crypto>> _fetchNewCryptos() async {
    _currentPage += 1;
    final result = await _cryptoRepository.get(page: _currentPage);

    return result.fold((error) {
      _error = error.message;
      return <Crypto>[];
    }, (cryptos) => cryptos);
  }

  Future<void> _processAndUpdateCryptos(List<Crypto> newCryptos) async {
    _cryptos.addAllUniqueById(newCryptos);
    await _syncFavoritesWithRepository();
    _removeDuplicatesFromList();
  }

  Future<void> _syncFavoritesWithRepository() async {
    await _loadSavedFavorites();
    final favoriteIds = await _favoritesRepository.getAllFavorites();
    final favoriteIdsSet = Set<String>.from(favoriteIds);
    _updateCryptosWithFavoriteStatus(favoriteIdsSet);
  }

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

  void _updateCryptosWithFavoriteStatus(Set<String> favoriteIds) {
    for (int i = 0; i < _cryptos.length; i++) {
      final isFavorite = favoriteIds.contains(_cryptos[i].id);
      _cryptos[i] = _cryptos[i].copyWith(isFavorite: isFavorite);
    }
    _syncFilteredCryptosWithMainList();
  }

  void _removeDuplicatesFromList() {
    final uniqueCryptos = _cryptos.uniqueById;
    _cryptos.clear();
    _cryptos.addAll(uniqueCryptos);
  }

  void _setLoadingState(bool loading) {
    _isLoading = loading;
    if (loading) _error = null;
    notifyListeners();
  }

  int _findCryptoIndex(String cryptoId) {
    return cryptos.indexWhere((crypto) => crypto.id == cryptoId);
  }

  Crypto? _findCrypto(String cryptoId) {
    try {
      return cryptos.firstWhere((c) => c.id == cryptoId);
    } catch (e) {
      return null;
    }
  }

  Future<void> _addFavorite(String cryptoId, int index, Crypto crypto) async {
    await _favoritesRepository.addToFavorites(cryptoId);
    if (hasSearchResults) {
      _searchedCryptos[index] = crypto.copyWith(isFavorite: true);
      return;
    }
    _cryptos[index] = crypto.copyWith(isFavorite: true);
  }

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

  void _updateAllCryptosAsFavorite(bool isFavorite) {
    for (int i = 0; i < _cryptos.length; i++) {
      if (_cryptos[i].isFavorite != isFavorite) {
        _cryptos[i] = _cryptos[i].copyWith(isFavorite: isFavorite);
      }
    }
  }

  void _updateAllFilteredCryptosAsFavorite(bool isFavorite) {
    for (int i = 0; i < _searchedCryptos.length; i++) {
      if (_searchedCryptos[i].isFavorite != isFavorite) {
        _searchedCryptos[i] = _searchedCryptos[i].copyWith(
          isFavorite: isFavorite,
        );
      }
    }
  }

  void _updateFilteredCryptoFavoriteStatus(String cryptoId, bool isFavorite) {
    final filteredIndex = _searchedCryptos.indexWhere(
      (crypto) => crypto.id == cryptoId,
    );
    if (filteredIndex != -1) {
      _searchedCryptos[filteredIndex] = _searchedCryptos[filteredIndex]
          .copyWith(isFavorite: isFavorite);
    }
  }

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

  void sortFavoritesFirst() {
    _cryptos.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return 0;
    });

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
