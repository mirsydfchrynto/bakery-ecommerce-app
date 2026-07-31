import '../../../../core/constants/app_config.dart';

class ProductModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String status;
  final String? imageUrl;
  final String categoryName;
  final int stock;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.status,
    this.imageUrl,
    this.categoryName = 'Uncategorized',
    this.stock = 0,
  });

  String? get displayImageUrl {
    if (imageUrl == null || imageUrl!.isEmpty) return null;
    if (imageUrl!.startsWith('http')) return imageUrl;
    final hostUrl = AppConfig.baseUrl.replaceAll('/api/v1', '');
    return hostUrl + (imageUrl!.startsWith('/') ? imageUrl! : '/$imageUrl');
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'DRAFT',
      imageUrl: json['imageUrl'],
      categoryName: json['categoryName'] ?? 'Uncategorized',
      stock: json['stock'] ?? 0,
    );
  }
}
