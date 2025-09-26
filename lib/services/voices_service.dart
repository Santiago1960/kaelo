import 'package:shared_preferences/shared_preferences.dart';

// Este servicio gestiona el almacenamiento y recuperación de la voz configurada.
class CustomVoiceService {
  // Patrón Singleton para asegurar una única instancia.
  static final CustomVoiceService _instance = CustomVoiceService._internal();

  factory CustomVoiceService() {
    return _instance;
  }

  CustomVoiceService._internal();

  // Nombres de las claves para SharedPreferences
  static const String _genderKey = 'gender';
  
  /// Guarda el género seleccionado.
  Future<void> saveCustomVoice({
    String? gender,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(gender != null) {
      await prefs.setString(_genderKey, gender);
    }
  }

  /// Recupera el género seleccionado.
  /// Retorna un mapa con el género, o un mapa vacío si no se encuentran datos.
  Future<Map<String, String?>> getCustomVoice() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? gender = prefs.getString(_genderKey);

    return {
      'gender': gender,
    };
  }

  // Borra una frase
  Future<void> clearCustomVoice(optionButton) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(_genderKey);
  }
}
