import '../entities/favorite_quote.dart';
import '../repositories/favorites_repository.dart';

class RemoveFavoriteQuote {
  final FavoritesRepository repository;
  RemoveFavoriteQuote(this.repository);

  Future<void> call(FavoriteQuote quote) async {
    return await repository.removeFavoriteQuote(quote);
  }
}
