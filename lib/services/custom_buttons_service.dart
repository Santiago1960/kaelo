import 'package:shared_preferences/shared_preferences.dart';

// Este servicio gestiona el almacenamiento y recuperación de las frases personalizables.
class CustomButtonsService {
  // Patrón Singleton para asegurar una única instancia.
  static final CustomButtonsService _instance = CustomButtonsService._internal();

  factory CustomButtonsService() {
    return _instance;
  }

  CustomButtonsService._internal();

  // Nombres de las claves para SharedPreferences
  static const String _button1Key = 'button1';
  static const String _button2Key = 'button2';
  
  /// Guarda las frases en el almacenamiento local.
  Future<void> saveCustomButtons({
    String? button1,
    String? button2,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(button1 != null) {
      await prefs.setString(_button1Key, button1);
    }

    if(button2 != null) {
      await prefs.setString(_button2Key, button2);
    }
  }

  /// Recupera las frases personalizables.
  ///
  /// Retorna un mapa con el nombre y el número, o un mapa vacío si no se encuentran datos.
  Future<Map<String, String?>> getCustomButtons() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? button1 = prefs.getString(_button1Key);
    final String? button2 = prefs.getString(_button2Key);

    return {
      'button1': button1,
      'button2': button2,
    };
  }

  /// Borra todas las frases.
  Future<void> clearCustomButtons() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_button1Key);
    await prefs.remove(_button2Key);
  }
}
