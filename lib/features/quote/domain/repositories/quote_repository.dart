import '../entities/quote.dart';

abstract class QuoteRepository {
  Future<Quote> getQuoteOfTheDay();
  // Favorites
  Future<List<Quote>> getFavoriteQuotes();
  Future<void> addFavoriteQuote(Quote quote);
  Future<void> removeFavoriteQuote(Quote quote);
}
