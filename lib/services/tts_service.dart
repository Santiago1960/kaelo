import 'package:flutter_tts/flutter_tts.dart';

// Este servicio gestionará la instancia de FlutterTts
class TtsService {
  // Patrón Singleton para asegurar una única instancia
  static final TtsService _instance = TtsService._internal();

  factory TtsService() {
    return _instance;
  }

  TtsService._internal() {
    _initTts(); // Inicializa el motor TTS al crear la instancia
  }

  late FlutterTts _flutterTts; // Instancia privada de FlutterTts

  // Getter para acceder a la instancia de FlutterTts si es necesario
  FlutterTts get flutterTts => _flutterTts;

  // Función de inicialización del motor TTS
  Future<void> _initTts() async {
    _flutterTts = FlutterTts(); // Inicializa el motor TTS

    // Configura el motor TTS para iOS (buena práctica)
    // No necesitamos Theme.of(context) aquí, ya que el servicio es independiente del contexto de un widget
    // Puedes ajustar esto si necesitas lógica específica de plataforma que dependa del contexto.
    // Para setSharedInstance, generalmente se puede llamar sin contexto.
    await _flutterTts.setSharedInstance(true);
    
    // Configura la velocidad de la voz (opcional)
    await _flutterTts.setSpeechRate(0.5); // 0.5 es una velocidad normal
    // Configura el tono de la voz (opcional)
    await _flutterTts.setPitch(1.0); // 1.0 es el tono normal

    // Listeners (puedes añadir callbacks o Streams si necesitas notificar a los widgets)
    _flutterTts.setCompletionHandler(() {

    });

    _flutterTts.setStartHandler(() {

    });

    _flutterTts.setErrorHandler((msg) {

    });
  }

  // Función para hacer que el teléfono hable
  Future<void> speak(String text, String languageCode) async {
    await _flutterTts.stop(); // Detiene cualquier voz actual
    await _flutterTts.setLanguage(languageCode); // Establece el idioma
    await _flutterTts.speak(text); // Habla el texto
  }

  // Función para detener la voz
  Future<void> stop() async {
    await _flutterTts.stop();
  }

  // Función para liberar recursos (importante al cerrar la app)
  void dispose() {
    _flutterTts.stop(); // Detiene el TTS
    // No hay un método 'dispose' directo en FlutterTts para liberar todo,
    // pero 'stop()' es suficiente para detener la reproducción.
  }
}
