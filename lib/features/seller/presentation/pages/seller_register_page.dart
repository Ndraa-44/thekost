import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Seller registration page – "Form Daftar" from Figma.
class SellerRegisterPage extends StatefulWidget {
  const SellerRegisterPage({super.key});

  @override
  State<SellerRegisterPage> createState() => _SellerRegisterPageState();
}

class _SellerRegisterPageState extends State<SellerRegisterPage> {
  final _emailCtl = TextEditingController();
  final _waCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _confirmCtl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _emailCtl.dispose();
    _waCtl.dispose();
    _passCtl.dispose();
    _confirmCtl.dispose();
    super.dispose();
  }

  InputDecoration _deco(String hint, {Widget? suffix}) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffix,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Text(
                AppStrings.sellerRegisterTitle,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.3),
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.sellerRegisterSubtitle,
                style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
              ),
              const SizedBox(height: 28),

              // Email
              _label('Email'),
              const SizedBox(height: 8),
              TextField(controller: _emailCtl, keyboardType: TextInputType.emailAddress, decoration: _deco('Masukkan alamat email aktif')),
              _helper('Gunakan email yang aktif untuk verifikasi akun dan penerimaan pesanan.'),
              const SizedBox(height: 16),

              // WhatsApp
              _label(AppStrings.sellerWhatsappLabel),
              const SizedBox(height: 8),
              TextField(controller: _waCtl, keyboardType: TextInputType.phone, decoration: _deco(AppStrings.sellerWhatsappHint)),
              _helper(AppStrings.sellerWhatsappNote),
              const SizedBox(height: 16),

              // Password
              _label('Password'),
              const SizedBox(height: 8),
              TextField(
                controller: _passCtl,
                obscureText: _obscurePass,
                decoration: _deco(AppStrings.sellerPasswordHint, suffix: _eye(_obscurePass, () => setState(() => _obscurePass = !_obscurePass))),
              ),
              _helper(AppStrings.sellerPasswordNote),
              const SizedBox(height: 16),

              // Confirm
              _label(AppStrings.sellerConfirmPasswordLabel),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmCtl,
                obscureText: _obscureConfirm,
                decoration: _deco(AppStrings.sellerConfirmPasswordHint, suffix: _eye(_obscureConfirm, () => setState(() => _obscureConfirm = !_obscureConfirm))),
              ),
              const SizedBox(height: 28),

              // Continue
              ElevatedButton(
                onPressed: _agreeTerms ? () => context.push(AppRouter.sellerVerifyWaPath) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
                  disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                child: const Text(AppStrings.sellerContinueButton, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(AppStrings.sellerHasAccount, style: TextStyle(fontSize: 12, color: Colors.black87)),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Text(AppStrings.sellerLoginLink, style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Checkbox + terms
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
                          const TextSpan(text: AppStrings.sellerAgreePrefix),
                          TextSpan(
                            text: AppStrings.sellerTermsLink,
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()..onTap = () => context.push(AppRouter.termsConditionsPath),
                          ),
                          const TextSpan(text: AppStrings.sellerAndText),
                          TextSpan(
                            text: AppStrings.sellerPrivacyLink,
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()..onTap = () => context.push(AppRouter.privacyPolicyPath),
                          ),
                          const TextSpan(text: AppStrings.sellerAgreeTheKost),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Text(t, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14));
  Widget _helper(String t) => Padding(padding: const EdgeInsets.only(top: 4), child: Text(t, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)));
  Widget _eye(bool obs, VoidCallback fn) => IconButton(icon: Icon(obs ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.black38, size: 20), onPressed: fn);
}
