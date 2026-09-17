import 'package:flutter/material.dart';
import 'package:product_finder/Providers/favorite_provider.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              final isFavorite =
                  favoriteProvider.isFavorite(product.id);

              return IconButton(
                onPressed: () {
                  favoriteProvider.toggleFavorite(product);
                },
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                tooltip: 'Favorite',
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.thumbnail,
                width: screenWidth * 0.9,
                height: screenWidth * 0.6,
                fit: BoxFit.contain,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 60,
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: screenWidth * 0.2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: product.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: Image.network(
                      product.images[index],
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Icon(
                          Icons.image_not_supported,
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Text(
              product.title,
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              '\$${product.price}',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Discount: ${product.discountPercentage.toStringAsFixed(1)}%',
            ),

            const SizedBox(height: 10),

            Text(
              '⭐ ${product.rating}',
            ),

            const SizedBox(height: 10),

            Text(
              'Category: ${product.category}',
            ),

            const SizedBox(height: 10),

            Text(
              'Brand: ${product.brand ?? 'N/A'}',
            ),

            const SizedBox(height: 10),

            Text(
              'Stock: ${product.stock}',
            ),

            const SizedBox(height: 20),

            Text(
              'Description',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              product.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Tags',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product.tags.map((tag) {
                return Chip(
                  label: Text(tag),
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            Consumer<FavoriteProvider>(
              builder: (context, favoriteProvider, child) {
                final isFavorite =
                    favoriteProvider.isFavorite(product.id);

                return SizedBox(
                  width: screenWidth * 0.9,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      favoriteProvider.toggleFavorite(product);
                    },
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    label: Text(
                      isFavorite
                          ? 'Remove from Favorites'
                          : 'Add to Favorites',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}