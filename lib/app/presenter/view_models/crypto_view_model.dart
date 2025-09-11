import 'package:brasilcripto/app/core/routes/routes.dart';
import 'package:brasilcripto/app/data/repositories/crypto_repository.dart';
import 'package:brasilcripto/app/data/repositories/favorites_respository.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CryptoViewModel extends ChangeNotifier {
  final CryptoRepository _cryptoRepository;
  final FavoritesRepository _favoritesRepository;

  List<Crypto> get cryptos => _partialCryptos;
  final List<Crypto> _allCryptos = [];
  final List<Crypto> _partialCryptos = [];

  bool get hasMoreItem => _partialCryptos.length < _allCryptos.length;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  String? get error => _error;
  String? _error;

  int _currentPage = 0;

  CryptoViewModel({
    required CryptoRepository cryptoRepository,
    required FavoritesRepository favoritesRepository,
  }) : _favoritesRepository = favoritesRepository,
       _cryptoRepository = cryptoRepository;

  //==============================================
  //---------------- Main Request ----------------
  //==============================================

  Future<void> refresh() async {
    _currentPage = 0;
    _allCryptos.clear();
    _partialCryptos.clear();
    load();
  }

  Future<void> load() async {
    if (isLoading) return;
    _currentPage += 1;
    _error = null;
    _isLoading = true;
    notifyListeners();

    final result = await _cryptoRepository.get(_currentPage);

    result.fold((error) => _error = error.message, (cryptos) {
      _allCryptos.addAll(cryptos);
      incrementPartialCryptos();
    });
    _isLoading = false;
    notifyListeners();
  }

  void incrementPartialCryptos() {
    if (!hasMoreItem) return;
    final newCryptos = _allCryptos.skip(_partialCryptos.length).take(10);
    _partialCryptos.addAll(newCryptos);
    updateFavorites(newCryptos);
    notifyListeners();
  }

  //==================================================
  //---------------- Favorite Methods ----------------
  //==================================================

  void updateFavorites(Iterable<Crypto> newCryptos) {
    for (var crypto in newCryptos) {
      _favoritesRepository.isFavorite(crypto.id).then((isFav) {
        final index = _partialCryptos.indexWhere((c) => c.id == crypto.id);
        if (index != -1) {
          _partialCryptos[index] = _partialCryptos[index].copyWith(
            isFavorite: isFav,
          );
          notifyListeners();
        }
      });
    }
  }

  void toggleFavorite(String cryptoId) async {
    final index = _partialCryptos.indexWhere((crypto) => cryptoId == crypto.id);
    if (index == -1) return;

    if (await _favoritesRepository.isFavorite(cryptoId)) {
      await _favoritesRepository.removeFromFavorites(cryptoId);
      _partialCryptos[index] = _partialCryptos[index].copyWith(
        isFavorite: false,
      );
    } else {
      await _favoritesRepository.addToFavorites(cryptoId);
      _partialCryptos[index] = _partialCryptos[index].copyWith(
        isFavorite: true,
      );
    }
    notifyListeners();
  }

  //========================================
  //---------------- Routes ----------------
  //========================================

  void goToDetails(BuildContext context, String cryptoId) =>
      context.push(Routes.cryptoDetails(cryptoId));
}
