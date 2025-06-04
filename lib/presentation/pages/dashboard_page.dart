import 'package:flutter/material.dart';
import 'package:fixtrack_ticket/data/services/api_service.dart';
import 'create_ticket_page.dart';
import 'ticket_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ApiService _apiService = ApiService();

  List<dynamic> _tickets = [];
  List<dynamic> _categories = [];

  bool _loading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    try {
      final tickets = await _apiService.getTickets();
      final categories = await _apiService.getCategories();

      setState(() {
        _tickets = tickets;
        _categories = categories;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data dashboard.';
        _loading = false;
      });
    }
  }

  Map<String, int> _countTicketsByStatus() {
    final Map<String, int> map = {};
    for (var ticket in _tickets) {
      final status = ticket['status'] ?? 'unknown';
      map[status] = (map[status] ?? 0) + 1;
    }
    return map;
  }

  Map<String, int> _countTicketsByCategory() {
    final Map<int, int> categoryCount = {};
    for (var ticket in _tickets) {
      final categoryId = ticket['category']?['id'];
      if (categoryId != null) {
        categoryCount[categoryId] = (categoryCount[categoryId] ?? 0) + 1;
      }
    }

    Map<String, int> result = {};
    for (var cat in _categories) {
      final id = cat['id'];
      final name = cat['name'] ?? 'Kategori tidak diketahui';
      result[name] = categoryCount[id] ?? 0;
    }

    return result;
  }

  Map<String, int> _countTicketsByDetailedStatus() {
    final Map<String, int> map = {};
    for (var ticket in _tickets) {
      final status = (ticket['status'] ?? 'unknown').toLowerCase();
      map[status] = (map[status] ?? 0) + 1;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Selamat datang di Dashboard',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),

                        // Total Tiket
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Total Tiket',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    Text('${_tickets.length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              color:
                                                  Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.bold,
                                            )),
                                  ],
                                ),
                                const Icon(Icons.confirmation_num_outlined,
                                    size: 48, color: Colors.blueAccent),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Status tiket
                        Text('Status Tiket',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: _countTicketsByStatus().entries.map((entry) {
                            Color color;
                            switch (entry.key.toLowerCase()) {
                              case 'open':
                                color = Colors.green;
                                break;
                              case 'pending':
                                color = Colors.orange;
                                break;
                              case 'closed':
                                color = Colors.red;
                                break;
                              default:
                                color = Colors.grey;
                            }

                            return Chip(
                              backgroundColor: color.withOpacity(0.2),
                              label: Text(
                                '${entry.key} : ${entry.value}',
                                style: TextStyle(color: color),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 24),

                        // Tiket per Kategori
                        Text('Tiket per Kategori',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 12),
                        ..._countTicketsByCategory().entries.map((entry) {
                          final percent = _tickets.isEmpty
                              ? 0.0
                              : entry.value / _tickets.length;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${entry.key} (${entry.value})'),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: percent,
                                  color: Theme.of(context).primaryColor,
                                  backgroundColor:
                                      Colors.grey.withOpacity(0.3),
                                  minHeight: 10,
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 24),

                        // Tiket per Status Detail
                        Text('Tiket per Status Detail',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 12),
                        ..._countTicketsByDetailedStatus().entries.map((entry) {
                          final percent = _tickets.isEmpty
                              ? 0.0
                              : entry.value / _tickets.length;

                          final labelMap = {
                            'baru': 'Baru',
                            'progress': 'Sedang Dikerjakan',
                            'selesai': 'Sudah Dikerjakan',
                            'feedback': 'Sudah Diberikan Feedback',
                          };

                          Color color;
                          switch (entry.key) {
                            case 'baru':
                              color = Colors.blue;
                              break;
                            case 'progress':
                              color = Colors.orange;
                              break;
                            case 'selesai':
                              color = Colors.green;
                              break;
                            case 'feedback':
                              color = Colors.purple;
                              break;
                            default:
                              color = Colors.grey;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${labelMap[entry.key] ?? entry.key} (${entry.value})',
                                  style: TextStyle(color: color),
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: percent,
                                  color: color,
                                  backgroundColor: color.withOpacity(0.2),
                                  minHeight: 10,
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 30),

                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Buat Tiket Baru'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CreateTicketPage()),
                            );
                            if (result == true) {
                              _loadDashboardData();
                            }
                          },
                        ),

                        const SizedBox(height: 12),

                        ElevatedButton(
                          child: const Text('Lihat Semua Tiket'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const TicketPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
