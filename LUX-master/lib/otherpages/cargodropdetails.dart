
import 'package:flutter/material.dart';
import 'package:luxair/widgets/customdialogue.dart';

import '../constants.dart';
import 'package:luxair/widgets/headerclipper.dart';

class CargoDropDetails extends StatefulWidget {
   bool isExport = false;
  //final VehicleToken selectedVtDetails;

  //  CargoDropDetails({ Key? key, required this.selectedVtDetails, 
  //  required this.isExport }) : super(key: key);

     CargoDropDetails({ Key? key, 
   required this.isExport }) : super(key: key);

  @override
  State<CargoDropDetails> createState() => _CargoDropDetailsState();
}

class _CargoDropDetailsState extends State<CargoDropDetails> {
  bool useMobileLayout = false;
  bool isLoading = false;
  TextEditingController txtVTNO = new TextEditingController();
    String scannedCodeReceived = "";

    @override
  void initState() {
    txtVTNO.text="EVT220212121212";

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = smallestDimension < 600;
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          HeaderClipperWave(
              color1: Color(0xFF3383CD),
              color2: Color(0xFF11249F),
              headerText: "Cargo Drop Details"),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: useMobileLayout
                        ? const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 15.0)
                        : const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: useMobileLayout
                              ? MediaQuery.of(context).size.width / 5
                              : MediaQuery.of(context).size.width / 7,
                          // hard coding child width
                          child: Text(
                            "VT No.",
                            style: useMobileLayout
                                ? mobileHeaderFontStyle
                                : TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF11249F),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: useMobileLayout
                              ? MediaQuery.of(context).size.width / 2.2
                              : MediaQuery.of(context).size.width /
                                  2.2, // hard coding child width
                          child: Container(
                            height: useMobileLayout ? 40 : 65,
                            width: MediaQuery.of(context).size.width / 2.4,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextField(
                              controller: txtVTNO,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter Vehicle No.",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                isDense: true,
                              ),
                              style: useMobileLayout
                                  ? mobileTextFontStyle
                                  : TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                            ),
                          ),
                        ),
                           ],
                    ),
                  ),
                  Padding(
                    padding: useMobileLayout
                        ? const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 10.0)
                        : const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!useMobileLayout) SizedBox(height: 10),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width / 1.15,
                          color: Color(0xFF0461AA),
                        ),
                        SizedBox(height: useMobileLayout ? 10 : 20),
                        Text(
                          "Vehicle Details",
                          style: useMobileLayout
                              ? mobileHeaderFontStyle
                              : TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF11249F),
                                ),
                        ),
                        useMobileLayout
                            ? SizedBox(height: 5)
                            : SizedBox(height: 20),
                        useMobileLayout
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width / 1.01,
                                child: isLoading
                                    ? Center(
                                        child: Container(
                                            height: 100,
                                            width: 100,
                                            child: CircularProgressIndicator()))
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Column(
                                                children: [
                                                  // SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.2,
                                                        child: Container(
                                                          height: 30,
                                                          color: Colors
                                                              .yellow.shade300,
                                                          child: Center(
                                                            child: Text(
                                                                'Vehicle No.',
                                                                style:
                                                                    mobileYellowTextFontStyleBold),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.2,
                                                        child: Container(
                                                          height: 30,
                                                          color: Colors
                                                              .yellow.shade300,
                                                          child: Center(
                                                            child: Text(
                                                                'Driver Name',
                                                                style:
                                                                    mobileYellowTextFontStyleBold),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.2,
                                                        child: Container(
                                                          height: 30,
                                                          color: Colors
                                                              .yellow.shade100,
                                                          child: Center(
                                                            child: Text(
                                                                "mh84848",
                                                                style:
                                                                    mobileDetailsYellowBold),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.2,
                                                        child: Container(
                                                          height: 30,
                                                          color: Colors
                                                              .yellow.shade100,
                                                          child: Center(
                                                            child: Text(
                                                                "DRIVERNAME",
                                                                style:
                                                                    mobileDetailsYellowBold),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: useMobileLayout
                                                          ? 5
                                                          : 20),

                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.09,
                                                        child: Container(
                                                          height: 30,
                                                          color: Colors
                                                              .yellow.shade300,
                                                          child: Center(
                                                            child: Text(
                                                                'Slot/ Dock Details',
                                                                style:
                                                                    mobileYellowTextFontStyleBold),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.09,
                                                        child: Container(
                                                          height: 30,
                                                          color: Colors
                                                              .yellow.shade100,
                                                          child: Center(
                                                            child: Text(
                                                                "SLOTTIME",
                                                                style:
                                                                    mobileDetailsYellowBold),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: useMobileLayout
                                                          ? 10
                                                          : 20),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              height: useMobileLayout ? 5 : 40),
                                         ],
                                      ),
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width / 1.1,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text(
                                                    'Vehicle No.',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text(
                                                    'Driver Name',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text(
                                                    'Slot/ Dock Details',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                    'TN34Y-82223',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                    'John',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                    '05:30 - 06:00',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text(
                                                    'AWB No.',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text(
                                                    'HAWB No.',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text(
                                                    'Flt Arr.',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                    '777-8934Y82223',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                    ' -- ',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                    '18:00',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text(
                                                    'CRN',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text(
                                                    'Pmt Cnf.',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 50,
                                                color: Colors.white,
                                                child: Center(
                                                  child: Text(
                                                    '',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.task_alt,
                                                    size: 36,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                    child: Icon(
                                                  Icons.task_alt,
                                                  size: 36,
                                                  color: Colors.green,
                                                )

                                                    //  Text(
                                                    //   'Received',
                                                    //   style: TextStyle(
                                                    //       fontSize: 20,
                                                    //       fontWeight: FontWeight.bold,
                                                    //       color: Colors.black),
                                                    // ),
                                                    ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 50,
                                                color: Colors.white,
                                                child: Center(
                                                  child: Text(
                                                    '',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(height: useMobileLayout ? 10 : 40),
                      ],
                    ),
                  ),
                  Padding(
                    padding: useMobileLayout
                        ? const EdgeInsets.only(right: 00.0)
                        : const EdgeInsets.only(right: 40.0),
                    child: Align(
                      alignment: useMobileLayout
                          ? Alignment.center
                          : Alignment.topRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // showSuccessMessage();

                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialog(
                              title: txtVTNO.text,
                              description: "Cargo Drop for VT# " +
                                  txtVTNO.text +
                                  " has been completed successfully",
                              buttonText: "Okay",
                              imagepath: 'assets/images/successchk.gif',
                                            isMobile: useMobileLayout,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)), //
                          padding: const EdgeInsets.all(0.0),
                        ),
                        child: Container(
                          height: 70,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color(0xFF1220BC),
                                Color(0xFF3540E8),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 18.0, bottom: 18.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        //Text('CONTAINED BUTTON'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}
