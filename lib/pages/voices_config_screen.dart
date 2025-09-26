import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaelo/services/voices_service.dart';
import 'package:localization/localization.dart';

enum Gender { female, male }

final voicesServiceProvider = Provider((ref) => CustomVoiceService());

class VoicesConfigurationPage extends ConsumerStatefulWidget {
  const VoicesConfigurationPage({super.key});

  @override
  ConsumerState<VoicesConfigurationPage> createState() => _VoicesConfigurationPageState();
}

class _VoicesConfigurationPageState extends ConsumerState<VoicesConfigurationPage> {
  final _voiceController = TextEditingController();

  // Controla que la pantalla tenga la información antes de renderizarla
  late Future<void> _loadingData;
  Gender? _selectedGender;

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
    return g == Gender.female ? 'FEMALE' : 'MALE';
  }

  // Función para cargar los datos del servicio
  Future<void> _loadVoicesState() async {
    final voiceService = ref.read(voicesServiceProvider);
    final voice = await voiceService.getCustomVoice();

    final String? storedGender = voice['gender'];
    _selectedGender = _genderFromString(storedGender) ?? Gender.female;
    _voiceController.text = _genderToString(_selectedGender);
  }

  @override
  void dispose() {
    _voiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Variables de localization
    final String configuration = 'configuration'.i18n();
    final String customizeGender = 'customize_gender'.i18n();

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
                            const SizedBox(height: 36),

                            // SegmentedButton moderno (reemplaza Radio/RadioListTile)
                            Center(
                              child: SegmentedButton<Gender>(
                                segments: <ButtonSegment<Gender>>[

                                  ButtonSegment<Gender>(
                                    value: Gender.female,
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.woman_2, 
                                          color: _selectedGender == Gender.female ? Colors.white : Colors.pink[700],
                                          size: 25.0,
                                        ),
                                        const SizedBox(width: 8),
                                        Text('Mujer'),
                                      ],
                                    ),
                                  ),
                                  
                                  ButtonSegment<Gender>(
                                    value: Gender.male,
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.man_4_outlined, 
                                          color: _selectedGender == Gender.male ? Colors.white : Colors.black54, 
                                          size: 25.0,
                                        ),
                                        const SizedBox(width: 8),
                                        Text('Hombre'),
                                      ],
                                    ),
                                  ),
                                ],
                                selected: _selectedGender == null ? <Gender>{} : <Gender>{_selectedGender!},
                                onSelectionChanged: (Set<Gender> newSelection) {
                                  setState(() {
                                    _selectedGender = newSelection.isEmpty ? null : newSelection.first;
                                    _voiceController.text = _genderToString(_selectedGender);
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                                    (Set<WidgetState> states) {
                                      if (states.contains(WidgetState.selected)) {
                                        return Color.fromARGB(255, 111, 149, 183);
                                      }
                                      return Colors.transparent;
                                    },
                                  ),
                                  foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                                    (Set<WidgetState> states) {
                                      if (states.contains(WidgetState.selected)) {
                                        return Colors.white;
                                      }
                                      return Colors.black;
                                    },
                                  ),
                                ),
                                multiSelectionEnabled: false,
                                // Opcional: ajustar estilo si deseas mayor contraste/tamaño
                                // style: ButtonStyle(...),
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