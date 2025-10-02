// 1. Define tu lista de textos fijos en un lugar accesible

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaelo/pages/home/button_config_screen.dart';
import 'package:kaelo/services/hybrid_tts_service.dart';
import 'package:kaelo/services/voices_service.dart';
import 'package:localization/localization.dart';

// Variables de localization
final String imHungry          = 'im_hungry'.i18n();
final String imThirsty         = 'im_thirsty'.i18n();
final String imNeedTheBathroom = 'i_need_the_bathroom'.i18n();
final String imHot             = 'im_hot'.i18n();
final String imCold            = 'im_cold'.i18n();
final String imSleepy          = 'im_sleepy'.i18n();
final String itItchesMe        = 'it_itches_me'.i18n();
final String iDontFeelWeel     = 'i_dont_feel_well'.i18n();
final String itHurtsMe         = 'it_hurts_me'.i18n();
final String imHappy           = 'im_happy'.i18n();
final String iFeelSad          = 'i_feel_sad'.i18n();
final String iLoveYouVeryMuch  = 'i_love_you_very_much'.i18n();
final String yes               = 'Yes'.i18n();
final String confused          = 'confused'.i18n();
final String no                = 'No'.i18n();

List<String> fixedButtonTexts = [
  imHungry,
  imThirsty,
  imNeedTheBathroom,
  imHot,
  imCold,
  imSleepy,
  itItchesMe,
  iDontFeelWeel,
  itHurtsMe,
  imHappy,
  iFeelSad,
  iLoveYouVeryMuch,
  yes,
  confused,
  no
];

// 2. Crea el Provider para el nuevo servicio
final ttsCachingServiceProvider = Provider((ref) {
  // Pasamos 'ref' para que este servicio pueda leer otros providers
  return TtsCachingService(ref);
});

// 3. Define la clase del servicio
class TtsCachingService {
  TtsCachingService(this._ref);
  final Ref _ref;

  // El método principal que orquestará todo el proceso
  Future<void> preCacheRequiredAudios({required String lang}) async {

    // A. Recolectar TODOS los textos que necesitamos
    final customButtons = await _ref.read(customButtonsServiceProvider).getCustomButtons();
    final Set<String> textsToCache = {...fixedButtonTexts}; // Usamos un Set para evitar duplicados

    // Agregamos los textos de los botones personalizados si no son nulos o vacíos
    if (customButtons['button1']?.isNotEmpty == true) {
      textsToCache.add(customButtons['button1']!);
    }
    if (customButtons['button2']?.isNotEmpty == true) {
      textsToCache.add(customButtons['button2']!);
    }

    // B. Crear una lista de tareas (Futures) para generar cada audio
    // Esto se ejecutará en PARALELO, mucho más rápido que un 'for' con 'await'
    final List<Future<void>> cachingTasks = textsToCache
        .map((text) => _generateAndSaveAudio(text: text, voice: lang))
        .toList();

    // C. Esperar a que todas las tareas de generación de audio terminen
    await Future.wait(cachingTasks);

    debugPrint('Proceso de pre-caching completado para ${textsToCache.length} audios.');
  }

  // Método privado para manejar un solo texto
  Future<void> _generateAndSaveAudio({required String text, required String voice}) async {
    try {
      final voiceData = await _ref.read(customVoiceServiceProvider).getCustomVoice();
      final gender = voiceData['gender'] ?? '';
      
      await _ref.read(hybridTtsProvider.notifier).download(text, voice, gender);
      debugPrint('Audio cacheado exitosamente para: "$text"');
    } catch (e) {
      // Si un audio falla, solo imprimimos el error pero no detenemos todo el proceso.
      debugPrint('Falló el cacheo para "$text": $e');
    }
  }
}