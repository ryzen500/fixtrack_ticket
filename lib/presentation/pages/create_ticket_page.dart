import 'package:flutter/material.dart';
import 'package:fixtrack_ticket/data/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<dynamic> _categories = [];
  String? _selectedUrgency = 'sedang';
  int? _selectedCategoryId;
  int _assignedTo = 1; // default sementara
  int? _userId;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _loadUserId();
  }

  Future<void> _fetchCategories() async {
    final categories = await _apiService.getCategories();
    setState(() {
      _categories = categories;
    });
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt(
        'user_id',
      ); // asumsi user_id disimpan setelah login
    });
  }

 void _submitForm() async {
  print("SUBMIT DIPANGGIL");

  if (_formKey.currentState?.validate() != true) {
    print("Form validation gagal");
    return;
  }

  if (_selectedCategoryId == null) {
    print("Category ID null");
    return;
  }


  if (_userId == null) {
    print(" User ID null");
    return;
  }


  final data = {
    "subject": _subjectController.text,
    "description": _descriptionController.text,
    "category_id": _selectedCategoryId,
    "assigned_to": _assignedTo,
    "user_id": _userId,
    "urgensi": _selectedUrgency,
  };

  print("Mengirim data: $data");

  final success = await _apiService.createTicket(data);

  if (success) {
    if (mounted) {
      // Navigator.pop(context);
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tiket berhasil dibuat')),
      );
    }
  } else {
    print("GAGAL mengirim data");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gagal membuat tiket')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Tiket Baru')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => value!.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => value!.isEmpty ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                items:
                    _categories.map<DropdownMenuItem<int>>((cat) {
                      return DropdownMenuItem(
                        value: cat['id'],
                        child: Text(cat['name']),
                      );
                    }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                onChanged:
                    (value) => setState(() {
                      _selectedCategoryId = value;
                    }),
                validator:
                    (value) => value == null ? 'Kategori wajib dipilih' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedUrgency,
                items: const [
                  DropdownMenuItem(value: 'rendah', child: Text('Rendah')),
                  DropdownMenuItem(value: 'sedang', child: Text('Sedang')),
                  DropdownMenuItem(value: 'tinggi', child: Text('Tinggi')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Urgensi',
                  border: OutlineInputBorder(),
                ),
                onChanged:
                    (value) => setState(() {
                      _selectedUrgency = value;
                    }),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Kirim'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
