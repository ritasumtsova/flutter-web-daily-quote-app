import '../../domain/entities/quote.dart';

class QuoteModel extends Quote {
  const QuoteModel({required String text, required String author})
    : super(text: text, author: author);

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      text: json['quote'] as String,
      author: json['author'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'quote': text, 'author': author};
}
