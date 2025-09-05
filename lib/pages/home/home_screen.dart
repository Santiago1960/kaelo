import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:go_router/go_router.dart' as go_router;
import 'package:localization/localization.dart';

import 'package:kaelo/providers/tts_notifier_provider.dart';
import 'package:kaelo/services/emergency_service.dart';
import 'package:kaelo/services/whatsapp_launcher.dart';
import 'package:kaelo/widgets/custom_footer.dart';

final emergencyServiceProvider = Provider((ref) => EmergencyService());

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    // Escuchamos el estado 'isSpeaking' del ttsNotifier
    final bool isSpeaking = ref.watch(ttsNotifierProvider);
    
    // Accedemos al Notifier para llamar a sus métodos
    final TtsNotifier ttsNotifier = ref.read(ttsNotifierProvider.notifier);

    final screenWidth = MediaQuery.of(context).size.width;

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
    final String sosTapAlert       = 'sos_tap_alert'.i18n();
    final String emergencyButton   = 'emergency_button'.i18n();
    final String registerNumber    = 'register_number'.i18n();
    final String needsHelp         = 'needs_help'.i18n();
    final String infoMissing       = 'info_missing'.i18n();
    final String mustConfig        = 'you_must_config'.i18n();
    final String setUp             = 'set_up'.i18n();
    
    final router = GoRouter.of(context);

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
                      width: screenWidth * 0.40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone_forwarded, size: 40, color: Colors.white,),
                          const SizedBox(width: 20),
                          const Text('SOS', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                        ]
                      )
                    ),
                    onLongPress: () async {

                      // Verificamos is existe un usuario registrado en la memoria local
                      final emergencyService = ref.read(emergencyServiceProvider);
                      final contact = await emergencyService.getEmergencyContact();

                      if(mounted) {

                        final String patientName = contact['patientName'] ?? '';
                        final String countryCode = contact['countryCode'] ?? '';
                        final String emergencyPhone = contact['emergencyPhone'] ?? '';
                        
                        if(patientName.isNotEmpty && countryCode.isNotEmpty && emergencyPhone.isNotEmpty) {

                          WhatsAppService().sendMessage(emergencyPhone, '$patientName $needsHelp');
                        } else {

                          if(Platform.isIOS) {

                            // Diálogo para iOS
                            showCupertinoDialog(
                              // ignore: use_build_context_synchronously
                              context: context, 
                              builder: (BuildContext context) => CupertinoAlertDialog(
                                title: Text(infoMissing.toUpperCase(),),
                                content: Text(
                                  mustConfig,
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [

                                      CupertinoDialogAction(
                                        child: Text(setUp, style: TextStyle(color: Colors.red),),
                                        onPressed: () {
                                          router.push('/configuration');
                                          context.pop();
                                        }
                                      ),

                                      CupertinoDialogAction(
                                        child: Text('OK', style: TextStyle(color: Colors.blue),),
                                        onPressed: () {
                                          context.pop();
                                        }
                                      ),
                                    ],
                                  ),
                                ]
                              )
                            );
                          } else {

                            // Diálogo para Android
                            showDialog(
                              barrierDismissible: false,
                              // ignore: use_build_context_synchronously
                              context: context, 
                              builder: (BuildContext context) {

                                return AlertDialog(
                                  title: Text(infoMissing.toUpperCase(),),
                                  content: Text(mustConfig),
                                  actions: <Widget>[

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [

                                        TextButton(
                                          child: Text(setUp, style: TextStyle(color: Colors.red),),
                                          onPressed: () {
                                            router.push('/configuration');
                                            Navigator.of(context).pop();
                                          }
                                        ),

                                        TextButton(
                                          child: Text('OK', style: TextStyle(color: Colors.blue),),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }
                                        ),
                                      ]
                                    )
                                  ]
                                );
                              }
                            );
                          }
                        }
                      }
                    },
                    onTap: () {

                      if(Platform.isIOS) {

                        // Diálogo para iOS
                        showCupertinoDialog(
                          context: context, 
                          builder: (BuildContext context) => CupertinoAlertDialog(
                            title: Text(emergencyButton.toUpperCase(),),
                            content: Text(
                              sosTapAlert,
                              textAlign: TextAlign.center,
                            ),
                            actions: <Widget>[

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [

                                  CupertinoDialogAction(
                                    child: Text(registerNumber, style: TextStyle(color: Colors.red),),
                                    onPressed: () {
                                      router.push('/configuration');
                                      context.pop();
                                    }
                                  ),

                                  CupertinoDialogAction(
                                    child: Text('OK', style: TextStyle(color: Colors.blue),),
                                    onPressed: () {
                                      context.pop();
                                    }
                                  ),
                                ],
                              ),
                            ]
                          )
                        );
                      } else {

                        // Diálogo para Android
                        showDialog(
                          barrierDismissible: false,
                          context: context, 
                          builder: (BuildContext context) {

                            return AlertDialog(
                              title: Text(emergencyButton.toUpperCase(),),
                              content: Text(sosTapAlert,),
                              actions: <Widget>[

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [

                                    TextButton(
                                      child: Text(registerNumber, style: TextStyle(color: Colors.red),),
                                      onPressed: () {
                                        router.push('/configuration');
                                        Navigator.of(context).pop();
                                      }
                                    ),

                                    TextButton(
                                      child: Text('OK', style: TextStyle(color: Colors.blue),),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }
                                    ),
                                  ]
                                )
                              ]
                            );
                          }
                        );
                      }
                    }
                  ),

                  PhraseButton(
                    optionButton: 1, 
                    optionButtonColor: Colors.blue.shade700, 
                    optionButtonIcon: Icon(Icons.star, size: 30.0,),
                    router: router,
                  ),

                  PhraseButton(
                    optionButton: 2, 
                    optionButtonColor: Colors.green.shade800,
                    optionButtonIcon: Row(
                      children: [
                        Icon(Icons.star, size: 30.0,),
                        Icon(Icons.star, size: 30.0,),
                      ],
                    ),
                    router: router,
                  )
                ],
              ),
          
              SizedBox(height: 40,),
          
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
                      ttsNotifier.speak(imHungry, lang);
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
                      ttsNotifier.speak(imThirsty, lang);
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
                      ttsNotifier.speak(imNeedTheBathroom, lang);
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
                      ttsNotifier.speak(imHot, lang);
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
                      ttsNotifier.speak(imCold, lang);
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
                      ttsNotifier.speak(imSleepy, lang);
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
                      ttsNotifier.speak(itItchesMe, lang);
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
                      ttsNotifier.speak(iDontFeelWeel, lang);
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
                      ttsNotifier.speak(itHurtsMe, lang);
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
                      ttsNotifier.speak(imHappy, lang);
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
                      ttsNotifier.speak(iFeelSad, lang);
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
                      ttsNotifier.speak(iLoveYouVeryMuch, lang);
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

