import 'package:firebase_auth/firebase_auth.dart';

class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => 'AuthFailure(message: $message)';
}

class AuthRepository {
  AuthRepository({FirebaseAuth? firebaseAuth}) : _injectedAuth = firebaseAuth;

  final FirebaseAuth? _injectedAuth;

  FirebaseAuth get _firebaseAuth => _injectedAuth ?? FirebaseAuth.instance;

  User? get currentUser {
    try {
      return _firebaseAuth.currentUser;
    } on FirebaseException {
      return null;
    }
  }

  Future<User> signUp({required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return credential.user!;
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error));
    } on FirebaseException catch (error) {
      throw AuthFailure(_unavailableMessage(error));
    }
  }

  Future<User> signIn({required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return credential.user!;
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error));
    } on FirebaseException catch (error) {
      throw AuthFailure(_unavailableMessage(error));
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error));
    } on FirebaseException catch (error) {
      throw AuthFailure(_unavailableMessage(error));
    }
  }

  String _unavailableMessage(FirebaseException error) {
    return 'Firebase is unavailable on this platform (${error.code}). '
        'Run the app on Android, iOS, or the web to sign in.';
  }

  String _messageFor(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email sign-in is not enabled for this project.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }
}
