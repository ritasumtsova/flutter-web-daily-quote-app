import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

abstract class QuoteRemoteDataSource {
  Future<QuoteModel> getRandomQuote();
}

class QuoteRemoteDataSourceImpl implements QuoteRemoteDataSource {
  final String apiKey;
  QuoteRemoteDataSourceImpl(this.apiKey);

  @override
  Future<QuoteModel> getRandomQuote() async {
    print('Calling API...');
    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/quotes'),
      headers: {'X-Api-Key': apiKey},
    );
    print('API response: \\${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return QuoteModel.fromJson(data[0]);
    } else {
      throw Exception('Failed to fetch quote: \\${response.statusCode}');
    }
  }
}
