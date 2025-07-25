import '../entities/favorite_quote.dart';
import '../repositories/favorites_repository.dart';

class AddFavoriteQuote {
  final FavoritesRepository repository;
  AddFavoriteQuote(this.repository);

  Future<void> call(FavoriteQuote quote) async {
    return await repository.addFavoriteQuote(quote);
  }
}
