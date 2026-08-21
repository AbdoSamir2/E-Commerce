import 'package:flutter/material.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/theme/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/theme_state.dart';
import 'home_widgets/category_item.dart';
import 'home_widgets/section_header.dart';
import 'home_widgets/product_card.dart';
import '../../models/product_model.dart';

import '../cart/logic/cart/cart_cubit.dart';
import '../cart/logic/cart/cart_screen.dart';

import 'package:e_commerce_project/features/productdetailed/Logic/quantity_cubit.dart';
import 'package:e_commerce_project/features/productdetailed/Logic/wishlist_cubit.dart';
import 'package:e_commerce_project/features/productdetailed/product_detailed_screen.dart';

import 'package:e_commerce_project/features/wishlist/wishlist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final isDarkMode =
        themeState
            is DarkThemeState; //====>temperory to avoid merge conflict only :) ==>last two lines be commented and next line be u -K
    //   final isDarkMode = false;
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
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                      ),
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
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: const [
                    SizedBox(height: 10),
                    CategoryItem(
                      title: 'all',
                      icon: Icons.grid_view_rounded,
                      isSelected: true,
                    ),
                    SizedBox(width: 12),
                    CategoryItem(
                      title: 'electornics',
                      icon: Icons.devices_rounded,
                    ),
                    SizedBox(width: 12),
                    CategoryItem(title: 'wears', icon: Icons.checkroom_rounded),
                    SizedBox(width: 12),
                    CategoryItem(
                      title: 'shoes',
                      icon: Icons.straighten_rounded,
                    ),
                    SizedBox(width: 12),
                    CategoryItem(title: 'watches', icon: Icons.watch_rounded),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SectionHeader(
                title: 'Popular Products',
                onSeeAllPressed: () {
                  //will be editied soon
                },
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: dummyProducts.length,
                itemBuilder: (context, index) {
                  final product = dummyProducts[index];

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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
