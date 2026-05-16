import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart' as google_auth;
import '../state/app_state.dart';
import '../state/app_state_scope.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final google_auth.GoogleSignIn _googleSignIn =
      google_auth.GoogleSignIn();

  AuthService();

  Future<AuthResponse> login({
    required BuildContext context,
    required String email,
    required String password,
    bool isTrader = false,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      if (context.mounted) {
        await _updateLocalState(context, userCredential.user!, isTrader);
        return AuthResponse(isSuccess: true);
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      }
      return AuthResponse(isSuccess: false, message: message);
    } catch (e) {
      return AuthResponse(isSuccess: false, message: e.toString());
    }
    return AuthResponse(isSuccess: false, message: 'Unknown error occurred');
  }

  Future<AuthResponse> loginWithGoogle({
    required BuildContext context,
    bool isTrader = false,
  }) async {
    try {
      final google_auth.GoogleSignInAccount? googleUser = await _googleSignIn
          .signIn();

      if (googleUser == null) {
        return AuthResponse(isSuccess: false, message: 'cancelled');
      }

      final google_auth.GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (context.mounted) {
        await _updateLocalState(context, userCredential.user!, isTrader);
        return AuthResponse(isSuccess: true);
      }
    } catch (e) {
      debugPrint('Google Login Error: $e');
      return AuthResponse(isSuccess: false, message: e.toString());
    }
    return AuthResponse(isSuccess: false, message: 'Google login failed');
  }

  Future<AuthResponse> loginWithFacebook({
    required BuildContext context,
    bool isTrader = false,
  }) async {
    // Facebook OAuth is not yet configured. Returning a user-facing error.
    return AuthResponse(isSuccess: false, message: 'coming_soon');
  }

  Future<AuthResponse> loginWithApple({
    required BuildContext context,
    bool isTrader = false,
  }) async {
    // Apple Sign-In is not yet configured. Returning a user-facing error.
    return AuthResponse(isSuccess: false, message: 'coming_soon');
  }

  // 🔥 الدالة المحدثة لجلب صلاحية الأدمن الحقيقية من السيرفر فوراً عند تسجيل الدخول
  Future<void> _updateLocalState(
    BuildContext context,
    User? firebaseUser,
    bool isTrader,
  ) async {
    final state = AppStateScope.of(context);

    if (firebaseUser == null) {
      state.setCurrentUser(
        AppUser(
          name: isTrader ? 'Guest Trader' : 'Guest Customer',
          email: '',
          phone: '',
          location: '',
          isTrader: isTrader,
          isAdmin: false,
        ),
      );
      return;
    }

    // Read isTrader and isAdmin from Firestore — do NOT overwrite existing values
    // on re-login. Only write isTrader on first registration (handled in register()).
    bool isTraderFromFirestore = isTrader;
    bool isAdminFromFirestore = false;

    try {
      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid);

      final docSnapshot = await userDocRef.get();
      if (docSnapshot.exists) {
        // Respect existing Firestore values; do not overwrite.
        isAdminFromFirestore = docSnapshot.data()?['isAdmin'] ?? false;
        isTraderFromFirestore = docSnapshot.data()?['isTrader'] ?? isTrader;
      } else {
        // First time this Firebase user is seen — write initial values.
        await userDocRef.set({
          'name': firebaseUser.displayName ??
              (isTrader ? 'Trader User' : 'Customer User'),
          'email': firebaseUser.email ?? '',
          'phone': firebaseUser.phoneNumber ?? '',
          'isTrader': isTrader,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Always update lastLogin timestamp.
      await userDocRef.set({
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error syncing user to Firestore: $e');
    }

    state.setCurrentUser(
      AppUser(
        name: firebaseUser.displayName ??
            (isTraderFromFirestore ? 'Trader User' : 'Customer User'),
        email: firebaseUser.email ?? '',
        phone: firebaseUser.phoneNumber ?? '',
        location: '',
        isTrader: isTraderFromFirestore,
        isAdmin: isAdminFromFirestore,
      ),
    );
  }

  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
    bool isTrader = false,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(username);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'name': username,
              'email': email,
              'isTrader': isTrader,
              'createdAt': FieldValue.serverTimestamp(),
            });

        return AuthResponse(
          isSuccess: true,
          message: 'Registration successful',
        );
      }
    } catch (e) {
      return AuthResponse(isSuccess: false, message: e.toString());
    }
    return AuthResponse(isSuccess: false, message: 'Registration failed');
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}

class AuthResponse {
  final bool isSuccess;
  final String? message;

  AuthResponse({required this.isSuccess, this.message});
}
