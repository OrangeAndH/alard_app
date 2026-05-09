import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../main_screen.dart';
import '../../state/app_state.dart';
import '../../state/app_state_scope.dart';
  
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool isTrader = true;
  bool obscurePassword = true;
  bool _isProcessing = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
  if (_isProcessing) return;

  final username = usernameController.text.trim();
  final email = emailController.text.trim();
  final password = passwordController.text.trim();
  final confirmPassword = confirmPasswordController.text.trim();

  if (username.isEmpty ||
      email.isEmpty ||
      password.isEmpty ||
      confirmPassword.isEmpty) {
    _showSnackBar(AppStateScope.of(context).t('register_fill_fields'));
    return;
  }

  if (password != confirmPassword) {
    _showSnackBar(AppStateScope.of(context).t('register_password_mismatch'));
    return;
  }

  setState(() => _isProcessing = true);

  final response = await _authService.register(
    username: username,
    email: email,
    password: password,
    isTrader: isTrader,
  );

  if (mounted) setState(() => _isProcessing = false);

  if (response.isSuccess && mounted) {
    AppStateScope.of(context).setCurrentUser(
      AppUser(
        name: username,
        email: email,
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
    _showSnackBar(response.message ?? 'Registration failed');
  }
}

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
                const SizedBox(height: 50),
                Center(
                  child: ClipOval(
                    child: Image.asset(
                      "assets/alard_icon.png",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  state.t('register_subtitle'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRoleToggle(state.t('login_trader'), "assets/trader.png", true),
                    const SizedBox(width: 12),
                    _buildRoleToggle(state.t('login_customer'), "assets/regular.png", false),
                  ],
                ),
                const SizedBox(height: 25),
                _buildTextField(
                  controller: usernameController,
                  hint: state.t('register_name'),
                  iconPath: "assets/email.png", // Reusing email icon style for placeholder
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: emailController,
                  hint: state.t('register_email'),
                  iconPath: "assets/email.png",
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: passwordController,
                  hint: state.t('register_password'),
                  iconPath: "assets/password.png",
                  obscure: true,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: confirmPasswordController,
                  hint: state.t('register_confirm_password'),
                  iconPath: "assets/password.png",
                  obscure: true,
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 62, 70, 14),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              state.t('register_button'),
                              style: const TextStyle(color: Color(0xFFE4DFC1), fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    state.t('register_already_have'),
                    style: const TextStyle(color: Color(0xFFF0E7DE), fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleToggle(String label, String asset, bool role) {
    final bool isSelected = isTrader == role;
    return GestureDetector(
      onTap: () => setState(() => isTrader = role),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFCEB04B) : const Color(0xFFE6D8A6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Image.asset(asset, width: 30),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String iconPath,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: controller,
        obscureText: obscure && obscurePassword,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(iconPath),
          ),
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF0E7DE),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}