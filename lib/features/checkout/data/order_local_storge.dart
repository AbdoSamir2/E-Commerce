import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/local_storage_service.dart';
import '../models/order_model.dart';

class OrderLocalStorage
{
  const OrderLocalStorage(this._storage);
  final LocalStorageService _storage;

  Future<List<Order>> getOrders() async
  {
    final data = await _storage.getJson(StorageKeys.orderHistory,);
    final orders = <Order>[];

    if (data is! List) {return [];}

    for (final item in data) {
      if (item is! Map) {continue;}
      try
      {
        orders.add(Order.fromJson(Map<String, dynamic>.from(item),),);
      } catch (_) {

      }
    }

    return orders;
  }

  Future<void> saveOrder(Order order) async
  {
    final orders = await getOrders();
    orders.insert(0, order);

    await _storage.saveJson(
      StorageKeys.orderHistory,
      orders.map((order) => order.toJson()).toList(),
    );
  }

  Future<void> clearOrders() async
  {
    await _storage.remove(StorageKeys.orderHistory,);
  }
}