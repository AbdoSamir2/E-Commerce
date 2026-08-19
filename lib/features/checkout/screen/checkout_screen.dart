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

class CheckoutScreen extends StatefulWidget
{
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
{
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

  String? _requiredValidator(String? value, String fieldName,)
  {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    if (!RegExp(r'^[0-9]{11}$').hasMatch(value.trim())) {
      return 'Enter a valid 11-digit phone number';
    }

    return null;
  }

  String? _postalCodeValidator(String? value)
  {
    if (value == null || value.trim().isEmpty) {
      return 'Postal code is required';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Enter a valid postal code';
    }
    return null;
  }

  Future<void> _placeOrder() async {
    final cartState = context.read<CartCubit>().state;

    if (!_formKey.currentState!.validate()) {return;}
    if (cartState.items.isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty.'),),
      );
      return;
    }
    setState(() {_isPlacingOrder = true;});

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
      await context.read<CartCubit>().clearCart();

      if (!mounted) return;

      setState(() {_isPlacingOrder = false;});
      await _showSuccessDialog(order.orderId);
    }
    catch (error)
    {
      if (!mounted) return;

      setState(() {_isPlacingOrder = false;});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not place order: $error',),
        ),
      );
    }
  }

  Future<void> _showSuccessDialog(String orderId,) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Order Placed Successfully',),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 70,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              const Text(
                'Your order has been placed successfully.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Order ID:\n$orderId',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold,),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.go(AppRoutes.home);
              },
              child: const Text('Back to Home'),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon,)
  {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        return Scaffold(
          appBar: AppBar(title: const Text('Checkout'),),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                  ),
                  const SizedBox(height: 12),

                  _buildOrderSummary(cartState),
                  const SizedBox(height: 28),

                  const Text(
                    'Shipping Address',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration('Full Name', Icons.person_outline,),
                    validator: (value) => _requiredValidator(value, 'Full name',),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration('Phone Number', Icons.phone_outlined,),
                    validator: _phoneValidator,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration('Address', Icons.location_on_outlined,),
                    validator: (value) => _requiredValidator(value, 'Address',),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _cityController,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration('City', Icons.location_city_outlined,),
                    validator: (value) => _requiredValidator(value, 'City',),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _postalCodeController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Postal Code', Icons.markunread_mailbox_outlined,),
                    validator: _postalCodeValidator,
                  ),
                  const SizedBox(height: 28),

                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildPaymentMethod(),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isPlacingOrder || cartState.items.isEmpty ? null : _placeOrder,
                      child: _isPlacingOrder ? const SizedBox(
                        width: 24, height: 24,
                        child:
                        CircularProgressIndicator(strokeWidth: 2,),
                      )
                          : Text(
                        'Place Order - \$${cartState.grandTotal.toStringAsFixed(2)}',
                        style:
                        const TextStyle(
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

  Widget _buildOrderSummary(CartState cartState,)
  {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...cartState.items.map((item) => Padding(
                padding:
                const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        width: 55, height: 55,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _)
                        {
                          return const SizedBox(
                            width: 55, height: 55,
                            child: Icon(Icons.image_not_supported,),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),

                          Text('Qty: ${item.quantity}',),
                        ],
                      ),
                    ),

                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 24),
            _priceRow('Subtotal', cartState.subtotal,),

            const SizedBox(height: 10),
            _priceRow('Tax', cartState.tax,),

            const SizedBox(height: 10),
            _priceRow('Shipping', cartState.shipping,),

            const Divider(height: 24),
            _priceRow('Grand Total', cartState.grandTotal, isTotal: true,),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String title, double price, {bool isTotal = false })
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod()
  {
    return Card(
      child: Column(
        children: [
          RadioListTile<String>(
            title:
            const Text('Cash on Delivery'),
            value: 'Cash on Delivery',
            groupValue: _paymentMethod,
            onChanged: (value) {
              if (value == null) return;

              setState(() {_paymentMethod = value;});
            },
          ),
          RadioListTile<String>(
            title: const Text('Credit Card'),
            value: 'Credit Card',
            groupValue: _paymentMethod,
            onChanged: (value) {
              if (value == null) return;

              setState(() {_paymentMethod = value;});
            },
          ),
        ],
      ),
    );
  }
}