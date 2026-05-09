import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Halaman Syarat dan Ketentuan.
///
/// Menampilkan konten statis teks panjang mengenai
/// syarat dan ketentuan penggunaan aplikasi thekost.
class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Syarat dan Ketentuan'),
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
              'Syarat dan Ketentuan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildParagraph(
              'Kost, tempat tidur, atau media dan keseluruhan atau sebagian '
              'layanan thekost berasal pihak yang bertanggung jawab atas '
              'pengelolaan, baik yang ditemukan pada platform maupun pada '
              'sumber lain. Harap baca syarat dan ketentuan ini dengan '
              'saksama sebelum menggunakan platform thekost.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSectionTitle('1. Umum'),
            const SizedBox(height: AppSpacing.sm),
            _buildParagraph(
              'Platform ini dimiliki oleh thekost beserta pihak yang '
              'berfungsi sebagai pengelola dan penyedia layanan kos daring. '
              'Dengan mengakses dan/atau menggunakan platform, anda menyetujui '
              'bahwa anda telah membaca, memahami, dan setuju untuk terikat oleh '
              'Syarat dan Ketentuan ini.',
            ),

            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle('2. Live Chat'),
            const SizedBox(height: AppSpacing.sm),
            _buildParagraph(
              'Fitur Live Chat memungkinkan anda untuk berkomunikasi langsung '
              'dengan pemilik kos atau tim customer service thekost. Penggunaan '
              'fitur ini harus sesuai dengan norma kesopanan dan tidak boleh '
              'digunakan untuk mengirimkan konten yang melanggar hukum.',
            ),

            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle('3. Pusat Bantuan'),
            const SizedBox(height: AppSpacing.sm),
            _buildParagraph(
              'Platform ini menyediakan pusat bantuan bagi pengguna untuk '
              'mendapatkan informasi, panduan, dan jawaban atas pertanyaan yang '
              'sering diajukan. Anda dapat mengakses pusat bantuan melalui menu '
              'yang tersedia di aplikasi.',
            ),

            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle('4. Layanan Pengaduan Konsumen'),
            const SizedBox(height: AppSpacing.sm),
            _buildParagraph(
              'thekost menyediakan layanan pengaduan konsumen yang dapat '
              'diakses melalui kanal komunikasi yang tersedia. Kami berkomitmen '
              'untuk menindaklanjuti setiap pengaduan dalam waktu yang wajar '
              'dan memberikan solusi yang adil bagi semua pihak.',
            ),

            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle('Penggunaan Platform'),
            const SizedBox(height: AppSpacing.sm),
            _buildParagraph(
              'Dengan menggunakan platform ini, anda menyetujui bahwa:',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildBulletList([
              'Anda berusia minimal 17 tahun atau memiliki izin dari orang tua/wali.',
              'Informasi yang anda berikan adalah benar dan akurat.',
              'Anda bertanggung jawab atas keamanan akun dan password anda.',
              'Anda tidak akan menyalahgunakan platform untuk tujuan yang melanggar hukum.',
            ]),

            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle('Syarat dan Ketentuan'),
            const SizedBox(height: AppSpacing.sm),
            _buildParagraph(
              'Syarat dan ketentuan ini merupakan perjanjian mengikat yang '
              'mengatur kewajiban dan hak-hak pengguna serta thekost. Dengan '
              'mendaftar dan/atau menggunakan platform, anda dianggap telah '
              'menyetujui seluruh ketentuan yang berlaku.',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildParagraph(
              'thekost berhak untuk mengubah, memodifikasi, menambah, atau '
              'menghapus bagian dari Syarat dan Ketentuan ini kapan saja. '
              'Perubahan akan berlaku efektif setelah dipublikasikan melalui '
              'platform.',
            ),

            const SizedBox(height: AppSpacing.xl),

            // Divider
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: AppSpacing.md),

            // Footer note
            Center(
              child: Text(
                'Terakhir diperbarui: 1 Januari 2026',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
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
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade700,
        height: 1.7,
      ),
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
}
