import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../data/datasources/favorites_local_data_source.dart';
import '../data/repositories/favorites_repository_impl.dart';
import '../domain/usecases/add_favorite_quote.dart';
import '../domain/usecases/remove_favorite_quote.dart';
import '../domain/usecases/get_favorite_quotes.dart';
import '../presentation/bloc/favorites_bloc.dart';

List<SingleChildWidget> favoritesProviders = [
  Provider<FavoritesLocalDataSource>(
    create: (_) => FavoritesLocalDataSourceImpl(),
  ),
  Provider<FavoritesRepositoryImpl>(
    create: (context) => FavoritesRepositoryImpl(
      localDataSource: context.read<FavoritesLocalDataSource>(),
    ),
  ),
  Provider<AddFavoriteQuote>(
    create: (context) =>
        AddFavoriteQuote(context.read<FavoritesRepositoryImpl>()),
  ),
  Provider<RemoveFavoriteQuote>(
    create: (context) =>
        RemoveFavoriteQuote(context.read<FavoritesRepositoryImpl>()),
  ),
  Provider<GetFavoriteQuotes>(
    create: (context) =>
        GetFavoriteQuotes(context.read<FavoritesRepositoryImpl>()),
  ),
  Provider<FavoritesBloc>(
    create: (context) => FavoritesBloc(
      getFavoriteQuotes: context.read<GetFavoriteQuotes>(),
      addFavoriteQuote: context.read<AddFavoriteQuote>(),
      removeFavoriteQuote: context.read<RemoveFavoriteQuote>(),
    ),
  ),
];
