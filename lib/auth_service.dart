import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A class to encapsulate the result of an authentication attempt.
class AuthResponse {
  final bool isSuccess;
  final String? message;
  final String? token;

  AuthResponse({required this.isSuccess, this.message, this.token});
}

/// A simple data model for the User.
class User {
  final String id;
  final String username;
  final String email;
  final bool isTrader;

  User({required this.id, required this.username, required this.email, required this.isTrader});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      username: json['username'] ?? 'No Username',
      email: json['email'] ?? 'No Email',
      isTrader: json['isTrader'] ?? false,
    );
  }
}

class AuthService {
  /// Handles the login logic.
  Future<AuthResponse> login({
    required String email,
    required String password,
    required bool isTrader,
  }) async {
    try {
      // Simulate slight network latency for realistic UX
      await Future.delayed(const Duration(milliseconds: 500));

      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user_$email');

      if (userJson != null) {
        final userData = jsonDecode(userJson);
        if (userData['password'] == password) {
          // Save logged-in email to persist the user session
          await prefs.setString('logged_in_email', email);
          return AuthResponse(isSuccess: true, token: 'local_token_$email');
        }
      }
      
      return AuthResponse(
        isSuccess: false,
        message: 'Invalid email or password.',
      );
    } catch (e) {
      return AuthResponse(isSuccess: false, message: 'An error occurred during login.');
    }
  }

  /// Handles social authentication logic.
  Future<AuthResponse> loginWithSocial({
    required String provider,
    required bool isTrader,
  }) async {
    try {
      // Simulate slight network latency for realistic UX
      await Future.delayed(const Duration(seconds: 1));

      if (provider == 'Google' || provider == 'Facebook') {
        // Simulate a successful social authentication
        final prefs = await SharedPreferences.getInstance();
        final email = 'social_${provider.toLowerCase()}@example.com';
        await prefs.setString('logged_in_email', email);
        return AuthResponse(isSuccess: true, token: 'local_token_$email');
      }

      return AuthResponse(isSuccess: false, message: 'Unsupported provider: $provider');
    } catch (e) {
      return AuthResponse(
        isSuccess: false,
        message: 'Could not connect to $provider.',
      );
    }
  }

  /// Handles the account registration logic.
  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
    required bool isTrader,
  }) async {
    try {
      // Simulate slight network latency for realistic UX
      await Future.delayed(const Duration(milliseconds: 500));

      final prefs = await SharedPreferences.getInstance();
      final existingUser = prefs.getString('user_$email');

      if (existingUser != null) {
        return AuthResponse(isSuccess: false, message: 'User already exists with this email.');
      }

      // Create a local user record
      final newUser = {
        '_id': DateTime.now().millisecondsSinceEpoch.toString(),
        'username': username,
        'email': email,
        'password': password,
        'isTrader': isTrader,
      };

      await prefs.setString('user_$email', jsonEncode(newUser));
      await prefs.setString('logged_in_email', email);

      return AuthResponse(isSuccess: true, token: 'local_token_$email');
    } catch (e) {
      return AuthResponse(isSuccess: false, message: 'Registration failed. Please try again.');
    }
  }

  /// Fetches the profile of the currently authenticated user.
  Future<User?> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loggedInEmail = prefs.getString('logged_in_email');

      if (loggedInEmail == null) {
        return null;
      }

      final userJson = prefs.getString('user_$loggedInEmail');
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson));
      } else {
        await prefs.remove('logged_in_email');
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Logs out the currently authenticated user by clearing the local session.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_email');
  }
}