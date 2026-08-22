import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistCubit extends Cubit<bool> {
  final String productId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  WishlistCubit(this.productId) : super(false) {
    _loadFavoriteState();
  }

  Future<void> _loadFavoriteState() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .doc(productId)
          .get();

      emit(doc.exists);
    } catch (e) {
      emit(false);
    }
  }

  Future<void> toggleFavorite() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final newState = !state;
    emit(newState);

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wishlist')
        .doc(productId);

    try {
      if (newState) {
        await docRef.set({
          'productId': productId,
          'addedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await docRef.delete();
      }
    } catch (e) {
      emit(!newState);
    }
  }
}
