import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;


    return Container(
      color: Colors.white,
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 231, 248, 233),
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              border: Border.all(
                color: Colors.green,
                width: 3.0,
              ),
            ),
            height: screenWidth * 0.25,
            width: screenWidth * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.thumb_up_sharp, color: Colors.green,),
                Text('Sí', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                Icon(Icons.check_circle, color: Colors.green,)
              ],
            )
          ),

          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 230, 229, 229),
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              border: Border.all(
                color: Colors.black,
                width: 3.0,
              ),
            ),
            height: screenWidth * 0.25,
            width: screenWidth * 0.25,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SvgPicture.asset(
                'assets/icon/confused.svg',
                width: 60,
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 251, 234, 234),
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              border: Border.all(
                color: Colors.red,
                width: 3.0,
              ),
            ),
            height: screenWidth * 0.25,
            width: screenWidth * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.thumb_down_sharp, color: Colors.red,),
                Text('No', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                Icon(Icons.cancel_rounded, color: Colors.red,)
              ],
            )
          ),
        ],
      )
    );
  }
}