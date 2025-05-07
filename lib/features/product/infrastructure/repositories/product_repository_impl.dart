import 'package:teslo_shop/features/product/domain/datasources/product_datasource.dart';
import 'package:teslo_shop/features/product/domain/repositories/product_repository.dart';
import 'package:teslo_shop/features/product/infrastructure/datasources/product_datasource_impl.dart';
import 'package:teslo_shop/features/product/infrastructure/models/product_response_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource dataSource;
  ProductRepositoryImpl({ProductDataSource? dataSource})
      : dataSource = dataSource ?? ProductDataSourceImpl();

  @override
  Future<ProductResponse> getProducts({
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
    return dataSource.getProducts(
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

  @override
  Future<Product> createProduct(Product product) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProduct(int id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(int id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<Product> updateProduct(int id, Product product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }
}
