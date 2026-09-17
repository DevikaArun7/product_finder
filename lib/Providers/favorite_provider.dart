import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final favoriteData = prefs.getStringList('favorites') ?? [];

    _favorites = favoriteData.map((item) {
      return Product.fromJson(
        jsonDecode(item),
      );
    }).toList();

    notifyListeners();
  }

  bool isFavorite(int productId) {
    return _favorites.any(
      (product) => product.id == productId,
    );
  }

  Future<void> addFavorite(Product product) async {
    if (!isFavorite(product.id)) {
      _favorites.add(product);

      await _saveFavorites();

      notifyListeners();
    }
  }

  Future<void> removeFavorite(int productId) async {
    _favorites.removeWhere(
      (product) => product.id == productId,
    );

    await _saveFavorites();

    notifyListeners();
  }

  Future<void> toggleFavorite(Product product) async {
    if (isFavorite(product.id)) {
      await removeFavorite(product.id);
    } else {
      await addFavorite(product);
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final favoriteData = _favorites.map((product) {
      return jsonEncode({
        'id': product.id,
        'title': product.title,
        'description': product.description,
        'category': product.category,
        'price': product.price,
        'discountPercentage': product.discountPercentage,
        'rating': product.rating,
        'stock': product.stock,
        'tags': product.tags,
        'brand': product.brand,
        'images': product.images,
        'thumbnail': product.thumbnail,
      });
    }).toList();

    await prefs.setStringList(
      'favorites',
      favoriteData,
    );
  }
}