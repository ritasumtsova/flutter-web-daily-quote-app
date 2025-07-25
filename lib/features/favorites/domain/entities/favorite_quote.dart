class FavoriteQuote {
  final String text;
  final String author;

  const FavoriteQuote({required this.text, required this.author});

  factory FavoriteQuote.fromJson(Map<String, dynamic> json) {
    return FavoriteQuote(
      text: json['text'] as String? ?? json['quote'] as String? ?? '',
      author: json['author'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'text': text, 'author': author};
}
