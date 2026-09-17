import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService productService = ProductService();

  List<Product> products = [];

  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchProducts() async {
   

    isLoading = true;
    errorMessage = '';

    notifyListeners();

    try {
      print('Calling ProductService...');

      final result = await productService.getProducts();

      print('API request completed');
      print('Number of products: ${result.length}');

      products = result;
    } catch (e) {
      print(e);

      errorMessage = 'Failed to load products: $e';
    }

    isLoading = false;

    notifyListeners();

  }

  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      await fetchProducts();
      return;
    }

    print('Search query: ${query.trim()}');

    isLoading = true;
    errorMessage = '';

    notifyListeners();

    try {
      final result =
          await productService.searchProducts(query.trim());

      print('Search completed');
      print('Search results: ${result.length}');

      products = result;
    } catch (e) {
      print(e);

      errorMessage = 'Failed to search products: $e';
    }

    isLoading = false;

    notifyListeners();

  }
}