import 'package:flutter_test/flutter_test.dart';
import 'package:thekost/core/constants/app_strings.dart';

void main() {
  group('AppStrings', () {
    group('app', () {
      test('appName should be non-empty', () {
        expect(AppStrings.appName, isNotEmpty);
      });

      test('appTitle should be non-empty', () {
        expect(AppStrings.appTitle, isNotEmpty);
      });

      test('appTagline should be non-empty', () {
        expect(AppStrings.appTagline, isNotEmpty);
      });
    });

    group('auth', () {
      test('loginTitle should be non-empty', () {
        expect(AppStrings.loginTitle, isNotEmpty);
      });

      test('loginButton should be non-empty', () {
        expect(AppStrings.loginButton, isNotEmpty);
      });

      test('registerTitle should be non-empty', () {
        expect(AppStrings.registerTitle, isNotEmpty);
      });

      test('registerButton should be non-empty', () {
        expect(AppStrings.registerButton, isNotEmpty);
      });

      test('googleLoginButton should be non-empty', () {
        expect(AppStrings.googleLoginButton, isNotEmpty);
      });
    });

    group('dynamic strings (methods)', () {
      test('propertiesFound should format correctly', () {
        expect(AppStrings.propertiesFound(5), contains('5'));
      });

      test('noResultFound should contain category and location', () {
        final result = AppStrings.noResultFound('Kost', 'Sleman');
        expect(result, contains('Kost'));
        expect(result, contains('Sleman'));
      });

      test('removedFromFavorite should contain property name', () {
        final result = AppStrings.removedFromFavorite('Villa Retreat');
        expect(result, contains('Villa Retreat'));
      });

      test('comingSoon should contain feature name', () {
        final result = AppStrings.comingSoon('Pembayaran');
        expect(result, contains('Pembayaran'));
      });
    });

    group('navigation', () {
      test('navDiscover should be non-empty', () {
        expect(AppStrings.navDiscover, isNotEmpty);
      });

      test('navBookings should be non-empty', () {
        expect(AppStrings.navBookings, isNotEmpty);
      });

      test('navChat should be non-empty', () {
        expect(AppStrings.navChat, isNotEmpty);
      });

      test('navSaved should be non-empty', () {
        expect(AppStrings.navSaved, isNotEmpty);
      });

      test('navProfile should be non-empty', () {
        expect(AppStrings.navProfile, isNotEmpty);
      });
    });

    group('search', () {
      test('searchPropertyHint should be non-empty', () {
        expect(AppStrings.searchPropertyHint, isNotEmpty);
      });

      test('selectLocation should be non-empty', () {
        expect(AppStrings.selectLocation, isNotEmpty);
      });
    });
  });
}
