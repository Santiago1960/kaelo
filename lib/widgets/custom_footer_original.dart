import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaelo/services/tts_service.dart';
import 'package:localization/localization.dart';
import 'package:animate_do/animate_do.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {

    final TtsService ttsService = TtsService();
    final screenWidth = MediaQuery.of(context).size.width;

    // Variables de localization
    String yes = 'Yes'.i18n();
    String confused = 'confused'.i18n();
    String no = 'No'.i18n();

    // Determinamos el lenguaje actual
    final lang = Localizations.localeOf(context).languageCode;

    // Definimos los botones
    Widget yesButton = ButtonStatic(screenWidth: screenWidth, 
                                    ttsService: ttsService, 
                                    speak: yes, 
                                    lang: lang, 
                                    color: Color.fromARGB(255, 231, 248, 233), 
                                    borderColor: Color.fromARGB(255, 76, 175, 80), 
                                    imageChild: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.thumb_up_sharp, color: Colors.green,),
                                        Text(yes, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                        Icon(Icons.check_circle, color: const Color.fromARGB(255, 76, 175, 80),)
                                      ],
                                    )
    );

    Widget confusedButton = ButtonStatic( screenWidth: screenWidth, 
                                          ttsService: ttsService, 
                                          speak: confused, 
                                          lang: lang,
                                          color: Color.fromARGB(255, 230, 229, 229),
                                          borderColor: Color.fromARGB(255, 0, 0, 0),
                                          imageChild: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: SvgPicture.asset(
                                              'assets/icon/confused.svg',
                                              width: 60,
                                            ),
                                          ),
    );

    Widget noButton = ButtonStatic( screenWidth: screenWidth, 
                                    ttsService: ttsService, 
                                    speak: no, 
                                    lang: lang, 
                                    color: Color.fromARGB(255, 251, 234, 234), 
                                    borderColor: Color.fromARGB(255, 244, 67, 54), 
                                    imageChild: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.thumb_down_sharp, color: Colors.red,),
                                        Text(no, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                        Icon(Icons.cancel_rounded, color: Colors.red,)
                                      ],
                                    )
    );

    return Container(
      color: Colors.white,
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          yesButton,

          confusedButton,

          noButton,
        ],
      )
    );
  }
}

class ButtonStatic extends StatelessWidget {
  const ButtonStatic({
    super.key,
    required this.screenWidth,
    required this.ttsService,
    required this.speak,
    required this.lang,
    required this.color,
    required this.borderColor,
    required this.imageChild,
  });

  final double screenWidth;
  final TtsService ttsService;
  final String speak;
  final String lang;
  final Color color;
  final Color borderColor;
  final Widget imageChild;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          border: Border.all(
            color: borderColor,
            width: 3.0,
          ),
        ),
        height: screenWidth * 0.25,
        width: screenWidth * 0.25,
        child: imageChild
      ),
      onTap: () => ttsService.speak(speak, lang),
    );
  }
}