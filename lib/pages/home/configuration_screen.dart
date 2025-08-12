import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaelo/services/emergency_service.dart';
import 'package:localization/localization.dart';

final emergencyServiceProvider = Provider((ref) => EmergencyService());

class ConfigurationPage extends ConsumerStatefulWidget {
  const ConfigurationPage({super.key});

  @override
  ConsumerState<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends ConsumerState<ConfigurationPage> {

  // Controladores para los campos de texto
  final _patientNameController = TextEditingController();
  final _countryCodeController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

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
    _loadingData = _loadEmergencyContact();
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _countryCodeController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  // Función para cargar los datos del servicio
  Future<void> _loadEmergencyContact() async {
    final emergencyService = ref.read(emergencyServiceProvider);
    final contact = await emergencyService.getEmergencyContact();
    
    _patientNameController.text = contact['patientName'] ?? '';
    _countryCodeController.text = contact['countryCode'] ?? '';
    _emergencyPhoneController.text = contact['emergencyPhone'] ?? '';
  }

  // Función para guardar los datos usando el servicio
  Future<void> _saveContact() async {

    if(_formKey.currentState!.validate()) {

      FocusScope.of(context).unfocus();  // Cierra el teclado

      final emergencyService = ref.read(emergencyServiceProvider);
      await emergencyService.saveEmergencyContact(
        patientName: _patientNameController.text,
        countryCode: _countryCodeController.text,
        emergencyPhone: _emergencyPhoneController.text,
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

    // Variables de localization
    final String configuration       = 'configuration'.i18n();
    final String emergencyData       = 'emergency_data'.i18n();
    final String patientName         = 'patient_name'.i18n();
    final String countryCode         = 'country_code'.i18n();
    final String emergencyPhone      = 'emergency_phone'.i18n();
    final String saveData            = 'save_data'.i18n();
    final String byPressSOS          = 'by_press_SOS'.i18n();
    final String emergencyMessage    = 'emergency_message'.i18n();
    final String whatsappMessage     = 'whatsapp_message'.i18n();
    final String enterPatientName    = 'enter_your_name'.i18n();
    final String enterCountryCode    = 'enter_country_code'.i18n();
    final String countryCodeOneDigit = 'country_code_one_digit'.i18n();
    final String enterPhoneNumber    = 'enter_phone_number'.i18n();
    
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
              
                  // Formulario para capturar el nombre del paciente y el teléfono de emergencia
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
                                  emergencyData,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                                
                            const SizedBox(height: 16),
                                
                            TextFormField(
                              controller: _patientNameController,
                              decoration: InputDecoration(
                                labelText: patientName,
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.person),
                              ),
                              maxLength: 20,
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return enterPatientName;
                                }
                                return null;
                              },
                            ),
                                
                            const SizedBox(height: 16),
                                
                            TextFormField(
                              controller: _countryCodeController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: countryCode,
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.flag),
                              ),
                              maxLength: 4,
            
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CountryCodeInputFormatter(),
                              ],
            
                              validator: (value) {
                                if (value == null || value.isEmpty || value == '+') {
                                  return enterCountryCode;
                                }
                                if (value.length < 2) {
                                  return countryCodeOneDigit;
                                }
                                return null;
                              },
                            ),
                                
                            const SizedBox(height: 16),
                                
                            TextFormField(
                              controller: _emergencyPhoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: emergencyPhone,
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.phone),
                              ),
            
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
            
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return enterPhoneNumber;
                                }
                                return null;
                              },
                            ),
                                
                            const SizedBox(height: 24),
                                
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _saveContact,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 111, 149, 183),
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
                        text: byPressSOS,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: emergencyMessage,
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
                        text: whatsappMessage,
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

/// Custom InputFormatter para el código de país.
/// Asegura que el "+" se mantenga al inicio y el resto sean dígitos.
class CountryCodeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: '+',
        selection: TextSelection.collapsed(offset: 1),
      );
    }
    if (newValue.text == '+') {
      return newValue;
    }
    if (!newValue.text.startsWith('+')) {
      return TextEditingValue(
        text: '+${newValue.text}',
        selection: TextSelection.collapsed(offset: newValue.text.length + 1),
      );
    }
    // Permite solo dígitos después del '+'
    final text = newValue.text.substring(1);
    final filteredText = text.replaceAll(RegExp(r'[^0-9]'), '');
    return TextEditingValue(
      text: '+$filteredText',
      selection: TextSelection.collapsed(offset: '+$filteredText'.length),
    );
  }
}