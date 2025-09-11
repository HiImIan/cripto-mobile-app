import 'package:brasilcripto/app/core/routes/routes.dart';
import 'package:brasilcripto/app/data/repositories/crypto_repository.dart';
import 'package:brasilcripto/app/data/repositories/favorites_respository.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CryptosViewModel extends ChangeNotifier {
  final CryptoRepository _cryptoRepository;
  final FavoritesRepository _favoritesRepository;

  int _requestCurrentPage = 0;
  bool get hasMoreItem => _cryptos.isEmpty || _requestCurrentPage != -1;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  String? get error => _error;
  String? _error;

  List<Crypto> get cryptos => _cryptos;
  final List<Crypto> _cryptos = [];

  List<Crypto> get favoriteCryptos => _favoriteCryptos;
  final List<Crypto> _favoriteCryptos = [];

  CryptosViewModel({
    required CryptoRepository cryptoRepository,
    required FavoritesRepository favoritesRepository,
  }) : _favoritesRepository = favoritesRepository,
       _cryptoRepository = cryptoRepository;

  Future<void> refresh() async {
    _requestCurrentPage = 0;
    _cryptos.clear();
    _favoriteCryptos.clear();
    await load();
    loadFavorites();
  }

  //==============================================
  //---------------- Main Request ----------------
  //==============================================

  Future<void> load() async {
    if (isLoading) return;
    if (_requestCurrentPage == -1) return;
    _requestCurrentPage += 1;
    _error = null;
    _isLoading = true;
    notifyListeners();

    final result = await _cryptoRepository.get(page: _requestCurrentPage);

    result.fold((error) => _error = error.message, (cryptos) {
      if (cryptos.isEmpty) {
        _requestCurrentPage = -1;
        return;
      }
      _cryptos.addAll(cryptos);
      updateFavorites(cryptos);
    });
    _isLoading = false;
    notifyListeners();
  }

  void updateFavorites(Iterable<Crypto> newCryptos) {
    for (var crypto in newCryptos) {
      final cryptoId = crypto.id;
      _favoritesRepository.isFavorite(cryptoId).then((isFav) {
        final index = _cryptos.indexWhere((c) => c.id == cryptoId);
        if (index != -1) {
          _cryptos[index] = _cryptos[index].copyWith(isFavorite: isFav);
          notifyListeners();
        }
      });
    }
  }

  //==================================================
  //---------------- Favorite Requests ---------------
  //==================================================

  Future<void> loadFavorites() async {
    if (isLoading) return;
    _error = null;
    _isLoading = true;
    notifyListeners();

    final favoriteCryptos = await _favoritesRepository.getAllFavorites();

    if (favoriteCryptos.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    final result = await _cryptoRepository.get(ids: favoriteCryptos);
    result.fold((error) => _error = error.message, (newCryptos) {
      final addedCryptos = [
        ...cryptos.where((e) => e.isFavorite),
        ...newCryptos.map((e) => e = e.copyWith(isFavorite: true)),
      ];
      _favoriteCryptos.addAll(addedCryptos);
    });
    _isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(String cryptoId) async {
    final index = _cryptos.indexWhere((crypto) => cryptoId == crypto.id);
    if (index == -1) return;

    if (await _favoritesRepository.isFavorite(cryptoId)) {
      await _favoritesRepository.removeFromFavorites(cryptoId);
      _favoriteCryptos.remove(_cryptos[index]);

      final newCrypto = _cryptos[index].copyWith(isFavorite: false);
      _cryptos[index] = newCrypto;
    } else {
      await _favoritesRepository.addToFavorites(cryptoId);

      final newCrypto = _cryptos[index].copyWith(isFavorite: true);
      _favoriteCryptos.add(newCrypto);

      _cryptos[index] = newCrypto;
    }
    notifyListeners();
  }

  void deleteAllFavorites() {
    _favoritesRepository.clearAllFavorites();
    refresh();
  }

  //========================================
  //---------------- Routes ----------------
  //========================================

  void goToDetails(BuildContext context, String cryptoId) =>
      context.push(Routes.cryptoDetails(cryptoId));
}
