import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/product/domain/usecases/product_usecase.dart';
import 'package:teslo_shop/features/product/infrastructure/models/product_response_model.dart';

final productUseCaseProvider = Provider<ProductUseCase>((ref) {
  return ProductUseCase();
});

final productsNotifierProvider =
    StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  final useCase = ref.watch(productUseCaseProvider);
  return ProductNotifier(productUseCase: useCase);
});

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductUseCase productUseCase;

  ProductNotifier({required this.productUseCase})
      : super(ProductState(
          response: const AsyncValue.loading(),
          isLoadingMore: false,
          searchQuery: null,
          filters: {},
        )) {
    loadInitialProducts();
  }

  Future<void> loadInitialProducts({
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
    bool forceRefresh = false,
  }) async {
    // Si no es un refresh forzado y ya tenemos datos, mantenemos los datos actuales mientras cargamos
    if (!forceRefresh && state.response.value != null) {
      state = state.copyWith(
        response: AsyncValue.data(state.response.value!)
            .copyWithPrevious(state.response),
      );
    } else {
      state = state.copyWith(response: const AsyncValue.loading());
    }

    try {
      final filters = {
        'page': page,
        if (name != null) 'name': name,
        if (categoryName != null) 'category_name': categoryName,
        if (providerName != null) 'provider_name': providerName,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (minStock != null) 'min_stock': minStock,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        if (sortPrice != null) 'sort_price': sortPrice,
      };

      final products = await productUseCase.call(
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

      state = state.copyWith(
        response: AsyncValue.data(products),
        searchQuery: name,
        currentFilters: filters,
      );
    } catch (e, st) {
      state = state.copyWith(
        response: AsyncValue.error(e, st),
      );
    }
  }

  Future<void> loadNextPage() async {
    final currentData = state.response.value;
    if (currentData == null ||
        currentData.nextPageUrl == null ||
        state.isLoadingMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = currentData.currentPage + 1;

      // Mantener los filtros actuales
      final newProducts = await productUseCase(
        page: nextPage,
        name: state.searchQuery,
        categoryName: state.currentFilters['category_name'],
        providerName: state.currentFilters['provider_name'],
        minPrice: state.currentFilters['min_price'],
        maxPrice: state.currentFilters['max_price'],
        minStock: state.currentFilters['min_stock'],
        startDate: state.currentFilters['start_date'],
        endDate: state.currentFilters['end_date'],
        sortPrice: state.currentFilters['sort_price'],
      );

      // Combinar los productos existentes con los nuevos
      final combinedProducts = ProductResponse(
        currentPage: newProducts.currentPage,
        data: [...currentData.data, ...newProducts.data],
        firstPageUrl: newProducts.firstPageUrl,
        from: newProducts.from,
        lastPage: newProducts.lastPage,
        lastPageUrl: newProducts.lastPageUrl,
        links: newProducts.links,
        nextPageUrl: newProducts.nextPageUrl,
        path: newProducts.path,
        perPage: newProducts.perPage,
        prevPageUrl: newProducts.prevPageUrl,
        to: newProducts.to,
        total: newProducts.total,
      );

      state = state.copyWith(
        response: AsyncValue.data(combinedProducts),
        isLoadingMore: false,
      );
    } catch (e, st) {
      state = state.copyWith(
        response: AsyncValue.error(e, st),
        isLoadingMore: false,
      );
    }
  }

  Future<void> refreshProducts() async {
    await loadInitialProducts(
      forceRefresh: true,
      // Replicar los filtros actuales
      name: state.searchQuery,
      page: state.currentFilters['page'] ?? 1,
      categoryName: state.currentFilters['category_name'],
      providerName: state.currentFilters['provider_name'],
      minPrice: state.currentFilters['min_price'],
      maxPrice: state.currentFilters['max_price'],
      minStock: state.currentFilters['min_stock'],
      startDate: state.currentFilters['start_date'],
      endDate: state.currentFilters['end_date'],
      sortPrice: state.currentFilters['sort_price'],
    );
  }

  Future<void> applySearch(String query) async {
    await loadInitialProducts(name: query);
  }

  Future<void> applyFilters(Map<String, dynamic> filters) async {
    await loadInitialProducts(
      page: state.currentFilters['page'] ?? 1,
      name: state.searchQuery,
      categoryName: state.currentFilters['category_name'],
      providerName: state.currentFilters['provider_name'],
      minPrice: state.currentFilters['min_price'],
      maxPrice: state.currentFilters['max_price'],
      minStock: state.currentFilters['min_stock'],
      startDate: state.currentFilters['start_date'],
      endDate: state.currentFilters['end_date'],
      sortPrice: state.currentFilters['sort_price'],
    );
  }

  // Métodos CRUD
  Future<void> createProduct(Product product) async {
    try {
      state = state.copyWith(response: const AsyncValue.loading());
      await productUseCase.repository.createProduct(product);
      await refreshProducts(); // Recargar con los mismos filtros
    } catch (e, st) {
      state = state.copyWith(
        response: AsyncValue<ProductResponse>.error(e, st)
            .copyWithPrevious(state.response),
      );
      rethrow;
    }
  }

  Future<void> updateProduct(int id, Product product) async {
    try {
      state = state.copyWith(response: const AsyncValue.loading());
      await productUseCase.repository.updateProduct(id, product);
      await refreshProducts(); // Recargar con los mismos filtros
    } catch (e, st) {
      state = state.copyWith(
        response: AsyncValue<ProductResponse>.error(e, st)
            .copyWithPrevious(state.response),
      );
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      state = state.copyWith(response: const AsyncValue.loading());
      await productUseCase.repository.deleteProduct(id);
      await refreshProducts(); // Recargar con los mismos filtros
    } catch (e, st) {
      state = state.copyWith(
        response: AsyncValue<ProductResponse>.error(e, st)
            .copyWithPrevious(state.response),
      );
      rethrow;
    }
  }
}

class ProductState {
  final AsyncValue<ProductResponse> response;
  final bool isLoadingMore;
  final String? searchQuery;
  final Map<String, dynamic> currentFilters;

  ProductState({
    required this.response,
    this.isLoadingMore = false,
    this.searchQuery,
    Map<String, dynamic>? filters,
  }) : currentFilters = filters ?? {};

  ProductState copyWith({
    AsyncValue<ProductResponse>? response,
    bool? isLoadingMore,
    String? searchQuery,
    Map<String, dynamic>? currentFilters,
  }) {
    return ProductState(
      response: response ?? this.response,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      filters: currentFilters ?? this.currentFilters,
    );
  }
}
