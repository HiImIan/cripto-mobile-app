import 'package:brasilcripto/app/core/routes/routes.dart';
import 'package:brasilcripto/app/data/repositories/crypto_repository.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CryptoViewModel extends ChangeNotifier {
  final CryptoRepository _cryptoRepository;

  List<Crypto> get cryptos => _partialCryptos;
  final List<Crypto> _allCryptos = [];
  final List<Crypto> _partialCryptos = [];

  bool get hasMoreItem => _partialCryptos.length < _allCryptos.length;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  String? get error => _error;
  String? _error;

  int _currentPage = 0;

  CryptoViewModel({required CryptoRepository cryptoRepository})
    : _cryptoRepository = cryptoRepository;

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
    _partialCryptos.addAll(_allCryptos.skip(_partialCryptos.length).take(10));
    notifyListeners();
  }

  Future<void> refresh() async {
    _currentPage = 0;
    _allCryptos.clear();
    _partialCryptos.clear();
    load();
  }

  void goToDetails(BuildContext context, String cryptoId) =>
      context.push(Routes.cryptoDetails(cryptoId));
}
