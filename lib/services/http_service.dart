import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Función para llamar a tu Cloud Function y obtener el audio
Future<String?> getAudioFromText({
  required String text,
  String language = 'es-ES', // Valor por defecto
  String gender = 'FEMALE', // Valor por defecto
}) async {
  // La URL de tu Cloud Function
  final url = Uri.parse('https://proxy-texto-a-voz-njvvxwo7rq-uc.a.run.app');

  // El encabezado (header) es crucial
  final headers = {
    'Content-Type': 'application/json',
  };

  // El cuerpo (body) de la petición
  final body = jsonEncode({
    'text': text,
    'languageCode': language,
    'gender': gender,
  });

  try {
    // Hacemos la petición POST
    final response = await http.post(url, headers: headers, body: body);

    // Verificamos si la petición fue exitosa (código 200)
    if (response.statusCode == 200) {
      // Decodificamos la respuesta JSON
      final responseBody = jsonDecode(response.body);
      // Devolvemos el contenido del audio en Base64
      return responseBody['audioContent'];
    } else {
  // Si algo salió mal, registramos el error en modo debug
  debugPrint('Error en la petición: ${response.statusCode}');
  debugPrint('Respuesta: ${response.body}');
      return null;
    }
    } catch (e) {
      // Capturamos cualquier error de red
      debugPrint('Error al realizar la petición: $e');
      return null;
    }
}