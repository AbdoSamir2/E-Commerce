import 'package:flutter/material.dart';
import '../../cart/logic/cart/cart_item.dart';

class OrderSummary extends StatelessWidget {
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double shipping;

  const OrderSummary({
    super.key,
    required this.items,
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
            ...items.map(_buildCartItem),
            const Divider(height: 24),

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

  Widget _buildCartItem(CartItem item) {
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
                return const SizedBox(
                  width: 55,
                  height: 55,
                  child: Icon(Icons.image_not_supported),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),
                Text('Qty: ${item.quantity}'),
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
    );
  }

  Widget _priceRow(String title, double price, {bool isTotal = false,})
  {
    final textStyle = TextStyle(
      fontSize: isTotal ? 18 : 15,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: textStyle),
        Text('\$${price.toStringAsFixed(2)}', style: textStyle,),
      ],
    );
  }
}