import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:product_finder/Providers/product_provider.dart';
import 'package:product_finder/Screens/FavoritesPage.dart';
import 'package:product_finder/Screens/LoginPage.dart';
import 'package:product_finder/Screens/ProductDetailsPage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).fetchProducts();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context);

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Finder'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesPage(),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorites',
          ),

          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onSubmitted: (value) {
                Provider.of<ProductProvider>(
                  context,
                  listen: false,
                ).searchProducts(value);
              },
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          Expanded(
            child: productProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : productProvider.errorMessage.isNotEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                productProvider.errorMessage,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: () {
                                  productProvider.fetchProducts();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : productProvider.products.isEmpty
                        ? const Center(
                            child: Text(
                              'No products found',
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                productProvider.products.length,
                            itemBuilder: (context, index) {
                              final product =
                                  productProvider.products[index];

                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailsPage(
                                          product: product,
                                        ),
                                      ),
                                    );
                                  },

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
                                    overflow:
                                        TextOverflow.ellipsis,
                                  ),

                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text(
                                        '\$${product.price}',
                                      ),
                                      Text(
                                        '⭐ ${product.rating}',
                                      ),
                                      Text(
                                        product.category,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}