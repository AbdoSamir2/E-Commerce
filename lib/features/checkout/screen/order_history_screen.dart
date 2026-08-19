import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../../features/checkout/data/order_local_storge.dart';
import '../../../features/checkout/models/order_model.dart';

class OrderHistoryScreen extends StatefulWidget
{
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
{
  late final OrderLocalStorage _orderStorage;
  List<Order> _orders = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState()
  {
    super.initState();
    _orderStorage = OrderLocalStorage(context.read<LocalStorageService>(),);
    _loadOrders();
  }

  Future<void> _loadOrders() async
  {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try
    {
      final orders = await _orderStorage.getOrders();
      if (!mounted) return;

      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    }
    catch (_)
    {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not load your order history.';
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History'),),
      body: _buildBody(),
    );
  }

  Widget _buildBody()
  {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(),);
    }

    if (_errorMessage != null)
    {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60,),
              const SizedBox(height: 16),

              Text(_errorMessage!, textAlign: TextAlign.center,),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _loadOrders,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_orders.isEmpty)
    {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.receipt_long_outlined, size: 70,),
              const SizedBox(height: 16),
              const Text(
                'No orders yet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
              ),
              const SizedBox(height: 8),

              const Text(
                'Your completed orders will appear here.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildOrderCard(_orders[index],);
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order)
  {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.orderId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  '\$${order.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold,),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              _formatDate(order.date),
              style: TextStyle(color: Colors.grey.shade600,),
            ),
            const SizedBox(height: 12),

            Text('${order.items.fold<int>(0, (sum, item) => sum + item.quantity)} item(s)',),
            const SizedBox(height: 8),

            Text('Payment: ${order.paymentMethod}',),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date)
  {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}