import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart'; // debugPrint
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// 1. CREAMOS EL PROVIDER
// Este Notifier gestionará un 'bool' que nos dirá si algo se está reproduciendo.
final hybridTtsProvider = NotifierProvider<HybridTtsService, bool>(HybridTtsService.new);

// 2. CONVERTIMOS TU SERVICIO EN UN NOTIFIER
class HybridTtsService extends Notifier<bool> {
  // Las instancias de los reproductores
  late FlutterTts _flutterTts;
  late AudioPlayer _audioPlayer;
  final String _cloudFunctionUrl = 'https://proxy-texto-a-voz-njvvxwo7rq-uc.a.run.app';

  // El método 'build' se llama al inicializar el Notifier
  @override
  bool build() {
    // Inicializamos las instancias
    _flutterTts = FlutterTts();
    _audioPlayer = AudioPlayer();

    // Liberamos recursos cuando el provider ya no se use
    ref.onDispose(() {
      _audioPlayer.dispose();
      _flutterTts.stop();
    });

    return false; // El estado inicial es 'no hablando'
  }

  // MÉTODO PÚBLICO PRINCIPAL
  Future<void> speak(String text, String lang) async {
    // Trazas para depuración: iniciar speak
    debugPrint('HybridTtsService.speak() start — text: "${text.replaceAll('\n', ' ')}" lang: $lang state: $state');

    // Si ya está hablando, no hacemos nada para evitar solapamientos.
    if (state) {
      debugPrint('HybridTtsService.speak() - ya hablando, retorno anticipado');
      return;
    }

    try {
      // INICIAMOS: Ponemos el estado en 'true' para mostrar el CircularProgressIndicator
      state = true;

      // El resto de la lógica que ya teníamos...
      final fileName = _generateFileName(text, lang);
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      // 1. Revisar caché
      debugPrint('Comprobando caché en: $filePath');
      if (await file.exists()) {
        debugPrint('Reproduciendo desde caché: $filePath');
        await _audioPlayer.play(DeviceFileSource(filePath));
        await _audioPlayer.onPlayerComplete.first; // Esperar a que termine
        debugPrint('Reproducción desde caché finalizada');
        return;
      }

      // 2. Revisar conexión
      // Normalizar el resultado de checkConnectivity() ya que en algunas
      // versiones/platforms puede devolver un ConnectivityResult o una
      // List<ConnectivityResult> (web/platform differences). Manejar ambos.
      final dynamic rawConnectivity = await Connectivity().checkConnectivity();
      ConnectivityResult connectivityResult;
      if (rawConnectivity is ConnectivityResult) {
        connectivityResult = rawConnectivity;
      } else if (rawConnectivity is List && rawConnectivity.isNotEmpty && rawConnectivity.first is ConnectivityResult) {
        connectivityResult = rawConnectivity.first as ConnectivityResult;
      } else {
        // Valor desconocido: asumimos conexión para evitar fallback innecesario.
        connectivityResult = ConnectivityResult.mobile;
      }

      debugPrint('Conexion: $connectivityResult');

      if (connectivityResult == ConnectivityResult.none) {
        debugPrint('Sin internet. Usando motor nativo TTS.');
        await _flutterTts.setLanguage(_mapLangToLocale(lang));
        await _flutterTts.awaitSpeakCompletion(true);
        await _flutterTts.speak(text);
        return;
      }

      // 3. Descargar desde la API
  debugPrint('Descargando audio desde Google Cloud...');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'text': text,
        'languageCode': _mapLangToLocale(lang),
        'gender': 'MALE',
      });
      final response = await http.post(Uri.parse(_cloudFunctionUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final String audioContent = responseBody['audioContent'];
        final Uint8List audioBytes = base64Decode(audioContent);
        await file.writeAsBytes(audioBytes);
  debugPrint('Audio guardado en: $filePath');
        await _audioPlayer.play(DeviceFileSource(filePath));
        await _audioPlayer.onPlayerComplete.first; // Esperar a que termine
      } else {
        throw Exception('API call failed with status code ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Fallback a TTS nativo por error: $e');
      await _flutterTts.setLanguage(_mapLangToLocale(lang));
      await _flutterTts.awaitSpeakCompletion(true);
      await _flutterTts.speak(text);
    } finally {
      // FINALMENTE: Pase lo que pase, ponemos el estado en 'false' al terminar.
      state = false;
    }
  }

  // --- FUNCIONES AUXILIARES PRIVADAS ---
  String _generateFileName(String text, String lang) {
    final key = '$lang-$text';
    final bytes = utf8.encode(key);
    final digest = md5.convert(bytes);
    return '${digest.toString()}.mp3';
  }

  String _mapLangToLocale(String lang) {
    return switch (lang) {
      'es' => 'es-US',
      'en' => 'en-US',
      'de' => 'de-DE',
      'fr' => 'fr-FR',
      'it' => 'it-IT',
      'pt' => 'pt-BR',
      _ => 'en-US',
    };
  }
}