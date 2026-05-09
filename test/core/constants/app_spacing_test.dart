import 'package:flutter_test/flutter_test.dart';
import 'package:thekost/core/constants/app_spacing.dart';

void main() {
  group('AppSpacing', () {
    group('raw values', () {
      test('xs should be 4.0', () {
        expect(AppSpacing.xs, 4.0);
      });

      test('sm should be 8.0', () {
        expect(AppSpacing.sm, 8.0);
      });

      test('md should be 16.0', () {
        expect(AppSpacing.md, 16.0);
      });

      test('lg should be 24.0', () {
        expect(AppSpacing.lg, 24.0);
      });

      test('xl should be 32.0', () {
        expect(AppSpacing.xl, 32.0);
      });

      test('xxl should be 48.0', () {
        expect(AppSpacing.xxl, 48.0);
      });

      test('values should be in ascending order', () {
        expect(AppSpacing.xs, lessThan(AppSpacing.sm));
        expect(AppSpacing.sm, lessThan(AppSpacing.md));
        expect(AppSpacing.md, lessThan(AppSpacing.lg));
        expect(AppSpacing.lg, lessThan(AppSpacing.xl));
        expect(AppSpacing.xl, lessThan(AppSpacing.xxl));
      });
    });

    group('radius values', () {
      test('radiusSm should be 8.0', () {
        expect(AppSpacing.radiusSm, 8.0);
      });

      test('radiusMd should be 12.0', () {
        expect(AppSpacing.radiusMd, 12.0);
      });

      test('radiusLg should be 16.0', () {
        expect(AppSpacing.radiusLg, 16.0);
      });

      test('radiusXl should be 20.0', () {
        expect(AppSpacing.radiusXl, 20.0);
      });

      test('radius values should be in ascending order', () {
        expect(AppSpacing.radiusSm, lessThan(AppSpacing.radiusMd));
        expect(AppSpacing.radiusMd, lessThan(AppSpacing.radiusLg));
        expect(AppSpacing.radiusLg, lessThan(AppSpacing.radiusXl));
      });
    });

    group('edge insets', () {
      test('paddingPage should have correct horizontal and vertical', () {
        expect(AppSpacing.paddingPage.left, AppSpacing.lg);
        expect(AppSpacing.paddingPage.right, AppSpacing.lg);
        expect(AppSpacing.paddingPage.top, AppSpacing.md);
        expect(AppSpacing.paddingPage.bottom, AppSpacing.md);
      });

      test('paddingCard should be uniform', () {
        expect(AppSpacing.paddingCard.left, AppSpacing.md);
        expect(AppSpacing.paddingCard.right, AppSpacing.md);
        expect(AppSpacing.paddingCard.top, AppSpacing.md);
        expect(AppSpacing.paddingCard.bottom, AppSpacing.md);
      });

      test('paddingHorizontal should have no vertical padding', () {
        expect(AppSpacing.paddingHorizontal.left, AppSpacing.lg);
        expect(AppSpacing.paddingHorizontal.right, AppSpacing.lg);
        expect(AppSpacing.paddingHorizontal.top, 0);
        expect(AppSpacing.paddingHorizontal.bottom, 0);
      });
    });
  });
}
