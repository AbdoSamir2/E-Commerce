import 'package:flutter/material.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/theme/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/theme_state.dart';
import 'home_widgets/category_item.dart';
import 'home_widgets/section_header.dart';
import 'home_widgets/product_card.dart';

import '../cart/logic/cart/cart_cubit.dart';
import '../cart/logic/cart/cart_screen.dart';

import 'package:e_commerce_project/features/productdetailed/Logic/quantity_cubit.dart';
import 'package:e_commerce_project/features/productdetailed/Logic/wishlist_cubit.dart';
import 'package:e_commerce_project/features/productdetailed/product_detailed_screen.dart';

import 'package:e_commerce_project/features/wishlist/wishlist_screen.dart';

import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import 'logic/product_cubit.dart';
import 'logic/product_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final isDarkMode = themeState is DarkThemeState;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLogo(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              context.read<ThemeCubit>().toggleTheme();
                            },
                            icon: Icon(
                              isDarkMode ? Icons.light_mode : Icons.dark_mode,
                              color: isDarkMode ? Colors.amber : Colors.indigo,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CartScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.shopping_cart_outlined),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const WishlistScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.favorite_border_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SectionHeader(title: 'Popular Products'),
              
              BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state.status == ProductStatus.loading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state.status == ProductStatus.failure) {
                    return _ProductsMessage(
                      icon: Icons.error_outline,
                      message: state.errorMessage ?? 'Could not load products.',
                      onRetry: () =>
                          context.read<ProductCubit>().loadProducts(),
                    );
                  }

                  if (state.isEmpty) {
                    return const _ProductsMessage(
                      icon: Icons.inventory_2_outlined,
                      message: 'No products yet. Tap + to add the first one.',
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];

                      return ProductCard(
                        title: product.title,
                        price: product.price,
                        imageUrl: product.imageUrl,
                        rating: product.rating,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(create: (_) => QuantityCubit()),
                                  BlocProvider(
                                    create: (_) => WishlistCubit(product.id),
                                  ),
                                ],
                                child: ProductDetailScreen(
                                  id: product.id,
                                  title: product.title,
                                  price: double.parse(product.price.toString()),
                                  imageUrl: product.imageUrl,
                                  description: product.description,
                                  stockStatus: product.stockStatus,
                                ),
                              ),
                            ),
                          );
                        },
                        onAddToCart: () {
                          context.read<CartCubit>().addToCart(
                            title: product.title,
                            price: double.parse(product.price.toString()),
                            imageUrl: product.imageUrl,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.title} added to cart'),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addProduct),
        tooltip: 'Add product',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProductsMessage extends StatelessWidget {
  const _ProductsMessage({
    required this.icon,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          Icon(icon, size: 48, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ],
      ),
    );
  }
}
