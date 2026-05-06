import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign up a user (student or admin)
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String customId,
    required String role,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'custom_id': customId,
        'role': role,
      },
    );
  }

  // Sign in a user
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current user role
  String? getCurrentUserRole() {
    final user = _supabase.auth.currentUser;
    if (user != null && user.userMetadata != null) {
      return user.userMetadata!['role'] as String?;
    }
    return null;
  }
}
