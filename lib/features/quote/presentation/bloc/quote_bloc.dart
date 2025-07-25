import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/quote.dart';
import '../../domain/usecases/get_quote_of_the_day.dart';
import '../../domain/usecases/add_favorite_quote.dart';
import '../../domain/usecases/remove_favorite_quote.dart';
import '../../domain/usecases/get_favorite_quotes.dart';

// Events
abstract class QuoteEvent {}

class GetQuoteEvent extends QuoteEvent {}

class AddFavoriteEvent extends QuoteEvent {
  final Quote quote;
  AddFavoriteEvent(this.quote);
}

class RemoveFavoriteEvent extends QuoteEvent {
  final Quote quote;
  RemoveFavoriteEvent(this.quote);
}

class LoadFavoritesEvent extends QuoteEvent {}

// States
abstract class QuoteState {}

class QuoteInitial extends QuoteState {}

class QuoteLoading extends QuoteState {}

class QuoteLoaded extends QuoteState {
  final Quote quote;
  final bool isFavorite;
  QuoteLoaded(this.quote, {this.isFavorite = false});
}

class QuoteError extends QuoteState {
  final String message;
  QuoteError(this.message);
}

class FavoritesLoaded extends QuoteState {
  final List<Quote> favorites;
  FavoritesLoaded(this.favorites);
}

// Bloc
class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final GetQuoteOfTheDay getQuoteOfTheDay;
  final AddFavoriteQuote addFavoriteQuote;
  final RemoveFavoriteQuote removeFavoriteQuote;
  final GetFavoriteQuotes getFavoriteQuotes;

  Quote? _lastLoadedQuote;

  QuoteBloc(
    this.getQuoteOfTheDay,
    this.addFavoriteQuote,
    this.removeFavoriteQuote,
    this.getFavoriteQuotes,
  ) : super(QuoteInitial()) {
    on<GetQuoteEvent>((event, emit) async {
      emit(QuoteLoading());
      try {
        final quote = await getQuoteOfTheDay();
        _lastLoadedQuote = quote;
        final favorites = await getFavoriteQuotes();
        final isFavorite = favorites.any(
          (q) => q.text == quote.text && q.author == quote.author,
        );
        emit(QuoteLoaded(quote, isFavorite: isFavorite));
      } catch (e) {
        emit(QuoteError(e.toString()));
      }
    });
    on<AddFavoriteEvent>((event, emit) async {
      await addFavoriteQuote(event.quote);
      if (_lastLoadedQuote != null) {
        emit(QuoteLoaded(_lastLoadedQuote!, isFavorite: true));
      }
    });
    on<RemoveFavoriteEvent>((event, emit) async {
      await removeFavoriteQuote(event.quote);
      if (_lastLoadedQuote != null) {
        emit(QuoteLoaded(_lastLoadedQuote!, isFavorite: false));
      }
    });
    on<LoadFavoritesEvent>((event, emit) async {
      final favorites = await getFavoriteQuotes();
      emit(FavoritesLoaded(favorites));
    });
  }
}
