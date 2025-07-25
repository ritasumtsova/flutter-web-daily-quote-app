import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class GetFavoriteQuotes {
  final QuoteRepository repository;
  GetFavoriteQuotes(this.repository);

  Future<List<Quote>> call() async {
    return await repository.getFavoriteQuotes();
  }
}
