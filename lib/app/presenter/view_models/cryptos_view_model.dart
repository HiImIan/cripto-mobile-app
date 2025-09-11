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

  // Estado interno
  final List<Crypto> _cryptos = [];
  int _currentPage = 0;
  bool _isLoading = false;
  String? _error;

  // Getters públicos
  List<Crypto> get cryptos => List.unmodifiable(_cryptos);
  List<Crypto> get favoriteCryptos =>
      _cryptos.where((crypto) => crypto.isFavorite).toList();

  bool get isLoading => _isLoading;
  bool get hasMoreItems => _cryptos.isEmpty || _currentPage != -1;
  String? get error => _error;
  int get favoritesCount => favoriteCryptos.length;
  List<String> get favoriteIds => favoriteCryptos.map((c) => c.id).toList();

  CryptosViewModel({
    required CryptoRepository cryptoRepository,
    required FavoritesRepository favoritesRepository,
  }) : _cryptoRepository = cryptoRepository,
       _favoritesRepository = favoritesRepository;

  //=======================================================
  //---------------- Métodos Principais ------------------
  //=======================================================

  /// Carrega mais cryptos (paginação)
  Future<void> loadMore() async {
    if (_shouldSkipLoad()) return;

    await _performLoad();
  }

  /// Atualiza a lista completa (refresh)
  Future<void> refresh() async {
    _resetState();
    await _performLoad();
  }

  /// Alterna o status de favorito de um crypto
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

  /// Remove todos os favoritos
  Future<void> deleteAllFavorites() async {
    await _favoritesRepository.clearAllFavorites();
    _updateAllCryptosAsFavorite(false);
    notifyListeners();
  }

  //=======================================================
  //---------------- Métodos de Busca --------------------
  //=======================================================

  /// Busca cryptos por nome ou símbolo
  List<Crypto> searchByName(String query) {
    if (query.isEmpty) return cryptos;
    return _filterCryptosByQuery(_cryptos, query);
  }

  /// Busca apenas favoritos por nome ou símbolo
  List<Crypto> searchFavoritesByName(String query) {
    if (query.isEmpty) return favoriteCryptos;
    return _filterCryptosByQuery(favoriteCryptos, query);
  }

  //=======================================================
  //---------------- Consultas de Estado -----------------
  //=======================================================

  /// Verifica se um crypto está nos favoritos
  bool isCryptoFavorite(String cryptoId) {
    final crypto = _findCrypto(cryptoId);
    return crypto?.isFavorite ?? false;
  }

  /// Busca um crypto específico por ID
  Crypto? getCrypto(String cryptoId) => _findCrypto(cryptoId);

  /// Busca um crypto favorito específico
  Crypto? getFavoriteCrypto(String cryptoId) {
    return favoriteCryptos.where((c) => c.id == cryptoId).firstOrNull;
  }

  //=======================================================
  //---------------- Métodos Privados --------------------
  //=======================================================

  /// Verifica se deve pular o carregamento
  bool _shouldSkipLoad() => _isLoading || _currentPage == -1;

  /// Reseta o estado para refresh
  void _resetState() {
    _currentPage = 0;
    _cryptos.clear();
    _error = null;
  }

  /// Executa o carregamento principal
  Future<void> _performLoad() async {
    _setLoadingState(true);

    final newCryptos = await _fetchNewCryptos();
    if (newCryptos.isEmpty) {
      _currentPage = -1;
      return;
    }

    await _processAndUpdateCryptos(newCryptos);

    _setLoadingState(false);
  }

  /// Busca novos cryptos da API
  Future<List<Crypto>> _fetchNewCryptos() async {
    _currentPage += 1;
    final result = await _cryptoRepository.get(page: _currentPage);

    return result.fold((error) {
      _error = error.message;
      return <Crypto>[];
    }, (cryptos) => cryptos);
  }

  /// Processa e atualiza a lista com novos cryptos
  Future<void> _processAndUpdateCryptos(List<Crypto> newCryptos) async {
    // Adiciona novos cryptos sem duplicatas
    _cryptos.addAllUniqueById(newCryptos);

    // Carrega e sincroniza favoritos
    await _syncFavoritesWithRepository();

    // Remove duplicatas finais
    _removeDuplicatesFromList();
  }

  /// Sincroniza status de favoritos com o repository
  Future<void> _syncFavoritesWithRepository() async {
    // Busca favoritos uma única vez
    final favoriteIds = await _favoritesRepository.getAllFavorites();

    // Carrega favoritos salvos e adiciona à lista
    await _loadSavedFavorites(favoriteIds);

    // Atualiza status de todos os cryptos
    final favoriteIdsSet = Set<String>.from(favoriteIds);

    _updateCryptosWithFavoriteStatus(favoriteIdsSet);
  }

  /// Carrega favoritos salvos da API
  Future<void> _loadSavedFavorites(List<String> favoriteIds) async {
    if (favoriteIds.isEmpty) return;

    final result = await _cryptoRepository.get(ids: favoriteIds);

    result.fold((error) => _error = error.message, (favoriteCryptos) {
      final favoritesWithFlag = favoriteCryptos
          .map((crypto) => crypto.copyWith(isFavorite: true))
          .toList();
      _cryptos.addAllUniqueById(favoritesWithFlag);
    });
  }

  /// Atualiza status de favorito baseado no conjunto de IDs
  void _updateCryptosWithFavoriteStatus(Set<String> favoriteIds) {
    for (int i = 0; i < _cryptos.length; i++) {
      final isFavorite = favoriteIds.contains(_cryptos[i].id);
      _cryptos[i] = _cryptos[i].copyWith(isFavorite: isFavorite);
    }
  }

  /// Remove duplicatas da lista principal
  void _removeDuplicatesFromList() {
    final uniqueCryptos = _cryptos.uniqueById;
    _cryptos.clear();
    _cryptos.addAll(uniqueCryptos);
  }

  /// Define estado de loading
  void _setLoadingState(bool loading) {
    _isLoading = loading;
    if (loading) _error = null;
    notifyListeners();
  }

  /// Encontra índice de um crypto na lista
  int _findCryptoIndex(String cryptoId) {
    return _cryptos.indexWhere((crypto) => crypto.id == cryptoId);
  }

  /// Encontra um crypto por ID
  Crypto? _findCrypto(String cryptoId) {
    return _cryptos.firstWhere((c) => c.id == cryptoId);
  }

  /// Adiciona crypto aos favoritos
  Future<void> _addFavorite(String cryptoId, int index, Crypto crypto) async {
    await _favoritesRepository.addToFavorites(cryptoId);
    _cryptos[index] = crypto.copyWith(isFavorite: true);
  }

  /// Remove crypto dos favoritos
  Future<void> _removeFavorite(
    String cryptoId,
    int index,
    Crypto crypto,
  ) async {
    await _favoritesRepository.removeFromFavorites(cryptoId);
    _cryptos[index] = crypto.copyWith(isFavorite: false);
  }

  /// Atualiza todos os cryptos com um status de favorito
  void _updateAllCryptosAsFavorite(bool isFavorite) {
    for (int i = 0; i < _cryptos.length; i++) {
      if (_cryptos[i].isFavorite != isFavorite) {
        _cryptos[i] = _cryptos[i].copyWith(isFavorite: isFavorite);
      }
    }
  }

  /// Filtra cryptos por query de busca
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
}
