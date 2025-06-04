import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fixtrack_ticket/data/services/api_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = _apiService.getComments();
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy – HH:mm').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi')),
      body: FutureBuilder<List<dynamic>>(
        future: _commentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada notifikasi.'));
          }

          final comments = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: comments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final comment = comments[index];
              final ticket = comment['ticket'];
              final user = comment['user'];

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.blue),
                  title: Text(ticket?['subject'] ?? 'Tiket'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment['message'] ?? 'Belum di Tindak Lanjut'),
                      const SizedBox(height: 4),
                      Text(
                        'Oleh: ${user?['name'] ?? 'Anonim'} • ${formatDate(comment['created_at'])}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Bisa diarahkan ke detail tiket
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
