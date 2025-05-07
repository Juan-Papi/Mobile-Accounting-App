import 'package:teslo_shop/features/product/domain/repositories/product_repository.dart';
import 'package:teslo_shop/features/product/infrastructure/models/product_response_model.dart';
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
}
