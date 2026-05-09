import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../auth/domain/entities/user.dart';

/// Halaman Edit Profil.
///
/// Menampilkan form untuk mengedit data diri pengguna,
/// termasuk fitur upload/ganti foto profil.
class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dobController;
  late final TextEditingController _jobController;
  late final TextEditingController _cityController;
  late final TextEditingController _educationController;
  late final TextEditingController _statusController;
  late final TextEditingController _emergencyContactController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController(text: '••••••••');
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    _dobController = TextEditingController();
    _jobController = TextEditingController();
    _cityController = TextEditingController();
    _educationController = TextEditingController();
    _statusController = TextEditingController();
    _emergencyContactController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _jobController.dispose();
    _cityController.dispose();
    _educationController.dispose();
    _statusController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            _buildAvatarSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildFormSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildSaveButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: GestureDetector(
        onTap: _showPhotoOptions,
        child: Stack(
          children: [
            // Avatar circle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFE2E8F0),
                child: Icon(
                  Icons.person_outline,
                  size: 50,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
            // Camera icon overlay
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Ubah Foto Profil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm + 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSm + 2),
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: AppColors.primary, size: 22),
                ),
                title: const Text('Ambil Foto',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text('Gunakan kamera',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500)),
                trailing: Icon(Icons.chevron_right_rounded,
                    color: Colors.grey.shade400),
                onTap: () {
                  Navigator.pop(ctx);
                  // TODO: Implement camera capture
                },
              ),
              Divider(height: 1, color: Colors.grey.shade100),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm + 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSm + 2),
                  ),
                  child: const Icon(Icons.photo_library_rounded,
                      color: AppColors.primary, size: 22),
                ),
                title: const Text('Pilih dari Galeri',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text('Pilih foto yang sudah ada',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500)),
                trailing: Icon(Icons.chevron_right_rounded,
                    color: Colors.grey.shade400),
                onTap: () {
                  Navigator.pop(ctx);
                  // TODO: Implement gallery picker
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Akun Section ──
          const Text(
            'Akun',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(label: 'Nama', controller: _nameController),
          _buildTextField(label: 'Email', controller: _emailController),
          _buildTextField(
            label: 'Password',
            controller: _passwordController,
            obscureText: true,
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Data Diri Section ──
          const Text(
            'Data Diri',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(
            label: 'No Handphone',
            controller: _phoneController,
            prefix: '🇮🇩 +62',
          ),
          _buildTextField(
            label: 'Tanggal Lahir',
            controller: _dobController,
            hint: 'DD / MM / YYYY',
            suffix: Icons.calendar_today_rounded,
          ),
          _buildTextField(
            label: 'Pekerjaan',
            controller: _jobController,
            hint: 'Mahasiswa / Kerja',
          ),
          _buildTextField(
            label: 'Kota Asal',
            controller: _cityController,
            hint: 'Masukkan kota asal',
          ),
          _buildTextField(
            label: 'Pendidikan Terakhir',
            controller: _educationController,
            hint: 'SMA/SMK/S1',
          ),
          _buildTextField(
            label: 'Status',
            controller: _statusController,
            hint: 'Belum Menikah',
          ),
          _buildTextField(
            label: 'No Telp Darurat',
            controller: _emergencyContactController,
            prefix: '🇮🇩 +62',
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    String? prefix,
    IconData? suffix,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
              prefixText: prefix != null ? '$prefix  ' : null,
              prefixStyle: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              suffixIcon: suffix != null
                  ? Icon(suffix, size: 18, color: Colors.grey.shade400)
                  : null,
              filled: true,
              fillColor: AppColors.cardBackground,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement profile save logic
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Profil berhasil disimpan!'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.success,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Simpan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
