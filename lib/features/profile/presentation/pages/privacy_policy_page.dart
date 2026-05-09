import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Halaman Kebijakan Privasi.
///
/// Menampilkan konten statis teks panjang mengenai
/// kebijakan privasi aplikasi TheKost.
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kebijakan Privasi'),
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
            const Text(
              'Kebijakan Privasi thekost',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildParagraph(
              'Kami berkomitmen untuk menjaga privasi dan keamanan data pribadi Anda. '
              'Kebijakan privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, '
              'dan melindungi informasi Anda saat menggunakan platform thekost.',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildParagraph(
              'Kebijakan ini mencakup informasi yang kami peroleh melalui '
              'platform thekost, termasuk tetapi tidak terbatas pada:',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildNumberedList([
              'Informasi yang Anda berikan langsung kepada kami.',
              'Pengumpulan data otomatis.',
              'Informasi yang diperoleh dari pihak ketiga.',
              'Login melalui layanan pihak ketiga.',
              'Cookies dan teknologi pelacakan.',
              'Data analitik dari pihak ketiga.',
            ]),
            const SizedBox(height: AppSpacing.lg),
            _buildParagraph(
              'Kami memeriksa dan memperbaharui kebijakan privasi ini dari waktu ke waktu. '
              'Informasi yang kami kumpulkan untuk membantu tujuan bisnis yang sah, setelah '
              'menimbang potensi risiko terhadap hak-hak privasi Anda.',
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle('Pengumpulan Data'),
            const SizedBox(height: AppSpacing.sm),
            _buildParagraph(
              'Kami memproses data pribadi Anda ketika Anda mendaftarkan akun, '
              'membuat pemesanan, berkomunikasi dengan kami, atau menggunakan layanan kami. '
              'Data yang kami kumpulkan meliputi:',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildBulletList([
              'Nama lengkap dan informasi kontak',
              'Alamat email dan nomor telepon',
              'Data identitas (KTP/SIM/Paspor)',
              'Informasi pembayaran',
              'Riwayat transaksi dan pemesanan',
              'Data lokasi dan preferensi pencarian',
            ]),
            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle('Penggunaan Data'),
            const SizedBox(height: AppSpacing.sm),
            _buildParagraph(
              'Kami menggunakan informasi yang dikumpulkan untuk:',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildBulletList([
              'Memproses dan mengelola pemesanan Anda',
              'Menyediakan layanan pelanggan',
              'Mengirimkan notifikasi terkait transaksi',
              'Meningkatkan kualitas layanan kami',
              'Mematuhi kewajiban hukum yang berlaku',
            ]),
            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle('Keamanan Data'),
            const SizedBox(height: AppSpacing.sm),
            _buildParagraph(
              'Kami melindungi data pribadi Anda dengan menerapkan langkah-langkah '
              'keamanan teknis dan organisasi yang sesuai. Kami menggunakan enkripsi, '
              'kontrol akses, dan audit keamanan secara berkala untuk menjaga keamanan '
              'informasi Anda.',
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle('Hak Anda'),
            const SizedBox(height: AppSpacing.sm),
            _buildParagraph(
              'Anda memiliki hak untuk mengakses, memperbaiki, atau menghapus data '
              'pribadi Anda. Untuk mengajukan permintaan terkait data Anda, silakan '
              'hubungi kami melalui informasi kontak yang tersedia di aplikasi.',
            ),
            const SizedBox(height: AppSpacing.xl),
            // TheKost branding footer
            _buildBrandingFooter(),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.7),
    );
  }

  Widget _buildNumberedList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
            bottom: AppSpacing.xs + 2,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                child: Text(
                  '${entry.key + 1}.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.7,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.7,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
            bottom: AppSpacing.xs + 2,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.7,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBrandingFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
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
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.apartment_rounded, color: AppColors.primary, size: 24),
              SizedBox(width: AppSpacing.sm),
              Text(
                'thekost',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Dapatkan "info kost murah" hanya di thekost App',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStoreBadge('Google Play'),
              const SizedBox(width: AppSpacing.sm),
              _buildStoreBadge('App Store'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoreBadge(String store) {
    final isPlayStore = store == 'Google Play';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPlayStore ? Icons.play_arrow_rounded : Icons.apple_rounded,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isPlayStore ? 'GET IT ON' : 'Download on the',
                style: const TextStyle(fontSize: 7, color: Colors.white70),
              ),
              Text(
                store,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
