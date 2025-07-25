import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class RemoveFavoriteQuote {
  final QuoteRepository repository;
  RemoveFavoriteQuote(this.repository);

  Future<void> call(Quote quote) async {
    return await repository.removeFavoriteQuote(quote);
  }
}
