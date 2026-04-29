import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/property/presentation/bloc/property_bloc.dart';
import 'features/splash/presentation/pages/splash_screen.dart';

void main() {
  runApp(const TheKostApp());
}

class TheKostApp extends StatelessWidget {
  const TheKostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<PropertyBloc>(create: (context) => PropertyBloc()),
      ],
      child: MaterialApp(
        title: 'thekost',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}