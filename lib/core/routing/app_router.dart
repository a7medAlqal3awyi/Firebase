import 'package:fire_app/core/routing/routing.dart';
import 'package:fire_app/features/add_category/add_category_screen.dart';
import 'package:fire_app/features/home/ui/home_screen.dart';
import 'package:fire_app/features/login/ui/login_screen.dart';
import 'package:flutter/material.dart';

import '../../features/signup/ui/signup_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case Routes.signupScreen:
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case Routes.addCategoryScreen:
        return MaterialPageRoute(
          builder: (_) => const AddCategoryScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text("No route defined for ${settings.name}"),
            ),
          ),
        );
    }
  }
}
