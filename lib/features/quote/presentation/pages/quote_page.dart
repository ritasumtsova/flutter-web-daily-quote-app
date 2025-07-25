import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../features/favorites/presentation/bloc/favorites_bloc.dart';
import '../../../../../features/favorites/domain/entities/favorite_quote.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuoteBloc>(context, listen: false).add(GetQuoteEvent());
      Provider.of<FavoritesBloc>(
        context,
        listen: false,
      ).add(LoadFavoritesEvent());
    });
  }

  void _showAddCustomQuoteSheet() {
    final textController = TextEditingController();
    final authorController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 32,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Custom Quote',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: textController,
                decoration: const InputDecoration(labelText: 'Quote'),
                maxLines: 2,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(
                  labelText: 'Author (optional)',
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final text = textController.text.trim();
                      final author = authorController.text.trim();
                      if (text.isNotEmpty) {
                        context.read<FavoritesBloc>().add(
                          AddFavoriteEvent(
                            FavoriteQuote(text: text, author: author),
                          ),
                        );
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Quote added successfully!'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF283593),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<QuoteBloc, QuoteState>(
                builder: (context, quoteState) {
                  if (quoteState is QuoteLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (quoteState is QuoteLoaded) {
                    return BlocBuilder<FavoritesBloc, FavoritesState>(
                      builder: (context, favState) {
                        final isFavorite =
                            favState is FavoritesLoaded &&
                            favState.favorites.any(
                              (q) =>
                                  q.text == quoteState.quote.text &&
                                  q.author == quoteState.quote.author,
                            );
                        return Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(
                              color: Color(0xFF283593),
                              width: 1.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 18,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Get your daily inspiration',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF283593),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  quoteState.quote.text,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        quoteState.quote.author.isNotEmpty
                                            ? '- ${quoteState.quote.author}'
                                            : '',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.red,
                                      ),
                                      tooltip: isFavorite
                                          ? 'Remove from Favorites'
                                          : 'Add to Favorites',
                                      onPressed: () {
                                        final favBloc = context
                                            .read<FavoritesBloc>();
                                        final favQuote = FavoriteQuote(
                                          text: quoteState.quote.text,
                                          author: quoteState.quote.author,
                                        );
                                        if (isFavorite) {
                                          favBloc.add(
                                            RemoveFavoriteEvent(favQuote),
                                          );
                                        } else {
                                          favBloc.add(
                                            AddFavoriteEvent(favQuote),
                                          );
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.ios_share,
                                        color: Colors.grey,
                                      ),
                                      tooltip: 'Share Quote',
                                      onPressed: () {
                                        final text =
                                            '"${quoteState.quote.text}"\n- ${quoteState.quote.author}';
                                        Share.share(text);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (quoteState is QuoteError) {
                    return Text(
                      quoteState.message,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _showAddCustomQuoteSheet,
                icon: const Icon(Icons.add),
                label: const Text('Add Custom Quote'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF283593),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Your custom quotes will appear in Favorites!',
                  style: TextStyle(color: Colors.grey[600], fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
