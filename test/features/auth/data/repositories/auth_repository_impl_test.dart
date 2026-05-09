import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thekost/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:thekost/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:thekost/features/auth/domain/entities/user.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(dataSource: mockDataSource);
  });

  const testUser = User(
    id: '1',
    name: 'Test User',
    email: 'test@test.com',
    phoneNumber: '081234567890',
  );

  group('AuthRepositoryImpl', () {
    group('login', () {
      test('should delegate to data source and return User on success',
          () async {
        when(() => mockDataSource.login('test@test.com', 'pass123'))
            .thenAnswer((_) async => testUser);

        final result = await repository.login('test@test.com', 'pass123');

        expect(result, equals(testUser));
        verify(() => mockDataSource.login('test@test.com', 'pass123'))
            .called(1);
      });

      test('should propagate exception from data source', () async {
        when(() => mockDataSource.login('bad@email.com', 'wrong'))
            .thenThrow(Exception('Invalid credentials'));

        expect(
          () => repository.login('bad@email.com', 'wrong'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('register', () {
      test('should delegate to data source and return User', () async {
        when(() => mockDataSource.register('new@user.com'))
            .thenAnswer((_) async => testUser);

        final result = await repository.register('new@user.com');

        expect(result, equals(testUser));
        verify(() => mockDataSource.register('new@user.com')).called(1);
      });
    });

    group('loginWithGoogle', () {
      test('should delegate to data source and return User', () async {
        when(() => mockDataSource.loginWithGoogle())
            .thenAnswer((_) async => testUser);

        final result = await repository.loginWithGoogle();

        expect(result, equals(testUser));
        verify(() => mockDataSource.loginWithGoogle()).called(1);
      });
    });

    group('logout', () {
      test('should delegate to data source', () async {
        when(() => mockDataSource.logout()).thenAnswer((_) async {});

        await repository.logout();

        verify(() => mockDataSource.logout()).called(1);
      });
    });
  });
}
