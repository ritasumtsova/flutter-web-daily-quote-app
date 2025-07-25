import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../bloc/quote_bloc.dart';

class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  @override
  void initState() {
    super.initState();
    // Auto-load quote on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuoteBloc>(context, listen: false).add(GetQuoteEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<QuoteBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Quote of the Day',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            tooltip: 'New Quote',
            onPressed: () => bloc.add(GetQuoteEvent()),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          ),
        ),
        child: Center(
          child: BlocBuilder<QuoteBloc, QuoteState>(
            builder: (context, state) {
              if (state is QuoteLoading) {
                return const CircularProgressIndicator(color: Colors.white);
              } else if (state is QuoteLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.white.withValues(alpha: .95),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.format_quote,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            state.quote.text,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            state.quote.author.isNotEmpty
                                ? '- ${state.quote.author}'
                                : '',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[700],
                                ),
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.ios_share,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                tooltip: 'Share Quote',
                                onPressed: () {
                                  final text =
                                      '"${state.quote.text}"\n- ${state.quote.author}';
                                  Share.share(text);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (state is QuoteError) {
                return Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                );
              }
              // Initial state
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
