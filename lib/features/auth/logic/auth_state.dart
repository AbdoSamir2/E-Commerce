enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.email,
    this.errorMessage,
  });

  final AuthStatus status;
  final String? email;
  final String? errorMessage;

  bool get isLoggedIn => status == AuthStatus.authenticated;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    String? email,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      errorMessage: errorMessage,
    );
  }
}
