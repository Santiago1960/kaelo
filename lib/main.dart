import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaelo/services/tts_service.dart';
import 'package:localization/localization.dart';

import 'config/config.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  // Orientación Portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  // Inicializamos el servicio TTS
  TtsService();

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
    );
  }
}
