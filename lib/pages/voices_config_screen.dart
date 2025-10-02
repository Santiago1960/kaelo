import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaelo/services/hybrid_tts_service.dart';
import 'package:kaelo/services/tts_caching_service.dart';
import 'package:kaelo/services/voices_service.dart';
import 'package:localization/localization.dart';

enum Gender { female, male, phone }

final voicesServiceProvider = Provider((ref) => CustomVoiceService());
final hybridTtsProvider = Provider((ref) => HybridTtsService());

class VoicesConfigurationPage extends ConsumerStatefulWidget {
  const VoicesConfigurationPage({super.key});

  @override
  ConsumerState<VoicesConfigurationPage> createState() => _VoicesConfigurationPageState();
}

class _VoicesConfigurationPageState extends ConsumerState<VoicesConfigurationPage> {

  // Controla que la pantalla tenga la información antes de renderizarla
  late Future<void> _loadingData;
  Gender? _selectedGender;
  Gender? _initialGender;

  @override
  void initState() {
    super.initState();
    // Cargamos los datos guardados al iniciar la  página
    _loadingData = _loadVoicesState();
  }

  // Helper: parsea String -> Gender
  Gender? _genderFromString(String? s) {
    if (s == null) return null;
    switch (s.toUpperCase()) {
      case 'FEMALE':
        return Gender.female;
      case 'MALE':
        return Gender.male;
      default:
        return null;
    }
  }

  // Helper: convierte Gender -> String (guardable/legible)
  String _genderToString(Gender? g) {
    if (g == null) return '';
    return g == Gender.female 
                  ? 'FEMALE' 
                  : g == Gender.male
                    ? 'MALE'
                    : '';
  }

  // Función para cargar los datos del servicio
  Future<void> _loadVoicesState() async {
    final voiceService = ref.read(voicesServiceProvider);
    final voice = await voiceService.getCustomVoice();

    final String? storedGender = voice['gender'];
    _selectedGender = _genderFromString(storedGender) ?? Gender.phone;
    _initialGender = _selectedGender; // Guardamos el estado inicial para posibles comparaciones
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Variables de localization
    final String configuration    = 'configuration'.i18n();
    final String customizeGender  = 'customize_gender'.i18n();
    final String woman            = 'woman'.i18n();
    final String man              = 'man'.i18n();
    final String phoneSettings    = 'phone_settings'.i18n();
    final String offLine          = 'off_line'.i18n();
    final String internetRequired = 'internet_required'.i18n();
    final String downloadWoman    = 'download_woman'.i18n();
    final String downloadMan      = 'download_man'.i18n();
    final String usePhoneVoice    = 'use_phone_voice'.i18n();

    return Scaffold(
      appBar: AppBar(
        title: Text(configuration),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<void>(
        future: _loadingData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  customizeGender,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            Center(
                              child: Column(
                                children: [

                                  RadioListTile<Gender>(
                                    fillColor: WidgetStatePropertyAll(Colors.pink),
                                    title: Text(woman),
                                    value: Gender.female,
                                    groupValue: _selectedGender,
                                    onChanged: (Gender? value) {
                                      setState((){
                                        _selectedGender = value;
                                      });
                                    },
                                  ),

                                  RadioListTile<Gender>(
                                    fillColor: WidgetStatePropertyAll(Colors.blue.shade700),
                                    title: Text(man),
                                    value: Gender.male,
                                    groupValue: _selectedGender,
                                    onChanged: (Gender? value) {
                                      setState((){
                                        _selectedGender = value;
                                      });
                                    },
                                  ),

                                  RadioListTile<Gender>(
                                    fillColor: WidgetStatePropertyAll(Colors.black87),
                                    title: Text(phoneSettings),
                                    value: Gender.phone,
                                    groupValue: _selectedGender,
                                    onChanged: (Gender? value) {
                                      setState((){
                                        _selectedGender = value;
                                      });
                                    },
                                  ),

                                  SizedBox(height: 25.0,),

                                  if(_selectedGender != _initialGender)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () async {

                                            // Verificamos la conexión
                                            final connectivityResult = await (Connectivity().checkConnectivity());

                                            if (connectivityResult.contains(ConnectivityResult.none)) {
                                              if (context.mounted) {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {

                                                    return AlertDialog(
                                                      title: Text(offLine),
                                                      content: Text(internetRequired),
                                                      actions: [
                                                        TextButton(
                                                          child: Text('Ok', style: TextStyle(color: Colors.blue[700]),),
                                                          onPressed: () => Navigator.of(context).pop(),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                              return; // Salimos de la función AHORA.
                                            }
                                            
                                            if(context.mounted) {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (BuildContext context) {
                                                  return const Center(child: CircularProgressIndicator());
                                                }
                                              );
                                            }

                                            try {

                                              final voice = _genderToString(_selectedGender);
                                              await ref.read(voicesServiceProvider).saveCustomVoice(gender: voice);

                                              if(voice == '') {

                                                ref.read(hybridTtsProvider).clearCache();

                                                if (context.mounted) {
                                                  Navigator.of(context).pop(); // Cierra el diálogo de carga
                                                  Navigator.of(context).pop(); // Cierra la pantalla de configuración de voz
                                                }
                                                return;
                                              }

                                              // Antes de descargar, verificamos la conexión a internet
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

                                                if (connectivityResult == ConnectivityResult.none && context.mounted) {

                                                  if(context.mounted) {
                                                    Navigator.of(context).pop(); // Cierra el diálogo de carga
                                                  }

                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (BuildContext context) {
                                                      return Text(internetRequired);
                                                    }
                                                  );
                                                  return;
                                                }

                                              String lang = 'es-US';

                                              if(context.mounted) {
                                                lang = Localizations.localeOf(context).languageCode;
                                              }

                                              // Borramos la caché de audios anteriores
                                              await ref.read(hybridTtsProvider).clearCache();

                                              await ref.read(ttsCachingServiceProvider).preCacheRequiredAudios(lang: lang);

                                              if (context.mounted) {
                                                Navigator.of(context).pop(); // Cierra el diálogo de carga
                                                Navigator.of(context).pop(); // Cierra la pantalla de configuración de voz
                                              }
                                            } catch (e) {

                                              debugPrint('Error: $e');
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color.fromARGB(255, 111, 149, 183),
                                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                                          ),
                                          icon: _selectedGender == Gender.female
                                              ? const Icon(Icons.woman, color: Colors.white, size: 25.0,)
                                              : _selectedGender == Gender.male
                                                ? const Icon(Icons.man, color: Colors.white, size: 25.0)
                                                : const Icon(Icons.phone_android, color: Colors.white, size: 25.0,),
                                          label: Text(
                                            _selectedGender == Gender.female
                                                ? downloadWoman
                                                : _selectedGender ==  Gender.male
                                                    ? downloadMan
                                                    : usePhoneVoice,
                                            style: const TextStyle(fontSize: 18, color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}