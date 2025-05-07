import 'package:flutter/material.dart';
import 'package:teslo_shop/config/constants/app_api_constants.dart';
import 'package:teslo_shop/features/product/infrastructure/models/product_response_model.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: product.imgUrl != null
            ? Image.network(
                '${ApiConstants.baseUrl}/storage/${product.imgUrl}',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.image),
        title: Text(product.name),
        subtitle: Text('\$${product.price} - Stock: ${product.stock}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _navigateToEditProduct(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToEditProduct(BuildContext context) {
    // Navegar a pantalla de edición
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content:
            const Text('¿Estás seguro de que quieres eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Llamar al método delete del notifier
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
