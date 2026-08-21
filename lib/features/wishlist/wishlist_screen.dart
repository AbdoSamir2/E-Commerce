import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/product_model.dart';
import '../catalog/home_widgets/product_card.dart';
import '../cart/logic/cart/cart_cubit.dart';
import '../productdetailed/Logic/quantity_cubit.dart';
import '../productdetailed/Logic/wishlist_cubit.dart';
import '../productdetailed/product_detailed_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool _isLoading = true;
  List<ProductModel> _favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final favorites = dummyProducts.where((product) {
      return prefs.getBool('favorite_${product.id}') ?? false;
    }).toList();

    if (!mounted) return;

    setState(() {
      _favoriteProducts = favorites;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Wishlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteProducts.isEmpty
          ? const _EmptyWishlistView()
          : RefreshIndicator(
              onRefresh: _loadFavorites,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = _favoriteProducts[index];

                  return ProductCard(
                    title: product.title,
                    price: product.price,
                    imageUrl: product.imageUrl,
                    rating: product.rating,
                    onTap: () async {
                      await Navigator.of(context).push(
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
                      _loadFavorites();
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
            ),
    );
  }
}

class _EmptyWishlistView extends StatelessWidget {
  const _EmptyWishlistView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 54,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Your wishlist is empty',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart icon on any product to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.65,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Start Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
