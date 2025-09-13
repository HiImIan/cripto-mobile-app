import 'package:shared_preferences/shared_preferences.dart';

class FavoritesRepository {
  static const String _favoritesKey = 'favorite_cryptos';

  Future<void> addToFavorites(String cryptoId) async {
    final preferences = await SharedPreferences.getInstance();
    final favorites = await getAllFavorites();

    if (!favorites.contains(cryptoId)) {
      favorites.add(cryptoId);
      await preferences.setStringList(_favoritesKey, favorites);
    }
  }

  Future<void> removeFromFavorites(String cryptoId) async {
    final preferences = await SharedPreferences.getInstance();
    final favorites = await getAllFavorites();

    favorites.remove(cryptoId);
    await preferences.setStringList(_favoritesKey, favorites);
  }

  Future<bool> isFavorite(String cryptoId) async {
    final favorites = await getAllFavorites();
    return favorites.contains(cryptoId);
  }

  Future<List<String>> getAllFavorites() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(_favoritesKey) ?? [];
  }

  Future<void> clearAllFavorites() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_favoritesKey);
  }
}
