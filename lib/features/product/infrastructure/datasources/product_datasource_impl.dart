import 'package:teslo_shop/config/constants/app_api_constants.dart';
import 'package:teslo_shop/config/network/api_client.dart';
import 'package:teslo_shop/config/network/api_client_impl.dart';
import 'package:teslo_shop/features/product/domain/datasources/product_datasource.dart';
import 'package:teslo_shop/features/product/infrastructure/models/product_response_model.dart';

class ProductDataSourceImpl implements ProductDataSource {
  final ApiClient apiClient = ApiClientImpl();

  @override
  Future<ProductResponse> getProducts({
    int? page = 1,
    String? name,
    String? categoryName,
    String? providerName,
    double? minPrice,
    double? maxPrice,
    int? minStock,
    DateTime? startDate,
    DateTime? endDate,
    String? sortPrice,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      if (name != null && name.isNotEmpty) 'name': name,
      if (categoryName != null && categoryName.isNotEmpty)
        'category_name': categoryName,
      if (providerName != null && providerName.isNotEmpty)
        'provider_name': providerName,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (minStock != null) 'min_stock': minStock,
      if (startDate != null) 'start_date': startDate.toIso8601String(),
      if (endDate != null) 'end_date': endDate.toIso8601String(),
      if (sortPrice != null && sortPrice.isNotEmpty) 'sort_price': sortPrice,
    };

    final response = await apiClient.get(
      ApiConstants.listProductsEndpoint,
      queryParams: queryParams,
    );

    return ProductResponse.fromJson(response);
  }

  @override
  Future<Product> getProductById(int id) async {
    final response = await apiClient.get(
      '${ApiConstants.listProductsEndpoint}/$id',
    );
    return Product.fromJson(response);
  }

  @override
  Future<Product> createProduct(Product product) async {
    final response = await apiClient.post(
      ApiConstants.listProductsEndpoint,
      data: product.toJson(),
    );
    return Product.fromJson(response);
  }

  @override
  Future<Product> updateProduct(int id, Product product) async {
    final response = await apiClient.put(
      '${ApiConstants.listProductsEndpoint}/$id',
      data: product.toJson(),
    );
    return Product.fromJson(response);
  }

  @override
  Future<void> deleteProduct(int id) async {
    await apiClient.delete(
      '${ApiConstants.listProductsEndpoint}/$id',
    );
  }
}
