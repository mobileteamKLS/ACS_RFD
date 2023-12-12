import 'package:luxair/widgets/headerclipper.dart';
import 'package:flutter/material.dart';

class ViewBookedSlots extends StatefulWidget {
  const ViewBookedSlots({ Key? key }) : super(key: key);

  @override
  State<ViewBookedSlots> createState() => _ViewBookedSlotsState();
}

class _ViewBookedSlotsState extends State<ViewBookedSlots> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderClipperWave(
                  color1: Color(0xFF3383CD),
                  color2: Color(0xFF11249F),
                  headerText: "View Booked Slots")
            ]),
      ),
    );
  }
}