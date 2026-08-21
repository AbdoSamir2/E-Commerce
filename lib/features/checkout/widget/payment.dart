import 'package:flutter/material.dart';

class PaymentMethod extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onChanged;

  const PaymentMethod({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context)
  {
    return Card(
      child: RadioGroup<String>(
        groupValue: selectedMethod,
        onChanged: (value) {
          if (value != null) {onChanged(value);}
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