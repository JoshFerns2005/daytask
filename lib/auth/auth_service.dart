import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  SupabaseClient get _client => Supabase.instance.client;

  /// Basic email validator
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  /// Basic password validator (min 6 characters)
  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Sign up with email & password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    if (!isValidEmail(email)) {
      throw AuthException("Invalid email address.");
    }
    if (!isValidPassword(password)) {
      throw AuthException("Password must be at least 6 characters.");
    }

    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    return response;
  }

  /// Sign in with email & password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    if (!isValidEmail(email)) {
      throw AuthException("Invalid email address.");
    }
    if (!isValidPassword(password)) {
      throw AuthException("Password must be at least 6 characters.");
    }

    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo:
          'https://arzeuzhyjmthudgpgozn.supabase.co/auth/v1/callback', // Update this to match your deep link
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Current user
  User? get currentUser => _client.auth.currentUser;

  /// Auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
