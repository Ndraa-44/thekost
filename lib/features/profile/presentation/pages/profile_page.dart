import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return _ProfileContent(user: state.user);
        }
        return _ProfileLoginPrompt();
      },
    );
  }
}

// ─────────────── BELUM LOGIN ───────────────
class _ProfileLoginPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_rounded,
                    size: 64, color: AppColors.primary.withOpacity(0.5)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Anda Belum Login',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Login untuk mengelola profil,\npesanan, dan preferensi Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500, height: 1.5),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Masuk Sekarang',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────── SUDAH LOGIN ───────────────
class _ProfileContent extends StatelessWidget {
  final dynamic user;

  const _ProfileContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 24),
            _buildMenuSection(context),
            const SizedBox(height: 16),
            _buildSupportSection(context),
            const SizedBox(height: 16),
            _buildLogoutButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Blue background
        Container(
          width: double.infinity,
          height: 220,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
        ),
        // White Card
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 150, left: 24, right: 24),
          padding: const EdgeInsets.only(top: 56, bottom: 24, left: 24, right: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                user.email,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.phoneNumber ?? '-',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Avatar positioned overlapping
        Positioned(
          top: 106,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFE2E8F0),
              child: Icon(Icons.person_outline, size: 40, color: Color(0xFF64748B)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return _buildCardSection(
      title: 'Akun',
      items: [
        _MenuItem(
          icon: Icons.person_add_alt_1,
          label: 'Mulai Menyewakan',
          subtitle: 'Daftar Sebagai Pemilik Kos',
          onTap: () => _showComingSoon(context, 'Mulai Menyewakan'),
        ),
        _MenuItem(
          icon: Icons.receipt_long,
          label: 'Pesanan Saya',
          onTap: () => _showComingSoon(context, 'Pesanan Saya'),
        ),
        _MenuItem(
          icon: Icons.admin_panel_settings_outlined,
          label: 'Verifikasi Akun',
          subtitle: 'Akun belum diverifikasi',
          hasWarning: true,
          onTap: () => _showComingSoon(context, 'Verifikasi Akun'),
        ),
        _MenuItem(
          icon: Icons.person_outline_rounded,
          label: 'Edit Profil',
          onTap: () => _showComingSoon(context, 'Edit Profil'),
        ),
        _MenuItem(
          icon: Icons.lock_outline_rounded,
          label: 'Metode Pembayaran',
          onTap: () => _showComingSoon(context, 'Metode Pembayaran'),
        ),
        _MenuItem(
          icon: Icons.notifications_outlined,
          label: 'Notifikasi',
          onTap: () => _showComingSoon(context, 'Notifikasi'),
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return _buildCardSection(
      title: 'Dukungan',
      items: [
        _MenuItem(
          icon: Icons.help_outline_rounded,
          label: 'Pusat Bantuan',
          onTap: () => _showComingSoon(context, 'Pusat Bantuan'),
        ),
        _MenuItem(
          icon: Icons.description_outlined,
          label: 'Syarat & Ketentuan',
          onTap: () => _showComingSoon(context, 'Syarat & Ketentuan'),
        ),
        _MenuItem(
          icon: Icons.shield_outlined,
          label: 'Kebijakan Privasi',
          onTap: () => _showComingSoon(context, 'Kebijakan Privasi'),
        ),
      ],
    );
  }

  Widget _buildCardSection(
      {required String title, required List<_MenuItem> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final idx = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon,
                            color: AppColors.primary, size: 20),
                      ),
                      title: RichText(
                        text: TextSpan(
                          text: item.label,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                          children: [
                            if (item.hasWarning)
                              const TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      subtitle: item.subtitle != null
                          ? Text(item.subtitle!,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade500))
                          : null,
                      trailing: Icon(Icons.chevron_right_rounded,
                          color: Colors.grey.shade400),
                      onTap: item.onTap,
                    ),
                    if (idx < items.length - 1)
                      Divider(
                          height: 1,
                          indent: 60,
                          color: Colors.grey.shade100),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton(
          onPressed: () => _showLogoutDialog(context),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text('Keluar dari Akun',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal',
                style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Keluar',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — Segera hadir!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final bool hasWarning;

  _MenuItem({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
    this.hasWarning = false,
  });
}
