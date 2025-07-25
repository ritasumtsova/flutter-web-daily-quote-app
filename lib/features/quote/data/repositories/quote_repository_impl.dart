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
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final cached = await localDataSource.getCachedQuote(today);
    if (cached != null) {
      return cached;
    }
    try {
      final quote = await remoteDataSource.getRandomQuote();
      await localDataSource.saveQuote(quote, today);
      return quote;
    } catch (e) {
      throw Exception('Failed to fetch quote: $e');
    }
  }
}
