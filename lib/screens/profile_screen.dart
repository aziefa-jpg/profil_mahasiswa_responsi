import 'package:flutter/material.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';
import '../widgets/profile_card.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _nimController;
  late TextEditingController _prodiController;
  late TextEditingController _emailController;
  bool _isEditing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final student = AppProvider.of(context).student;
    _nameController = TextEditingController(text: student.name);
    _nimController = TextEditingController(text: student.nim);
    _prodiController = TextEditingController(text: student.programStudi);
    _emailController = TextEditingController(text: student.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _prodiController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final provider = AppProvider.of(context);
    final updated = provider.student.copyWith(
      name: Validators.sanitize(_nameController.text.trim()),
      nim: Validators.sanitize(_nimController.text.trim()),
      programStudi: Validators.sanitize(_prodiController.text.trim()),
      email: Validators.sanitize(_emailController.text.trim()),
    );

    provider.updateStudent(updated);
    setState(() => _isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = AppProvider.of(context).student;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileCard(
              student: student,
              onEditPressed: _isEditing
                  ? null
                  : () => setState(() => _isEditing = true),
            ),
            if (_isEditing) ...[
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => Validators.validateRequired(v, 'Nama'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nimController,
                      decoration: const InputDecoration(
                        labelText: 'NIM',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => Validators.validateRequired(v, 'NIM'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _prodiController,
                      decoration: const InputDecoration(
                        labelText: 'Program Studi',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          Validators.validateRequired(v, 'Program Studi'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => Validators.validateRequired(v, 'Email'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _isEditing = false),
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: _saveProfile,
                            child: const Text('Simpan'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}