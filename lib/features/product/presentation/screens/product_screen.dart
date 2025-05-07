import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/product/presentation/providers/product_provider.dart';
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
            onPressed: _showFilterDialog,
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
                hintStyle: const TextStyle(fontSize: 14.0), // Reduce font size
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _applySearch(),
                ),
              ),
              style: const TextStyle(fontSize: 14.0), // Reduce input text size
              onSubmitted: (_) => _applySearch(),
            ),
          ),
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
    ref.read(productsNotifierProvider.notifier).loadInitialProducts(
          name: _searchController.text,
        );
  }

  void _showFilterDialog() {
    // Implementa tu diálogo de filtros aquí
  }

  void _navigateToCreateProduct() {
    // Navegar a pantalla de creación
  }
}
