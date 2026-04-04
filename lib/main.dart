import 'package:flutter/material.dart';
import 'services/auth_service.dart';

void main() => runApp(const MaterialApp(home: LoginPage()));

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(title: const Text("Dating App Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone Number")),
            ElevatedButton(
              onPressed: () async {
                bool success = await authService.login(phoneController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? "Login Success!" : "Login Failed")),
                );
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}