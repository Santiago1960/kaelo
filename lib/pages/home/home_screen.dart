import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:go_router/go_router.dart' as go_router;
import 'package:kaelo/pages/home/button_config_screen.dart';
import 'package:localization/localization.dart';

import 'package:kaelo/services/hybrid_tts_service.dart';
import 'package:kaelo/services/emergency_service.dart';
import 'package:kaelo/services/whatsapp_launcher.dart';
import 'package:kaelo/widgets/custom_footer.dart';

final emergencyServiceProvider = Provider((ref) => EmergencyService());

enum OptionItem {optionOne, optionTwo, optionThree}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int? activeSpeakingButtonId;

  @override
  void initState() {
    super.initState();
    activeSpeakingButtonId = null;
  }
  @override
  Widget build(BuildContext context) {

  // Escuchamos el estado 'isSpeaking' del hybridTtsProvider
  final bool globalIsSpeaking = ref.watch(hybridTtsProvider);
  final HybridTtsService hybridTts = ref.read(hybridTtsProvider.notifier);

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
    final String emergencyPhone    = 'emergency_phone'.i18n();
    final String configuration     = 'configuration'.i18n();
    final String phrase             = 'phrase'.i18n();
    
    final router = GoRouter.of(context);

    // Determinamos el lenguaje actual
    String lang = Localizations.localeOf(context).languageCode;

    OptionItem? selectedItem;
    
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
              child: PopupMenuButton<OptionItem>(
                initialValue: selectedItem,
                onSelected: (OptionItem item) {
                  setState(() {
                    selectedItem = item;
                  });
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<OptionItem>(
                    onTap: () {},
                    enabled: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(configuration.toUpperCase()),
                        Divider(),
                      ],
                    ),
                  ),
                  PopupMenuItem<OptionItem>(
                    onTap: () {
                      router.push('/configuration');
                    },
                    value: OptionItem.optionOne,
                    child: Row(
                      children: [
                        Icon(Icons.phone, color: Colors.red,),
                        SizedBox(width: 8),
                        Text(emergencyPhone),
                      ],
                    ),
                  ),
                  PopupMenuItem<OptionItem>(
                    onTap: () {
                      router.push('/button_config/1');
                    },
                    value: OptionItem.optionTwo,
                    child: Row(
                      children: [
                        Icon(Icons.edit_note, size: 30.0, color: Colors.blue.shade700,),
                        SizedBox(width: 8),
                        Text('$phrase 1'),
                      ],
                    ),
                  ),
                  PopupMenuItem<OptionItem>(
                    onTap: () {
                      router.push('/button_config/2');
                    },
                    value: OptionItem.optionThree,
                    child: Row(
                      children: [
                        Icon(Icons.edit_calendar, size: 30.0, color: Colors.green.shade800,),
                        SizedBox(width: 8),
                        Text('$phrase 2'),
                      ],
                    ),
                  ),
                  PopupMenuItem<OptionItem>(
                    onTap: () {
                      router.push('/voices_config');
                    },
                    value: OptionItem.optionThree,
                    child: Row(
                      children: [
                        Icon(Icons.record_voice_over, size: 30.0, color: Colors.black54,),
                        SizedBox(width: 8),
                        Text('Voces'),
                      ],
                    ),
                  ),
                ],
                child: Icon(Icons.settings),
              )
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

                      // Verificamos si existe un usuario registrado en la memoria local
                      final emergencyService = ref.read(emergencyServiceProvider);
                      final contact = await emergencyService.getEmergencyContact();

                      // Evitar usar `context` si el widget fue desmontado mientras esperábamos.
                      if (!mounted) return;

                        final String patientName = contact['patientName'] ?? '';
                        final String countryCode = contact['countryCode'] ?? '';
                        final String emergencyPhone = contact['emergencyPhone'] ?? '';
                        
                        if(patientName.isNotEmpty && countryCode.isNotEmpty && emergencyPhone.isNotEmpty) {

                          // Usamos el servicio refactorizado que devuelve un resultado
                          final result = await WhatsAppService().sendMessage(emergencyPhone, '$patientName $needsHelp');

                          if (!mounted) return;

                          if (result == WhatsAppSendResult.notInstalled) {
                            // Mostrar diálogo indicando que WhatsApp no está instalado
                            final title = 'whatsapp_not_installed'.i18n();
                            final msg = 'install_whatsapp'.i18n();

                            if (Platform.isIOS) {

                              if (!context.mounted) return;

                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) => CupertinoAlertDialog(
                                  title: Text(title),
                                  content: Text(msg),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else {

                              if (!context.mounted) return;

                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text(title),
                                  content: Text(msg),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else if (result == WhatsAppSendResult.error) {
                            // Mostrar diálogo de error genérico
                            if (Platform.isIOS) {
                              if (!context.mounted) return;
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) => CupertinoAlertDialog(
                                  title: Text('Error'),
                                  content: Text('No se pudo abrir WhatsApp. Intenta nuevamente.'),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              if (!context.mounted) return;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text('No se pudo abrir WhatsApp. Intenta nuevamente.'),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          }

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
                    optionButtonIcon: Icon(Icons.edit_note, size: 30.0,),
                    router: router,
                    lang: lang,
                  ),

                  PhraseButton(
                    optionButton: 2, 
                    optionButtonColor: Colors.green.shade800,
                    optionButtonIcon: Icon(Icons.edit_calendar, size: 30.0,),
                    router: router,
                    lang: lang,
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
                    isSpeaking: globalIsSpeaking && activeSpeakingButtonId == 6,
                    onTap: () async {
                      setState(() { activeSpeakingButtonId = 6; });
                      try {
                        await hybridTts.speak(imHungry, lang);
                      } finally {
                        if (mounted) {
                          setState(() { activeSpeakingButtonId = null; });
                        }
                      }
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
                    isSpeaking: globalIsSpeaking && activeSpeakingButtonId == 7,
                    onTap: () async {
                      setState(() { activeSpeakingButtonId = 7; });
                      try {
                        await hybridTts.speak(imThirsty, lang);
                      } finally {
                        if (mounted) {
                          setState(() { activeSpeakingButtonId = null; });
                        }
                      }
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
                    isSpeaking: globalIsSpeaking && activeSpeakingButtonId == 8,
                    onTap: () async {
                      setState(() { activeSpeakingButtonId = 8; });
                      try {
                        await hybridTts.speak(imNeedTheBathroom, lang);
                      } finally {
                        if (mounted) {
                          setState(() { activeSpeakingButtonId = null; });
                        }
                      }
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
                    isSpeaking: globalIsSpeaking && activeSpeakingButtonId == 9,
                    onTap: () async {
                      setState(() { activeSpeakingButtonId = 9; });
                      try {
                        await hybridTts.speak(imHot, lang);
                      } finally {
                        if (mounted) {
                          setState(() { activeSpeakingButtonId = null; });
                        }
                      }
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
                    isSpeaking: globalIsSpeaking && activeSpeakingButtonId == 10,
                    onTap: () async {
                      setState(() { activeSpeakingButtonId = 10; });
                      try {
                        await hybridTts.speak(imCold, lang);
                      } finally {
                        if (mounted) {
                          setState(() { activeSpeakingButtonId = null; });
                        }
                      }
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
                    isSpeaking: globalIsSpeaking && activeSpeakingButtonId == 11,
                    onTap: () async {
                      setState(() { activeSpeakingButtonId = 11; });
                      try {
                        await hybridTts.speak(imSleepy, lang);
                      } finally {
                        if (mounted) {
                          setState(() { activeSpeakingButtonId = null; });
                        }
                      }
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
                    isSpeaking: globalIsSpeaking && activeSpeakingButtonId == 12,
                    onTap: () async {
                      setState(() { activeSpeakingButtonId = 12; });
                      try {
                        await hybridTts.speak(itItchesMe, lang);
                      } finally {
                        if (mounted) {
                          setState(() { activeSpeakingButtonId = null; });
                        }
                      }
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
                    isSpeaking: globalIsSpeaking && activeSpeakingButtonId == 13,
                    onTap: () async {
                      setState(() { activeSpeakingButtonId = 13; });
                      try {
                        await hybridTts.speak(iDontFeelWeel, lang);
                      } finally {
                        if (mounted) {
                          setState(() { activeSpeakingButtonId = null; });
                        }
                      }
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
                    isSpeaking: globalIsSpeaking && activeSpeakingButtonId == 14,
                    onTap: () async {
                      setState(() { activeSpeakingButtonId = 14; });
                      try {
                        await hybridTts.speak(itHurtsMe, lang);
                      } finally {
                        if (mounted) {
                          setState(() { activeSpeakingButtonId = null; });
                        }
                      }
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
                    isSpeaking: globalIsSpeaking && activeSpeakingButtonId == 15,
                    onTap: () async {
                      setState(() { activeSpeakingButtonId = 15; });
                      try {
                        await hybridTts.speak(imHappy, lang);
                      } finally {
                        if (mounted) {
                          setState(() { activeSpeakingButtonId = null; });
                        }
                      }
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
                    isSpeaking: globalIsSpeaking && activeSpeakingButtonId == 16,
                    onTap: () async {
                      setState(() { activeSpeakingButtonId = 16; });
                      try {
                        await hybridTts.speak(iFeelSad, lang);
                      } finally {
                        if (mounted) {
                          setState(() { activeSpeakingButtonId = null; });
                        }
                      }
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
                    isSpeaking: globalIsSpeaking && activeSpeakingButtonId == 17,
                    onTap: () async {
                      setState(() { activeSpeakingButtonId = 17; });
                      try {
                        await hybridTts.speak(iLoveYouVeryMuch, lang);
                      } finally {
                        if (mounted) {
                          setState(() { activeSpeakingButtonId = null; });
                        }
                      }
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

class PhraseButton extends ConsumerWidget {
  PhraseButton({
    super.key,
    required this.optionButton,
    required this.optionButtonColor,
    required this.optionButtonIcon,
    required this.router,
    required this.lang,
  });

  final int optionButton;
  final Color optionButtonColor;
  final Widget optionButtonIcon;
  final String lang;
  final String customizableButton = 'customizable_button'.i18n();
  final String customizableText   = 'customizable_text'.i18n();
  final String customize          = 'customize'.i18n();
  final String phrase             = 'phrase'.i18n();

  final go_router.GoRouter router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // Accedemos al Notifier para llamar a sus métodos
    // (removed old ttsNotifier; using hybridTtsProvider where needed)

    return TextButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(optionButtonColor),
      ),
      onPressed: () async {

  final customButtonService = ref.read(customButtonsServiceProvider);
  final customButtons = await customButtonService.getCustomButtons();
  final button = optionButton == 1 ? customButtons['button1'] : customButtons['button2'];

  // Evitar uso del `context` después de un await si el widget ya fue desmontado.
  if (!context.mounted) return;

        if(button == null) {

          if(Platform.isIOS) {

            // Diálogo para iOS
            showCupertinoDialog(
              context: context, 
              builder: (BuildContext context) => CupertinoAlertDialog(
                title: Row(
                  children: [
                    Icon(
                        optionButton == 1 ? Icons.edit_note : Icons.edit_calendar,
                        color: optionButtonColor,
                      ),

                      SizedBox(width: 10.0,),

                      Expanded(
                        child: Text(
                          customizableButton.toUpperCase(),
                          style: TextStyle(color: optionButtonColor),
                        ),
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
                          router.push('/button_config/$optionButton');
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
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            optionButton == 1 ? Icons.edit_note : Icons.edit_calendar,
                            color: optionButtonColor,
                          ),
                      
                          SizedBox(width: 10.0,),
                      
                          Expanded(
                            child: Text(
                              customizableButton.toUpperCase(),
                              style: TextStyle(color: optionButtonColor),
                            ),
                          ),
                        ],
                      ),
                      Divider(color: optionButton == 1 ? Colors.blue.shade700 : Colors.green.shade800,),
                    ],
                  ),

                  content: Text(customizableText,),
                  actions: <Widget>[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        TextButton(
                          child: Text(customize, style: TextStyle(color: Colors.red),),
                          onPressed: () {
                            router.push('/button_config/$optionButton');
                            Navigator.of(context).pop();
                          }
                        ),

                        TextButton(
                          child: Text('OK', style: TextStyle(color: optionButton == 1 ? Colors.blue.shade700 : Colors.green.shade800),),
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
        } else {
          ref.read(hybridTtsProvider.notifier).speak(button, lang);
        }

      },
      onLongPress: () async {
        // Envío mínimo por WhatsApp al mantener presionado el botón.
        // Flujo:
        // 1. Obtener el texto personalizado del botón (si no existe, no hacemos nada aquí).
        // 2. Obtener el contacto de emergencia (teléfono).
        // 3. Llamar al servicio WhatsApp que devuelve un WhatsAppSendResult.
        // 4. Comprobar `context.mounted` antes de mostrar cualquier diálogo.

        final customButtonService = ref.read(customButtonsServiceProvider);
        final customButtons = await customButtonService.getCustomButtons();
        final button = optionButton == 1 ? customButtons['button1'] : customButtons['button2'];

        // Si el botón no está configurado, no hacemos nada (el onPressed ya muestra un diálogo para configurar).
        if (button == null) return;

        final emergencyService = ref.read(emergencyServiceProvider);
        final contact = await emergencyService.getEmergencyContact();
        final String emergencyPhone = contact['emergencyPhone'] ?? '';

        if (emergencyPhone.isEmpty) {
          // No hay teléfono registrado: mostrar diálogo breve indicando configurar (mínimo cambio).
          if (!context.mounted) return;

          final title = 'info_missing'.i18n();
          final msg = 'you_must_config'.i18n();

          if (Platform.isIOS) {
            showCupertinoDialog(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text(title.toUpperCase()),
                content: Text(msg, textAlign: TextAlign.center),
                actions: [
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(title.toUpperCase()),
                content: Text(msg),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            );
          }

          return;
        }

        // Intentamos enviar el mensaje por WhatsApp
        final result = await WhatsAppService().sendMessage(emergencyPhone, button);

        if (!context.mounted) return;

        if (result == WhatsAppSendResult.notInstalled) {
          final title = 'whatsapp_not_installed'.i18n();
          final msg = 'install_whatsapp'.i18n();

          if (Platform.isIOS) {
            showCupertinoDialog(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text(title),
                content: Text(msg),
                actions: [
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(title),
                content: Text(msg),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
          }
        } else if (result == WhatsAppSendResult.error) {
          if (Platform.isIOS) {
            showCupertinoDialog(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Error'),
                content: Text('No se pudo abrir WhatsApp. Intenta nuevamente.'),
                actions: [
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Error'),
                content: Text('No se pudo abrir WhatsApp. Intenta nuevamente.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
          }
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
      onTap: onTap,
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
        child: isSpeaking 
        ? Center(
            child: SizedBox(
              // Hacer el indicador más pequeño: por ejemplo 1/3 del ancho del botón
              width: (screenWidth * 0.20) * 0.33,
              height: (screenWidth * 0.20) * 0.33,
              child: const CircularProgressIndicator(strokeWidth: 2.5, color: Colors.blue,),
            ),
          ) 
        : imageChild,
      ),
    );
  }
}