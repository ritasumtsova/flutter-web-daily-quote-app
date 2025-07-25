import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/quote.dart';
import '../../domain/usecases/get_quote_of_the_day.dart';

// Events
abstract class QuoteEvent {}

class GetQuoteEvent extends QuoteEvent {}

// States
abstract class QuoteState {}

class QuoteInitial extends QuoteState {}

class QuoteLoading extends QuoteState {}

class QuoteLoaded extends QuoteState {
  final Quote quote;
  QuoteLoaded(this.quote);
}

class QuoteError extends QuoteState {
  final String message;
  QuoteError(this.message);
}

// Bloc
class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final GetQuoteOfTheDay getQuoteOfTheDay;

  QuoteBloc(this.getQuoteOfTheDay) : super(QuoteInitial()) {
    on<GetQuoteEvent>((event, emit) async {
      print('GetQuoteEvent received');
      emit(QuoteLoading());
      try {
        final quote = await getQuoteOfTheDay();
        print('Quote loaded: \\${quote.text}');
        emit(QuoteLoaded(quote));
      } catch (e) {
        print('Error: \\${e.toString()}');
        emit(QuoteError(e.toString()));
      }
    });
  }
}
