import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget
{
  final double subtotal;
  final double tax;
  final double shipping;

  const OrderSummary({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.shipping,
  });
  double get total => subtotal + tax + shipping;

  @override
  Widget build(BuildContext context)
  {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _priceRow('Subtotal', subtotal),
            const SizedBox(height: 10),
            _priceRow('Tax', tax),
            const SizedBox(height: 10),
            _priceRow('Shipping', shipping),
            const Divider(height: 24),
            _priceRow('Grand Total', total, isTotal: true,),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(
      String title,
      double price, {bool isTotal = false,}
      )
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
}