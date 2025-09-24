import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

Future<Map<String, List<Map<String, dynamic>>>> getAvailableVoices() async {
  Map<String, List<Map<String, dynamic>>> categorizedVoices = {
    'male': [],
    'female': [],
  };

  var voices = await flutterTts.getVoices;

  for (var voice in voices) {
    // Convertimos explícitamente el mapa genérico al tipo que necesitamos
    final voiceMap = Map<String, dynamic>.from(voice);

    /* if (voiceMap['gender'] == 'male') {
      categorizedVoices['male']!.add(voiceMap);
    } else if (voiceMap['gender'] == 'female') {
      categorizedVoices['female']!.add(voiceMap);
    } */
   categorizedVoices['male']!.add(voiceMap);
  }
  return categorizedVoices;
}