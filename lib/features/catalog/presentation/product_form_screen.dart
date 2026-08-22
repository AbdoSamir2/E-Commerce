import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/product_model.dart';
import '../logic/product_cubit.dart';
import '../logic/product_state.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key, this.existingProduct});

  final ProductModel? existingProduct;

  bool get isEditing => existingProduct != null;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _stockStatus = 'In stock';

  @override
  void initState() {
    super.initState();

    final product = widget.existingProduct;
    if (product == null) {
      return;
    }

    _titleController.text = product.title;
    _priceController.text = product.price;
    _imageUrlController.text = product.imageUrl;
    _descriptionController.text = product.description;
    _stockStatus = product.stockStatus;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final description = _descriptionController.text.trim();

    final product = ProductModel(
      id: widget.existingProduct?.id ?? '',
      title: _titleController.text.trim(),
      price: _priceController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
      description: description.isEmpty
          ? 'No description available.'
          : description,
      stockStatus: _stockStatus,
    );

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final cubit = context.read<ProductCubit>();

    final wasSaved = widget.isEditing
        ? await cubit.updateProduct(product)
        : await cubit.addProduct(product);

    if (!mounted) {
      return;
    }

    if (wasSaved) {
      final action = widget.isEditing ? 'updated' : 'added';
      messenger.showSnackBar(
        SnackBar(content: Text('${product.title} $action')),
      );
      navigator.pop(product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit product' : 'Add product'),
      ),
      body: BlocListener<ProductCubit, ProductState>(
        listenWhen: (previous, current) =>
            current.errorMessage != null &&
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a product title';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    validator: (value) {
                      final price = double.tryParse(value?.trim() ?? '');

                      if (price == null) {
                        return 'Please enter a valid price';
                      }

                      if (price <= 0) {
                        return 'Price must be greater than zero';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _imageUrlController,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      prefixIcon: Icon(Icons.image_outlined),
                    ),
                    validator: (value) {
                      final url = value?.trim() ?? '';

                      if (url.isEmpty) {
                        return 'Please enter an image URL';
                      }

                      final parsed = Uri.tryParse(url);
                      final isWebAddress =
                          parsed != null &&
                          (parsed.scheme == 'http' ||
                              parsed.scheme == 'https') &&
                          parsed.host.isNotEmpty;

                      if (!isWebAddress) {
                        return 'Enter a full URL starting with http:// or https://';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    initialValue: _stockStatus,
                    decoration: const InputDecoration(
                      labelText: 'Availability',
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'In stock',
                        child: Text('In stock'),
                      ),
                      DropdownMenuItem(
                        value: 'Out of stock',
                        child: Text('Out of stock'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        _stockStatus = value;
                      });
                    },
                  ),
                  const SizedBox(height: 28),
                  BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state.isSaving ? null : _submitProduct,
                        child: state.isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                widget.isEditing
                                    ? 'Save changes'
                                    : 'Save product',
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
