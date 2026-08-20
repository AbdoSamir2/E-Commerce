import 'package:flutter/material.dart';

class PaymentMethod extends StatelessWidget
{
  final String selectedMethod;
  final ValueChanged<String> onChanged;

  const PaymentMethod({super.key, required this.selectedMethod, required this.onChanged,});

  @override
  Widget build(BuildContext context)
  {
    return Card(
      child: Column(
        children: [
          RadioListTile<String>(
            title: const Text('Cash on Delivery'),
            value: 'Cash on Delivery',
            groupValue: selectedMethod,
            onChanged: (value) {
              if (value != null) {onChanged(value);}
            },
          ),
          RadioListTile<String>(
            title: const Text('Credit Card'),
            value: 'Credit Card',
            groupValue: selectedMethod,
            onChanged: (value) {
              if (value != null) {onChanged(value);}
            },
          ),
        ],
      ),
    );
  }
}