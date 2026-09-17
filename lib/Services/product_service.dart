import 'dart:convert';
import 'dart:io';


import '../models/product.dart';

class ProductService {
  final String baseUrl = 'https://dummyjson.com';

  Future<List<Product>> getProducts() async {
    print('Starting products API request...');

    final client = HttpClient();

    try {
      client.connectionTimeout = const Duration(seconds: 30);

      final request = await client.getUrl(
        Uri.parse('$baseUrl/products?limit=30'),
      );

      request.headers.set(
        HttpHeaders.acceptHeader,
        'application/json',
      );

      request.headers.set(
        HttpHeaders.userAgentHeader,
        'Mozilla/5.0 Flutter Product Finder',
      );

      print('Sending request to DummyJSON...');

      final response = await request.close();

      print('Products API status: ${response.statusCode}');

      final responseBody = await response.transform(utf8.decoder).join();

      print('Response received');

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);

        final List productsJson = data['products'];

        final products = productsJson
            .map(
              (json) => Product.fromJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList();

        print('Products parsed successfully: ${products.length}');

        return products;
      } else {
        throw Exception(
          'Failed to load products: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Products API ERROR: $e');
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    print('Starting search API request...');

    final client = HttpClient();

    try {
      client.connectionTimeout = const Duration(seconds: 30);

      final uri = Uri.parse(
        '$baseUrl/products/search',
      ).replace(
        queryParameters: {
          'q': query.trim(),
        },
      );

      final request = await client.getUrl(uri);

      request.headers.set(
        HttpHeaders.acceptHeader,
        'application/json',
      );

      request.headers.set(
        HttpHeaders.userAgentHeader,
        'Mozilla/5.0 Flutter Product Finder',
      );

      print('Sending search request to DummyJSON...');

      final response = await request.close();

      print('Search API status: ${response.statusCode}');

      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);

        final List productsJson = data['products'];

        final products = productsJson
            .map(
              (json) => Product.fromJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList();

        print(
          'Search results parsed successfully: ${products.length}',
        );

        return products;
      } else {
        throw Exception(
          'Failed to search products: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Search API ERROR: $e');
      rethrow;
    } finally {
      client.close();
    }
  }
}