import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class GetQuoteOfTheDay {
  final QuoteRepository repository;
  GetQuoteOfTheDay(this.repository);

  Future<Quote> call() async {
    return await repository.getQuoteOfTheDay();
  }
}
