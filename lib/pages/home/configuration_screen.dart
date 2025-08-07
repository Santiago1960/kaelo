import 'package:flutter/material.dart';
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
  final _emergencyPhoneController = TextEditingController();
  
  // Estado para mostrar un mensaje al usuario
  String _message = '';

  @override
  void initState() {
    super.initState();
    // Cargamos los datos guardados al iniciar la p\u00e1gina
    _loadEmergencyContact();
  }

  // Función para cargar los datos del servicio
  Future<void> _loadEmergencyContact() async {
    final emergencyService = ref.read(emergencyServiceProvider);
    final contact = await emergencyService.getEmergencyContact();
    
    _patientNameController.text = contact['patientName'] ?? '';
    _emergencyPhoneController.text = contact['emergencyPhone'] ?? '';
  }

  // Función para guardar los datos usando el servicio
  Future<void> _saveContact() async {
    final emergencyService = ref.read(emergencyServiceProvider);
    await emergencyService.saveEmergencyContact(
      patientName: _patientNameController.text,
      emergencyPhone: _emergencyPhoneController.text,
    );
    setState(() {
      _message = 'Datos guardados correctamente.';
    });
  }

  @override
  Widget build(BuildContext context) {

    // Variables de localization
    final String configuration = 'configuration'.i18n();
    final String emergencyData = 'emergency_data'.i18n();
    final String patientName = 'patient_name'.i18n();
    final String countryCode = 'country_code'.i18n();
    final String emergencyPhone = 'emergency_phone'.i18n();
    final String saveData = 'save_data'.i18n();
    final String byPressSOS = 'by_press_SOS'.i18n();
    final String emergencyMessage = 'emergency_message'.i18n();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(configuration),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Formulario para capturar el nombre del paciente y el tel\u00e9fono
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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

                    TextField(
                      controller: _patientNameController,
                      decoration: InputDecoration(
                        labelText: patientName,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _patientNameController,
                      decoration: InputDecoration(
                        labelText: countryCode,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.flag),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _emergencyPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: emergencyPhone,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.phone),
                      ),
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
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}