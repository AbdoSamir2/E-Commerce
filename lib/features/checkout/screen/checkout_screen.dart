import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../../features/cart/logic/cart/cart_cubit.dart';
import '../../../features/cart/logic/cart/cart_state.dart';
import '../../cart/logic/cart/cart_item.dart';
import '../../checkout/data/order_local_storge.dart';
import '../../checkout/models/order_model.dart';
import '../widget/order_summary.dart';
import '../widget/payment.dart';
import '../widget/shipping_form.dart';

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

  Future<void> _placeOrder() async {
    final cartCubit = context.read<CartCubit>();
    final cartState = cartCubit.state;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (cartState.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty.')));
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });
    try {
      final order = Order(
        orderId: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        date: DateTime.now(),
        items: List<CartItem>.from(cartState.items),
        totalPrice: cartState.grandTotal,
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        paymentMethod: _paymentMethod,
      );

      final storage = context.read<LocalStorageService>();
      final orderStorage = OrderLocalStorage(storage);
      await orderStorage.saveOrder(order);
      await cartCubit.clearCart();

      if (!mounted) {
        return;
      }
      context.go(AppRoutes.orderSuccessLocation(order.orderId));
    }
    catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isPlacingOrder = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not place order: $error')));
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
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  OrderSummary(
                    items: cartState.items,
                    subtotal: cartState.subtotal,
                    tax: cartState.tax,
                    shipping: cartState.shipping,
                  ),
                  const SizedBox(height: 28),

                  const Text(
                    'Shipping Address',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  ShippingForm(
                    nameController: _nameController,
                    phoneController: _phoneController,
                    addressController: _addressController,
                    cityController: _cityController,
                    postalCodeController: _postalCodeController,
                  ),
                  const SizedBox(height: 28),

                  const Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  PaymentMethod(
                    selectedMethod: _paymentMethod,
                    onChanged: (value) {
                      setState(() {_paymentMethod = value;});
                    },
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isPlacingOrder || cartState.items.isEmpty ? null : _placeOrder,

                      child: _isPlacingOrder
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2),)
                          : Text(
                              'Place Order - \$${cartState.grandTotal.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
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
