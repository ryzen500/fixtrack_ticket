import 'package:flutter/material.dart';
import 'package:fixtrack_ticket/data/services/api_service.dart';
import 'create_ticket_page.dart';
import 'package:intl/intl.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  void _fetchTickets() {
    _ticketsFuture = _apiService.getTickets();
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tiket')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Buat Tiket'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateTicketPage(),
                    ),
                  );

                  if (result == true) {
                    setState(() {
                      _fetchTickets();
                    });
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _ticketsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada tiket.'));
                }

                final tickets = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor:
                              MaterialStateProperty.all(Colors.blue.shade50),
                          headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.blue.shade100;
                              }
                              return null; // Use default value.
                            },
                          ),
                          dataTextStyle: const TextStyle(fontSize: 14),
                          columns: const [
                            DataColumn(label: Text('No')),
                            DataColumn(label: Text('Judul')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Kategori')),
                            DataColumn(label: Text('Assigned User')),
                            DataColumn(label: Text('Tanggal')),
                          ],
                          rows: List<DataRow>.generate(tickets.length, (index) {
                            final ticket = tickets[index];
                            return DataRow(
                              color: MaterialStateProperty.all(
                                index % 2 == 0 ? Colors.grey.shade50 : Colors.grey.shade200,
                              ),
                              cells: [
                                DataCell(Text('${index + 1}')),
                                DataCell(Text(ticket['subject'] ?? '-')),
                                DataCell(Text(ticket['status'] ?? '-')),
                                DataCell(Text(ticket['category']?['name'] ?? '-')),
                                DataCell(Text(ticket['assigned_user']?['name'] ?? '-')),
                                DataCell(Text(formatDate(ticket['created_at']))),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
