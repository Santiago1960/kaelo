import 'package:url_launcher/url_launcher.dart';

// Este servicio gestiona toda la lógica de envío de mensajes de WhatsApp.
class WhatsAppService {
  // Patrón Singleton para asegurar una única instancia.
  static final WhatsAppService _instance = WhatsAppService._internal();

  factory WhatsAppService() {
    return _instance;
  }

  WhatsAppService._internal();

  /// Resultado del intento de enviar un mensaje por WhatsApp.
  /// - launched: se abrió la app correctamente.
  /// - notInstalled: WhatsApp no está instalado o no se pudo abrir.
  /// - error: ocurrió un error al intentar abrir la URL.
  ///
  /// Usar este enum permite que la UI decida mostrar diálogos usando su
  /// propio `BuildContext` (evita usar context dentro de servicios).
  Future<WhatsAppSendResult> _sendMessageInternal(String phoneNumber, String message) async {
    // Codificamos el mensaje para que sea válido en la URL.
    final encodedMessage = Uri.encodeComponent(message);

    // Número de teléfono con código de país (sin símbolos). Ajusta el prefijo
    // si necesitas otro país.
    final phoneNumberWithCode = '+593${phoneNumber.replaceAll(RegExp(r'\D'), '')}';

    // Construimos la URL de WhatsApp.
    final uri = Uri.parse('whatsapp://send?phone=$phoneNumberWithCode&text=$encodedMessage');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return WhatsAppSendResult.launched;
      }

      return WhatsAppSendResult.notInstalled;
    } catch (e) {
      return WhatsAppSendResult.error;
    }
  }

  /// Envía un mensaje de WhatsApp a un número específico.
  ///
  /// [phoneNumber]: El número de teléfono (sin código de país).
  /// [message]: El texto del mensaje a enviar.
  /// [context]: Opcional. Si se proporciona, se mostrará un diálogo si WhatsApp
  ///            no está instalado o ocurre un error al abrir la URL.
  Future<WhatsAppSendResult> sendMessage(String phoneNumber, String message) async {
    return _sendMessageInternal(phoneNumber, message);
  }
}

/// Resultado del intento de envío por WhatsApp.
enum WhatsAppSendResult { launched, notInstalled, error }

// Ejemplo de uso del servicio:
// final whatsAppService = WhatsAppService();
// whatsAppService.sendMessage('0987654321', 'Necesito ayuda. ¡Es una emergencia!', context: context);
