import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // Background
          SizedBox.expand(
            child: Image.asset(
              "assets/loginscreen_background.png",
              fit: BoxFit.cover,
            ),
          ),

          // Scrollable content
          SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox(height: 60),

                // Logo (circular)
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

                // Trader / Regular User Row
                Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [

    GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFCEB04B),
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
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFCEB04B),
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

                // Email Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
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

                // Password Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      suffix: GestureDetector(
  onTap: () {
    // TODO: navigate to forgot password page
  },
  child: const Padding(
    padding: EdgeInsets.only(right: 10),
    child: Text(
      "Forgot password?",
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
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

                const SizedBox(height: 20),

                // Log In Button
               Padding(
  padding: const EdgeInsets.symmetric(horizontal: 30),
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {},
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

                // Create Account Button
                Padding(
  padding: const EdgeInsets.symmetric(horizontal: 30),
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {},
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

                // Social Login
                Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [

    GestureDetector(
      onTap: () {},
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
      onTap: () {},
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