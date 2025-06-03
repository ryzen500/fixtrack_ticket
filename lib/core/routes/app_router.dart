import 'package:flutter/material.dart';
import 'package:fixtrack_ticket/presentation/pages/login_page.dart';
import 'package:fixtrack_ticket/presentation/pages/dashboard_page.dart';
import 'package:fixtrack_ticket/core/middleware/auth_guard.dart';
import 'package:fixtrack_ticket/presentation/pages/main_navigation.dart';


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: MainNavigation()),
        );
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('Page not found')),
                ));
    }
  }
}
