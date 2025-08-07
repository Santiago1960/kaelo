import 'package:url_launcher/url_launcher.dart';

// Este servicio gestiona toda la lógica de envío de mensajes de WhatsApp.
class WhatsAppService {
  // Patrón Singleton para asegurar una única instancia.
  static final WhatsAppService _instance = WhatsAppService._internal();

  factory WhatsAppService() {
    return _instance;
  }

  WhatsAppService._internal();

  /// Envia un mensaje de WhatsApp a un número específico.
  ///
  /// [phoneNumber]: El número de teléfono (sin código de país).
  /// [message]: El texto del mensaje a enviar.
  Future<void> sendMessage(String phoneNumber, String message) async {
    // Codificamos el mensaje para que sea válido en la URL.
    final encodedMessage = Uri.encodeComponent(message);
    
    // Número de teléfono con código de país (sin símbolos).
    // Aquí se asume un código de país, puedes cambiarlo según tus necesidades.
    final phoneNumberWithCode = '+593' + phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Construimos la URL de WhatsApp.
    final uri = Uri.parse('whatsapp://send?phone=$phoneNumberWithCode&text=$encodedMessage');

    // Verificamos si WhatsApp est\u00e1 instalado y lanzamos la URL.
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Manejamos el caso en que WhatsApp no est\u00e9 instalado.
      print('WhatsApp no está instalado en el dispositivo.');
      // Puedes a\u00f1adir l\u00f3gica para mostrar un di\u00e1logo de error,
      // un SnackBar o un di\u00e1logo para el usuario.
    }
  }
}

// Ejemplo de uso del servicio:
// Para invocar este servicio desde tu Home, puedes hacerlo de la siguiente manera:
//
// final whatsAppService = WhatsAppService();
// whatsAppService.sendMessage('0987654321', 'Necesito ayuda. \u00a1Es una emergencia!');
