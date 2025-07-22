import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote_model.dart';

abstract class QuoteLocalDataSource {
  Future<QuoteModel?> getCachedQuote(String today);
  Future<void> cacheQuote(String today, QuoteModel quote);
}

class QuoteLocalDataSourceImpl implements QuoteLocalDataSource {
  static const String dateKey = 'quote_date';
  static const String quoteKey = 'quote_text';
  static const String authorKey = 'quote_author';

  @override
  Future<QuoteModel?> getCachedQuote(String today) async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString(dateKey);
    final savedQuote = prefs.getString(quoteKey);
    final savedAuthor = prefs.getString(authorKey);
    if (savedDate == today && savedQuote != null && savedAuthor != null) {
      return QuoteModel(text: savedQuote, author: savedAuthor);
    }
    return null;
  }

  @override
  Future<void> cacheQuote(String today, QuoteModel quote) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(dateKey, today);
    await prefs.setString(quoteKey, quote.text);
    await prefs.setString(authorKey, quote.author);
  }
}
