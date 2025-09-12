import 'package:brasilcripto/app/core/routes/routes.dart';
import 'package:brasilcripto/app/presenter/view_models/cryptos_view_model.dart';
import 'package:brasilcripto/app/presenter/views/main_navigation_shell.dart';
import 'package:brasilcripto/app/presenter/views/pages/cryptos_details_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter routerConfig() {
  return GoRouter(
    initialLocation: Routes.cryptos,
    routes: [
      GoRoute(
        path: Routes.cryptos,
        builder: (context, state) {
          final cryptosViewModel = context.read<CryptosViewModel>();
          return MainCryptoTabs(cryptosViewModel: cryptosViewModel);
        },
        routes: [
          GoRoute(
            path: ":id",
            builder: (context, state) {
              final cryptoId = state.pathParameters["id"]!;
              final cryptoViewModel = context.read<CryptosViewModel>();

              final cryptos = cryptoViewModel.cryptos;

              final crypto = cryptos.firstWhere(
                (crypto) => crypto.id == cryptoId,
              );

              return CryptosDetailsPage(crypto: crypto);
            },
          ),
        ],
      ),
    ],
  );
}
