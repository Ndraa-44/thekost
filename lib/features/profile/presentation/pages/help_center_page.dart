import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Halaman Pusat Bantuan.
///
/// Menampilkan informasi kontak bantuan seperti WhatsApp, Live Chat,
/// dan Layanan Pengaduan Konsumen sesuai desain Figma.
class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpHeader(),
            const SizedBox(height: AppSpacing.lg),
            _buildContactSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildComplaintSection(),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF1A56DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Butuh Bantuan?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tim kami siap membantu Anda kapan pun. Jangan ragu untuk menghubungi kami melalui kanal di bawah untuk mendapatkan bantuan yang cepat.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // WhatsApp
        _buildContactCard(
          icon: Icons.chat_rounded,
          iconBgColor: const Color(0xFF25D366),
          title: 'WhatsApp',
          description: 'Hubungi kami langsung melalui WhatsApp. Tim kami siap membantu anda pada hari & jam kerja.',
          actionLabel: 'Chat WhatsApp',
          onTap: () {
            // TODO: Open WhatsApp link
          },
        ),
        const SizedBox(height: AppSpacing.md),

        // Live Chat
        _buildContactCard(
          icon: Icons.headset_mic_rounded,
          iconBgColor: AppColors.primary,
          title: 'Live Chat',
          description: 'Chat langsung dengan tim kami di aplikasi. Customer Service kami akan merespon dengan cepat dan siap membantu.',
          actionLabel: 'Mulai Live Chat',
          onTap: () {
            // TODO: Open Live Chat
          },
        ),
        const SizedBox(height: AppSpacing.md),

        // FAQ / Pusat Bantuan
        _buildContactCard(
          icon: Icons.help_outline_rounded,
          iconBgColor: const Color(0xFFF59E0B),
          title: 'Pusat Bantuan',
          description: 'Temukan jawaban dari pertanyaan yang sering diajukan, panduan penggunaan atau seluruh info lainnya.',
          actionLabel: 'Lihat FAQ',
          onTap: () {
            // TODO: Open FAQ
          },
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String description,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(icon, color: iconBgColor, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    actionLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.report_outlined,
                  color: AppColors.error, size: 22),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Layanan Pengaduan Konsumen',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Jika Anda memiliki keluhan atau pengaduan terkait layanan TheKost, silakan hubungi kami melalui kanal berikut:',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          _buildComplaintRow(
            icon: Icons.phone_outlined,
            label: 'Layanan Pengaduan Konsumen',
            value: '008540007647',
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildComplaintRow(
            icon: Icons.phone_outlined,
            label: 'Direktorat Jenderal Perlindungan Konsumen',
            value: '008540007647',
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
