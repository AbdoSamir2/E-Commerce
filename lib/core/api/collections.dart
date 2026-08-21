import 'package:cloud_firestore/cloud_firestore.dart';
Future<void> getProducts() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();
    for (var doc in snapshot.docs) {
      print('Product: ${doc.data()}');
    }
  } catch (e) {
    print('Error fetching products: $e');
  }
}
Future<void> addProduct(Map<String, dynamic> productData) async {
  try {
    await FirebaseFirestore.instance.collection('products').add(productData);
    print('Product added successfully.');
  } catch (e) {
    print('Error adding product: $e');
  }
}
Future<void> updateProduct(String documentId, Map<String, dynamic> productData) async {
  try {
    await FirebaseFirestore.instance.collection('products').doc(documentId).update(productData);
    print('Product updated successfully.');
  } catch (e) {
    print('Error updating product: $e');
  }
}
Future<void> deleteProduct(String documentId) async {
  try {
    await FirebaseFirestore.instance.collection('products').doc(documentId).delete();
    print('Product deleted successfully.');
  } catch (e) {
    print('Error deleting product: $e');
  }
}
Future<void> getUsers() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
    for (var doc in snapshot.docs) {
      print('User: ${doc.data()}');
    }
  } catch (e) {
    print('Error fetching users: $e');
  }
}
Future<void> addUser(Map<String, dynamic> userData) async {
  try {
    await FirebaseFirestore.instance.collection('users').add(userData);
    print('User added successfully.');
  } catch (e) {
    print('Error adding user: $e');
  }
}
Future<void> updateUser(String documentId, Map<String, dynamic> userData) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(documentId).update(userData);
    print('User updated successfully.');
  } catch (e) {
    print('Error updating user: $e');
  }
}
Future<void> deleteUser(String documentId) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(documentId).delete();
    print('User deleted successfully.');
  } catch (e) {
    print('Error deleting user: $e');
  }
}
