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
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuoteBloc>(context, listen: false).add(GetQuoteEvent());
      Provider.of<QuoteBloc>(context, listen: false).add(LoadFavoritesEvent());
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Provider.of<QuoteBloc>(context, listen: false).add(LoadFavoritesEvent());
    }
  }

  Widget _buildHomeTab(BuildContext context, QuoteBloc bloc) {
    return Center(
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
                color: Colors.white.withOpacity(0.95),
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
                      const SizedBox(height: 24),
                      IconButton(
                        icon: Icon(
                          state.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                          size: 32,
                        ),
                        tooltip: state.isFavorite
                            ? 'Remove from Favorites'
                            : 'Add to Favorites',
                        onPressed: () {
                          if (state.isFavorite) {
                            bloc.add(RemoveFavoriteEvent(state.quote));
                          } else {
                            bloc.add(AddFavoriteEvent(state.quote));
                          }
                          bloc.add(LoadFavoritesEvent());
                        },
                      ),
                      const SizedBox(height: 16),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.black),
                        tooltip: 'New Quote',
                        onPressed: () => bloc.add(GetQuoteEvent()),
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
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFavoritesTab(BuildContext context) {
    return BlocBuilder<QuoteBloc, QuoteState>(
      builder: (context, state) {
        List<Widget> children = [];
        if (state is FavoritesLoaded) {
          if (state.favorites.isEmpty) {
            children.add(
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Center(child: Text('No favorites yet.')),
              ),
            );
          } else {
            children.add(
              ListView.builder(
                itemCount: state.favorites.length,
                itemBuilder: (context, index) {
                  final quote = state.favorites[index];
                  return ListTile(
                    title: Text('"${quote.text}"'),
                    subtitle: Text('- ${quote.author}'),
                  );
                },
              ),
            );
          }
        } else {
          children.add(const Center(child: CircularProgressIndicator()));
        }
        return Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: children.isNotEmpty
                  ? children.first
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<QuoteBloc>(context, listen: false);
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   title: const Text(
      //     'Quote of the Day',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontWeight: FontWeight.bold,
      //       fontSize: 22,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
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
        child: _selectedIndex == 0
            ? _buildHomeTab(context, bloc)
            : _buildFavoritesTab(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.red),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