class PhraseButton extends StatelessWidget {
  PhraseButton({
    super.key,
    required this.optionButton,
    required this.optionButtonColor,
    required this.optionButtonIcon,
    required this.router,
  });

  final int optionButton;
  final Color optionButtonColor;
  final Widget optionButtonIcon;
  final String customizableButton = 'customizable_button'.i18n();
  final String customizableText   = 'customizable_text'.i18n();
  final String customize          = 'customize'.i18n();
  final String phrase             = 'phrase'.i18n();

  final go_router.GoRouter router;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(optionButtonColor),
      ),
      onPressed: () {
        if(Platform.isIOS) {

            // Diálogo para iOS
            showCupertinoDialog(
              context: context, 
              builder: (BuildContext context) => CupertinoAlertDialog(
                title: Row(
                  children: [
                    Text(
                      '${customizableButton.toUpperCase()} $optionButton',
                      style: TextStyle(color: optionButtonColor),
                    ),
                  ],
                ),
                content: Text(
                  customizableText,
                  textAlign: TextAlign.center,
                ),
                actions: <Widget>[

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      CupertinoDialogAction(
                        child: Text(customize, style: TextStyle(color: Colors.red),),
                        onPressed: () {
                          router.push('/configuration');
                          context.pop();
                        }
                      ),

                      CupertinoDialogAction(
                        child: Text('OK', style: TextStyle(color: optionButtonColor),),
                        onPressed: () {
                          context.pop();
                        }
                      ),
                    ],
                  ),
                ]
              )
            );
          } else {

            // Diálogo para Android
            showDialog(
              barrierDismissible: false,
              context: context, 
              builder: (BuildContext context) {

                return AlertDialog(
                  title: Text(customizableButton.toUpperCase(),),
                  content: Text(customizableText,),
                  actions: <Widget>[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        TextButton(
                          child: Text(customize, style: TextStyle(color: Colors.red),),
                          onPressed: () {
                            router.push('/configuration');
                            Navigator.of(context).pop();
                          }
                        ),

                        TextButton(
                          child: Text('OK', style: TextStyle(color: Colors.blue),),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }
                        ),
                      ]
                    )
                  ]
                );
              }
            );
          }
      }, 
      child: Column(
        children: [
          optionButtonIcon,
          Text('$phrase $optionButton', style: TextStyle(fontSize: 15.0),),
        ],
      )
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