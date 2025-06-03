import 'package:flutter/material.dart';
// call Api
import 'package:fixtrack_ticket/data/services/api_service.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

void login() async {
  setState(() => isLoading = true);

  final api = ApiService();
  final success = await api.login(
    email: emailController.text,
    password: passwordController.text,
  );

  setState(() => isLoading = false);

  if (success) {
    Navigator.pushReplacementNamed(context, '/dashboard');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login gagal')),
    );
  }

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login FixTrack')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: login,
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
