import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductFilterDialog extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;
  final Function(Map<String, dynamic> filters) onApplyFilters;

  const ProductFilterDialog({
    Key? key,
    this.initialFilters,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  State<ProductFilterDialog> createState() => _ProductFilterDialogState();
}

class _ProductFilterDialogState extends State<ProductFilterDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para los campos de texto
  late TextEditingController _categoryController;
  late TextEditingController _providerController;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  late TextEditingController _minStockController;
  
  // Para fechas
  DateTime? _startDate;
  DateTime? _endDate;
  
  // Para ordenamiento
  String? _sortPrice;

  @override
  void initState() {
    super.initState();
    
    // Inicializar controladores con valores iniciales si existen
    final filters = widget.initialFilters ?? {};
    
    _categoryController = TextEditingController(
      text: filters['category_name']?.toString() ?? '',
    );
    _providerController = TextEditingController(
      text: filters['provider_name']?.toString() ?? '',
    );
    _minPriceController = TextEditingController(
      text: filters['min_price']?.toString() ?? '',
    );
    _maxPriceController = TextEditingController(
      text: filters['max_price']?.toString() ?? '',
    );
    _minStockController = TextEditingController(
      text: filters['min_stock']?.toString() ?? '',
    );
    
    // Fechas
    _startDate = filters['start_date'] != null 
        ? DateTime.parse(filters['start_date'])
        : null;
    _endDate = filters['end_date'] != null
        ? DateTime.parse(filters['end_date'])
        : null;
    
    // Ordenamiento
    _sortPrice = filters['sort_price']?.toString();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _providerController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtrar productos'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryField(),
              const SizedBox(height: 12),
              _buildProviderField(),
              const SizedBox(height: 12),
              _buildPriceFields(),
              const SizedBox(height: 12),
              _buildStockField(),
              const SizedBox(height: 12),
              _buildDateFields(),
              const SizedBox(height: 12),
              _buildSortFields(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _resetFilters,
          child: const Text('Resetear'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _applyFilters,
          child: const Text('Aplicar'),
        ),
      ],
    );
  }

  Widget _buildCategoryField() {
    return TextFormField(
      controller: _categoryController,
      decoration: const InputDecoration(
        labelText: 'Categoría',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }

  Widget _buildProviderField() {
    return TextFormField(
      controller: _providerController,
      decoration: const InputDecoration(
        labelText: 'Proveedor',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }

  Widget _buildPriceFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _minPriceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Precio mínimo',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: _maxPriceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Precio máximo',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStockField() {
    return TextFormField(
      controller: _minStockController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Stock mínimo',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }

  Widget _buildDateFields() {
    // Formato para mostrar la fecha
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Rango de fechas:'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(isStartDate: true),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                  child: Text(
                    _startDate != null
                        ? dateFormat.format(_startDate!)
                        : 'Fecha inicial',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(isStartDate: false),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                  child: Text(
                    _endDate != null
                        ? dateFormat.format(_endDate!)
                        : 'Fecha final',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSortFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ordenar por precio:'),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Radio<String>(
                value: 'asc',
                groupValue: _sortPrice,
                onChanged: (value) {
                  setState(() {
                    _sortPrice = value;
                  });
                },
              ),
              const Text('Menor a mayor'),
              const SizedBox(width: 8),
              Radio<String>(
                value: 'desc',
                groupValue: _sortPrice,
                onChanged: (value) {
                  setState(() {
                    _sortPrice = value;
                  });
                },
              ),
              const Text('Mayor a menor'),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate({required bool isStartDate}) async {
    final initialDate = isStartDate ? _startDate : _endDate;
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _categoryController.clear();
      _providerController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
      _minStockController.clear();
      _startDate = null;
      _endDate = null;
      _sortPrice = null;
    });
  }

  void _applyFilters() {
    // Validar el formulario si es necesario
    if (_formKey.currentState!.validate()) {
      // Construir el mapa de filtros
      final filters = <String, dynamic>{};
      
      if (_categoryController.text.isNotEmpty) {
        filters['category_name'] = _categoryController.text;
      }
      
      if (_providerController.text.isNotEmpty) {
        filters['provider_name'] = _providerController.text;
      }
      
      if (_minPriceController.text.isNotEmpty) {
        filters['min_price'] = double.parse(_minPriceController.text);
      }
      
      if (_maxPriceController.text.isNotEmpty) {
        filters['max_price'] = double.parse(_maxPriceController.text);
      }
      
      if (_minStockController.text.isNotEmpty) {
        filters['min_stock'] = int.parse(_minStockController.text);
      }
      
      if (_startDate != null) {
        filters['start_date'] = _startDate!.toIso8601String();
      }
      
      if (_endDate != null) {
        filters['end_date'] = _endDate!.toIso8601String();
      }
      
      if (_sortPrice != null) {
        filters['sort_price'] = _sortPrice;
      }
      
      // Aplicar filtros y cerrar el diálogo
      widget.onApplyFilters(filters);
      Navigator.pop(context);
    }
  }
}