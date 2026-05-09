import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thekost/core/constants/app_colors.dart';

void main() {
  group('AppColors', () {
    test('primary should be correct color', () {
      expect(AppColors.primary, const Color(0xFF003FA3));
    });

    test('primaryLight should be correct color', () {
      expect(AppColors.primaryLight, const Color(0xFFA5B4FC));
    });

    test('background should be correct color', () {
      expect(AppColors.background, const Color(0xFFF8FAFC));
    });

    test('textPrimary should be correct color', () {
      expect(AppColors.textPrimary, const Color(0xFF1E293B));
    });

    test('success should be correct color', () {
      expect(AppColors.success, const Color(0xFF16A34A));
    });

    test('error should be correct color', () {
      expect(AppColors.error, const Color(0xFFDC2626));
    });

    test('warning should be correct color', () {
      expect(AppColors.warning, const Color(0xFFF59E0B));
    });

    test('white should be Colors.white', () {
      expect(AppColors.white, Colors.white);
    });

    test('cardShadow should have low opacity', () {
      expect(AppColors.cardShadow.a, lessThan(0.1));
    });
  });
}
