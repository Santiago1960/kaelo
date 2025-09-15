import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaelo/pages/home/home_screen.dart';
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

  // Controlador para el estado del Formulario
  final _formKey = GlobalKey<FormState>();

  // Controla que la pantalla tenga la información antes de renderizarla
  late Future<void> _loadingData;
  
  // Estado para mostrar un mensaje al usuario
  String _message = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phraseController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = GoRouterState.of(context);
    _loadingData = _loadCustomButtons(state);
  }

  // Función para cargar los datos del servicio
  Future<void> _loadCustomButtons(GoRouterState state) async {

    final state = GoRouterState.of(context);
    final customButtonsService = ref.read(customButtonsServiceProvider);
    final button = await customButtonsService.getCustomButtons();
    
    // Obtenemos el valor del botón que corresponda
    final phrase = state.pathParameters['id'] == '1'? button['button1'] : button['button2'];

    _phraseController.text = phrase ?? '';
  }

  // Función para borrar texto personalizado
  Future<void> _deletePhrases(optionItem) async {

    final customButtonsService = ref.read(customButtonsServiceProvider);
    
    await customButtonsService.clearCustomButton(optionItem);

    setState(() {
      _message = 'El mensaje fue eliminado';
      Future.delayed(
        const Duration(milliseconds: 750),
        () {
          if(mounted) {
            Navigator.of(context).pop();
          }
        },
      );
    });
  }

  // Función para guardar los datos usando el servicio
  Future<void> _savePhrases(optionItem) async {

    if(_formKey.currentState!.validate()) {

      FocusScope.of(context).unfocus();  // Cierra el teclado

      final customButtonsService = ref.read(customButtonsServiceProvider);
      
      if(optionItem == '1') {
        await customButtonsService.saveCustomButtons(
          button1: _phraseController.text,
        );
      } else {
        await customButtonsService.saveCustomButtons(
          button2: _phraseController.text,
        );
      }

      setState(() {
        _message = 'Los datos se guardaron correctamente';
        Future.delayed(
          const Duration(milliseconds: 750),
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

    // Variables de localization
    final String configuration       = 'configuration'.i18n();
    final String saveData            = 'save_data'.i18n();
    
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
                                  onPressed: () {
                                    _deletePhrases(optionItem);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade800,
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                                  ),
                                  icon: const Icon(Icons.delete, color: Colors.white),
                                  label: Text(
                                    'Borrar',
                                    style: const TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ),

                                SizedBox(width: 20,),

                                ElevatedButton.icon(
                                  onPressed: () {
                                    _savePhrases(optionItem);
                                  },
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