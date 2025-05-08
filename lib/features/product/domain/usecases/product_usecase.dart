import 'package:teslo_shop/features/product/domain/repositories/product_repository.dart';
import 'package:teslo_shop/features/product/infrastructure/models/category_response.dart';
import 'package:teslo_shop/features/product/infrastructure/models/product_response_model.dart';
import 'package:teslo_shop/features/product/infrastructure/models/provider_response.dart';
import 'package:teslo_shop/features/product/infrastructure/repositories/product_repository_impl.dart';

class ProductUseCase {
  final ProductRepository repository;

  ProductUseCase({ProductRepository? repository})
      : repository = repository ?? ProductRepositoryImpl();

  Future<ProductResponse> call({
    int page = 1,
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
    return await repository.getProducts(
      page: page,
      name: name,
      categoryName: categoryName,
      providerName: providerName,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minStock: minStock,
      startDate: startDate,
      endDate: endDate,
      sortPrice: sortPrice,
    );
  }

  Future<Product> getProductById(int id) async {
    return await repository.getProductById(id);
  }

  Future<Product> createProduct(Product product) async {
    return await repository.createProduct(product);
  }

  Future<Product> updateProduct(int id, Product product) async {
    return await repository.updateProduct(id, product);
  }

  Future<void> deleteProduct(int id) async {
    return await repository.deleteProduct(id);
  }

  Future<List<Category>> getCategories() async {
    return await repository.getCategories();
  }

  Future<List<Provider>> getProviders() async {
    return await repository.getProviders();
  }
}
