import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/product/presentation/providers/product_provider.dart';
import 'package:teslo_shop/features/product/presentation/widgets/product_filter_dialog.dart';
import 'package:teslo_shop/features/product/presentation/widgets/product_item.dart';
import 'package:teslo_shop/features/shared/widgets/side_menu.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(productsNotifierProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final productState = ref.watch(productsNotifierProvider);

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showFilterDialog(productState.currentFilters),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                hintStyle: const TextStyle(fontSize: 14.0),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _applySearch(),
                ),
                // Indicador de filtros activos
                prefixIcon: _hasActiveFilters(productState.currentFilters)
                    ? Tooltip(
                        message: 'Filtros activos',
                        child: IconButton(
                          icon:
                              const Icon(Icons.filter_list, color: Colors.blue),
                          onPressed: () =>
                              _showFilterDialog(productState.currentFilters),
                        ),
                      )
                    : null,
              ),
              style: const TextStyle(fontSize: 14.0),
              onSubmitted: (_) => _applySearch(),
            ),
          ),
          // Chips para mostrar filtros activos
          if (_hasActiveFilters(productState.currentFilters))
            _buildActiveFiltersChips(productState.currentFilters),
          Expanded(
            child: productState.response.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (products) {
                if (products.data.isEmpty) {
                  return const Center(
                      child: Text('No hay productos disponibles'));
                }
                return RefreshIndicator(
                  onRefresh: () => ref
                      .read(productsNotifierProvider.notifier)
                      .refreshProducts(),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: products.data.length + 1,
                    itemBuilder: (context, index) {
                      if (index < products.data.length) {
                        final product = products.data[index];
                        return ProductItem(product: product);
                      } else {
                        return products.nextPageUrl == null
                            ? const SizedBox()
                            : const Padding(
                                padding: EdgeInsets.all(16.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateProduct(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _applySearch() {
    if (_searchController.text.isEmpty) {
      // Si se borra la búsqueda, mantener los otros filtros
      final currentFilters = Map<String, dynamic>.from(
          ref.read(productsNotifierProvider).currentFilters);
      currentFilters.remove('name');

      ref.read(productsNotifierProvider.notifier).loadInitialProducts(
            categoryName: currentFilters['category_name'],
            providerName: currentFilters['provider_name'],
            minPrice: currentFilters['min_price'],
            maxPrice: currentFilters['max_price'],
            minStock: currentFilters['min_stock'],
            startDate: currentFilters['start_date'],
            endDate: currentFilters['end_date'],
            sortPrice: currentFilters['sort_price'],
          );
    } else {
      // Conservar filtros existentes y añadir búsqueda
      final currentFilters = Map<String, dynamic>.from(
          ref.read(productsNotifierProvider).currentFilters);

      ref.read(productsNotifierProvider.notifier).loadInitialProducts(
            name: _searchController.text,
            categoryName: currentFilters['category_name'],
            providerName: currentFilters['provider_name'],
            minPrice: currentFilters['min_price'],
            maxPrice: currentFilters['max_price'],
            minStock: currentFilters['min_stock'],
            startDate: currentFilters['start_date'],
            endDate: currentFilters['end_date'],
            sortPrice: currentFilters['sort_price'],
          );
    }
  }

  void _showFilterDialog(Map<String, dynamic> currentFilters) {
    showDialog(
      context: context,
      builder: (context) => ProductFilterDialog(
        initialFilters: currentFilters,
        onApplyFilters: (filters) {
          // Conservar el término de búsqueda
          final searchTerm = _searchController.text;
          if (searchTerm.isNotEmpty) {
            filters['name'] = searchTerm;
          }

          // Aplicar filtros
          ref.read(productsNotifierProvider.notifier).loadInitialProducts(
                name: filters['name'],
                categoryName: filters['category_name'],
                providerName: filters['provider_name'],
                minPrice: filters['min_price'],
                maxPrice: filters['max_price'],
                minStock: filters['min_stock'],
                startDate: filters['start_date'] != null
                    ? DateTime.parse(filters['start_date'])
                    : null,
                endDate: filters['end_date'] != null
                    ? DateTime.parse(filters['end_date'])
                    : null,
                sortPrice: filters['sort_price'],
              );
        },
      ),
    );
  }

  bool _hasActiveFilters(Map<String, dynamic> filters) {
    // Excluir el parámetro page que siempre está presente
    final filtersCopy = Map<String, dynamic>.from(filters)..remove('page');
    return filtersCopy.isNotEmpty;
  }

  Widget _buildActiveFiltersChips(Map<String, dynamic> filters) {
    final chips = <Widget>[];

    // Crear chip para cada filtro activo
    filters.forEach((key, value) {
      // Ignorar el filtro de página
      if (key != 'page' && key != 'name') {
        String label = '';

        switch (key) {
          case 'category_name':
            label = 'Categoría: $value';
            break;
          case 'provider_name':
            label = 'Proveedor: $value';
            break;
          case 'min_price':
            label = 'Precio min: $value';
            break;
          case 'max_price':
            label = 'Precio max: $value';
            break;
          case 'min_stock':
            label = 'Stock min: $value';
            break;
          case 'start_date':
            final date = DateTime.parse(value);
            label = 'Desde: ${date.day}/${date.month}/${date.year}';
            break;
          case 'end_date':
            final date = DateTime.parse(value);
            label = 'Hasta: ${date.day}/${date.month}/${date.year}';
            break;
          case 'sort_price':
            label = 'Orden: ${value == 'asc' ? '↑' : '↓'}';
            break;
        }

        if (label.isNotEmpty) {
          chips.add(
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Chip(
                label: Text(label, style: const TextStyle(fontSize: 12)),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => _removeFilter(key),
              ),
            ),
          );
        }
      }
    });

    // Añadir chip para limpiar todos los filtros
    if (chips.isNotEmpty) {
      chips.add(
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: ActionChip(
            label:
                const Text('Limpiar filtros', style: TextStyle(fontSize: 12)),
            onPressed: _clearAllFilters,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(children: chips),
      ),
    );
  }

  void _removeFilter(String key) {
    final currentFilters = Map<String, dynamic>.from(
        ref.read(productsNotifierProvider).currentFilters);

    // Eliminar el filtro específico
    currentFilters.remove(key);

    // Conservar el término de búsqueda
    final searchTerm = _searchController.text;
    if (searchTerm.isNotEmpty) {
      currentFilters['name'] = searchTerm;
    }

    // Aplicar el resto de filtros
    ref.read(productsNotifierProvider.notifier).loadInitialProducts(
          name: currentFilters['name'],
          categoryName: currentFilters['category_name'],
          providerName: currentFilters['provider_name'],
          minPrice: currentFilters['min_price'],
          maxPrice: currentFilters['max_price'],
          minStock: currentFilters['min_stock'],
          startDate: currentFilters['start_date'] != null
              ? DateTime.parse(currentFilters['start_date'])
              : null,
          endDate: currentFilters['end_date'] != null
              ? DateTime.parse(currentFilters['end_date'])
              : null,
          sortPrice: currentFilters['sort_price'],
        );
  }

  void _clearAllFilters() {
    // Mantener solo el término de búsqueda si existe
    final searchTerm = _searchController.text;
    final Map<String, dynamic> newFilters = {};

    if (searchTerm.isNotEmpty) {
      newFilters['name'] = searchTerm;
    }

    ref.read(productsNotifierProvider.notifier).loadInitialProducts(
          name: searchTerm.isNotEmpty ? searchTerm : null,
        );
  }

  void _navigateToCreateProduct() {
    // Navegar a pantalla de creación
  }
}
