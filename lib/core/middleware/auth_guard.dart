import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isAuthenticated(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == true) {
          return child;
        } else {
          // Arahkan kembali ke login
          Future.microtask(() {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return const SizedBox(); // Widget kosong sementara
        }
      },
    );
  }
}
