import 'package:go_router/go_router.dart';
import 'package:kaelo/pages/home/home_screen.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
  ],
);