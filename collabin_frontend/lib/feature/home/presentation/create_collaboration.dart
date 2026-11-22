import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:collabin/core/common/app_ui_helper.dart';
import 'package:collabin/feature/home/service/collaboration_service.dart';
import 'package:collabin/core/common/shared_code.dart';
import '../../../../core/common/color_value.dart';

class CreateCollaborationPage extends StatefulWidget {
  const CreateCollaborationPage({super.key});

  @override
  State<CreateCollaborationPage> createState() =>
      _CreateCollaborationPageState();
}

class _CreateCollaborationPageState extends State<CreateCollaborationPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  final _repoController = TextEditingController();
  final _urlController = TextEditingController();
  final FocusNode _categoryFocusNode = FocusNode();
  final List<String> _selectedCategories = [];
  final SharedCode _sharedCode = SharedCode();

  String _selectedStatus = 'Belum Dimulai';
  String? _imagePath; // ganti dengan File jika pakai image_picker
  DateTime? _selectedDeadline;

  final List<String> _statusOptions = [
    'Belum Dimulai',
    'Sedang Berjalan',
    'Selesai',
    'Ditunda',
  ];

  @override
  void initState() {
    super.initState();
    _categoryFocusNode.addListener(_handleCategoryFocusChange);
  }

  void _handleCategoryFocusChange() {
    if (!_categoryFocusNode.hasFocus) {
      _addCategory(_categoryController.text);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    _repoController.dispose();
    _urlController.dispose();
    _categoryFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final sizeInBytes = await picked.length();
      final sizeInMb = sizeInBytes / (1024 * 1024);

      if (sizeInMb > 10) {
        if (mounted) {
          AppUiHelper.showError(context, 'Ukuran gambar maksimal adalah 10MB');
        }
        return;
      }
      setState(() => _imagePath = picked.path);
    }
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDeadline = picked);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_categoryController.text.trim().isNotEmpty) {
      _addCategory(_categoryController.text);
    }

    if (_selectedCategories.isEmpty) {
      AppUiHelper.showError(context, 'Kategori wajib diisi.');
      return;
    }

    // Mapping UI status to Backend status if needed
    // Samakan dengan mapping di halaman detail/edit.
    const statusMap = {
      'Belum Dimulai': 'NOT OPEN',
      'Sedang Berjalan': 'OPEN',
      'Selesai': 'DONE',
      'Project Berakhir': 'COMPLETED',
      'Ditunda': 'HOLD',
    };
    final backendStatus = statusMap[_selectedStatus] ?? 'OPEN';

    // show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: ColorValue.primaryColor,
        ),
      ),
    );

    try {
      await CollaborationService().createProject(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        category: _selectedCategories,
        status: backendStatus,
        repositoryLink: _repoController.text.trim(),
        imagePath: _imagePath,
        deadline: _selectedDeadline,
      );

      if (!mounted) return;
      Navigator.of(context).pop(); // remove loading
      AppUiHelper.showSuccess(context, 'Proyek berhasil dibuat.');
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // remove loading
      AppUiHelper.showError(context, AppUiHelper.readableError(e));
    }
  }

  static const Color _fieldFill = Color(0xFFF5F6F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ── Toolbar bawah (Figma): pilih gambar + dropdown status ──────────
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          padding: const EdgeInsets.fromLTRB(12, 6, 16, 6),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Pilih gambar',
                onPressed: _pickImage,
                icon: const Icon(Icons.image_outlined, color: ColorValue.textSecondary, size: 26),
              ),
              const Spacer(),
              _buildStatusDropdown(),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              // ── App Bar: ← Buat Kolaborasi ............ Tambah ──────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: ColorValue.textPrimary, size: 24),
                    ),
                    const SizedBox(width: 4),
                    const Expanded(
                      child: Text(
                        'Buat Kolaborasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: ColorValue.textPrimary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _submit,
                      style: TextButton.styleFrom(foregroundColor: ColorValue.primaryColor),
                      child: const Text(
                        'Tambah',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Gambar cover ─────────────────────────────────
                      GestureDetector(
                        onTap: _pickImage,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _imagePath != null
                              ? _buildPickedImage()
                              : Container(
                                  height: 180,
                                  width: double.infinity,
                                  color: _fieldFill,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_photo_alternate_outlined,
                                          size: 44, color: Colors.grey[400]),
                                      const SizedBox(height: 8),
                                      Text('Tambah Gambar Kolaborasi',
                                          style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildLabel('Judul'),
                      const SizedBox(height: 4),
                      _buildTextField(
                        controller: _titleController,
                        hint: 'Judul Kolaborasi',
                        validator: _sharedCode.titleValidator,
                        isBorderless: true,
                      ),
                      const SizedBox(height: 22),

                      _buildLabel('Deskripsi'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _descController,
                        hint: 'Tambahkan Deskripsi',
                        maxLines: 4,
                        validator: _sharedCode.descriptionValidator,
                      ),
                      const SizedBox(height: 22),

                      _buildLabel('Kategori'),
                      const SizedBox(height: 8),
                      _buildCategoryInput(),
                      const SizedBox(height: 22),

                      _buildLabel('Link Repository (Opsional)'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _repoController,
                        hint: 'https://github.com/...',
                        keyboardType: TextInputType.url,
                        prefixIcon: Icons.link_rounded,
                        validator: _sharedCode.urlValidator,
                      ),
                      const SizedBox(height: 22),

                      _buildLabel('Deadline (Opsional)'),
                      const SizedBox(height: 8),
                      _buildDeadlineField(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Preview gambar yang dipilih (web memakai blob URL, mobile memakai File).
  Widget _buildPickedImage() {
    const h = 180.0;
    if (kIsWeb) {
      return Image.network(_imagePath!, height: h, width: double.infinity, fit: BoxFit.cover);
    }
    return Image.file(File(_imagePath!), height: h, width: double.infinity, fit: BoxFit.cover);
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        color: ColorValue.textSecondary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    String? Function(String?)? validator,
    bool isBorderless = false,
  }) {
    if (isBorderless) {
      return TextFormField(
        controller: controller,
        validator: validator,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: ColorValue.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.grey[400],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      );
    }

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontSize: 14,
        color: ColorValue.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 18, color: Colors.grey[400])
            : null,
        filled: true,
        fillColor: _fieldFill,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: ColorValue.primaryColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildCategoryInput() {
    final List<String> categories = SharedCode.itScopeCategories.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _fieldFill,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ..._selectedCategories.map(
                  (cat) => Chip(
                    label: Text(cat),
                    onDeleted: () => setState(() => _selectedCategories.remove(cat)),
                    backgroundColor: ColorValue.primaryColor.withValues(alpha: 0.1),
                    deleteIcon: Icon(Icons.cancel, size: 16, color: ColorValue.primaryColor.withValues(alpha: 0.7)),
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ColorValue.primaryColor,
                    ),
                  ),
                ),
                IntrinsicWidth(
                  child: TextField(
                    controller: _categoryController,
                    focusNode: _categoryFocusNode,
                    style: const TextStyle(fontSize: 14, color: ColorValue.textPrimary),
                    decoration: InputDecoration(
                      hintText: _selectedCategories.isEmpty ? 'Tambahkan Kategori' : null,
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && value.endsWith(',')) {
                        _addCategory(value.substring(0, value.length - 1));
                      }
                    },
                    onSubmitted: (value) {
                      _addCategory(value);
                      _categoryFocusNode.requestFocus();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((cat) {
            final isSelected = _selectedCategories.contains(cat);
            return ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    if (!_selectedCategories.contains(cat)) _selectedCategories.add(cat);
                  } else {
                    _selectedCategories.remove(cat);
                  }
                });
              },
              selectedColor: ColorValue.primaryColor.withValues(alpha: 0.1),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 12,
                color: isSelected ? ColorValue.primaryColor : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? ColorValue.primaryColor : Colors.grey[300]!,
                ),
              ),
              showCheckmark: false,
            );
          }).toList(),
        ),
      ],
    );
  }

  void _addCategory(String value) {
    if (value.isEmpty) {
      _categoryController.clear();
      return;
    }

    // Mendukung input multiple via koma
    final parts = value.split(',');

    for (var part in parts) {
      final clean = part.trim();
      if (clean.isEmpty) continue;

      if (!SharedCode.isITSector(clean)) {
        AppUiHelper.showError(context, 'Kategori "$clean" harus dalam lingkup IT');
        continue;
      }

      if (!_selectedCategories.contains(clean)) {
        setState(() => _selectedCategories.add(clean));
      }
    }
    _categoryController.clear();
  }

  /// Dropdown status di toolbar bawah (posisi "Project Portofolio ▾" di Figma).
  Widget _buildStatusDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedStatus,
        borderRadius: BorderRadius.circular(12),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: ColorValue.textSecondary),
        selectedItemBuilder: (_) => _statusOptions
            .map((s) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flag_outlined, size: 18, color: _statusColor(s)),
                    const SizedBox(width: 6),
                    Text(s, style: const TextStyle(fontSize: 14, color: ColorValue.textSecondary)),
                    const SizedBox(width: 4),
                  ],
                ))
            .toList(),
        items: _statusOptions.map((s) {
          return DropdownMenuItem(
            value: s,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: _statusColor(s)),
                ),
                const SizedBox(width: 10),
                Text(s, style: const TextStyle(fontSize: 14, color: ColorValue.textPrimary)),
              ],
            ),
          );
        }).toList(),
        onChanged: (v) {
          if (v != null) setState(() => _selectedStatus = v);
        },
      ),
    );
  }

  Widget _buildDeadlineField() {
    return GestureDetector(
      onTap: _pickDeadline,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: _fieldFill,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                color: ColorValue.primaryColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _selectedDeadline != null
                    ? 'Deadline: ${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}'
                    : 'Pilih tanggal deadline',
                style: TextStyle(
                  fontSize: 14,
                  color: _selectedDeadline != null
                      ? ColorValue.textPrimary
                      : Colors.grey[500],
                ),
              ),
            ),
            if (_selectedDeadline != null)
              GestureDetector(
                onTap: () => setState(() => _selectedDeadline = null),
                child: Icon(Icons.close_rounded, color: Colors.grey[500]),
              ),
          ],
        ),
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status) {
    case 'Sedang Berjalan':
      return Colors.green;
    case 'Selesai':
      return const Color(0xFFF7941D);
    case 'Ditunda':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}