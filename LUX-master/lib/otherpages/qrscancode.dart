import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:luxair/datastructure/vehicletoken.dart';
import 'package:luxair/widgets/customdialogue.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:luxair/widgets/qrscan.dart';

import '../constants.dart';
import '../global.dart';

class ScanQRCode extends StatefulWidget {
  ScanQRCode({Key? key}) : super(key: key);

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  String scannedCodeReceived = "";
  bool isLoading = false;
  int value = 0;
  bool useMobileLayout = false;
  List<WalInTokenDetails> walkInTokensList = [];
  String errMsgText = "";
  int modeSelected = 0;

  final _controllerScanType = ValueNotifier<bool>(false);
  bool checked = false, isSaving = false;
  @override
  void initState() {
    if (useMobileLayout)
      _controllerScanType.addListener(() {
        setState(() {
          scannedCodeReceived = "";

          if (_controllerScanType.value) {
            checked = true;
          } else {
            checked = false;
          }
        });
      });

    super.initState();
  }

  @override
  void dispose() {
    _controllerScanType.dispose();

    super.dispose();
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
          //     "Scan QR Code",
          HeaderClipperWave(
              color1: Color(0xFF3383CD),
              color2: Color(0xFF11249F),
              headerText: "Scan QR Code"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 8.0),
              child: Padding(
                padding: useMobileLayout
                    ? const EdgeInsets.only(left: 0.0, top: 8.0, right: 0.0)
                    : const EdgeInsets.only(left: 8.0, top: 20.0, right: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          useMobileLayout
                              ? AdvancedSwitch(
                                  activeColor: Color(0xFF11249F),
                                  inactiveColor: Color(0xFF11249F),
                                  activeChild: Text('Camera',
                                      style: mobileToggleTextFontStyleWhite),
                                  inactiveChild: Text('File',
                                      style: mobileToggleTextFontStyleWhite),
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  height: 35,
                                  controller: _controllerScanType,
                                )
                              : SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.3,
                                  child: ToggleSwitch(
                                    minWidth: 166,
                                    minHeight: 65.0,
                                    initialLabelIndex: modeSelected,
                                    cornerRadius: 20.0,
                                    activeFgColor: Colors.white,
                                    inactiveBgColor: Colors.grey,
                                    inactiveFgColor: Colors.white,
                                    totalSwitches: 2,
                                    customTextStyles: [
                                      iPadModelabelFontStyleSmall,
                                      iPadModelabelFontStyleSmall
                                    ],
                                    labels: ['Camera', 'Gallary'],
                                    icons: [
                                      Icons.scanner,
                                      Icons.collections,
                                    ],
                                    iconSize: 22.0,
                                    activeBgColors: [
                                      // [Colors.blueAccent, Colors.blue],
                                      // [Colors.blueAccent, Colors.blue],
                                      [Color(0xFF1220BC), Color(0xFF3540E8)],
                                      [Color(0xFF1220BC), Color(0xFF3540E8)],
                                    ],
                                    animate:
                                        true, // with just animate set to true, default curve = Curves.easeIn
                                    curve: Curves
                                        .bounceInOut, // animate must be set to true when using custom curve
                                    onToggle: (index) {
                                      scannedCodeReceived = "";
                                      print('switched to: $index');

                                      setState(() {
                                        //selectedText = "";

                                        // if (!useMobileLayout){
                                        //
                                        if (index == 1)
                                          checked = false; //from camera
                                        else
                                          checked = true; //from gallary'

                                        modeSelected = index!;
                                      });
                                    },
                                  ),
                                ),
                          SizedBox(width: useMobileLayout ? 10 : 40),
                          Icon(
                            Icons.qr_code_scanner,
                            size: useMobileLayout ? 48 : 100,
                            color: Color(0xFF3540E8),
                          ),
                          SizedBox(width: useMobileLayout ? 10 : 40),
                          ElevatedButton(
                            onPressed: () async {
                              bool selOption = false;

                              useMobileLayout
                                  ? selOption = _controllerScanType.value
                                  : selOption =
                                      modeSelected == 1 ? false : true;

//                               useMobileLayout ?

//                               print(_controllerScanType.value.toString())
//                               :  print(modeSelected.toString());
// //                               //  print(checked.toString());

// return;

                              if (selOption == true) {
                                var scannedCode = await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => const QRViewExample(),
                                ));
                                print("code returned from app");
                                print(scannedCode);
                                if (scannedCode == null)
                                  setState(() {
                                    scannedCodeReceived = "";
                                  });
                                if (scannedCode == "")
                                  setState(() {
                                    scannedCodeReceived = "";
                                  });
                                if (scannedCode != null) {
                                  if (scannedCode != "") {
                                    print("code returned from app =" +
                                        scannedCode);
                                    setState(() {
                                      scannedCodeReceived = scannedCode;
                                      getTokenDetailsByVTNO(1);
                                    });
                                    // await getShipmentDetails(scannedCode);
                                  }
                                }
                              } else {
                                final ImagePicker _picker = ImagePicker();
                                final XFile? image = await _picker.pickImage(
                                    source:
                                        ImageSource.gallery); // Pick an image
                                if (image == null)
                                  return;
                                else {
                                  String? str = await Scan.parse(image.path);
                                  if (str != null) {
                                    print("str not null");
                                    setState(() {
                                      scannedCodeReceived = str;
                                      getTokenDetailsByVTNO(1);
                                    });
                                  }
                                }
                              }

                              //  setState(() {
                              //   scannedCodeReceived = "scannedCode";
                              // });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)), //
                              padding: const EdgeInsets.all(0.0),
                            ),
                            child: Container(
                              // height: 70,
                              // width: 150,
                              height: useMobileLayout ? 48 : 70,
                              width: MediaQuery.of(context).size.width / 3.5,
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
                                padding: useMobileLayout
                                    ? const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0)
                                    : const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Scan',
                                    style: TextStyle(
                                        fontSize: useMobileLayout
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22
                                            : 24,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            //Text('CONTAINED BUTTON'),
                          ),
                        ],
                      ),
                      useMobileLayout
                          ? SizedBox(height: 10)
                          : SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width / 1.15,
                            color: Color(0xFF3540E8),
                          ),
                        ],
                      ),

                      // if (isLoading) SizedBox(height: 50),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 150.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       CircleAvatar(
                      //         backgroundImage:
                      //             AssetImage('assets/images/loading.gif'),
                      //         radius: 126,
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      if (scannedCodeReceived != "") SizedBox(height: 10),
                      if (scannedCodeReceived != "")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width /
                                  3, // hard coding child width
                              child: Text(
                                "Scanned Code: ",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 22,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF11249F),
                                ),
                              ),
                            ),
                            if (scannedCodeReceived != "")
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    2.5, // hard coding child width
                                child: Text(
                                  scannedCodeReceived,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF11249F),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      if (scannedCodeReceived != "")
                        useMobileLayout
                            ? SizedBox(height: 10)
                            : SizedBox(height: 25),
                      if (scannedCodeReceived != "")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width / 1.15,
                              color: Color(0xFF3540E8),
                            ),
                          ],
                        ),

                      if (scannedCodeReceived != "")
                        useMobileLayout
                            ? SizedBox(height: 10)
                            : SizedBox(height: 25),

                      isLoading
                          ? Column(
                              children: [
                                Center(
                                    child: Container(
                                        height: 100,
                                        width: 100,
                                        child: CircularProgressIndicator())),
                              ],
                            )
                          : Column(
                              children: [
                                // useMobileLayout
                                //     ? SizedBox(height: 15)
                                //     : SizedBox(height: 30),
                                // if (scannedCodeReceived != "" && walkInTokensList.length > 0)
                                //   Container(
                                //     height: 1,
                                //     width:
                                //         MediaQuery.of(context).size.width / 1.1,
                                //     color: Color(0xFF0461AA),
                                //   ),
                                if (scannedCodeReceived != "")
                                  SizedBox(height: 10),
                                if (scannedCodeReceived != "" &&
                                    walkInTokensList.length > 0)
                                  Text(
                                      "Confirm your slot and submit for yard Check-in",
                                      style: useMobileLayout
                                          ? mobileGroupHeaderFontStyle
                                          : iPadGroupHeaderFontStyle),
                                if (scannedCodeReceived != "")
                                  SizedBox(height: 10),
                                if (scannedCodeReceived != "")
                                  SizedBox(
                                    width: useMobileLayout
                                        ? MediaQuery.of(context).size.width /
                                            1.05
                                        : MediaQuery.of(context).size.width /
                                            1.05,
                                    child: useMobileLayout
                                        ? Card(
                                            color: Colors.yellow.shade100,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  top: 8.0,
                                                  bottom: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        child: Text(
                                                            'Vehicle No.',
                                                            style:
                                                                mobileHeaderFontStyle),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2,
                                                        child: Text(
                                                            'TN34Y-82223',
                                                            style:
                                                                mobileYellowTextFontStyleBold),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        child: Text('Mode',
                                                            style:
                                                                mobileHeaderFontStyle),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2,
                                                        child: Text('Exports',
                                                            style:
                                                                mobileYellowTextFontStyleBold),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        child: Text(
                                                            'Driver Name',
                                                            style:
                                                                mobileHeaderFontStyle),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2,
                                                        child: Text(
                                                            'Johnathan Stark',
                                                            style:
                                                                mobileYellowTextFontStyleBold),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        child: Text('Time Slot',
                                                            style:
                                                                mobileHeaderFontStyle),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2,
                                                        child: Text(
                                                            '02-JUL-2022 16:00-17:00',
                                                            style:
                                                                mobileYellowTextFontStyleBold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              for (WalInTokenDetails wtkn
                                                  in walkInTokensList)
                                                Card(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 8),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 56,
                                                            child: Container(
                                                              height: 40,
                                                              color: Colors
                                                                  .yellow
                                                                  .shade300,
                                                              child: Center(
                                                                child: Text(' ',
                                                                    style:
                                                                        iPadYellowTextFontStyleNormal),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                5,
                                                            child: Container(
                                                              height: 40,
                                                              color: Colors
                                                                  .yellow
                                                                  .shade300,
                                                              child: Center(
                                                                child: Text(
                                                                    'Vehicle No.',
                                                                    style:
                                                                        iPadYellowTextFontStyleNormal),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                5,
                                                            child: Container(
                                                              height: 40,
                                                              color: Colors
                                                                  .yellow
                                                                  .shade300,
                                                              child: Center(
                                                                child: Text(
                                                                    'Driver Name',
                                                                    style:
                                                                        iPadYellowTextFontStyleNormal),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                5,
                                                            child: Container(
                                                              height: 40,
                                                              color: Colors
                                                                  .yellow
                                                                  .shade300,
                                                              child: Center(
                                                                child: Text(
                                                                    'Mode',
                                                                    style:
                                                                        iPadYellowTextFontStyleNormal),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                4,
                                                            child: Container(
                                                              height: 40,
                                                              color: Colors
                                                                  .yellow
                                                                  .shade300,
                                                              child: Center(
                                                                child: Text(
                                                                    'Time Slot',
                                                                    style:
                                                                        iPadYellowTextFontStyleNormal),
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
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 56,
                                                            child: Container(
                                                              height: 64,
                                                              color: Colors
                                                                  .yellow
                                                                  .shade100,
                                                              child: Center(
                                                                child: Checkbox(
                                                                  value: wtkn
                                                                      .isChecked,
                                                                  onChanged:
                                                                      (newValue) {
                                                                    if (isSaving)
                                                                      return;
                                                                    setState(
                                                                        () {
                                                                      print(newValue
                                                                          .toString());
                                                                      if (newValue ==
                                                                          true)
                                                                        wtkn.isChecked =
                                                                            true;
                                                                      else
                                                                        wtkn.isChecked =
                                                                            false;
                                                                    });
                                                                  },
                                                                ),

                                                                // Text(' ',
                                                                //     style:
                                                                //         iPadYellowTextFontStyleNormal),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                5,
                                                            child: Container(
                                                              height: 64,
                                                              color: Colors
                                                                  .yellow
                                                                  .shade100,
                                                              child: Center(
                                                                child: Text(
                                                                    wtkn.VehicleRegNo
                                                                        .toUpperCase(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        iPadYellowTextFontStyleBold),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                5,
                                                            child: Container(
                                                              height: 64,
                                                              color: Colors
                                                                  .yellow
                                                                  .shade100,
                                                              child: Center(
                                                                child: Text(
                                                                    wtkn.DriverName
                                                                        .toUpperCase(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        iPadYellowTextFontStyleBold),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                5,
                                                            child: Container(
                                                              height: 64,
                                                              color: Colors
                                                                  .yellow
                                                                  .shade100,
                                                              child: Center(
                                                                child: Text(
                                                                    wtkn.Mode
                                                                        .toUpperCase(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        iPadYellowTextFontStyleBold),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                4,
                                                            child: Container(
                                                              height: 64,
                                                              color: Colors
                                                                  .yellow
                                                                  .shade100,
                                                              child: Center(
                                                                child: Text(
                                                                    wtkn.SlotDate
                                                                        .toUpperCase(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        iPadYellowTextFontStyleBold),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // SizedBox(height: 10),
                                                      // Row(
                                                      //   mainAxisAlignment:
                                                      //       MainAxisAlignment.spaceEvenly,
                                                      //   crossAxisAlignment:
                                                      //       CrossAxisAlignment.start,
                                                      //   children: [
                                                      //     Column(
                                                      //       children: [
                                                      //         SizedBox(
                                                      //           width: MediaQuery.of(context)
                                                      //                   .size
                                                      //                   .width /
                                                      //               1.8,
                                                      //           child: Container(
                                                      //             height: 50,
                                                      //             color:
                                                      //                 Colors.yellow.shade300,
                                                      //             child: Center(
                                                      //               child: Text('Time Slot',
                                                      //                   style:
                                                      //                       iPadYellowTextFontStyleNormal),
                                                      //             ),
                                                      //           ),
                                                      //         ),
                                                      //         SizedBox(
                                                      //           width: MediaQuery.of(context)
                                                      //                   .size
                                                      //                   .width /
                                                      //               1.8,
                                                      //           child: Container(
                                                      //             height: 50,
                                                      //             color:
                                                      //                 Colors.yellow.shade100,
                                                      //             child: Center(
                                                      //               child: Text(
                                                      //                   '02-JUL-2022 16:00-17:00',
                                                      //                   style:
                                                      //                       iPadYellowTextFontStyleBold),
                                                      //             ),
                                                      //           ),
                                                      //         ),
                                                      //       ],
                                                      //     ),

                                                      //     // SizedBox(
                                                      //     //   width:
                                                      //     //       MediaQuery.of(context).size.width / 4,
                                                      //     //   child: Container(
                                                      //     //     height: 50,
                                                      //     //     color: Colors.yellow.shade300,
                                                      //     //     child: Center(
                                                      //     //       child: Text(
                                                      //     //         'HAWB No.',
                                                      //     //         style: TextStyle(
                                                      //     //             fontSize: 18,
                                                      //     //             fontWeight: FontWeight.bold,
                                                      //     //             color: Colors.black),
                                                      //     //       ),
                                                      //     //     ),
                                                      //     //   ),
                                                      //     // ),
                                                      //   ],
                                                      // ),

                                                      SizedBox(height: 8),
                                                    ],
                                                  ),
                                                ),
                                              useMobileLayout
                                                  ? SizedBox(height: 10)
                                                  : SizedBox(height: 16),
                                              if (scannedCodeReceived != "" &&
                                                  walkInTokensList.length > 0)
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                      child: Container(
                                                        height: 100,
                                                        color: Colors.white,
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            if (isSaving)
                                                              return;

                                                            List<String>
                                                                checkInSlotsList =
                                                                [];
                                                            for (WalInTokenDetails wtd
                                                                in walkInTokensList) {
                                                              if (wtd.isChecked)
                                                                checkInSlotsList
                                                                    .add(wtd
                                                                        .TokenNo);
                                                            }
                                                            if (checkInSlotsList
                                                                .isEmpty) {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext context) => customAlertMessageDialog(
                                                                    title:
                                                                        "No Records Selected",
                                                                    description:
                                                                        "Select atleast one record to perform Yard Check-in",
                                                                    buttonText:
                                                                        "Okay",
                                                                    imagepath:
                                                                        'assets/images/warn.gif',
                                                                    isMobile:
                                                                        useMobileLayout),
                                                              );
                                                            } else {
                                                              var selectedVT =
                                                                  json.encode(
                                                                      checkInSlotsList);
                                                              selectedVT =
                                                                  selectedVT
                                                                      .toString()
                                                                      .replaceAll(
                                                                          "[",
                                                                          "");
                                                              selectedVT =
                                                                  selectedVT
                                                                      .toString()
                                                                      .replaceAll(
                                                                          "]",
                                                                          "");

                                                              var abc =
                                                                  await performYardCheckIn(
                                                                      checkInSlotsList);

                                                              if (abc ==
                                                                  false) {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext context) => customAlertMessageDialog(
                                                                      title: errMsgText ==
                                                                              ""
                                                                          ? "Error Occured"
                                                                          : "Yard Check-in Failed",
                                                                      description: errMsgText ==
                                                                              ""
                                                                          ? "Error occured while performing Yard Check-in, Please try again after some time"
                                                                          : errMsgText,
                                                                      buttonText:
                                                                          "Okay",
                                                                      imagepath:
                                                                          'assets/images/warn.gif',
                                                                      isMobile:
                                                                          useMobileLayout),
                                                                );
                                                              } else {
                                                                var dlgstatus =
                                                                    await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      CustomDialog(
                                                                    title:
                                                                        'Yard Check-in Success',
                                                                    description:
                                                                        "Yard Check-in for VT# " +
                                                                            selectedVT +
                                                                            " has been completed successfully. You will receive SMS notification shortly.",
                                                                    buttonText:
                                                                        "Okay",
                                                                    imagepath:
                                                                        'assets/images/successchk.gif',
                                                                    isMobile:
                                                                        useMobileLayout,
                                                                  ),
                                                                );
                                                                if (dlgstatus ==
                                                                    true) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          true); // To close the form
                                                                }
                                                              }
                                                            }

                                                            // showDialog(
                                                            //   context: context,
                                                            //   builder: (BuildContext
                                                            //           context) =>
                                                            //       CustomDialog(
                                                            //     title:
                                                            //         "WIVT220627006",
                                                            //     description:
                                                            //         "Yard Check-in recorded successfully for VT# WIVT220627006. You will receive an SMS notification shortly \n\n Kindly proceed for Document Verification.",
                                                            //     buttonText: "Okay",
                                                            //     imagepath:
                                                            //         'assets/images/successchk.gif',
                                                            //     isMobile:
                                                            //         useMobileLayout,
                                                            //   ),
                                                            // );
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            elevation: 4.0,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0)), //
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0.0),
                                                          ),
                                                          child: Container(
                                                            height: 100,
                                                            width: 250,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              gradient:
                                                                  LinearGradient(
                                                                begin: Alignment
                                                                    .topRight,
                                                                end: Alignment
                                                                    .bottomLeft,
                                                                colors: [
                                                                  isSaving
                                                                      ? Colors
                                                                          .grey
                                                                      : Color(
                                                                          0xFF1220BC),
                                                                  isSaving
                                                                      ? Colors
                                                                          .grey
                                                                      : Color(
                                                                          0xFF3540E8),
                                                                ],
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 18.0,
                                                                      bottom:
                                                                          18.0),
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  'Submit',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          24,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //Text('CONTAINED BUTTON'),
                                                        ),
                                                      ),
                                                    ),
                                                    if (isSaving)
                                                      SizedBox(width: 20),
                                                    if (isSaving)
                                                      Center(
                                                          child: Container(
                                                              height: useMobileLayout
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      13
                                                                  : 90,
                                                              width: useMobileLayout
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      13
                                                                  : 90,
                                                              child:
                                                                  CircularProgressIndicator()))
                                                  ],
                                                ),
                                            ],
                                          ),
                                  ),
                              ],
                            ),

                      if (scannedCodeReceived != "")
                        if (useMobileLayout)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, right: 12.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: Container(
                                  height: 50,
                                  color: Colors.white,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // showSuccessMessage();

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomDialog(
                                          title: "WIVT220627006",
                                          description:
                                              "Yard Check-in recorded successfully for VT# WIVT220627006. You will receive SMS notification shortly.",
                                          buttonText: "Okay",
                                          imagepath:
                                              'assets/images/successchk.gif',
                                          isMobile: useMobileLayout,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 4.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)), //
                                      padding: const EdgeInsets.all(0.0),
                                    ),
                                    child: Container(
                                      height: 70,
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
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
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text('Submit',
                                              style: buttonWhiteFontStyle),
                                        ),
                                      ),
                                    ),
                                    //Text('CONTAINED BUTTON'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  getTokenDetailsByVTNO(modeType) async {
    //export 1 , import 2

    if (isLoading) return;

    walkInTokensList = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "OperationType":  scannedCodeReceived.startsWith("I") ? "2" : "1",//modeType.toString(),
      "TokenNo": scannedCodeReceived,
    };
    await Global()
        .postData(
      Settings.SERVICES['SearchByVTNO'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      setState(() {
        walkInTokensList = resp
            .map<WalInTokenDetails>((json) => WalInTokenDetails.fromJson(json))
            .toList();

        print(
            "length walkInTokensList = " + walkInTokensList.length.toString());
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
  }

  Future<bool> performYardCheckIn(checkinList) async {
    //export 1 , import 2
    try {
      bool isValid = false;
      errMsgText = "";
      String responseTextUpdated = "";
      print(json.encode(checkinList));
      // if (isLoading) return;

      setState(() {
        isSaving = true;
      });

      var params = json.encode(checkinList);

      print(params);
      print(json.decode(params));

      var queryParams = {
        "TokenNos": json.decode(params),
      };

      await Global()
          .postData(
        Settings.SERVICES['PerformYardCheckIn'],
        queryParams,
      )
          .then((response) {
        print("data received ");
        print(json.decode(response.body)['d']);

        if (json.decode(response.body)['d'] == null) {
          isValid = true;
        } else {
          if (json.decode(response.body)['d'] == "null") {
            isValid = true;
          } else {
            var responseText = json.decode(response.body)['d'].toString();

            if (responseText.toLowerCase().contains("errormsg")) {
              responseTextUpdated =
                  responseText.toString().replaceAll("ErrorMSG", "");
              responseTextUpdated =
                  responseTextUpdated.toString().replaceAll(":", "");
              responseTextUpdated =
                  responseTextUpdated.toString().replaceAll("\"", "");
              responseTextUpdated =
                  responseTextUpdated.toString().replaceAll("{", "");
              responseTextUpdated =
                  responseTextUpdated.toString().replaceAll("}", "");
              print(responseTextUpdated.toString());
            }
            // print(responseText.toString().replaceAll("ErrorMSG", ""));
            // print(responseText.toString().replaceAll(":", ""));
            // print(responseText.toString().replaceAll("\"", ""));

            isValid = false;
          }
        }

        setState(() {
          isSaving = false;
          if (responseTextUpdated != "") errMsgText = responseTextUpdated;
        });
      }).catchError((onError) {
        setState(() {
          isSaving = false;
        });
        print(onError);
      });

      return isValid;
    } catch (Exc) {
      print(Exc);
      return false;
    }
  }
}
