import 'package:brasilcripto/app/data/repositories/crypto_repository.dart';
import 'package:brasilcripto/app/data/repositories/favorites_respository.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:flutter/material.dart';

// Extensão para remover duplicatas por ID
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

  bool get isLoading => _isLoading;
  bool _isLoading = false;
  String? get error => _error;
  String? _error;

  final TextEditingController searchController;

  int _currentPageToRequest = 0;

  List<Crypto> get cryptos =>
      hasFilters ? _filteredCryptos : List.unmodifiable(_cryptos);
  final List<Crypto> _cryptos = [];
  bool get hasFilters => _filteredCryptos.isNotEmpty;
  final List<Crypto> _filteredCryptos = [];

  List<Crypto> get favoriteCryptos =>
      _cryptos.where((crypto) => crypto.isFavorite).toList();

  bool get hasMoreItems => _cryptos.isEmpty || _currentPageToRequest != -1;

  CryptosViewModel({
    required CryptoRepository cryptoRepository,
    required FavoritesRepository favoritesRepository,
  }) : _cryptoRepository = cryptoRepository,
       _favoritesRepository = favoritesRepository,
       searchController = TextEditingController();

  //================================================
  //---------------- Main methods ------------------
  //================================================

  /// Carries more Cryptos
  Future<void> loadMore() async {
    if (_shouldSkipLoad()) return;

    await _performLoad();
  }

  /// Updates the full list
  Future<void> refresh() async {
    _resetState();
    await _performLoad();
  }

  /// Alternates a Crypto's favorite status
  Future<void> toggleFavorite(String cryptoId) async {
    final index = _findCryptoIndex(cryptoId);
    if (index == -1) return;

    final currentCrypto = _cryptos[index];
    final isCurrentlyFavorite = await _favoritesRepository.isFavorite(cryptoId);

    if (isCurrentlyFavorite) {
      await _removeFavorite(cryptoId, index, currentCrypto);
    } else {
      await _addFavorite(cryptoId, index, currentCrypto);
    }

    notifyListeners();
  }

  /// Removes all favorites
  Future<void> deleteAllFavorites() async {
    await _favoritesRepository.clearAllFavorites();
    _updateAllCryptosAsFavorite(false);
    notifyListeners();
  }

  //====================================================
  //---------------- Search methods --------------------
  //====================================================

  /// Cryptos search for name or symbol
  Future<void> search(String query) async {
    if (query.isEmpty) return;
    clearSearchResult();

    final filteredCryptos = _filterActualCryptos(_cryptos, query);
    _filteredCryptos.addAll(filteredCryptos);

    final searchRequestCryptos = await _fetchSearchCryptos();
    _filteredCryptos.addAll(searchRequestCryptos);
    notifyListeners();
  }

  void clearSearchResult() {
    notifyListeners();
    _filteredCryptos.clear();
  }

  //======================================================
  //---------------- Consultas de Estado -----------------
  //======================================================

  /// Check if a Crypto is in the favorites
  bool isCryptoFavorite(String cryptoId) {
    final crypto = _findCrypto(cryptoId);
    return crypto?.isFavorite ?? false;
  }

  /// Search a specific Crypto by ID
  Crypto? getCrypto(String cryptoId) => _findCrypto(cryptoId);

  /// Search a specific favorite crypto
  Crypto? getFavoriteCrypto(String cryptoId) {
    return favoriteCryptos.where((c) => c.id == cryptoId).firstOrNull;
  }

  //=======================================================
  //---------------- Private Methods ---------------------
  //=======================================================

  /// Checks if loading should be skipped
  bool _shouldSkipLoad() => _isLoading || _currentPageToRequest == -1;

  /// Resets state for refresh
  void _resetState() {
    _currentPageToRequest = 0;
    _cryptos.clear();
    _error = null;
  }

  /// Executes main loading process
  Future<void> _performLoad() async {
    _setLoadingState(true);

    final newCryptos = await _fetchNewCryptos();
    if (newCryptos.isEmpty) {
      _currentPageToRequest = -1;
      return;
    }

    await _processAndUpdateCryptos(newCryptos);

    _setLoadingState(false);
  }

  /// Fetches new cryptos from API
  Future<List<Crypto>> _fetchNewCryptos() async {
    _currentPageToRequest += 1;
    final result = await _cryptoRepository.get(page: _currentPageToRequest);

    return result.fold((error) {
      _error = error.message;
      return <Crypto>[];
    }, (cryptos) => cryptos);
  }

  /// Fetches search cryptos from API
  Future<List<Crypto>> _fetchSearchCryptos() async {
    final result = await _cryptoRepository.get(search: searchController.text);

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
    return _cryptos.indexWhere((crypto) => crypto.id == cryptoId);
  }

  /// Finds crypto by ID
  Crypto? _findCrypto(String cryptoId) {
    try {
      return _cryptos.firstWhere((c) => c.id == cryptoId);
    } catch (e) {
      return null;
    }
  }

  /// Adds crypto to favorites
  Future<void> _addFavorite(String cryptoId, int index, Crypto crypto) async {
    await _favoritesRepository.addToFavorites(cryptoId);
    _cryptos[index] = crypto.copyWith(isFavorite: true);
  }

  /// Removes crypto from favorites
  Future<void> _removeFavorite(
    String cryptoId,
    int index,
    Crypto crypto,
  ) async {
    await _favoritesRepository.removeFromFavorites(cryptoId);
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

  /// Filters cryptos by search query
  List<Crypto> _filterActualCryptos(List<Crypto> cryptos, String query) {
    final lowerQuery = query.toLowerCase();
    return cryptos
        .where(
          (crypto) =>
              //
              crypto.id.toLowerCase().contains(lowerQuery) ||
              crypto.symbol.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  //=========================================
  //---------------- Filters ----------------
  //=========================================

  void sortFavoritesFirst() {
    _cryptos.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return 0;
    });
    notifyListeners();
  }
}
