import '../../domain/entities/quote.dart';
import '../../domain/repositories/quote_repository.dart';
import '../datasources/quote_remote_data_source.dart';
import '../datasources/quote_local_data_source.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final QuoteRemoteDataSource remoteDataSource;
  final QuoteLocalDataSource localDataSource;

  QuoteRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Quote> getQuoteOfTheDay() async {
    final quote = await remoteDataSource.getRandomQuote();
    return quote;
  }
}
