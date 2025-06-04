import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'ticket_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';
// Tambahkan halaman lainnya jika sudah tersedia

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

    final List<Widget> _pages = const [
      DashboardPage(),
      TicketPage(),
      NotificationPage(),
      ProfilePage(),
    ];
  final List<BottomNavigationBarItem> _items = const [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
    BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: 'Tickets'),
    BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifikasi'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
