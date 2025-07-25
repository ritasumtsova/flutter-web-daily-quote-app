import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/favorite_quote.dart';
import 'dart:convert';

abstract class FavoritesLocalDataSource {
  Future<List<FavoriteQuote>> getFavoriteQuotes();
  Future<void> addFavoriteQuote(FavoriteQuote quote);
  Future<void> removeFavoriteQuote(FavoriteQuote quote);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  static const String favoritesKey = 'favorite_quotes';

  @override
  Future<List<FavoriteQuote>> getFavoriteQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(favoritesKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => FavoriteQuote.fromJson(e)).toList();
  }

  @override
  Future<void> addFavoriteQuote(FavoriteQuote quote) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteQuotes();
    if (favorites.any((q) => q.text == quote.text && q.author == quote.author))
      return;
    favorites.add(quote);
    final jsonString = json.encode(favorites.map((q) => q.toJson()).toList());
    await prefs.setString(favoritesKey, jsonString);
  }

  @override
  Future<void> removeFavoriteQuote(FavoriteQuote quote) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteQuotes();
    favorites.removeWhere(
      (q) => q.text == quote.text && q.author == quote.author,
    );
    final jsonString = json.encode(favorites.map((q) => q.toJson()).toList());
    await prefs.setString(favoritesKey, jsonString);
  }
}
