import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
Future<void> getProducts() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();
    for (var doc in snapshot.docs) {
      debugPrint('Product: ${doc.data()}');
    }
  } catch (e) {
    debugPrint('Error fetching products: $e');
  }
}
Future<void> addProduct(Map<String, dynamic> productData) async {
  try {
    await FirebaseFirestore.instance.collection('products').add(productData);
    debugPrint('Product added successfully.');
  } catch (e) {
    debugPrint('Error adding product: $e');
  }
}
Future<void> updateProduct(String documentId, Map<String, dynamic> productData) async {
  try {
    await FirebaseFirestore.instance.collection('products').doc(documentId).update(productData);
    debugPrint('Product updated successfully.');
  } catch (e) {
    debugPrint('Error updating product: $e');
  }
}
Future<void> deleteProduct(String documentId) async {
  try {
    await FirebaseFirestore.instance.collection('products').doc(documentId).delete();
    debugPrint('Product deleted successfully.');
  } catch (e) {
    debugPrint('Error deleting product: $e');
  }
}
Future<void> getUsers() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
    for (var doc in snapshot.docs) {
      debugPrint('User: ${doc.data()}');
    }
  } catch (e) {
    debugPrint('Error fetching users: $e');
  }
}
Future<void> addUser(Map<String, dynamic> userData) async {
  try {
    await FirebaseFirestore.instance.collection('users').add(userData);
    debugPrint('User added successfully.');
  } catch (e) {
    debugPrint('Error adding user: $e');
  }
}
Future<void> updateUser(String documentId, Map<String, dynamic> userData) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(documentId).update(userData);
    debugPrint('User updated successfully.');
  } catch (e) {
    debugPrint('Error updating user: $e');
  }
}
Future<void> deleteUser(String documentId) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(documentId).delete();
    debugPrint('User deleted successfully.');
  } catch (e) {
    debugPrint('Error deleting user: $e');
  }
}
