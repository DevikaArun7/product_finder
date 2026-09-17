import 'package:flutter/material.dart';
import 'package:product_finder/Providers/favorite_provider.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          final favorites = favoriteProvider.favorites;

          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'No favorite products yet',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final product = favorites[index];

              return Card(
                margin: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),

                  leading: Image.network(
                    product.thumbnail,
                    width: screenWidth * 0.18,
                    height: screenWidth * 0.18,
                    fit: BoxFit.cover,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 40,
                      );
                    },
                  ),

                  title: Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Text(
                      '\$${product.price}',
                    ),
                  ),

                  trailing: IconButton(
                    onPressed: () {
                      favoriteProvider.removeFavorite(
                        product.id,
                      );
                    },
                    icon: const Icon(
                      Icons.favorite,
                    ),
                    tooltip: 'Remove from favorites',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}