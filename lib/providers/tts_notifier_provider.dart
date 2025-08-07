    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:flutter_tts/flutter_tts.dart';// Necesario para TargetPlatform

    // Definimos el NotifierProvider de la manera recomendada en Riverpod 2.0+
    // Riverpod se encarga de crear la instancia y llamar al método 'build'
    final ttsNotifierProvider = NotifierProvider<TtsNotifier, bool>(TtsNotifier.new);

    // TtsNotifier: Extiende Notifier<bool> para gestionar el estado de si está hablando
    class TtsNotifier extends Notifier<bool> {
      late FlutterTts _flutterTts; // Instancia de FlutterTts

      // El método 'build' se llama la primera vez que se accede al Notifier.
      // Aquí se manejan la inicialización y los listeners.
      @override
      bool build() {
        // Usamos ref.onDispose para liberar recursos cuando el proveedor se cierre
        ref.onDispose(() {
          _flutterTts.stop();
        });
        
        // Inicializamos FlutterTts y configuramos el motor
        _flutterTts = FlutterTts();
        _configureTts();

        return false; // El estado inicial es 'no hablando'
      }
      
      // Función para inicialización del motor TTS
      Future<void> _configureTts() async {

        // Configura el motor TTS para iOS (buena práctica)
        await _flutterTts.setSharedInstance(true);
        
        // Configura la velocidad de la voz (opcional)
        await _flutterTts.setSpeechRate(0.5); 
        // Configura el tono de la voz (opcional)
        await _flutterTts.setPitch(1.0); 

        // Cuando el TTS termina de hablar, actualizamos el estado a false
        _flutterTts.setCompletionHandler(() {
          print("TTS completado");
          state = false; // Actualiza el estado del Notifier
        });

        // Cuando el TTS empieza a hablar, actualizamos el estado a true
        _flutterTts.setStartHandler(() {
          print("TTS iniciado");
          state = true; // Actualiza el estado del Notifier
        });

        // Si hay un error, también actualizamos el estado a false para que el botón se habilite
        _flutterTts.setErrorHandler((msg) {
          print("Error TTS: $msg");
          state = false; // Actualiza el estado del Notifier
        });
      }

      // Función para hacer que el teléfono hable
      Future<void> speak(String text, String languageCode) async {
        if (state) { // Si ya está hablando, lo detenemos primero
          await _flutterTts.stop();
        }
        state = true; // Actualiza el estado a true inmediatamente
        await _flutterTts.setLanguage(languageCode);
        await _flutterTts.speak(text);
        // El 'state = false' se maneja automáticamente en setCompletionHandler/setErrorHandler
      }

      // Función para detener la voz
      Future<void> stop() async {
        await _flutterTts.stop();
        state = false; // Si se detiene manualmente, no está hablando
      }
    }
