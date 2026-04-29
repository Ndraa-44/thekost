import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (event.email == 'admin@dkost.com' && event.password == 'admin123') {
        emit(AuthAuthenticated(User(
          id: '1',
          name: 'Ahmad Sobirin',
          email: 'ahmadsobirin@gmail.com',
          phoneNumber: '0895400976472',
        )));
      } else {
        emit(AuthError('Email atau password salah. (Gunakan admin@dkost.com / admin123)'));
      }
    });

    on<LogoutRequested>((event, emit) {
      emit(AuthInitial());
    });
  }
}
