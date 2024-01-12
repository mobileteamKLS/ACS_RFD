import 'package:flutter/material.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:luxair/widgets/headers.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

              HeaderClipperWave(color1:Color(0xFF3383CD),
                    color2:Color(0xFF11249F),headerText:       "How can we help you ?"),

          
       
          ]),
    );
  }
}
