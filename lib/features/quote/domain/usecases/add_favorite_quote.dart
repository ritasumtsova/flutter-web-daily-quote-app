import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class AddFavoriteQuote {
  final QuoteRepository repository;
  AddFavoriteQuote(this.repository);

  Future<void> call(Quote quote) async {
    return await repository.addFavoriteQuote(quote);
  }
}
