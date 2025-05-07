import 'package:teslo_shop/features/product/infrastructure/models/product_response_model.dart';

abstract class ProductDataSource {
  Future<ProductResponse> getProducts({
    int? page,
    String? name,
    String? categoryName,
    String? providerName,
    double? minPrice,
    double? maxPrice,
    int? minStock,
    DateTime? startDate,
    DateTime? endDate,
    String? sortPrice,
  });
  Future<Product> getProductById(int id);
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(int id, Product product);
  Future<void> deleteProduct(int id);
}
