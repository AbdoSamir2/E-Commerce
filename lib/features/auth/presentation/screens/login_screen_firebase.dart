import 'package:firebase_auth/firebase_auth.dart';
Future<void> signInWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Handle successful sign-in
    print('Signed in: ${userCredential.user?.email}');
  } on FirebaseAuthException catch (e) {
    // Handle sign-in errors
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  } catch (e) {
    print('Error signing in: $e');
  }
}
//this function can be called from your login screen when the user submits their email and password. Make sure to handle the UI updates and error messages accordingly in your login screen.
//and this function for signing in
Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    // Handle successful sign-out
    print('Signed out successfully.');
  } catch (e) {
    print('Error signing out: $e');
  }
}
Future<void> signUpWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Handle successful sign-up
    print('Signed up: ${userCredential.user?.email}');
  } on FirebaseAuthException catch (e) {
    // Handle sign-up errors
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print('Error signing up: $e');
  }
}

 
