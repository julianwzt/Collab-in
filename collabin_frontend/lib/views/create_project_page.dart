import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({Key? key}) : super(key: key);

  @override
  _CreateProjectPageState createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _category = 'Web Development';
  bool _isPublic = true;
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final res = await ApiService.createProject({
      'userId': 1,
      'title': _titleCtrl.text,
      'description': _descCtrl.text,
      'category': _category,
      'visibility': _isPublic ? 'Public' : 'Private',
    });

    setState(() => _isLoading = false);

    if (res.statusCode == 200) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Sukses'),
          content: const Text('Project berhasil dibuat'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Project Baru')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Masukkan Judul'),
              validator: (v) => v!.isEmpty ? 'Field wajib diisi' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              validator: (v) => v!.isEmpty ? 'Field wajib diisi' : null,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _category,
              items: ['Web Development', 'UI/UX', 'Mobile App']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
              decoration: const InputDecoration(labelText: 'Pilih Kategori'),
            ),
            SwitchListTile(
              title: const Text('Visibilitas Public'),
              value: _isPublic,
              onChanged: (v) => setState(() => _isPublic = v),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}
