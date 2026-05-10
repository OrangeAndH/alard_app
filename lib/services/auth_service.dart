import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';

class AuthService {
  Future<bool> login({
    required BuildContext context,
    required String email,
    required String password,
    bool isTrader = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (!context.mounted) return false;
    final state = AppStateScope.of(context);
    state.setCurrentUser(AppUser(
      name: isTrader ? 'Trader User' : 'Customer User',
      email: email,
      phone: isTrader ? '+970 599 000 000' : '+970 599 111 111',
      location: 'Nablus, Palestine',
      isTrader: isTrader,
    ));

    return true;
  }

  Future<bool> loginWithGoogle({
    required BuildContext context,
    bool isTrader = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (!context.mounted) return false;
    final state = AppStateScope.of(context);
    state.setCurrentUser(AppUser(
      name: isTrader ? 'Trader Google' : 'Customer Google',
      email: isTrader ? 'trader@google.com' : 'customer@google.com',
      phone: '',
      location: 'Ramallah, Palestine',
      isTrader: isTrader,
    ));

    return true;
  }

  Future<bool> loginWithApple({
    required BuildContext context,
    bool isTrader = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (!context.mounted) return false;
    final state = AppStateScope.of(context);
    state.setCurrentUser(AppUser(
      name: isTrader ? 'Trader Apple' : 'Customer Apple',
      email: isTrader ? 'trader@apple.com' : 'customer@apple.com',
      phone: '',
      location: 'Jerusalem, Palestine',
      isTrader: isTrader,
    ));

    return true;
  }

  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
    bool isTrader = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return AuthResponse(isSuccess: true, message: 'Registration successful');
  }

  Future<void> logout() async {
    // In a real app, clear tokens, etc.
  }
}

class AuthResponse {
  final bool isSuccess;
  final String? message;
  AuthResponse({required this.isSuccess, this.message});
}
