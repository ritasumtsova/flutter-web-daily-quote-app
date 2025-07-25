import '../entities/quote.dart';

abstract class QuoteRepository {
  Future<Quote> getQuoteOfTheDay();
}
