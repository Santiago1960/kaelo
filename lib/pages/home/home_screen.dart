import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaelo/config/config.dart';
import 'package:kaelo/services/whatsapp_launcher.dart';
import 'package:kaelo/widgets/custom_footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

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

        body: Column(

          children: [

            SizedBox(height: 20,),

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
          ],
        ),

        bottomNavigationBar: CustomFooter()
      ),
    );
  }
}