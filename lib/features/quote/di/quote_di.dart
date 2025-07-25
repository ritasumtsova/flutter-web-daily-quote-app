import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../data/datasources/quote_local_data_source.dart';
import '../data/datasources/quote_remote_data_source.dart';
import '../data/repositories/quote_repository_impl.dart';
import '../domain/usecases/get_quote_of_the_day.dart';
import '../domain/usecases/add_favorite_quote.dart';
import '../domain/usecases/remove_favorite_quote.dart';
import '../domain/usecases/get_favorite_quotes.dart';
import '../presentation/bloc/quote_bloc.dart';

List<SingleChildWidget> quoteProviders = [
  Provider<QuoteRemoteDataSource>(
    create: (_) =>
        QuoteRemoteDataSourceImpl('e4dDWAScCS0qo1OPlUoBGw==07yBxBeTOaLx02JU'),
  ),
  Provider<QuoteLocalDataSource>(create: (_) => QuoteLocalDataSourceImpl()),
  Provider<QuoteRepositoryImpl>(
    create: (context) => QuoteRepositoryImpl(
      remoteDataSource: context.read<QuoteRemoteDataSource>(),
      localDataSource: context.read<QuoteLocalDataSource>(),
    ),
  ),
  Provider<GetQuoteOfTheDay>(
    create: (context) => GetQuoteOfTheDay(context.read<QuoteRepositoryImpl>()),
  ),
  Provider<AddFavoriteQuote>(
    create: (context) => AddFavoriteQuote(context.read<QuoteRepositoryImpl>()),
  ),
  Provider<RemoveFavoriteQuote>(
    create: (context) =>
        RemoveFavoriteQuote(context.read<QuoteRepositoryImpl>()),
  ),
  Provider<GetFavoriteQuotes>(
    create: (context) => GetFavoriteQuotes(context.read<QuoteRepositoryImpl>()),
  ),
  Provider<QuoteBloc>(
    create: (context) => QuoteBloc(
      context.read<GetQuoteOfTheDay>(),
      context.read<AddFavoriteQuote>(),
      context.read<RemoveFavoriteQuote>(),
      context.read<GetFavoriteQuotes>(),
    ),
  ),
];
