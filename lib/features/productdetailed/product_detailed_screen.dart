import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_project/features/productdetailed/Logic/QuantityCubit.dart';
import 'package:e_commerce_project/features/productdetailed/Logic/WishlistCubit.dart';
import 'package:e_commerce_project/features/cart/logic/cart/cart_cubit.dart';

class ProductDetailScreen extends StatefulWidget {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String description;
  final String stockStatus;

  const ProductDetailScreen({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.stockStatus,
  });
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          BlocBuilder<WishlistCubit, bool>(
            builder: (context, isFavorite) {
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  context.read<WishlistCubit>().toggleFavorite();
                },
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Center(
                  child: Image.network(
                    widget.imageUrl,
                    height: 320,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        height: 320,
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 320,
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                // Product Details
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Size: 160 fl oz / 250ml',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            5,
                            (index) => const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '(32 Reviews)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Stock
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: widget.stockStatus.toLowerCase() == 'in stock'
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(38),
                  ),
                  child: Text(
                    widget.stockStatus,
                    style: TextStyle(
                      color: widget.stockStatus.toLowerCase() == 'in stock'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      // Bottom Bar
      // Bottom Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 30,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Price
              Expanded(
                child: Text(
                  '\$${widget.price}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              // Quantity
              Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: BlocBuilder<QuantityCubit, int>(
                  builder: (context, quantity) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          onPressed: () {
                            context.read<QuantityCubit>().decrement();
                          },
                          icon: const Icon(Icons.remove, size: 20),
                        ),
                        Text(
                          '$quantity',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          onPressed: () {
                            context.read<QuantityCubit>().increment();
                          },
                          icon: const Icon(Icons.add, size: 20),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              // Cart Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    minimumSize: const Size(64, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    final quantity = context.read<QuantityCubit>().state;

                    context.read<CartCubit>().addToCart(
                      title: widget.title,
                      price: widget.price,
                      imageUrl: widget.imageUrl,
                      quantity: quantity,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم إضافة $quantity من ${widget.title} لعربة التسوق!',
                        ),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text(
                    'Cart',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
