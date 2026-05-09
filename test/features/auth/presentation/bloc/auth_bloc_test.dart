import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thekost/features/auth/domain/entities/user.dart';
import 'package:thekost/features/auth/domain/repositories/auth_repository.dart';
import 'package:thekost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thekost/features/auth/presentation/bloc/auth_event.dart';
import 'package:thekost/features/auth/presentation/bloc/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockRepository;

  const testUser = User(
    id: '1',
    name: 'Test User',
    email: 'test@test.com',
    phoneNumber: '081234567890',
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    authBloc = AuthBloc(repository: mockRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state should be AuthInitial', () {
      expect(authBloc.state, const AuthInitial());
    });

    // ── Login ──
    group('LoginRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when login succeeds',
        build: () {
          when(() => mockRepository.login('test@test.com', 'pass123'))
              .thenAnswer((_) async => testUser);
          return authBloc;
        },
        act: (bloc) =>
            bloc.add(const LoginRequested('test@test.com', 'pass123')),
        expect: () => [
          const AuthLoading(),
          const AuthAuthenticated(testUser),
        ],
        verify: (_) {
          verify(() => mockRepository.login('test@test.com', 'pass123'))
              .called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when login fails',
        build: () {
          when(() => mockRepository.login('bad@email.com', 'wrong'))
              .thenThrow(Exception('Invalid credentials'));
          return authBloc;
        },
        act: (bloc) =>
            bloc.add(const LoginRequested('bad@email.com', 'wrong')),
        expect: () => [
          const AuthLoading(),
          isA<AuthError>(),
        ],
      );
    });

    // ── Register ──
    group('RegisterRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when register succeeds',
        build: () {
          when(() => mockRepository.register('new@user.com'))
              .thenAnswer((_) async => testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(const RegisterRequested('new@user.com')),
        expect: () => [
          const AuthLoading(),
          const AuthAuthenticated(testUser),
        ],
        verify: (_) {
          verify(() => mockRepository.register('new@user.com')).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when register fails',
        build: () {
          when(() => mockRepository.register('bad@email.com'))
              .thenThrow(Exception('Registration failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(const RegisterRequested('bad@email.com')),
        expect: () => [
          const AuthLoading(),
          isA<AuthError>(),
        ],
      );
    });

    // ── Google Auth ──
    group('GoogleAuthRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when Google auth succeeds',
        build: () {
          when(() => mockRepository.loginWithGoogle())
              .thenAnswer((_) async => testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(const GoogleAuthRequested()),
        expect: () => [
          const AuthLoading(),
          const AuthAuthenticated(testUser),
        ],
        verify: (_) {
          verify(() => mockRepository.loginWithGoogle()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when Google auth fails',
        build: () {
          when(() => mockRepository.loginWithGoogle())
              .thenThrow(Exception('Google auth failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(const GoogleAuthRequested()),
        expect: () => [
          const AuthLoading(),
          isA<AuthError>(),
        ],
      );
    });

    // ── Logout ──
    group('LogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthInitial] when logout succeeds',
        build: () {
          when(() => mockRepository.logout()).thenAnswer((_) async {});
          return authBloc;
        },
        act: (bloc) => bloc.add(const LogoutRequested()),
        expect: () => [
          const AuthInitial(),
        ],
        verify: (_) {
          verify(() => mockRepository.logout()).called(1);
        },
      );
    });
  });

  // ── Auth Event Tests ──
  group('AuthEvent', () {
    test('LoginRequested supports value equality', () {
      const event1 = LoginRequested('a@b.com', 'pass');
      const event2 = LoginRequested('a@b.com', 'pass');
      expect(event1, equals(event2));
    });

    test('LoginRequested props contains email and password', () {
      const event = LoginRequested('a@b.com', 'pass');
      expect(event.props, equals(['a@b.com', 'pass']));
    });

    test('RegisterRequested supports value equality', () {
      const event1 = RegisterRequested('a@b.com');
      const event2 = RegisterRequested('a@b.com');
      expect(event1, equals(event2));
    });

    test('LogoutRequested supports value equality', () {
      const event1 = LogoutRequested();
      const event2 = LogoutRequested();
      expect(event1, equals(event2));
    });

    test('GoogleAuthRequested supports value equality', () {
      const event1 = GoogleAuthRequested();
      const event2 = GoogleAuthRequested();
      expect(event1, equals(event2));
    });
  });

  // ── Auth State Tests ──
  group('AuthState', () {
    test('AuthInitial supports value equality', () {
      expect(const AuthInitial(), equals(const AuthInitial()));
    });

    test('AuthLoading supports value equality', () {
      expect(const AuthLoading(), equals(const AuthLoading()));
    });

    test('AuthAuthenticated supports value equality', () {
      const state1 = AuthAuthenticated(testUser);
      const state2 = AuthAuthenticated(testUser);
      expect(state1, equals(state2));
    });

    test('AuthAuthenticated props contains user', () {
      const state = AuthAuthenticated(testUser);
      expect(state.props, equals([testUser]));
    });

    test('AuthError supports value equality', () {
      const state1 = AuthError('error');
      const state2 = AuthError('error');
      expect(state1, equals(state2));
    });

    test('AuthError props contains message', () {
      const state = AuthError('some error');
      expect(state.props, equals(['some error']));
    });
  });
}
