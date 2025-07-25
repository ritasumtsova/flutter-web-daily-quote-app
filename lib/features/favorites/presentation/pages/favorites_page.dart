import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorites_bloc.dart';
import '../../domain/entities/favorite_quote.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  static final List<Color> cardColors = [
    const Color(0xFF283593), // Royal Blue
    const Color(0xFF8E24AA), // Purple
    const Color(0xFF43A047), // Green
    const Color(0xFFF4511E), // Orange
    const Color(0xFFD81B60), // Pink
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FavoritesLoaded) {
          if (state.favorites.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ), // No horizontal padding
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final quote = state.favorites[index];
              final color = cardColors[index % cardColors.length];
              return Dismissible(
                key: ValueKey('${quote.text}_${quote.author}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                onDismissed: (direction) {
                  context.read<FavoritesBloc>().add(RemoveFavoriteEvent(quote));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Removed from favorites'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          context.read<FavoritesBloc>().add(
                            AddFavoriteEvent(quote),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    left: 16,
                    right: 16,
                  ),
                  width: double.infinity,
                  child: Card(
                    elevation: 0,
                    color: color.withOpacity(0.12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: color, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '"${quote.text}"',
                            style: TextStyle(
                              color: Colors.grey[900],
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '- ${quote.author}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is FavoritesError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
