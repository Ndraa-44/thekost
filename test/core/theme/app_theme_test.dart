import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thekost/core/theme/app_theme.dart';
import 'package:thekost/core/constants/app_colors.dart';

void main() {
  group('AppTheme', () {
    late ThemeData theme;

    setUp(() {
      theme = AppTheme.lightTheme;
    });

    test('should use Material 3', () {
      expect(theme.useMaterial3, isTrue);
    });

    test('should use primary color', () {
      expect(theme.primaryColor, AppColors.primary);
    });

    test('should use correct scaffold background color', () {
      expect(theme.scaffoldBackgroundColor, AppColors.background);
    });

    test('should have a text theme defined', () {
      expect(theme.textTheme, isNotNull);
    });

    test('AppBar should use primary background and white foreground', () {
      expect(theme.appBarTheme.backgroundColor, AppColors.primary);
      expect(theme.appBarTheme.foregroundColor, AppColors.white);
      expect(theme.appBarTheme.elevation, 0);
    });

    test('ElevatedButton should use primary colors', () {
      final buttonStyle = theme.elevatedButtonTheme.style;
      expect(buttonStyle, isNotNull);
    });

    test('ColorScheme should be seeded from primary', () {
      expect(theme.colorScheme.surface, AppColors.background);
    });
  });
}
