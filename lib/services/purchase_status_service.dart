import 'package:shared_preferences/shared_preferences.dart';

// Este servicio gestiona el almacenamiento y recuperación de los datos de emergencia.
class PurchaseStatusService {
  // Patrón Singleton para asegurar una única instancia.
  static final PurchaseStatusService _instance = PurchaseStatusService._internal();

  factory PurchaseStatusService() {
    return _instance;
  }

  PurchaseStatusService._internal();

  // Nombres de las claves para SharedPreferences
  static const String _isPremiumKey = 'isPremium';
  
  /// Guarda el nombre del paciente y el número de emergencia en el almacenamiento local.
  Future<void> savePurchaseStatus({
    required bool isPremium,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isPremiumKey, isPremium);
  }

  /// Recupera el nombre del paciente y el número de emergencia del almacenamiento local.
  ///
  /// Retorna un mapa con el nombre y el número, o un mapa vacío si no se encuentran datos.
  Future<Map<String, bool?>> getPurchaseStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isPremium = prefs.getBool(_isPremiumKey);

    return {
      'isPremium': isPremium,
    };
  }

  /// Borra todos los datos de emergencia.
  Future<void> clearEmergencyContact() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isPremiumKey);
  }
}
