import 'dart:convert';

ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

class ProductResponse {
  List<Product> products;
  int total;
  int skip;
  int limit;

  ProductResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      products: List<Product>.from(
        json["products"].map((x) => Product.fromJson(x)),
      ),
      total: json["total"],
      skip: json["skip"],
      limit: json["limit"],
    );
  }
}

class Product {
  int id;
  String title;
  String description;
  String category;
  double price;
  double discountPercentage;
  double rating;
  int stock;
  List<String> tags;
  String? brand;
  List<String> images;
  String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    this.brand,
    required this.images,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      category: json["category"],
      price: (json["price"] as num).toDouble(),
      discountPercentage:
          (json["discountPercentage"] as num).toDouble(),
      rating: (json["rating"] as num).toDouble(),
      stock: json["stock"],
      tags: List<String>.from(json["tags"] ?? []),
      brand: json["brand"],
      images: List<String>.from(json["images"] ?? []),
      thumbnail: json["thumbnail"],
    );
  }
}