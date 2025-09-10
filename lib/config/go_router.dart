import 'package:go_router/go_router.dart';
import 'package:kaelo/pages/home/button_config_screen.dart';
import 'package:kaelo/pages/home/configuration_screen.dart';
import 'package:kaelo/pages/home/home_screen.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [

    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),

    GoRoute(
      path: '/configuration',
      builder: (context, state) => ConfigurationPage(),
    ),

    GoRoute(
      path: '/button_config/:id',
      builder: (context, state) => ButtonConfigurationPage(),
    ),
  ],
);