import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../features/cart/logic/cart/cart_cubit.dart';
import '../../../features/cart/logic/cart/cart_item.dart';
import '../../../features/cart/logic/cart/cart_state.dart';

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
 //validation
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

  // place order
  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cartState = context.read<CartCubit>().state;
    if (cartState.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty.'),),
      );
      return;
    }

    setState(() {_isPlacingOrder = true;});


    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

    try {
      await context.read<CartCubit>().clearCart();
      if (!mounted) return;

      setState(() {_isPlacingOrder = false;});
      await _showOrderSuccessDialog(orderId);
    }
    catch (_)
    {
      if (!mounted) return;

      setState(() {_isPlacingOrder = false;});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again.',),),
      );
    }
  }

 //success
  Future<void> _showOrderSuccessDialog(String orderId,) async
  {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Order Placed Successfully',),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 70, color: Colors.green,),
              const SizedBox(height: 16),

              const Text('Your order has been placed successfully.', textAlign: TextAlign.center,),
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

  // input
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
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  const Text('Order Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                  const SizedBox(height: 12),

                  _buildOrderSummary(cartState),
                  const SizedBox(height: 28),

                  const Text('Shipping Address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
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
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2,),
                      )
                      :Text(
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

  Widget _buildOrderSummary(CartState cartState,)
  {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (cartState.items.isNotEmpty)
              ...cartState.items.map((item) => _buildCartItem(item),),

            if (cartState.items.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Your cart is empty.',),
              ),
            const Divider(height: 24),

            _buildPriceRow('Subtotal', cartState.subtotal,),
            const SizedBox(height: 10),

            _buildPriceRow('Tax', cartState.tax,),
            const SizedBox(height: 10),

            _buildShippingRow(cartState.shipping,),
            const Divider(height: 24),

            _buildPriceRow('Grand Total', cartState.grandTotal, isTotal: true,),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem item,)
  {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12,),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
            BorderRadius.circular(8),
            child: Image.network(item.imageUrl, width: 55, height: 55,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _)
              {
                return Container(
                  width: 55, height: 55,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported,),
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
                  style: const TextStyle(fontWeight: FontWeight.w600,),
                ),
                const SizedBox(height: 4),

                Text('Qty: ${item.quantity}', style: TextStyle(color: Colors.grey.shade600,),),
              ],
            ),
          ),
          const SizedBox(width: 8),

          Text(
            '\$${item.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold,),
          ),
        ],
      ),
    );
  }
// price row
  Widget _buildPriceRow(String title, double price, {bool isTotal = false,})
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

  Widget _buildShippingRow(double shipping,) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Shipping', style: TextStyle(fontSize: 15,),),
        Text(
          shipping == 0 ? 'Free' : '\$${shipping.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 15,),
        ),
      ],
    );
  }

  // payment
  Widget _buildPaymentMethod() {
    return Card(
      child: RadioGroup<String>(
        groupValue: _paymentMethod,
        onChanged: (value)
        {
          if (value == null) return;
          setState(() {_paymentMethod = value;});
        },
        child: const Column(
          children: [
            RadioListTile<String>(
              title: Text('Cash on Delivery'),
              value: 'Cash on Delivery',
            ),

            RadioListTile<String>(
              title: Text('Credit Card'),
              value: 'Credit Card',
            ),
          ],
        ),
      ),
    );
  }
}