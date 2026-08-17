import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistCubit extends Cubit<bool> {
  final String productId;
  WishlistCubit(this.productId) : super(false) {
    _loadFavoriteState();
  }
  Future<void> _loadFavoriteState() async {
    final prefs = await SharedPreferences.getInstance();
    final isFavorite = prefs.getBool('favorite_$productId') ?? false;
    emit(isFavorite);
  }

  Future<void> toggleFavorite() async {
    final newState = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('favorite_$productId', newState);
    emit(newState);
  }
}
