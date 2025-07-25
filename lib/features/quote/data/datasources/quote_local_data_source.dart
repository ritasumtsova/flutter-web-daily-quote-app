import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote_model.dart';
import 'dart:convert';

abstract class QuoteLocalDataSource {
  Future<QuoteModel?> getCachedQuote(String today);
  Future<void> saveQuote(QuoteModel quote, String today);
  // Favorites
  Future<List<QuoteModel>> getFavoriteQuotes();
  Future<void> addFavoriteQuote(QuoteModel quote);
  Future<void> removeFavoriteQuote(QuoteModel quote);
}

class QuoteLocalDataSourceImpl implements QuoteLocalDataSource {
  static const String dateKey = 'quote_date';
  static const String quoteKey = 'quote_text';
  static const String authorKey = 'quote_author';
  static const String favoritesKey = 'favorite_quotes';

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
  Future<void> saveQuote(QuoteModel quote, String today) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(dateKey, today);
    await prefs.setString(quoteKey, quote.text);
    await prefs.setString(authorKey, quote.author);
  }

  @override
  Future<List<QuoteModel>> getFavoriteQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(favoritesKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => QuoteModel.fromJson(e)).toList();
  }

  @override
  Future<void> addFavoriteQuote(QuoteModel quote) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteQuotes();
    // Avoid duplicates
    if (favorites.any(
      (q) => q.text == quote.text && q.author == quote.author,
    )) {
      return;
    }
    favorites.add(quote);
    final jsonString = json.encode(favorites.map((q) => q.toJson()).toList());
    await prefs.setString(favoritesKey, jsonString);
  }

  @override
  Future<void> removeFavoriteQuote(QuoteModel quote) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteQuotes();
    favorites.removeWhere(
      (q) => q.text == quote.text && q.author == quote.author,
    );
    final jsonString = json.encode(favorites.map((q) => q.toJson()).toList());
    await prefs.setString(favoritesKey, jsonString);
  }
}
