import 'package:flutter_test/flutter_test.dart';
import 'package:thekost/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:thekost/features/auth/domain/entities/user.dart';

void main() {
  late AuthLocalDataSource dataSource;

  setUp(() {
    dataSource = AuthLocalDataSource();
  });

  group('AuthLocalDataSource', () {
    group('login', () {
      test('should return User when credentials are valid', () async {
        final user = await dataSource.login('admin@dkost.com', 'admin123');

        expect(user, isA<User>());
        expect(user.id, '1');
        expect(user.name, 'Ahmad Sobirin');
        expect(user.email, 'ahmadsobirin@gmail.com');
        expect(user.phoneNumber, '0895400976472');
      });

      test('should throw Exception when email is wrong', () async {
        expect(
          () => dataSource.login('wrong@email.com', 'admin123'),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw Exception when password is wrong', () async {
        expect(
          () => dataSource.login('admin@dkost.com', 'wrongpass'),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw Exception when both credentials are wrong', () async {
        expect(
          () => dataSource.login('wrong@email.com', 'wrongpass'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('register', () {
      test('should return User with email-derived name', () async {
        final user = await dataSource.register('testuser@email.com');

        expect(user, isA<User>());
        expect(user.id, '2');
        expect(user.name, 'testuser');
        expect(user.email, 'testuser@email.com');
      });

      test('should handle different email formats', () async {
        final user = await dataSource.register('john.doe@gmail.com');

        expect(user.name, 'john.doe');
        expect(user.email, 'john.doe@gmail.com');
      });
    });

    group('loginWithGoogle', () {
      test('should return a mock Google User', () async {
        final user = await dataSource.loginWithGoogle();

        expect(user, isA<User>());
        expect(user.id, '3');
        expect(user.name, 'Google User');
        expect(user.email, 'user@gmail.com');
      });
    });

    group('logout', () {
      test('should complete without error', () async {
        await expectLater(dataSource.logout(), completes);
      });
    });
  });
}
