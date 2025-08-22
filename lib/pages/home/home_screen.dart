import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaelo/config/config.dart';
import 'package:kaelo/providers/tts_notifier_provider.dart';
import 'package:kaelo/services/whatsapp_launcher.dart';
import 'package:kaelo/widgets/custom_footer.dart';
import 'package:localization/localization.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {

    // Escuchamos el estado 'isSpeaking' del ttsNotifier
    final bool isSpeaking = ref.watch(ttsNotifierProvider);
    
    // Accedemos al Notifier para llamar a sus métodos
    final TtsNotifier ttsNotifier = ref.read(ttsNotifierProvider.notifier);

    final screenWidth = MediaQuery.of(context).size.width;

    // Variables de localization
    final String imHungry          = 'im_hungry'.i18n();
    final String imThirsty         = 'im_thirsty'.i18n();
    final String imNeedTheBathroom = 'im_need_the_bathroom'.i18n();
    final String imHot             = 'im_hot'.i18n();
    final String imCold            = 'im_cold'.i18n();
    final String imSleepy          = 'im_sleepy'.i18n();
    final String itItchesMe        = 'it_itches_me'.i18n();
    final String iDontFeelWeel     = 'i_dont_feel_well'.i18n();
    final String itHurtsMe         = 'it_hurts_me'.i18n();
    final String imHappy           = 'im_happy'.i18n();
    final String iFeelSad          = 'i_feel_sad'.i18n();
    final String iLoveYouVeryMuch  = 'i_love_you_very_much'.i18n();

    // Determinamos el lenguaje actual
    String lang = Localizations.localeOf(context).languageCode;
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icon/icon.png', width: 40,),
                const SizedBox(width: 10),
                const Text('Kaelo'),
              ],
            ),
          ),
          centerTitle: true,
          actions: [

            Padding(
              padding: const EdgeInsets.only(right: 10, top: 20.0),
              child: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  router.push('/configuration');
                }, 
              ),
            ),
          ],
        ),

        body: SingleChildScrollView(
          
          child: Column(
            
            children: [
          
              SizedBox(height: 40,),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                        border: Border.all(
                          color: Colors.red,
                          width: 3.0,
                        ),
                      ),
                      height: 80,
                      width: screenWidth * 0.50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone_forwarded, size: 40, color: Colors.white,),
                          const SizedBox(width: 20),
                          const Text('SOS', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                        ]
                      )
                    ),
                    onLongPress: () {
                      WhatsAppService().sendMessage('0983686609', 'Necesito ayuda. \u00a1Es una emergencia!');
                    }
                  ),
                ],
              ),
          
              SizedBox(height: 60,),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
          
                  NeedButton(
                    screenWidth: screenWidth, 
                    speak: imHungry, 
                    lang: lang, 
                    color: Colors.white, 
                    borderColor: Colors.blue, 
                    imageChild: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset('assets/icon/hungry.png',),
                    ), 
                    isSpeaking: isSpeaking,
                    onTap: () {
                      ttsNotifier.speak(imHungry, 'es');
                    },
                  ),
          
                  NeedButton(
                    screenWidth: screenWidth, 
                    speak: imThirsty, 
                    lang: lang, 
                    color: Colors.white, 
                    borderColor: Colors.blue, 
                    imageChild: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset('assets/icon/thirsty.png',),
                    ), 
                    isSpeaking: isSpeaking,
                    onTap: () {
                      ttsNotifier.speak(imThirsty, 'es');
                    },
                  ),
          
                  NeedButton(
                    screenWidth: screenWidth, 
                    speak: imNeedTheBathroom, 
                    lang: lang, 
                    color: Colors.white, 
                    borderColor: Colors.blue, 
                    imageChild: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset('assets/icon/lavatory.png',),
                    ), 
                    isSpeaking: isSpeaking,
                    onTap: () {
                      ttsNotifier.speak(imNeedTheBathroom, 'es');
                    },
                  ),
                ],
              ),
          
              SizedBox(height: 20.0,),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
          
                  NeedButton(
                    screenWidth: screenWidth, 
                    speak: imHot, 
                    lang: lang, 
                    color: Colors.white, 
                    borderColor: Colors.orange, 
                    imageChild: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset('assets/icon/heat.png',),
                    ), 
                    isSpeaking: isSpeaking,
                    onTap: () {
                      ttsNotifier.speak(imHot, 'es');
                    },
                  ),
          
                  NeedButton(
                    screenWidth: screenWidth, 
                    speak: imCold, 
                    lang: lang, 
                    color: Colors.white, 
                    borderColor: Colors.orange, 
                    imageChild: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset('assets/icon/cold.png',),
                    ), 
                    isSpeaking: isSpeaking,
                    onTap: () {
                      ttsNotifier.speak(imCold, 'es');
                    },
                  ),

                  NeedButton(
                    screenWidth: screenWidth, 
                    speak: imSleepy, 
                    lang: lang, 
                    color: Colors.white, 
                    borderColor: Colors.orange, 
                    imageChild: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset('assets/icon/sleep.png',),
                    ), 
                    isSpeaking: isSpeaking,
                    onTap: () {
                      ttsNotifier.speak(imSleepy, 'es');
                    },
                  ),
                ],
              ),
          
              SizedBox(height: 20.0,),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  NeedButton(
                    screenWidth: screenWidth, 
                    speak: itItchesMe, 
                    lang: lang, 
                    color: Colors.white, 
                    borderColor: Colors.brown, 
                    imageChild: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset('assets/icon/itch.png',),
                    ), 
                    isSpeaking: isSpeaking,
                    onTap: () {
                      ttsNotifier.speak(itItchesMe, 'es');
                    },
                  ),

                  NeedButton(
                    screenWidth: screenWidth, 
                    speak: iDontFeelWeel, 
                    lang: lang, 
                    color: Colors.white, 
                    borderColor: Colors.brown, 
                    imageChild: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset('assets/icon/sick.png',),
                    ), 
                    isSpeaking: isSpeaking,
                    onTap: () {
                      ttsNotifier.speak(iDontFeelWeel, 'es');
                    },
                  ),
          
                  NeedButton(
                    screenWidth: screenWidth, 
                    speak: itHurtsMe, 
                    lang: lang, 
                    color: Colors.white, 
                    borderColor: Colors.brown, 
                    imageChild: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset('assets/icon/pain.png',),
                    ), 
                    isSpeaking: isSpeaking,
                    onTap: () {
                      ttsNotifier.speak(itHurtsMe, 'es');
                    },
                  ),
                ],
              ),
          
              SizedBox(height: 20.0,),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
          
                  NeedButton(
                    screenWidth: screenWidth, 
                    speak: imHappy, 
                    lang: lang, 
                    color: Colors.white, 
                    borderColor: Colors.green, 
                    imageChild: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset('assets/icon/happy.png',),
                    ), 
                    isSpeaking: isSpeaking,
                    onTap: () {
                      ttsNotifier.speak(imHappy, 'es');
                    },
                  ),
          
                  NeedButton(
                    screenWidth: screenWidth, 
                    speak: iFeelSad, 
                    lang: lang, 
                    color: Colors.white, 
                    borderColor: Colors.green, 
                    imageChild: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset('assets/icon/sad.png',),
                    ), 
                    isSpeaking: isSpeaking,
                    onTap: () {
                      ttsNotifier.speak(iFeelSad, 'es');
                    },
                  ),
          
                  NeedButton(
                    screenWidth: screenWidth, 
                    speak: iLoveYouVeryMuch, 
                    lang: lang, 
                    color: Colors.white, 
                    borderColor: Colors.green, 
                    imageChild: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset('assets/icon/love.png',),
                    ), 
                    isSpeaking: isSpeaking,
                    onTap: () {
                      ttsNotifier.speak(iLoveYouVeryMuch, 'es');
                    },
                  ),
                ],
              ),

              
            ],
          ),
        ),

        bottomNavigationBar: CustomFooter()
      ),
    );
  }
}

class NeedButton extends StatelessWidget {
  const NeedButton({
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
        height: screenWidth * 0.20,
        width: screenWidth * 0.20,
        child: imageChild
      ),
    );
  }
}