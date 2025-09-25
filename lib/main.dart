import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/config.dart';

// Definimos una variable global para SharedPreferences
late SharedPreferences prefs;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos SharedPreferences antes de correr la app
  prefs = await SharedPreferences.getInstance();

  // Orientación Portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(
    ProviderScope(
      child: const MainApp()
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    LocalJsonLocalization.delegate.directories = ['lib/i18n'];

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      localizationsDelegates: [
        // delegate from flutter_localization
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        
        // delegate from localization package.
        //json-file
        LocalJsonLocalization.delegate,
        //or map
        MapLocalization.delegate,
      ],      
      supportedLocales: const [
        Locale('de'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('it'),
        Locale('pt'),
      ],

      routerConfig: router,

      theme: ThemeData(
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white,
          elevation: 5.0,
          textStyle: const TextStyle(color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        )
      ),
    );
  }
}
