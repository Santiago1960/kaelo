import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaelo/services/custom_buttons_service.dart';
import 'package:localization/localization.dart';

final customButtonsServiceProvider = Provider((ref) => CustomButtonsService());

class ButtonConfigurationPage extends ConsumerStatefulWidget {
  const ButtonConfigurationPage({super.key});

  @override
  ConsumerState<ButtonConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends ConsumerState<ButtonConfigurationPage> {

  // Controladores para los campos de texto
  final _phraseController = TextEditingController();
  String _phraseController1 = '';
  String _phraseController2 = '';

  // Controlador para el estado del Formulario
  final _formKey = GlobalKey<FormState>();

  // Controla que la pantalla tenga la información antes de renderizarla
  late Future<void> _loadingData;
  
  // Estado para mostrar un mensaje al usuario
  String _message = '';

  @override
  void initState() {
    super.initState();
    // Cargamos los datos guardados al iniciar la p\u00e1gina
    _loadingData = _loadCustomButtons();
  }

  @override
  void dispose() {
    _phraseController.dispose();
    super.dispose();
  }

  // Función para cargar los datos del servicio
  Future<void> _loadCustomButtons() async {
    final customButtonsService = ref.read(customButtonsServiceProvider);
    final button = await customButtonsService.getCustomButtons();
    
    //_phraseController.text = button['button1'] ?? '';
    _phraseController1 = button['buton1'] ?? '';
    _phraseController2 = button['buton2'] ?? '';
  }

  // Función para guardar los datos usando el servicio
  Future<void> _savePhrases() async {

    if(_formKey.currentState!.validate()) {

      FocusScope.of(context).unfocus();  // Cierra el teclado

      final customButtonsService = ref.read(customButtonsServiceProvider);
      await customButtonsService.saveCustomButtons(
        button1: _phraseController.text,
      );

      setState(() {
        _message = 'Los datos se guardaron correctamente';
        Future.delayed(
          const Duration(seconds: 2),
          () {
            if(mounted) {
              Navigator.of(context).pop();
            }
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final state = GoRouterState.of(context);
    final optionItem = state.pathParameters['id'];

    if(optionItem == '1') {
      _phraseController.text = _phraseController1;
    } else {
      _phraseController.text = _phraseController2;
    }

    // Variables de localization
    final String configuration       = 'configuration'.i18n();
    /* final String patientName         = 'patient_name'.i18n();
    final String countryCode         = 'country_code'.i18n();
    final String emergencyPhone      = 'emergency_phone'.i18n(); */
    final String saveData            = 'save_data'.i18n();
    /* final String byPressSOS          = 'by_press_SOS'.i18n();
    final String emergencyMessage    = 'emergency_message'.i18n();
    final String whatsappMessage     = 'whatsapp_message'.i18n();
    final String enterPatientName    = 'enter_your_name'.i18n();
    final String enterCountryCode    = 'enter_country_code'.i18n();
    final String countryCodeOneDigit = 'country_code_one_digit'.i18n();
    final String enterPhoneNumber    = 'enter_phone_number'.i18n(); */
    
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
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              
                  // Formulario para capturar el mensaje que se asignará al botón
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
            
                      child: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Personalizar Frase $optionItem',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                                
                            const SizedBox(height: 16),
                                
                            TextFormField(
                              controller: _phraseController,
                              decoration: InputDecoration(
                                labelText: 'Escribe tu frase', 
                                            floatingLabelStyle: optionItem == '1'? TextStyle(color: Colors.blue.shade700,) : TextStyle(color: Colors.green.shade800,),
                                border: const OutlineInputBorder(),
                                prefixIcon: Icon(
                                  optionItem == '1' ? Icons.edit_note : Icons.edit_calendar, 
                                  color: optionItem == '1' ? Colors.blue.shade700 : Colors.green.shade800,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: optionItem == '1' ? Colors.blue.shade700 : Colors.green.shade800,
                                  )
                                ),
                              ),
                              maxLength: 60,
                              maxLines: null,
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return 'Ingresa tu frase';
                                }
                                return null;
                              },
                            ),
                                
                            const SizedBox(height: 24),
                                
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _savePhrases,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: optionItem == '1' ? Colors.blue.shade700 : Colors.green.shade800,
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                                  ),
                                  icon: const Icon(Icons.save, color: Colors.white),
                                  label: Text(
                                    saveData,
                                    style: const TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Muestra un mensaje al usuario después de guardar
                  if (_message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        _message,
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
              
                  const SizedBox(height: 32),
              
                  // Descripción del uso del botón SOS
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: TextSpan(
                        text: 'byPressSOS',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'emergencyMessage',
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
              
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: TextSpan(
                        text: 'whatsappMessage',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}