import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/view_models/cryptos_view_model.dart';
import 'package:brasilcripto/app/presenter/views/pages/cryptos_favorites_page.dart';
import 'package:brasilcripto/app/presenter/views/pages/cryptos_page.dart';
import 'package:brasilcripto/app/presenter/views/widgets/cryptos_search_field_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/main_bottom_navigation_widget.dart';
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

  bool get _isOnCryptosTab => _requestCurrentPage == 0;
  bool get _isOnFavoritesTab => _requestCurrentPage == 1;
  bool get _shouldShowClearFavoritesButton =>
      _isOnFavoritesTab && cryptosViewModel.favoriteCryptos.isNotEmpty;

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

  // Clean navigation method
  void _navigateToTab(int index) {
    setState(() => _requestCurrentPage = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Clear favorites with navigation
  void _clearAllFavoritesAndGoHome() {
    cryptosViewModel.deleteAllFavorites();
    _navigateToTab(0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = LocalizationService.instance.l10n;

    return AnimatedBuilder(
      animation: cryptosViewModel,
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.brazilCrypto, style: theme.textTheme.titleLarge),
            backgroundColor: colors.primary,
            actions: [
              IconButton(
                icon: const Icon(Icons.replay_outlined),
                splashRadius: 16,
                onPressed: cryptosViewModel.refresh,
              ),
              if (_shouldShowClearFavoritesButton)
                IconButton(
                  icon: const Icon(Icons.playlist_remove),
                  splashRadius: 16,
                  onPressed: _clearAllFavoritesAndGoHome,
                ),
            ],
          ),
          bottomNavigationBar: CryptoBottomNavigationBar(
            currentIndex: _requestCurrentPage,
            onTap: _navigateToTab,
          ),
          body: Column(
            children: [
              CryptoSearchField(
                cryptosViewModel: cryptosViewModel,
                showSearchField: _isOnCryptosTab,
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _requestCurrentPage = index),
                  children: [
                    CryptosPage(cryptosViewModel: cryptosViewModel),
                    CryptosFavoritePage(cryptosViewModel: cryptosViewModel),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
