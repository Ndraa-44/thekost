import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/pages/main_screen.dart';
import '../features/splash/presentation/pages/splash_screen.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/domain/entities/user.dart';
import '../features/property/domain/entities/property.dart';
import '../features/property/presentation/pages/property_detail_page.dart';
import '../features/property/presentation/pages/search_result_page.dart';
import '../features/profile/presentation/pages/verify_account_page.dart';
import '../features/profile/presentation/pages/edit_profile_page.dart';
import '../features/profile/presentation/pages/privacy_policy_page.dart';
import '../features/profile/presentation/pages/help_center_page.dart';
import '../features/profile/presentation/pages/terms_conditions_page.dart';
import '../features/booking/presentation/pages/create_booking_page.dart';
import '../features/booking/presentation/pages/booking_detail_page.dart';
import '../features/booking/domain/entities/booking.dart' as booking_entity;
import '../features/seller/presentation/pages/seller_login_page.dart';
import '../features/seller/presentation/pages/seller_register_page.dart';
import '../features/seller/presentation/pages/seller_whatsapp_verify_page.dart';
import '../features/seller/presentation/pages/seller_identity_page.dart';
import '../features/seller/presentation/pages/seller_verification_success_page.dart';

class AppRouter {
  AppRouter._(); // Prevent instantiation

  // ── Route Paths ──
  static const String splashPath = '/';
  static const String homePath = '/home';
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String propertyDetailPath = '/property-detail';
  static const String searchResultPath = '/search-result';
  static const String createBookingPath = '/create-booking';
  static const String bookingDetailPath = '/booking-detail';

  // ── Seller Paths ──
  static const String sellerLoginPath = '/seller-login';
  static const String sellerRegisterPath = '/seller-register';
  static const String sellerVerifyWaPath = '/seller-verify-wa';
  static const String sellerIdentityPath = '/seller-identity';
  static const String sellerSuccessPath = '/seller-success';

  // ── Profile Detail Paths ──
  static const String verifyAccountPath = '/verify-account';
  static const String editProfilePath = '/edit-profile';
  static const String privacyPolicyPath = '/privacy-policy';
  static const String helpCenterPath = '/help-center';
  static const String termsConditionsPath = '/terms-conditions';

  /// The GoRouter instance used by [MaterialApp.router].
  static final GoRouter router = GoRouter(
    initialLocation: splashPath,
    routes: [
      GoRoute(
        path: splashPath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: homePath,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: loginPath,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: registerPath,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: propertyDetailPath,
        builder: (context, state) {
          final property = state.extra as Property;
          return PropertyDetailPage(property: property);
        },
      ),
      GoRoute(
        path: searchResultPath,
        builder: (context, state) {
          final params = state.extra as Map<String, String>;
          return SearchResultPage(
            location: params['location']!,
            category: params['category']!,
          );
        },
      ),
      GoRoute(
        path: createBookingPath,
        builder: (context, state) {
          final property = state.extra as Property;
          return CreateBookingPage(property: property);
        },
      ),

      GoRoute(
        path: bookingDetailPath,
        builder: (context, state) {
          final booking = state.extra as booking_entity.Booking;
          return BookingDetailPage(booking: booking);
        },
      ),

      // ── Seller Routes ──
      GoRoute(
        path: sellerLoginPath,
        builder: (context, state) => const SellerLoginPage(),
      ),
      GoRoute(
        path: sellerRegisterPath,
        builder: (context, state) => const SellerRegisterPage(),
      ),
      GoRoute(
        path: sellerVerifyWaPath,
        builder: (context, state) => const SellerWhatsappVerifyPage(),
      ),
      GoRoute(
        path: sellerIdentityPath,
        builder: (context, state) => const SellerIdentityPage(),
      ),
      GoRoute(
        path: sellerSuccessPath,
        builder: (context, state) => const SellerVerificationSuccessPage(),
      ),

      // ── Profile Detail Routes ──
      GoRoute(
        path: verifyAccountPath,
        builder: (context, state) => const VerifyAccountPage(),
      ),
      GoRoute(
        path: editProfilePath,
        builder: (context, state) {
          final user = state.extra as User;
          return EditProfilePage(user: user);
        },
      ),
      GoRoute(
        path: privacyPolicyPath,
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
      GoRoute(
        path: helpCenterPath,
        builder: (context, state) => const HelpCenterPage(),
      ),
      GoRoute(
        path: termsConditionsPath,
        builder: (context, state) => const TermsConditionsPage(),
      ),
    ],
  );
}
