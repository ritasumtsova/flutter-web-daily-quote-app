import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../data/datasources/quote_local_data_source.dart';
import '../data/datasources/quote_remote_data_source.dart';
import '../data/repositories/quote_repository_impl.dart';
import '../domain/usecases/get_quote_of_the_day.dart';
import '../presentation/bloc/quote_bloc.dart';

List<SingleChildWidget> quoteProviders = [
  Provider<QuoteRemoteDataSource>(
    create: (_) =>
        QuoteRemoteDataSourceImpl(dotenv.env['API_NINJAS_KEY'] ?? ''),
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
  Provider<QuoteBloc>(
    create: (context) => QuoteBloc(context.read<GetQuoteOfTheDay>()),
  ),
];
