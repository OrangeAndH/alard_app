import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    String email = emailController.text;
    String password = passwordController.text;

    print("Email: $email");
    print("Password: $password");

    // TODO: Add authentication later
  }

  void loginWithGoogle() {
    print("Google login clicked");
  }

  void loginWithFacebook() {
    print("Facebook login clicked");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Login button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: login,
                child: const Text("Login"),
              ),
            ),

            const SizedBox(height: 20),

            // Google button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: loginWithGoogle,
                child: const Text("Continue with Google"),
              ),
            ),

            const SizedBox(height: 10),

            // Facebook button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: loginWithFacebook,
                child: const Text("Continue with Facebook"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}