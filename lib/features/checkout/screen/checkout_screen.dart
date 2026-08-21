import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../cart/logic/cart/cart_cubit.dart';
import '../../cart/logic/cart/cart_item.dart';
import '../../cart/logic/cart/cart_state.dart';
import '../order_model.dart';
import '../widget/order_summary.dart';
import '../widget/payment.dart';
import '../widget/shipping_form.dart';
import 'order_success.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();

  String _paymentMethod = 'Cash on Delivery';
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Order _buildOrder(CartState cartState) {
    return Order(
      orderId: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      totalPrice: cartState.grandTotal,
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
      paymentMethod: _paymentMethod,
    );
  }

  Future<void> _saveToOrderHistory(
    LocalStorageService storage,
    Order order,
  ) async {
    final saved = await storage.getJson(StorageKeys.orderHistory);
    final history = saved is List ? List<dynamic>.from(saved) : <dynamic>[];

    history.add(order.toJson());
    await storage.saveJson(StorageKeys.orderHistory, history);
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cartCubit = context.read<CartCubit>();
    final messenger = ScaffoldMessenger.of(context);

    if (cartCubit.state.items.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Your cart is empty.')),
      );
      return;
    }

    final navigator = Navigator.of(context);
    final storage = context.read<LocalStorageService>();
    final order = _buildOrder(cartCubit.state);

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      await _saveToOrderHistory(storage, order);
      await cartCubit.clearCart();

      if (!mounted) {
        return;
      }

      setState(() {
        _isPlacingOrder = false;
      });

      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(orderId: order.orderId),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isPlacingOrder = false;
      });

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        return Scaffold(
          appBar: AppBar(title: const Text('Checkout')),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle('Order Summary'),
                  const SizedBox(height: 12),

                  _CartItemsCard(items: cartState.items),
                  const SizedBox(height: 12),

                  OrderSummary(
                    subtotal: cartState.subtotal,
                    tax: cartState.tax,
                    shipping: cartState.shipping,
                  ),
                  const SizedBox(height: 28),

                  const _SectionTitle('Shipping Address'),
                  const SizedBox(height: 12),

                  ShippingForm(
                    nameController: _nameController,
                    phoneController: _phoneController,
                    addressController: _addressController,
                    cityController: _cityController,
                    postalCodeController: _postalCodeController,
                  ),
                  const SizedBox(height: 28),

                  const _SectionTitle('Payment Method'),
                  const SizedBox(height: 12),

                  PaymentMethod(
                    selectedMethod: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isPlacingOrder || cartState.items.isEmpty
                          ? null
                          : _placeOrder,
                      child: _isPlacingOrder
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              'Place Order - \$${cartState.grandTotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class _CartItemsCard extends StatelessWidget {
  const _CartItemsCard({required this.items});

  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: items.isEmpty
            ? const Text('Your cart is empty.')
            : Column(
                children: items
                    .map((item) => _CartItemRow(item: item))
                    .toList(),
              ),
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  const _CartItemRow({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 55,
              height: 55,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return Container(
                  width: 55,
                  height: 55,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),

                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          Text(
            '\$${item.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
