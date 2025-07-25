import '../entities/favorite_quote.dart';

abstract class FavoritesRepository {
  Future<List<FavoriteQuote>> getFavoriteQuotes();
  Future<void> addFavoriteQuote(FavoriteQuote quote);
  Future<void> removeFavoriteQuote(FavoriteQuote quote);
}
