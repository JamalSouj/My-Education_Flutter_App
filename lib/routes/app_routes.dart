import 'package:flutter/material.dart';
import '../presentation/establishments_screen/establishment_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/programs_screen/programs_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/register_screen/register_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String establishments = '/establishments-screen';
  static const String splash = '/splash-screen';
  static const String login = '/login-screen';
  static const String programs = '/programs-screen';
  static const String home = '/home-screen';
  static const String register = '/register-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    establishments: (context) => const EstablishmentsScreen(),
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    programs: (context) => const ProgramsScreen(),
    home: (context) => const HomeScreen(),
    register: (context) => const RegisterScreen(),
    // TODO: Add your other routes here
  };
}

