import 'package:alard_app/forgot_password.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'main_screen.dart';
import 'register_screen.dart';
import 'app_state.dart';
import 'app_state_scope.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
    return;
  }

  setState(() => _isProcessing = true);

  final AuthResponse response = await _authService.login(
    email: email,
    password: password,
    isTrader: isTrader,
  );

  if (mounted) setState(() => _isProcessing = false);

  if (response.isSuccess && mounted) {
    final nameFromEmail = email.split('@').first;

    AppStateScope.of(context).setCurrentUser(
      AppUser(
        name: nameFromEmail.isEmpty ? 'Alard User' : nameFromEmail,
        email: email,
        phone: 'No phone added',
        location: 'Palestine',
        isTrader: isTrader,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
    );
  } else {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message ?? 'Login failed'),
        ),
      );
    }
  }
}

Future<void> loginWithGoogle() async {
  if (_isProcessing) return;

  setState(() => _isProcessing = true);

  final AuthResponse response = await _authService.loginWithSocial(
    provider: 'Google',
    isTrader: isTrader,
  );

  if (mounted) setState(() => _isProcessing = false);

  if (response.isSuccess && mounted) {
    AppStateScope.of(context).setCurrentUser(
      AppUser(
        name: 'Google User',
        email: 'google.user@alard.com',
        phone: 'No phone added',
        location: 'Palestine',
        isTrader: isTrader,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  } else if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.message ?? 'Google Login failed')),
    );
  }
}

Future<void> loginWithFacebook() async {
  if (_isProcessing) return;

  setState(() => _isProcessing = true);

  final AuthResponse response = await _authService.loginWithSocial(
    provider: 'Facebook',
    isTrader: isTrader,
  );

  if (mounted) setState(() => _isProcessing = false);

  if (response.isSuccess && mounted) {
    AppStateScope.of(context).setCurrentUser(
      AppUser(
        name: 'Facebook User',
        email: 'facebook.user@alard.com',
        phone: 'No phone added',
        location: 'Palestine',
        isTrader: isTrader,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  } else if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.message ?? 'Facebook Login failed')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
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
                  child: ClipOval(
                    child: Image.asset(
                      "assets/alard_icon.png",
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Continue as:",
                  style: TextStyle(
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
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isTrader
                              ? const Color(0xFFCEB04B)
                              : const Color(0xFFE6D8A6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Image.asset("assets/trader.png", width: 36),
                            const SizedBox(width: 6),
                            const Text("Trader"),
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
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: !isTrader
                              ? const Color(0xFFCEB04B)
                              : const Color(0xFFE6D8A6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Image.asset("assets/regular.png", width: 36),
                            const SizedBox(width: 6),
                            const Text("Regular user"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "Welcome to Al'Ard!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Log in or create an account to continue",
                  style: TextStyle(
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
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset("assets/email.png"),
                      ),
                      hintText: "Email",
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
                        ),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset("assets/password.png"),
                      ),
                      hintText: "Password",
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
      child: const Text(
        "Forgot password?",
        style: TextStyle(
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          color: Color(0xFFE4DFC1),
                          fontWeight: FontWeight.bold,
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Create New Account",
                        style: TextStyle(
                          color: Color(0xFFE4DFC1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Or log in with",
                  style: TextStyle(
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
                          child: Image.asset("assets/facebook.png", width: 45),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}