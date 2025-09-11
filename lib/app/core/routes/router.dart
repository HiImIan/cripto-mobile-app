import 'package:brasilcripto/app/core/routes/routes.dart';
import 'package:brasilcripto/app/presenter/view_models/crypto_view_model.dart';
import 'package:brasilcripto/app/presenter/views/crypto_details_page.dart';
import 'package:brasilcripto/app/presenter/views/cryptos_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter routerConfig() {
  return GoRouter(
    initialLocation: Routes.cryptos,
    routes: [
      GoRoute(
        path: Routes.cryptos,
        builder: (context, state) {
          final cryptosViewModel = context.read<CryptoViewModel>();
          return CryptosPage(cryptosViewModel: cryptosViewModel);
        },
        routes: [
          GoRoute(
            path: ":id",
            builder: (context, state) {
              final cryptoId = state.pathParameters["id"]!;
              final cryptoViewModel = context.read<CryptoViewModel>();

              final cryptos = cryptoViewModel.cryptos;

              final crypto = cryptos[int.parse(cryptoId)];

              return CryptoDetailPage(crypto: crypto);
            },
          ),
        ],
      ),
    ],
  );
}
