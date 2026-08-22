import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthState());

  final AuthRepository _authRepository;

  void checkAuthStatus() {
    final user = _authRepository.currentUser;

    if (user == null) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
      return;
    }

    emit(AuthState(status: AuthStatus.authenticated, email: user.email));
  }

  Future<void> signUp({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await _authRepository.signUp(
        email: email,
        password: password,
      );

      emit(AuthState(status: AuthStatus.authenticated, email: user.email));
    } on AuthFailure catch (failure) {
      emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
        ).copyWith(status: AuthStatus.failure, errorMessage: failure.message),
      );
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );

      emit(AuthState(status: AuthStatus.authenticated, email: user.email));
    } on AuthFailure catch (failure) {
      emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
        ).copyWith(status: AuthStatus.failure, errorMessage: failure.message),
      );
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await _authRepository.signOut();

      emit(const AuthState(status: AuthStatus.unauthenticated));
    } on AuthFailure catch (failure) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }
}
