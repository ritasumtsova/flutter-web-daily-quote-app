import '../entities/favorite_quote.dart';
import '../repositories/favorites_repository.dart';

class GetFavoriteQuotes {
  final FavoritesRepository repository;
  GetFavoriteQuotes(this.repository);

  Future<List<FavoriteQuote>> call() async {
    return await repository.getFavoriteQuotes();
  }
}
