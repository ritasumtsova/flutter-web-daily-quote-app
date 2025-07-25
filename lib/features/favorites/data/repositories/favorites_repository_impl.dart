import '../../domain/entities/favorite_quote.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;
  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<List<FavoriteQuote>> getFavoriteQuotes() async {
    return await localDataSource.getFavoriteQuotes();
  }

  @override
  Future<void> addFavoriteQuote(FavoriteQuote quote) async {
    await localDataSource.addFavoriteQuote(quote);
  }

  @override
  Future<void> removeFavoriteQuote(FavoriteQuote quote) async {
    await localDataSource.removeFavoriteQuote(quote);
  }
}
