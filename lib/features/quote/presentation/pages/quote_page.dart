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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[100], // Flat, light background
      child: Center(
        child: BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, quoteState) {
            if (quoteState is QuoteLoading) {
              return const CircularProgressIndicator();
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 24.0,
                    ),
                    child: Card(
                      elevation: 0, // Flat card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.format_quote,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              quoteState.quote.text,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              quoteState.quote.author.isNotEmpty
                                  ? '- ${quoteState.quote.author}'
                                  : '',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[700],
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                      favBloc.add(AddFavoriteEvent(favQuote));
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
                                IconButton(
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: Colors.grey,
                                  ),
                                  tooltip: 'New Quote',
                                  onPressed: () => context
                                      .read<QuoteBloc>()
                                      .add(GetQuoteEvent()),
                                ),
                              ],
                            ),
                          ],
                        ),
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
      ),
    );
  }
}
