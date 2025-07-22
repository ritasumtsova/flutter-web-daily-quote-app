import '../../domain/entities/quote.dart';
import '../../domain/repositories/quote_repository.dart';
import '../datasources/quote_remote_data_source.dart';
import '../datasources/quote_local_data_source.dart';
import '../models/quote_model.dart';
import 'package:intl/intl.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final QuoteRemoteDataSource remoteDataSource;
  final QuoteLocalDataSource localDataSource;

  QuoteRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Quote> getQuoteOfTheDay() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final cached = await localDataSource.getCachedQuote(today);
    // if (cached != null) {
    //   return cached;
    // }
    final remote = await remoteDataSource.getRandomQuote();
    await localDataSource.cacheQuote(today, remote);
    return remote;
  }
}
