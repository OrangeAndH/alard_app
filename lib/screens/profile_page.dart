import 'package:flutter/material.dart';
import '../auth_service.dart';

// IMPORTANT: You will need to import your actual login screen file.
// Replace 'login_screen.dart' with the correct path and 'LoginScreen' with the correct widget name.
// import 'package:alard_app/screens/login_screen.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    // This FutureBuilder is the key. It calls getUserProfile() and rebuilds
    // the UI with the data when it's ready.
    return FutureBuilder<User?>(
      future: _authService.getUserProfile(),
      builder: (context, snapshot) {
        // While waiting for data from local storage, show a loading spinner.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If no user is logged in or an error occurs, show a message.
        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: const Center(
              child: Text('Could not load profile. Please log in.'),
            ),
          );
        }

        // Once the user data is successfully loaded, 'user' will contain it.
        final user = snapshot.data!;

        //
        // REPLACE THE UI BELOW WITH YOUR OWN WIDGETS
        //
        // You can now use `user.username` and `user.email` in your Text widgets.
        // Keep the `onPressed` logic for the logout button.
        //
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Example of a profile picture avatar
                  const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
                  const SizedBox(height: 20),

                  // Use the real user data here instead of hardcoded strings
                  Text(user.username, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(user.email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 40),

                  // This button now has the correct logout logic
                  ElevatedButton(
                    onPressed: () async {
                      await _authService.logout();
                      if (context.mounted) {
                        // IMPORTANT: Replace `LoginScreen()` with your actual login page widget.
                        // This navigates to the login screen and removes all previous screens.
                        // Navigator.of(context).pushAndRemoveUntil(
                        //   MaterialPageRoute(builder: (context) => LoginScreen()),
                        //   (Route<dynamic> route) => false,
                        // );
                      }
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}