import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/favorite_quote.dart';
import '../../domain/usecases/get_favorite_quotes.dart';
import '../../domain/usecases/add_favorite_quote.dart';
import '../../domain/usecases/remove_favorite_quote.dart';

// Events
abstract class FavoritesEvent {}

class LoadFavoritesEvent extends FavoritesEvent {}

class AddFavoriteEvent extends FavoritesEvent {
  final FavoriteQuote quote;
  AddFavoriteEvent(this.quote);
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final FavoriteQuote quote;
  RemoveFavoriteEvent(this.quote);
}

// States
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<FavoriteQuote> favorites;
  FavoritesLoaded(this.favorites);
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}

// Bloc
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoriteQuotes getFavoriteQuotes;
  final AddFavoriteQuote addFavoriteQuote;
  final RemoveFavoriteQuote removeFavoriteQuote;

  FavoritesBloc({
    required this.getFavoriteQuotes,
    required this.addFavoriteQuote,
    required this.removeFavoriteQuote,
  }) : super(FavoritesInitial()) {
    on<LoadFavoritesEvent>((event, emit) async {
      emit(FavoritesLoading());
      try {
        final favorites = await getFavoriteQuotes();
        emit(FavoritesLoaded(favorites));
      } catch (e) {
        emit(FavoritesError(e.toString()));
      }
    });
    on<AddFavoriteEvent>((event, emit) async {
      await addFavoriteQuote(event.quote);
      add(LoadFavoritesEvent());
    });
    on<RemoveFavoriteEvent>((event, emit) async {
      await removeFavoriteQuote(event.quote);
      add(LoadFavoritesEvent());
    });
  }
}
