import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Seller identity form – "Identitas Seller" from Figma.
/// Two-section form: KTP data + Bank account, with a curved blue header
/// and step indicator.
class SellerIdentityPage extends StatefulWidget {
  const SellerIdentityPage({super.key});

  @override
  State<SellerIdentityPage> createState() => _SellerIdentityPageState();
}

class _SellerIdentityPageState extends State<SellerIdentityPage> {
  final _namaKtpCtl = TextEditingController();
  final _nikCtl = TextEditingController();
  final _namaBankCtl = TextEditingController();
  final _noRekCtl = TextEditingController();
  final _namaPemilikCtl = TextEditingController();
  bool _agreeTerms = false;
  String? _ktpFileName;

  @override
  void dispose() {
    _namaKtpCtl.dispose();
    _nikCtl.dispose();
    _namaBankCtl.dispose();
    _noRekCtl.dispose();
    _namaPemilikCtl.dispose();
    super.dispose();
  }

  void _simulateKtpUpload() {
    // Simulate a file picker – in real integration use image_picker or file_picker
    setState(() {
      _ktpFileName = 'ktp_foto.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Foto KTP berhasil dipilih (simulasi)'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration _deco(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ── Curved blue header ──
          _buildHeader(context),
          // ── Body ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section: Data KTP
                  _buildSectionCard(
                    icon: Icons.badge_outlined,
                    title: AppStrings.sellerDataKtp,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Upload KTP
                        InkWell(
                          onTap: _simulateKtpUpload,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.primary.withValues(alpha: 0.04),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  _ktpFileName != null
                                      ? Icons.check_circle
                                      : Icons.cloud_upload_outlined,
                                  color: AppColors.primary,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _ktpFileName ?? AppStrings.sellerUploadKtp,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppStrings.sellerUploadKtpFormat,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _label(AppStrings.sellerNamaKtp),
                        const SizedBox(height: 8),
                        TextField(controller: _namaKtpCtl, decoration: _deco(AppStrings.sellerNamaKtpHint)),
                        const SizedBox(height: 16),
                        _label(AppStrings.sellerNik),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nikCtl,
                          keyboardType: TextInputType.number,
                          maxLength: 16,
                          decoration: _deco(AppStrings.sellerNikHint).copyWith(counterText: ''),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section: Rekening Bank
                  _buildSectionCard(
                    icon: Icons.account_balance_outlined,
                    title: AppStrings.sellerRekeningTitle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _label(AppStrings.sellerNamaBank),
                        const SizedBox(height: 8),
                        TextField(controller: _namaBankCtl, decoration: _deco(AppStrings.sellerNamaBankHint)),
                        const SizedBox(height: 16),
                        _label(AppStrings.sellerNoRekening),
                        const SizedBox(height: 8),
                        TextField(controller: _noRekCtl, keyboardType: TextInputType.number, decoration: _deco(AppStrings.sellerNoRekeningHint)),
                        const SizedBox(height: 16),
                        _label(AppStrings.sellerNamaPemilik),
                        const SizedBox(height: 8),
                        TextField(controller: _namaPemilikCtl, decoration: _deco(AppStrings.sellerNamaPemilikHint)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Checkbox terms
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _agreeTerms,
                          onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.4),
                            children: [
                              const TextSpan(text: AppStrings.sellerAgreeIdentity),
                              TextSpan(
                                text: AppStrings.sellerIdentityTerms,
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()..onTap = () => context.push(AppRouter.termsConditionsPath),
                              ),
                              const TextSpan(text: AppStrings.sellerIdentityForText),
                              TextSpan(
                                text: AppStrings.sellerIdentityPrivacy,
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()..onTap = () => context.push(AppRouter.privacyPolicyPath),
                              ),
                              const TextSpan(text: AppStrings.sellerIdentityEnding),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Submit button
                  ElevatedButton(
                    onPressed: _agreeTerms
                        ? () => context.push(AppRouter.sellerSuccessPath)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
                      disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text(
                      AppStrings.sellerRegisterButton,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Curved header with step indicator ──
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Transform.translate(
                offset: const Offset(-16, 0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                AppStrings.sellerIdentityTitle,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppStrings.sellerIdentitySubtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Step indicator
              Row(
                children: [
                  _buildStepDot(1, AppStrings.sellerStepIdentity, isActive: true),
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  _buildStepDot(2, AppStrings.sellerStepWaiting, isActive: false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepDot(int num, String label, {required bool isActive}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$num',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isActive ? AppColors.primary : Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.6),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _label(String t) => Text(t, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13));
}
