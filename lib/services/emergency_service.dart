import 'package:shared_preferences/shared_preferences.dart';

// Este servicio gestiona el almacenamiento y recuperación de los datos de emergencia.
class EmergencyService {
  // Patrón Singleton para asegurar una única instancia.
  static final EmergencyService _instance = EmergencyService._internal();

  factory EmergencyService() {
    return _instance;
  }

  EmergencyService._internal();

  // Nombres de las claves para SharedPreferences
  static const String _patientNameKey = 'patientName';
  static const String _emergencyPhoneKey = 'emergencyPhone';
  
  /// Guarda el nombre del paciente y el número de emergencia en el almacenamiento local.
  Future<void> saveEmergencyContact({
    required String patientName,
    required String emergencyPhone,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_patientNameKey, patientName);
    await prefs.setString(_emergencyPhoneKey, emergencyPhone);
  }

  /// Recupera el nombre del paciente y el número de emergencia del almacenamiento local.
  ///
  /// Retorna un mapa con el nombre y el número, o un mapa vacío si no se encuentran datos.
  Future<Map<String, String?>> getEmergencyContact() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? patientName = prefs.getString(_patientNameKey);
    final String? emergencyPhone = prefs.getString(_emergencyPhoneKey);

    return {
      'patientName': patientName,
      'emergencyPhone': emergencyPhone,
    };
  }

  /// Borra todos los datos de emergencia.
  Future<void> clearEmergencyContact() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_patientNameKey);
    await prefs.remove(_emergencyPhoneKey);
  }
}
