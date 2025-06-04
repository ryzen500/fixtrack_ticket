import 'package:flutter/material.dart';
import 'package:fixtrack_ticket/data/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_page.dart';
import 'update_password_page.dart';
import 'login_page.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _profileFuture;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadAndFetchProfile();
  }

  void _loadAndFetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('user_id');
    if (_userId != null) {
      setState(() {
        _profileFuture = _apiService.getProfile(_userId!);
      });
    }
  }

  String formatDateTime(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy – HH:mm').format(dt);
    } catch (e) {
      return dateStr;
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userId == null) {
      return  Scaffold(
        appBar: AppBar(title: const  Text('Profil')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          final profile = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    (profile['name'] as String).substring(0, 1).toUpperCase(),
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  profile['name'] ?? '',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  profile['email'] ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Nama'),
                subtitle: Text(profile['name'] ?? '-'),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(profile['email'] ?? '-'),
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Telepon'),
                subtitle: Text(profile['phone'] ?? '-'),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Bergabung'),
                subtitle: Text(formatDateTime(profile['created_at'])),
              ),
              const Divider(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Edit Biodata'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                  if (result == true) {
                    setState(() {
                      _profileFuture = _apiService.getProfile(_userId!);
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.lock),
                label: const Text('Ganti Password'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.orangeAccent,
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UpdatePasswordPage()),
                  );
                  if (result == true) {
                    setState(() {
                      _profileFuture = _apiService.getProfile(_userId!);
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: _logout,
              ),
            ],
          );
        },
      ),
    );
  }
}
