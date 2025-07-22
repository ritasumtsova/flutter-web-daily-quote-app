import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../di/quote_di.dart';
import '../pages/quote_page.dart';

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: quoteProviders,
      child: MaterialApp(
        title: 'Quote of the Day',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
        ),
        home: const QuotePage(),
      ),
    );
  }
}
