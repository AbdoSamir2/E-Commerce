import 'package:flutter/material.dart';
import '../order_model.dart';
import '../widget/order_summary.dart';
import '../widget/payment.dart';
import '../widget/shipping_form.dart';
import 'order_success.dart';

class CheckoutScreen extends StatefulWidget
{
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
{
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();
  String paymentMethod = 'Cash on Delivery';

  // Temporary values.
  final double subtotal = 120.00;
  final double tax = 12.00;
  final double shipping = 10.00;

  double get total => subtotal + tax + shipping;

  @override
  void dispose()
  {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  void _placeOrder()
  {
    if (!_formKey.currentState!.validate()) {return;}

    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    final order = Order(
      orderId: orderId,
      date: DateTime.now(),
      totalPrice: total,
      fullName: nameController.text.trim(),
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
      city: cityController.text.trim(),
      postalCode: postalCodeController.text.trim(),
      paymentMethod: paymentMethod,
    );

    debugPrint(order.toJson().toString());

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderSuccessScreen(orderId: order.orderId,),),
    );
  }

  @override
  Widget build(BuildContext context)
  {
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
              OrderSummary(subtotal: subtotal, tax: tax, shipping: shipping,),
              const SizedBox(height: 28),
              const Text('Shipping Address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
              const SizedBox(height: 12),

              ShippingForm(
                nameController: nameController,
                phoneController: phoneController,
                addressController: addressController,
                cityController: cityController,
                postalCodeController:
                postalCodeController,
              ),

              const SizedBox(height: 28),
              const Text('Payment Method', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
              const SizedBox(height: 12),

              PaymentMethod(
                selectedMethod: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value;
                  });
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  child: Text(
                    'Place Order - \$${total.toStringAsFixed(2)}',
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
  }
}