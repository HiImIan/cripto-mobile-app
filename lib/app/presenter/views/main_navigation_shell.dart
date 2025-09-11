import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/view_models/cryptos_view_model.dart';
import 'package:brasilcripto/app/presenter/views/pages/cryptos_favorites_page.dart';
import 'package:brasilcripto/app/presenter/views/pages/cryptos_home_page.dart';
import 'package:brasilcripto/app/presenter/views/widgets/crypto_bottom_navigation_widget.dart';
import 'package:flutter/material.dart';

class MainCryptoTabs extends StatefulWidget {
  final CryptosViewModel cryptosViewModel;
  const MainCryptoTabs({super.key, required this.cryptosViewModel});

  @override
  State<MainCryptoTabs> createState() => _MainCryptoTabsState();
}

class _MainCryptoTabsState extends State<MainCryptoTabs> {
  CryptosViewModel get cryptosViewModel => widget.cryptosViewModel;
  final PageController _pageController = PageController();
  int _requestCurrentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await cryptosViewModel.loadMore();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _requestCurrentPage = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _requestCurrentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = LocalizationService.instance.l10n;
    return AnimatedBuilder(
      animation: cryptosViewModel,
      builder: (_, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: colors.primary,
            title: Text(l10n.brazilCrypto, style: theme.textTheme.titleLarge),
            actions: [
              IconButton(
                icon: const Icon(Icons.replay_outlined),
                splashRadius: 16,
                onPressed: cryptosViewModel.refresh,
              ),
              if (_requestCurrentPage == 1)
                IconButton(
                  icon: const Icon(Icons.delete),
                  splashRadius: 16,
                  onPressed: cryptosViewModel.deleteAllFavorites,
                ),
            ],
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              CryptosHomePage(cryptosViewModel: cryptosViewModel),
              CryptosFavoritePage(cryptosViewModel: cryptosViewModel),
            ],
          ),
          bottomNavigationBar: CryptoBottomNavigationBar(
            currentIndex: _requestCurrentPage,
            onTap: _onTabTapped,
          ),
        );
      },
    );
  }
}
