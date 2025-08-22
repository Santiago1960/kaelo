import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:animate_do/animate_do.dart';
import 'package:kaelo/providers/tts_notifier_provider.dart';
import 'package:localization/localization.dart';
import 'package:flutter_svg/svg.dart';

// Usamos HookWidget para poder usar hooks como useState
class CustomFooter extends HookWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    // Los hooks deben ser llamados al principio del método build.
    // Usamos useState con UniqueKey para controlar la animación de cada botón
    final yesKey = useState(UniqueKey());
    final confusedKey = useState(UniqueKey());
    final noKey = useState(UniqueKey());

    // Luego, usamos Consumer para escuchar los providers de Riverpod
    return Consumer(
      builder: (context, ref, child) {

        // Escuchamos el estado 'isSpeaking' del ttsNotifier
        final bool isSpeaking = ref.watch(ttsNotifierProvider);
        
        // Accedemos al Notifier para llamar a sus métodos
        final TtsNotifier ttsNotifier = ref.read(ttsNotifierProvider.notifier);

        final screenWidth = MediaQuery.of(context).size.width;

        // Variables de localization
        final String yes = 'Yes'.i18n();
        final String confused = 'confused'.i18n();
        final String no = 'No'.i18n();

        // Determinamos el lenguaje actual
        String lang = Localizations.localeOf(context).languageCode;

        return Container(
          color: Colors.white,
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              // Botón "Yes" con animación
              ShakeY(
                key: yesKey.value, // La key cambia para forzar la animación
                duration: const Duration(milliseconds: 700),
                child: ButtonStatic(
                  screenWidth: screenWidth, 
                  speak: yes, 
                  lang: lang,
                  color: const Color.fromARGB(255, 231, 248, 233), 
                  borderColor: const Color.fromARGB(255, 76, 175, 80), 
                  imageChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.thumb_up_sharp, color: Colors.green),
                      Text(yes, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                      const Icon(Icons.check_circle, color: Color.fromARGB(255, 76, 175, 80))
                    ],
                  ),
                  isSpeaking: isSpeaking,
                  onTap: () {
                    // Al hacer clic, cambiamos la key para reiniciar la animación
                    yesKey.value = UniqueKey();
                    // Llamamos al servicio de TTS a través del Notifier
                    ttsNotifier.speak(yes, lang);
                  },
                ),
              ),

              // Botón "Confused" con animación
              Roulette(
                key: confusedKey.value,
                duration: const Duration(milliseconds: 700),
                child: ButtonStatic(
                  screenWidth: screenWidth,
                  speak: confused, 
                  lang: lang,
                  color: const Color.fromARGB(255, 230, 229, 229),
                  borderColor: const Color.fromARGB(255, 0, 0, 0),
                  imageChild: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/icon/confused.svg',
                      width: 60,
                    ),
                  ),
                  isSpeaking: isSpeaking,
                  onTap: () {
                    confusedKey.value = UniqueKey();
                    ttsNotifier.speak(confused, lang);
                  },
                ),
              ),

              // Botón "No" con animación
              ShakeX(
                key: noKey.value,
                duration: const Duration(milliseconds: 700),
                child: ButtonStatic(
                  screenWidth: screenWidth, 
                  speak: no, 
                  lang: lang,
                  color: const Color.fromARGB(255, 251, 234, 234), 
                  borderColor: const Color.fromARGB(255, 244, 67, 54), 
                  imageChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.thumb_down_sharp, color: Colors.red),
                      Text(no, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                      const Icon(Icons.cancel_rounded, color: Colors.red)
                    ],
                  ),
                  isSpeaking: isSpeaking,
                  onTap: () {
                    noKey.value = UniqueKey();
                    ttsNotifier.speak(no, lang);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ButtonStatic extends StatelessWidget {
  const ButtonStatic({
    super.key,
    required this.screenWidth,
    required this.speak,
    required this.lang,
    required this.color,
    required this.borderColor,
    required this.imageChild,
    required this.isSpeaking,
    this.onTap, // El onTap es ahora un callback opcional
  });

  final double screenWidth;
  final String speak;
  final String lang;
  final Color color;
  final Color borderColor;
  final Widget imageChild;
  final bool isSpeaking; // Recibimos el estado del TTS
  final VoidCallback? onTap; // Recibimos el onTap desde el padre

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSpeaking ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSpeaking ? Colors.grey[200] : color,
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          border: Border.all(
            color: isSpeaking ? Colors.grey[400]! : borderColor,
            width: 3.0,
          ),
        ),
        height: screenWidth * 0.25,
        width: screenWidth * 0.25,
        child: imageChild
      ),
    );
  }
}
