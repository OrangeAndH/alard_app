import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../state/app_state.dart';
import '../main_screen.dart';
import 'forgot_password.dart';
import 'register_screen.dart';
import '../../state/app_state_scope.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool isTrader = true;
  bool obscurePassword = true;
  bool _isProcessing = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (_isProcessing) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      }
      return;
    }

    setState(() => _isProcessing = true);

    // Note: Updated AuthService to use static methods or instances as needed.
    // Assuming AuthService.login is available.
    final response = await _authService.login(
      context: context,
      email: email,
      password: password,
      isTrader: isTrader,
    );

    if (mounted) setState(() => _isProcessing = false);

    if (response.isSuccess && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? 'Login failed')),
      );
    }
  }

  Future<void> loginWithGoogle() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    final response = await _authService.loginWithGoogle(
      context: context,
      isTrader: isTrader,
    );

    if (mounted) setState(() => _isProcessing = false);

    if (response.isSuccess && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else if (mounted) {
      if (response.message != 'cancelled') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Google login failed')),
        );
      }
    }
  }

  Future<void> loginWithApple() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    final response = await _authService.loginWithApple(
      context: context,
      isTrader: isTrader,
    );

    if (mounted) setState(() => _isProcessing = false);

    if (response.isSuccess && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Apple login failed')),
      );
    }
  }

  Future<void> loginWithFacebook() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    final response = await _authService.loginWithFacebook(
      context: context,
      isTrader: isTrader,
    );

    if (mounted) setState(() => _isProcessing = false);

    if (response.isSuccess && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? 'Facebook login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/loginscreen_background.png",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),

                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/alard_login_logo.png",
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        alignment: const Alignment(0.12, 0.0), // Shift content right to center it
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  state.t('login_continue_as'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isTrader = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isTrader
                              ? const Color(0xFFCEB04B)
                              : const Color(0xFFE6D8A6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black54, width: 0.6),
                        ),
                        child: Row(
                          children: [
                            Image.asset("assets/trader.png", width: 36),
                            const SizedBox(width: 6),
                            Text(state.t('login_trader')),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isTrader = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: !isTrader
                              ? const Color(0xFFCEB04B)
                              : const Color(0xFFE6D8A6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black54, width: 0.6),
                        ),
                        child: Row(
                          children: [
                            Image.asset("assets/regular.png", width: 36),
                            const SizedBox(width: 6),
                            Text(state.t('login_customer')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  state.t('login_welcome'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  state.t('login_subtext'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF5E2E2),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 46,
                        minHeight: 46,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset("assets/email.png"),
                      ),
                      hintText: state.t('login_email'),
                      filled: true,
                      fillColor: const Color(0xFFF0E7DE),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 46,
                        minHeight: 46,
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 46,
                        minHeight: 46,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 20,
                        ),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset("assets/password.png"),
                      ),
                      hintText: state.t('login_password'),
                      filled: true,
                      fillColor: const Color(0xFFF0E7DE),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        state.t('login_forgot_password'),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF0E7DE),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 62, 70, 14),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          state.t('login_button'),
                          style: const TextStyle(
                            color: Color(0xFFE4DFC1),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA2B52D),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          state.t('login_create_account'),
                          style: const TextStyle(
                            color: Color(0xFFE4DFC1),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  state.t('login_or_with'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF0E7DE),
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: loginWithGoogle,
                      child: Container(
                        width: 100,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE4DFC1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Image.asset("assets/google.png", width: 100),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: loginWithFacebook,
                      child: Container(
                        width: 100,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE4DFC1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/facebook.png",
                            width: 45,
                          ), // Reusing facebook asset as placeholder
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                _buildQuickLogin(context, state),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildQuickLogin(BuildContext context, AppState state) {
    return Column(
      children: [
        const Text(
          'Quick Login (Test)',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFF0E7DE),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _QuickLoginButton(
              label: 'Customer',
              onTap: () {
                emailController.text = 'hamzamonjed12@gmail.com';
                passwordController.text = '1234';
                setState(() => isTrader = false);
              },
            ),
            const SizedBox(width: 12),
            _QuickLoginButton(
              label: 'Trader',
              onTap: () {
                emailController.text = 'zaid123@gmail.com';
                passwordController.text = '1234';
                setState(() => isTrader = true);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickLoginButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickLoginButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white24,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.white30),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
