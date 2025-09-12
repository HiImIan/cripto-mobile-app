import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/view_models/cryptos_view_model.dart';
import 'package:brasilcripto/app/presenter/views/pages/cryptos_favorites_page.dart';
import 'package:brasilcripto/app/presenter/views/pages/cryptos_page.dart';
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
    final textStyle = theme.textTheme;
    final l10n = LocalizationService.instance.l10n;

    return AnimatedBuilder(
      animation: cryptosViewModel,
      builder: (_, __) {
        final hasFavorites = cryptosViewModel.favoriteCryptos.isNotEmpty;
        final hasItems = cryptosViewModel.cryptos.isNotEmpty;
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
              if (_requestCurrentPage == 1 && hasFavorites)
                IconButton(
                  icon: const Icon(Icons.playlist_remove),
                  splashRadius: 16,
                  onPressed: () {
                    cryptosViewModel.deleteAllFavorites();
                    _onTabTapped(0);
                  },
                ),
            ],
          ),
          bottomNavigationBar: CryptoBottomNavigationBar(
            currentIndex: _requestCurrentPage,
            onTap: _onTabTapped,
          ),
          body: Column(
            children: [
              if (hasItems)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: cryptosViewModel.searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colors.primaryContainer,
                      hintText: l10n.searchEngineLabel,
                      hintStyle: textStyle.bodyLarge,
                      contentPadding: EdgeInsets.only(left: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      suffixIcon: IconButton(
                        splashRadius: 10,
                        onPressed: () {},
                        icon: Icon(Icons.search),
                      ),
                    ),
                    onSubmitted: cryptosViewModel.search,
                  ),
                ),

              // 🔹 Conteúdo principal (aba de cryptos/favoritos)
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
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
