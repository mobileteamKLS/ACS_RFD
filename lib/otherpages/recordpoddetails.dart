import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:easy_signature_pad/easy_signature_pad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luxair/datastructure/acceptancepod.dart';
import 'package:luxair/widgets/camera_page.dart';
import 'package:luxair/widgets/common.dart';
import 'package:luxair/widgets/customdialogue.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:luxair/widgets/headers.dart';

import '../constants.dart';
import '../global.dart';

class RecordPodDetails extends StatefulWidget {
  final String vtNumber, awbNumber, prefix, hawbnumber;
  RecordPodDetails({
    Key? key,
    required this.vtNumber,
    required this.awbNumber,
    required this.hawbnumber,
    required this.prefix,
  }) : super(key: key);

  @override
  State<RecordPodDetails> createState() => _RecordPodDetailsState();
}

class _RecordPodDetailsState extends State<RecordPodDetails> {
  bool useMobileLayout = false;
  bool isSignature = true;
  XFile userPicture = XFile('');
  bool isLoading = false, isSavingData = false;
  List<AwbPod> awbPodDetails = [];
  TextEditingController txtDamagedPKGS = new TextEditingController();
  TextEditingController txtDriverName = new TextEditingController();
  TextEditingController txtReceivedPKGS = new TextEditingController();
  TextEditingController txtReceivedGRWT = new TextEditingController();
  TextEditingController txtRejectRemarks = new TextEditingController();
  TextEditingController txtDeliverto = new TextEditingController();

  String errMsgText = "";
  bool isValidRcvdPkgs = true;
  bool isValidDmgPkgs = true;
  bool isValidRcvdGrWt = true;
  bool isValidDeliveryRemark = true;

  List<String> rejectionDetails = [];

  int damageTypeSelected = 0,
      acceptanceReasonSelected = 0,
      rejectionReasonSelected = 0;

  String fileInBase64 = "", strImageString = "", strRejectionReasonText = "";

  @override
  void initState() {
    getPODDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = smallestDimension < 600;
    print("useMobileLayout");
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          // ClipPath(
          //   clipper: MyClippers1(),
          //   child: Container(
          //     padding: EdgeInsets.only(left: 40, top: 50, right: 20),
          //    height: MediaQuery.of(context).size.height / 5.2,
          //     width: MediaQuery.of(context).size.width, //180,
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         begin: Alignment.topRight,
          //         end: Alignment.bottomLeft,
          //         colors: [
          //           Color(0xFF3383CD),
          //           Color(0xFF11249F),
          //         ],
          //       ),
          //     ),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.only(top: 20.0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               GestureDetector(
          //                 onTap: () {
          //                   Navigator.of(context).pop();
          //                 },
          //                 child: Center(
          //                   child: Icon(
          //                     Icons.chevron_left,
          //                     size: MediaQuery.of(context).size.width / 18,//56,
          //                     color: Colors.white,
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(width: 20),
          //               Text(
          //                 "Record POD Details ",
          //                 style: TextStyle(
          //                     fontSize: MediaQuery.of(context).size.width / 18,//48,
          //                     fontWeight: FontWeight.normal,
          //                     color: Colors.white),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          HeaderClipperWave(
              color1: Color(0xFF3383CD),
              color2: Color(0xFF11249F),
              headerText: "Record POD Details"),

          Expanded(
            child: SingleChildScrollView(
              child: useMobileLayout
                  ? isLoading
                      ? Center(
                          child: Container(
                              height: 100,
                              width: 100,
                              child: CircularProgressIndicator()))
                      : Padding(
                          padding:
                              const EdgeInsets.only(bottom: 10.0, left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text("AWB Details", style: mobileHeaderFontStyle),
                              SizedBox(height: 5),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.01,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      children: [
                                        //SizedBox(height: 10),
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.spaceEvenly,
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   children: [

                                        //     Container(
                                        //       height: 30,
                                        //       color: Colors.yellow.shade300,
                                        //       child: Center(
                                        //         child: Text('VT No.',
                                        //             style:
                                        //                 mobileYellowTextFontStyleBold),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Container(
                                            height: 30,
                                            color: Colors.yellow.shade300,
                                            child: Center(
                                              child: Text('VT No.',
                                                  style:
                                                      mobileYellowTextFontStyleBold),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Container(
                                            height: 30,
                                            color: Colors.yellow.shade100,
                                            child: Center(
                                              child: Text(widget.vtNumber,
                                                  style:
                                                      mobileDetailsYellowBold),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
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
                                                  2.2,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text('AWB No.',
                                                      style:
                                                          mobileYellowTextFontStyleBold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.2,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text('Hawb No.',
                                                      style:
                                                          mobileYellowTextFontStyleBold),
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
                                                  7,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                      widget.prefix, //  '131',
                                                      style:
                                                          mobileDetailsYellowBold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.3,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(widget.awbNumber,
                                                      style:
                                                          mobileDetailsYellowBold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.2,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                      widget
                                                          .hawbnumber, // 'WIVT220627006',
                                                      style:
                                                          mobileDetailsYellowBold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        //  SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(height: 5),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.01,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      children: [
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
                                                  2.2,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text('Driver Name',
                                                      style:
                                                          mobileYellowTextFontStyleBold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.2,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text('CRN No.',
                                                      style:
                                                          mobileYellowTextFontStyleBold),
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
                                                  2.2,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                      awbPodDetails.isNotEmpty
                                                          ? awbPodDetails[0]
                                                              .DRIVERNAME
                                                          : "",
                                                      style:
                                                          mobileDetailsYellowBold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.2,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                      //'EK507',
                                                      awbPodDetails.isNotEmpty
                                                          ? awbPodDetails[0]
                                                              .Custom_Release_Status
                                                          : "",
                                                      style:
                                                          mobileDetailsYellowBold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
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
                                                  2.2,
                                              child: Container(
                                                height: 60,
                                                color: Colors.yellow.shade300,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Actual \n Packages',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          mobileYellowTextFontStyleBold),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width: MediaQuery.of(context)
                                            //           .size
                                            //           .width /
                                            //       4.5,
                                            //   child: Container(
                                            //     height: 60,
                                            //     color: Colors.yellow.shade300,
                                            //     child: Align(
                                            //       alignment: Alignment.center,
                                            //       child: Text('Received \n NOP',
                                            //           textAlign:
                                            //               TextAlign.center,
                                            //           style:
                                            //               mobileYellowTextFontStyleBold),
                                            //     ),
                                            //   ),
                                            // ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.2,
                                              child: Container(
                                                height: 60,
                                                color: Colors.yellow.shade300,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Actual \n Weight',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          mobileYellowTextFontStyleBold),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width: MediaQuery.of(context)
                                            //           .size
                                            //           .width /
                                            //       4.5,
                                            //   child: Container(
                                            //     height: 60,
                                            //     color: Colors.yellow.shade300,
                                            //     child: Align(
                                            //       alignment: Alignment.center,
                                            //       child: Text(
                                            //           'Received \n Weight',
                                            //           textAlign:
                                            //               TextAlign.center,
                                            //           style:
                                            //               mobileYellowTextFontStyleBold),
                                            //     ),
                                            //   ),
                                            // ),
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
                                                  2.2,
                                              child: Container(
                                                height: 40,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                      //'100',
                                                      awbPodDetails.isNotEmpty
                                                          ? awbPodDetails[0]
                                                              .DONoOfPackage
                                                              .toString()
                                                          : "",
                                                      style:
                                                          mobileDetailsYellowBold),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width: MediaQuery.of(context)
                                            //           .size
                                            //           .width /
                                            //       4.5,
                                            //   child: Container(
                                            //     height: 40,
                                            //     color: Colors.yellow.shade100,
                                            //     child: Center(
                                            //       child: Text(
                                            //           //'100',
                                            //           awbPodDetails.isNotEmpty
                                            //               ? awbPodDetails[0]
                                            //                   .RcvdPKG
                                            //                   .toString()
                                            //               : "",
                                            //           style:
                                            //               mobileDetailsYellowBold),
                                            //     ),
                                            //   ),
                                            // ),

                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.2,
                                              child: Container(
                                                height: 40,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                      //'51267.784',
                                                      awbPodDetails.isNotEmpty
                                                          ? awbPodDetails[0]
                                                              .DOGrossWeight
                                                              .toString()
                                                          : "",
                                                      style:
                                                          mobileDetailsYellowBold),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width: MediaQuery.of(context)
                                            //           .size
                                            //           .width /
                                            //       4.5,
                                            //   child: Container(
                                            //     height: 40,
                                            //     color: Colors.yellow.shade100,
                                            //     child: Center(
                                            //       child: Text(
                                            //           //'51267.78114',
                                            //           awbPodDetails.isNotEmpty
                                            //               ? awbPodDetails[0]
                                            //                   .RcvdGrossWT
                                            //                   .toString()
                                            //               : "",
                                            //           style:
                                            //               mobileDetailsYellowBold),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.01,
                                  child: Card(
                                      child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.2,
                                                          child: Text(
                                                              "Received Pkgs.",
                                                              style:
                                                                  mobileHeaderFontStyle),
                                                        ),
                                                        SizedBox(height: 10),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.2,
                                                          child: Container(
                                                            height: 40,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.2,
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                color: isValidRcvdPkgs
                                                                    ? Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5)
                                                                    : Colors
                                                                        .red,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                            ),
                                                            child: TextField(
                                                              // onChanged: (value) => _runFilter(value),
                                                              controller:
                                                                  txtReceivedPKGS,
                                                              keyboardType: TextInputType
                                                                  .numberWithOptions(
                                                                      decimal:
                                                                          false,
                                                                      signed:
                                                                          true),
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter
                                                                    .allow(RegExp(
                                                                        '[0-9]')),
                                                              ],
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    "Enter Received Pkgs.",
                                                                hintStyle: TextStyle(
                                                                    color: isValidRcvdPkgs
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .red),
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        vertical:
                                                                            8,
                                                                        horizontal:
                                                                            8),
                                                                isDense: true,
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.2,
                                                          child: Text(
                                                              "Received GR. WT.",
                                                              style:
                                                                  mobileHeaderFontStyle),
                                                        ),
                                                        SizedBox(height: 10),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.2,
                                                          child: Container(
                                                            height: 40,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.2,
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                color: isValidRcvdGrWt
                                                                    ? Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5)
                                                                    : Colors
                                                                        .red,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                            ),
                                                            child: TextField(
                                                              // onChanged: (value) => _runFilter(value),
                                                              controller:
                                                                  txtReceivedGRWT,
                                                              keyboardType: TextInputType
                                                                  .numberWithOptions(
                                                                      signed:
                                                                          true,
                                                                      decimal:
                                                                          true),
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter
                                                                    .allow(RegExp(
                                                                        r"[0-9.]")),
                                                                TextInputFormatter
                                                                    .withFunction(
                                                                        (oldValue,
                                                                            newValue) {
                                                                  try {
                                                                    final text =
                                                                        newValue
                                                                            .text;
                                                                    if (text
                                                                        .isNotEmpty)
                                                                      double.parse(
                                                                          text);
                                                                    return newValue;
                                                                  } catch (e) {}
                                                                  return oldValue;
                                                                }),
                                                              ],
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    "Enter Received GR. WT.",
                                                                hintStyle: TextStyle(
                                                                    color: isValidRcvdGrWt
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .red),
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        vertical:
                                                                            8,
                                                                        horizontal:
                                                                            8),
                                                                isDense: true,
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                      ],
                                                    )
                                                  ]),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3.2,
                                                      child: Text("Driver Name",
                                                          style:
                                                              mobileHeaderFontStyle),
                                                    ),
                                                    // SizedBox(width: 10),
                                                    Container(
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.7,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                      child: TextField(
                                                        // onChanged: (value) => _runFilter(value),
                                                        controller:
                                                            txtDriverName,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Enter Driver Name",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          8),
                                                          isDense: true,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3.2,
                                                      child: Text("Deliver to",
                                                          style:
                                                              mobileHeaderFontStyle),
                                                    ),
                                                    // SizedBox(width: 10),
                                                    Container(
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.7,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                      child: TextField(
                                                        // onChanged: (value) => _runFilter(value),
                                                        controller:
                                                            txtDeliverto,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Enter Deliver to",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          8),
                                                          isDense: true,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(height: 10),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3.2,
                                                      child: Text(
                                                          "Delivery Remark",
                                                          style:
                                                              mobileHeaderFontStyle),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.7,
                                                      child: Container(
                                                        height: 40,
                                                        child:
                                                            DropdownButtonFormField(
                                                          isExpanded: true,
                                                          isDense: true,
                                                          //isExpanded: true,
                                                          decoration:
                                                              InputDecoration(
                                                            //labelText: 'select option',
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        8,
                                                                        0,
                                                                        8,
                                                                        0),
                                                            // filled: true,
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  width: 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                            ),
                                                          ),
                                                          dropdownColor:
                                                              Colors.white,
                                                          // value: 'No Damage',
                                                          // items: [
                                                          //   'No Damage',
                                                          //   'Damaged',
                                                          //   'Short Landed',
                                                          //   'Missing Cargo',
                                                          //   'Others'
                                                          // ].map<
                                                          //         DropdownMenuItem<
                                                          //             String>>(
                                                          //     (String value) {
                                                          //   return DropdownMenuItem<
                                                          //       String>(
                                                          //     value: value,
                                                          //     child: Text(
                                                          //       value,
                                                          //     ),
                                                          //   );
                                                          // }).toList(),
                                                          // onChanged: (value) {},

                                                          value:
                                                              acceptanceReasonSelected,
                                                          items:
                                                              acceptanceTypeList
                                                                  .map((at) {
                                                            return DropdownMenuItem(
                                                              child: Text(
                                                                  at.Reason
                                                                      .toUpperCase(),
                                                                  style: useMobileLayout
                                                                      ? mobileTextFontStyle
                                                                      : iPadYellowTextFontStyleBold), //label of item
                                                              value: at
                                                                  .ReasonID, //value of item
                                                            );
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              acceptanceReasonSelected =
                                                                  int.parse(value
                                                                      .toString());
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //   SizedBox(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3.3,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text("Signature",
                                                              style:
                                                                  mobileHeaderFontStyle),
                                                          SizedBox(height: 10),
                                                          Text("OR",
                                                              style:
                                                                  mobileHeaderFontStyle),
                                                          SizedBox(height: 10),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              List<CameraDescription>
                                                                  cameraList =
                                                                  await availableCameras();
                                                              if (cameraList
                                                                  .isNotEmpty) {
                                                                var imagepath = await Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                CameraPage(cameras: cameraList)));

                                                                if (imagepath !=
                                                                    null) if (imagepath != "") {
                                                                  File
                                                                      filenormal =
                                                                      File(imagepath
                                                                          .path);
                                                                  List<int>
                                                                      fileInByte =
                                                                      filenormal
                                                                          .readAsBytesSync();
                                                                  String
                                                                      fileConvertedInBase64 =
                                                                      base64Encode(
                                                                          fileInByte);

                                                                  setState(() {
                                                                    fileInBase64 =
                                                                        fileConvertedInBase64;

                                                                    isSignature =
                                                                        false;
                                                                    signatureBytes =
                                                                        base64Decode(
                                                                            "");

                                                                    userPicture =
                                                                        imagepath;
                                                                  });
                                                                }
                                                              }
                                                            },
                                                            child: Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  9.5, // 65.0,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  9.5, //65.0,
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
                                                                    Color(
                                                                        0xFF1220BC),
                                                                    Color(
                                                                        0xFF3540E8),
                                                                  ],
                                                                ),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .camera_enhance,
                                                                color: Colors
                                                                    .white,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    16, //32,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.7,
                                                      child: Container(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: !isSignature
                                                              ? Stack(
                                                                  children: [
                                                                    Center(
                                                                      child: Image.file(
                                                                          File(userPicture
                                                                              .path),
                                                                          fit: BoxFit
                                                                              .contain),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 8.0),
                                                                        child:
                                                                            IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              isSignature = true;
                                                                              userPicture = XFile('');
                                                                              fileInBase64 = "";
                                                                              signatureBytes = base64Decode("");
                                                                            });
                                                                          },
                                                                          iconSize:
                                                                              24,
                                                                          padding:
                                                                              EdgeInsets.zero,
                                                                          constraints:
                                                                              const BoxConstraints(),
                                                                          icon: const Icon(
                                                                              Icons.close,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : EasySignaturePad(
                                                                  onChanged:
                                                                      (image) {
                                                                    setImage(
                                                                        image);
                                                                    setState(
                                                                        () {
                                                                      strImageString =
                                                                          image;
                                                                    });
                                                                  },
                                                                  penColor: Colors
                                                                      .blue
                                                                      .shade800,
                                                                ),
                                                          // child: Signature(
                                                          //   color: Colors
                                                          //       .black, // Color of the drawing path
                                                          //   strokeWidth: 5.0, // with
                                                          //   backgroundPainter:
                                                          //       null, // Additional custom painter to draw stuff like watermark
                                                          //   onSign:
                                                          //       null, // Callback called on user pan drawing
                                                          //   key:
                                                          //       null, // key that allow you to provide a GlobalKey that'll let you retrieve the image once user has signed
                                                          // ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                            style: BorderStyle
                                                                .solid,
                                                            width: 1.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        height: 200,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )))),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      // if (fileInBase64.isEmpty &&
                                      //     signatureBytes.isEmpty) {
                                      //   showAlertDialog(context, "OK", "Alert",
                                      //       "Photo or Signature is Required");
                                      //   return;
                                      // }

                                      setState(() {
                                        rejectionReasonSelected = 0;
                                        strRejectionReasonText = "";
                                        damageTypeSelected = 0;
                                        txtDamagedPKGS.text = "";
                                        txtRejectRemarks.text = "";
                                        txtReceivedPKGS.text = "";
                                        txtReceivedGRWT.text = "";
                                        acceptanceReasonSelected = 0;
                                        isValidRcvdGrWt = true;
                                        isValidRcvdPkgs = true;
                                      });

                                      rejectionDetails = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5.2,
                                              //  width: MediaQuery.of(context).size.width, //180,
                                              child: AlertDialog(
                                                scrollable: true,
                                                title: Text('Rejection Details',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors
                                                            .red)), // To display the title it is optional
                                                content: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                      child: Text(
                                                        "Rejection Reason",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              Color(0xFF11249F),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      height: 40,
                                                      child:
                                                          DropdownButtonFormField(
                                                        isExpanded: true,
                                                        isDense: true,
                                                        //isExpanded: true,
                                                        decoration:
                                                            InputDecoration(
                                                          //labelText: 'select option',
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(8,
                                                                      0, 8, 0),
                                                          // filled: true,
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                width: 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                          ),
                                                        ),
                                                        dropdownColor:
                                                            Colors.white,
                                                        value:
                                                            rejectionReasonSelected,
                                                        items:
                                                            rejectionReasonsList
                                                                .map((at) {
                                                          return DropdownMenuItem(
                                                            child: Text(
                                                                at.Reason,
                                                                style: useMobileLayout
                                                                    ? mobileTextFontStyle
                                                                    : iPadTextFontStyle), //label of item
                                                            value: at
                                                                .ReasonID, //value of item
                                                          );
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          print(int.parse(value
                                                              .toString()));
                                                          setState(() {
                                                            rejectionReasonSelected =
                                                                int.parse(value
                                                                    .toString());

                                                            List<AcceptanceType>
                                                                matches = [];
                                                            matches.addAll(
                                                                rejectionReasonsList);
                                                            matches.retainWhere(
                                                                (AcceptanceType
                                                                        s) =>
                                                                    s.ReasonID ==
                                                                    value);

                                                            strRejectionReasonText =
                                                                matches[0]
                                                                    .Reason;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text("Damage Type (Opt.)",
                                                        style:
                                                            mobileHeaderFontStyle),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      height: 40,
                                                      child:
                                                          DropdownButtonFormField(
                                                        isExpanded: true,
                                                        isDense: true,
                                                        //isExpanded: true,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(8,
                                                                      0, 8, 0),
                                                          // filled: true,
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                width: 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                          ),
                                                        ),
                                                        dropdownColor:
                                                            Colors.white,
                                                        value:
                                                            damageTypeSelected,
                                                        items: damageTypeList
                                                            .map((dt) {
                                                          return DropdownMenuItem(
                                                            child: Text(
                                                                dt.Damage,
                                                                style: useMobileLayout
                                                                    ? mobileTextFontStyle
                                                                    : iPadYellowTextFontStyleBold), //label of item
                                                            value: dt
                                                                .DamageID, //value of item
                                                          );
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            damageTypeSelected =
                                                                int.parse(value
                                                                    .toString());
                                                          });
                                                        },
                                                        // items: [
                                                        //   'No Damage',
                                                        //   'Physical Damage',
                                                        //   'Wet Damage',
                                                        //   'Reefer Related Damage',
                                                        //   'Infestation Damage'
                                                        // ].map<
                                                        //         DropdownMenuItem<
                                                        //             String>>(
                                                        //     (String value) {
                                                        //   return DropdownMenuItem<
                                                        //       String>(
                                                        //     value: value,
                                                        //     child: Text(
                                                        //       value,
                                                        //     ),
                                                        //   );
                                                        // }).toList(),
                                                        // onChanged: (value) {},
                                                      ),
                                                    ),

                                                    SizedBox(height: 10),
                                                    //rif (damageTypeSelected > 0)
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                      child: Text(
                                                          "Damaged Pieces",
                                                          style:
                                                              mobileHeaderFontStyle),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.7,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: isValidDmgPkgs
                                                              ? Colors.grey
                                                                  .withOpacity(
                                                                      0.5)
                                                              : Colors.red,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                      child: TextField(
                                                        // onChanged: (value) => _runFilter(value),
                                                        controller:
                                                            txtDamagedPKGS,
                                                        keyboardType: TextInputType
                                                            .numberWithOptions(
                                                                decimal: false,
                                                                signed: true),
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  '[0-9]')),
                                                        ],
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Enter Damaged Pieces count",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  isValidDmgPkgs
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .red),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          8),
                                                          isDense: true,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),

                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                      child: Text(
                                                        "Rejection Remark",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              Color(0xFF11249F),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                      child: TextField(
                                                        //  expands: true,
                                                        // minLines: 1,
                                                        controller:
                                                            txtRejectRemarks,
                                                        minLines: 1,
                                                        maxLines:
                                                            5, // allow user to enter 5 line in textfield
                                                        keyboardType: TextInputType
                                                            .multiline, // user keyboard will have a button to move cursor to next line
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Enter Rejection Remarks",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          8),
                                                          isDense: true,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ), // Message which will be pop up on the screen
                                                // Action widget which will provide the user to acknowledge the choice
                                                actions: [
                                                  ElevatedButton(
                                                    //textColor: Colors.black,
                                                    onPressed: () {
                                                      List<String> returnVal =
                                                          [];
                                                      Navigator.of(context)
                                                          .pop(returnVal);
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                  ElevatedButton(
                                                    //textColor: Colors.black,

                                                    onPressed: () {
                                                      //   print(
                                                      //     rejectionReasonSelected);
                                                      // print(txtRejectRemarks);
                                                      print(
                                                          rejectionReasonSelected);
                                                      print(txtRejectRemarks
                                                          .text);

                                                      if (rejectionReasonSelected ==
                                                          0) {
                                                        showAlertDialog(
                                                            context,
                                                            "OK",
                                                            "Alert",
                                                            "Select Rejection Reason");
                                                        return;
                                                      } else {
                                                        if (rejectionReasonSelected ==
                                                            1) {
                                                          if (txtDamagedPKGS
                                                                  .text ==
                                                              "") {
                                                            showAlertDialog(
                                                                context,
                                                                "OK",
                                                                "Alert",
                                                                "Enter damaged pieces quantity");
                                                            return;
                                                          } else {
                                                            if (int.parse(
                                                                    txtDamagedPKGS
                                                                        .text) >
                                                                double.parse(
                                                                    awbPodDetails[
                                                                            0]
                                                                        .DONoOfPackage
                                                                        .toString())) {
                                                              setState(() {
                                                                showAlertDialog(
                                                                    context,
                                                                    "OK",
                                                                    "Alert",
                                                                    "Damaged Pieces quantity must be less than or equal to Actual Packages");

                                                                // isValidDmgPkgs =
                                                                //     false;
                                                              });
                                                            } else {
                                                              if (txtRejectRemarks
                                                                      .text
                                                                      .trim()
                                                                      .toString() ==
                                                                  "") {
                                                                showAlertDialog(
                                                                    context,
                                                                    "OK",
                                                                    "Alert",
                                                                    "Rejection Remark cannot be empty");
                                                              } else {
                                                                List<String>
                                                                    returnVal =
                                                                    [];
                                                                returnVal.add(
                                                                    rejectionReasonSelected
                                                                        .toString());
                                                                returnVal.add(
                                                                    txtRejectRemarks
                                                                        .text
                                                                        .toString());

                                                                Navigator.of(
                                                                        context)
                                                                    .pop(
                                                                        returnVal);
                                                              }
                                                            }
                                                          }
                                                        } else {
                                                          List<String>
                                                              returnVal = [];
                                                          returnVal.add(
                                                              rejectionReasonSelected
                                                                  .toString());
                                                          returnVal.add(
                                                              txtRejectRemarks
                                                                  .text
                                                                  .toString());

                                                          Navigator.of(context)
                                                              .pop(returnVal);
                                                        }
                                                      }
                                                    },
                                                    child: Text('Okay'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                      if (rejectionDetails.isEmpty)
                                        print("User Cancelled");
                                      else {
                                        var submitCheckin =
                                            await submitForPOD();
                                        if (submitCheckin == true) {
                                          var dlgstatus = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CustomDialog(
                                              title: widget.vtNumber,
                                              description: "POD for AWB# " +
                                                  widget.prefix +
                                                  "-" +
                                                  widget.awbNumber +
                                                  " in VT# " +
                                                  widget.vtNumber +
                                                  " has been rejected successfully",
                                              buttonText: "Okay",
                                              imagepath:
                                                  'assets/images/successlines.gif',
                                              isMobile: useMobileLayout,
                                            ),
                                          );
                                          if (dlgstatus == true) {
                                            Navigator.of(context)
                                                .pop(true); // To close the form
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                customAlertMessageDialog(
                                                    title: errMsgText == ""
                                                        ? "Error Occured"
                                                        : "POD Failed",
                                                    description: errMsgText ==
                                                            ""
                                                        ? "Error occured while performing POD, Please try again after some time"
                                                        : errMsgText,
                                                    buttonText: "Okay",
                                                    imagepath:
                                                        'assets/images/warn.gif',
                                                    isMobile: useMobileLayout),
                                          );
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 4.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)), //
                                      padding: const EdgeInsets.all(0.0),
                                    ),

                                    child: Container(
                                      height: 50,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text('Reject',
                                              style: buttonRedFontStyle),
                                        ),
                                      ),
                                    ),
                                    //Text('CONTAINED BUTTON'),
                                  ),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        // isValidDmgPkgs = true;
                                        isValidRcvdGrWt = true;
                                        isValidRcvdPkgs = true;
                                        isValidDeliveryRemark = true;
                                      });
                                      // showSuccessMessage();

                                      if (txtReceivedPKGS.text.isEmpty)
                                        setState(() {
                                          isValidRcvdPkgs = false;
                                        });

                                      if (txtReceivedGRWT.text.isEmpty)
                                        setState(() {
                                          isValidRcvdGrWt = false;
                                        });

                                      if (txtReceivedPKGS.text != "") if (int
                                              .parse(txtReceivedPKGS.text) >
                                          double.parse(awbPodDetails[0]
                                              .DONoOfPackage
                                              .toString()))
                                        setState(() {
                                          showAlertDialog(
                                              context,
                                              "OK",
                                              "Alert",
                                              "Received Packages must be less than or equal to Actual Packages");
                                          isValidRcvdPkgs = false;
                                        });

                                      if (isValidRcvdPkgs) if (txtReceivedGRWT
                                              .text !=
                                          "") if (double.parse(
                                              txtReceivedGRWT.text) >
                                          double.parse(awbPodDetails[0]
                                              .DOGrossWeight
                                              .toString()))
                                        setState(() {
                                          showAlertDialog(
                                              context,
                                              "OK",
                                              "Alert",
                                              "Received GR. WT. must be less than or equal to Actual Weight");

                                          isValidRcvdGrWt = false;
                                        });

                                      // if (isValidRcvdGrWt) if (damageTypeSelected >
                                      //         0 &&
                                      //     txtDamagedPKGS.text == "")
                                      //   setState(() {
                                      //     showAlertDialog(
                                      //         context,
                                      //         "OK",
                                      //         "Alert",
                                      //         "Enter damaged pieces quantity");

                                      //     isValidDmgPkgs = false;
                                      //   });

                                      // if (isValidRcvdGrWt &&
                                      //     isValidDmgPkgs) if (int.parse(
                                      //         txtDamagedPKGS.text) >
                                      //     double.parse(awbPodDetails[0]
                                      //         .DONoOfPackage
                                      //         .toString()))
                                      //   setState(() {
                                      //     showAlertDialog(
                                      //         context,
                                      //         "OK",
                                      //         "Alert",
                                      //         "Damaged Pieces quantity must be less than or equal to Actual Packages");

                                      //     isValidDmgPkgs = false;
                                      //   });

                                      // if (isValidRcvdGrWt &&
                                      //     isValidRcvdPkgs &&
                                      //     isValidDmgPkgs) if (acceptanceReasonSelected == 0)
                                      //   setState(() {
                                      //     showAlertDialog(
                                      //         context,
                                      //         "OK",
                                      //         "Alert",
                                      //         "Delivery Remark cannot be empty");
                                      //     isValidDeliveryRemark = false;
                                      //   });

                                      if (isValidRcvdGrWt && isValidRcvdPkgs) {
                                        if (int.parse(txtReceivedPKGS.text) <
                                            double.parse(awbPodDetails[0]
                                                .DONoOfPackage
                                                .toString())) {
                                          if (acceptanceReasonSelected == 0)
                                            setState(() {
                                              showAlertDialog(
                                                  context,
                                                  "OK",
                                                  "Alert",
                                                  "Delivery Remark cannot be empty");
                                              isValidDeliveryRemark = false;
                                              return;
                                            });
                                        }
                                      }

                                      // return;

                                      if (isValidRcvdGrWt &&
                                          isValidRcvdPkgs &&
                                          isValidDeliveryRemark) {
                                        // print("fileInBase64");
                                        // print(fileInBase64);
                                        // print("signatureBytes");
                                        // print(signatureBytes);

                                        // if (fileInBase64.isEmpty &&
                                        //     signatureBytes.isEmpty) {
                                        //   showAlertDialog(
                                        //       context,
                                        //       "OK",
                                        //       "Alert",
                                        //       "Photo or Signature is Required");
                                        // } else {
                                        var submitCheckin =
                                            await submitForPOD();
                                        if (submitCheckin == true) {
                                          var dlgstatus = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CustomDialog(
                                              title: widget.vtNumber,
                                              description: "POD for AWB# " +
                                                  widget.prefix +
                                                  "-" +
                                                  widget.awbNumber +
                                                  " in VT# " +
                                                  widget.vtNumber +
                                                  " has been completed successfully",
                                              buttonText: "Okay",
                                              imagepath:
                                                  'assets/images/successchk.gif',
                                              isMobile: useMobileLayout,
                                            ),
                                          );
                                          // var isSent = await sendSMS(
                                          //     awbPodDetails[0].MobileNo,
                                          //     widget.vtNumber,
                                          //     awbPodDetails[0].DRIVERNAME);
                                          // if (isSent == true) print("SMS sent");

                                          if (dlgstatus == true) {
                                            Navigator.of(context)
                                                .pop(true); // To close the form
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                customAlertMessageDialog(
                                                    title: errMsgText == ""
                                                        ? "Error Occured"
                                                        : "POD Failed",
                                                    description: errMsgText ==
                                                            ""
                                                        ? "Error occured while performing POD, Please try again after some time"
                                                        : errMsgText,
                                                    buttonText: "Okay",
                                                    imagepath:
                                                        'assets/images/warn.gif',
                                                    isMobile: useMobileLayout),
                                          );
                                        }
                                        // }
                                      }
                                    },

                                    style: ElevatedButton.styleFrom(
                                      elevation: 4.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)), //
                                      padding: const EdgeInsets.all(0.0),
                                    ),
                                    child: Container(
                                      height: 50,
                                      width: 130,
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
                                ],
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        )
                  : isLoading
                      ? Center(
                          child: Container(
                              height: 100,
                              width: 100,
                              child: CircularProgressIndicator()))
                      : Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 40.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                "AWB Details",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF11249F),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.1,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        //SizedBox(height: 10),
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
                                                height: 30,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text(
                                                    'AWB No.',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal,
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
                                                height: 30,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text(
                                                    'Hawb No.',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text(
                                                    'VT No.',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal,
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
                                                  12,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                    widget.prefix, //  '131',,
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
                                                  5.4,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                    widget.awbNumber,
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
                                                height: 30,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                    widget.hawbnumber,
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
                                                  3.5,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                    widget
                                                        .vtNumber, // 'WIVT220627006',
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
                                        //  SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.1,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
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
                                                  2.5,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text(
                                                    'Driver Name',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.5,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text(
                                                    'CRN No.',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal,
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
                                                  2.5,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                    awbPodDetails.isNotEmpty
                                                        ? awbPodDetails[0]
                                                            .DRIVERNAME
                                                        : "",
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
                                                  2.5,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                    awbPodDetails.isNotEmpty
                                                        ? awbPodDetails[0]
                                                            .Custom_Release_Status
                                                        : "",
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
                                        SizedBox(height: 10),
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
                                                  2.5,
                                              child: Container(
                                                height: 60,
                                                color: Colors.yellow.shade300,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Actual \n Packages',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width: MediaQuery.of(context)
                                            //           .size
                                            //           .width /
                                            //       5.3,
                                            //   child: Container(
                                            //     height: 60,
                                            //     color: Colors.yellow.shade300,
                                            //     child: Align(
                                            //       alignment: Alignment.center,
                                            //       child: Text(
                                            //         'Received \n NOP',
                                            //         textAlign: TextAlign.center,
                                            //         style: TextStyle(
                                            //             fontSize: 16,
                                            //             fontWeight:
                                            //                 FontWeight.normal,
                                            //             color: Colors.black),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.5,
                                              child: Container(
                                                height: 60,
                                                color: Colors.yellow.shade300,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Actual \n Weight',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width: MediaQuery.of(context)
                                            //           .size
                                            //           .width /
                                            //       5.3,
                                            //   child: Container(
                                            //     height: 60,
                                            //     color: Colors.yellow.shade300,
                                            //     child: Align(
                                            //       alignment: Alignment.center,
                                            //       child: Text(
                                            //         'Received \n Weight',
                                            //         textAlign: TextAlign.center,
                                            //         style: TextStyle(
                                            //             fontSize: 16,
                                            //             fontWeight:
                                            //                 FontWeight.normal,
                                            //             color: Colors.black),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
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
                                                  2.5,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                    //'100',
                                                    awbPodDetails.isNotEmpty
                                                        ? awbPodDetails[0]
                                                            .DONoOfPackage
                                                            .toString()
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width: MediaQuery.of(context)
                                            //           .size
                                            //           .width /
                                            //       5.3,
                                            //   child: Container(
                                            //     height: 30,
                                            //     color: Colors.yellow.shade100,
                                            //     child: Center(
                                            //       child: Text(
                                            //         //'100',
                                            //         awbPodDetails.isNotEmpty
                                            //             ? awbPodDetails[0]
                                            //                 .RcvdPKG
                                            //                 .toString()
                                            //             : "",
                                            //         style: TextStyle(
                                            //             fontSize: 16,
                                            //             fontWeight:
                                            //                 FontWeight.bold,
                                            //             color: Colors.black),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.5,
                                              child: Container(
                                                height: 30,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                    //'51267.784',
                                                    awbPodDetails.isNotEmpty
                                                        ? awbPodDetails[0]
                                                            .DOGrossWeight
                                                            .toString()
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width: MediaQuery.of(context)
                                            //           .size
                                            //           .width /
                                            //       5.3,
                                            //   child: Container(
                                            //     height: 30,
                                            //     color: Colors.yellow.shade100,
                                            //     child: Center(
                                            //       child: Text(
                                            //         //'51267.78114',
                                            //         awbPodDetails.isNotEmpty
                                            //             ? awbPodDetails[0]
                                            //                 .RcvdGrossWT
                                            //                 .toString()
                                            //             : "",
                                            //         style: TextStyle(
                                            //             fontSize: 16,
                                            //             fontWeight:
                                            //                 FontWeight.bold,
                                            //             color: Colors.black),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        // SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  child: Card(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                      child: Text(
                                                        "Received Packages",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              Color(0xFF11249F),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                      child: Container(
                                                        height: 40,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.2,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: isValidRcvdPkgs
                                                                ? Colors.grey
                                                                    .withOpacity(
                                                                        0.5)
                                                                : Colors.red,
                                                            width: 1.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                        ),
                                                        child: TextField(
                                                          // onChanged: (value) => _runFilter(value),
                                                          controller:
                                                              txtReceivedPKGS,
                                                          keyboardType:
                                                              TextInputType
                                                                  .numberWithOptions(
                                                                      decimal:
                                                                          false,
                                                                      signed:
                                                                          true),
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    '[0-9]')),
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                "Enter Received Packages",
                                                            hintStyle: TextStyle(
                                                                color: isValidRcvdPkgs
                                                                    ? Colors
                                                                        .grey
                                                                    : Colors
                                                                        .red),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            8,
                                                                        horizontal:
                                                                            8),
                                                            isDense: true,
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                      child: Text(
                                                        "Deliver to",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              Color(0xFF11249F),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                      child: Container(
                                                        height: 40,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.2,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            width: 1.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                        ),
                                                        child: TextField(
                                                          // onChanged: (value) => _runFilter(value),
                                                          controller:
                                                              txtDeliverto,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                "Enter Deliver to",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            8,
                                                                        horizontal:
                                                                            8),
                                                            isDense: true,
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                      child: Text(
                                                        "Delivery Remark",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              Color(0xFF11249F),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                      child: Container(
                                                        height: 40,
                                                        child:
                                                            DropdownButtonFormField(
                                                          isExpanded: true,
                                                          isDense: true,
                                                          //isExpanded: true,
                                                          decoration:
                                                              InputDecoration(
                                                            //labelText: 'select option',
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        8,
                                                                        0,
                                                                        8,
                                                                        0),
                                                            // filled: true,
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  width: 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                            ),
                                                          ),
                                                          dropdownColor:
                                                              Colors.white,

                                                          value:
                                                              acceptanceReasonSelected,
                                                          items:
                                                              acceptanceTypeList
                                                                  .map((at) {
                                                            return DropdownMenuItem(
                                                              child: Text(
                                                                  at.Reason,
                                                                  style: useMobileLayout
                                                                      ? mobileTextFontStyle
                                                                      : iPadTextFontStyle), //label of item
                                                              value: at
                                                                  .ReasonID, //value of item
                                                            );
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              acceptanceReasonSelected =
                                                                  int.parse(value
                                                                      .toString());
                                                            });
                                                          },
                                                          // value: 'No Damage',
                                                          // items: [
                                                          //   'No Damage',
                                                          //   'Damaged',
                                                          //   'Short Landed',
                                                          //   'Missing Cargo',
                                                          //   'Others'
                                                          // ].map<
                                                          //     DropdownMenuItem<
                                                          //         String>>((String
                                                          //     value) {
                                                          //   return DropdownMenuItem<
                                                          //       String>(
                                                          //     value: value,
                                                          //     child: Text(
                                                          //       value,
                                                          //     ),
                                                          //   );
                                                          // }).toList(),
                                                          // onChanged: (value) {},
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                  ],
                                                ),
                                                Column(children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    child: Text(
                                                      "Received Gross Weight",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            Color(0xFF11249F),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    child: Container(
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3.2,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: isValidRcvdGrWt
                                                              ? Colors.grey
                                                                  .withOpacity(
                                                                      0.5)
                                                              : Colors.red,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                      child: TextField(
                                                        // onChanged: (value) => _runFilter(value),
                                                        controller:
                                                            txtReceivedGRWT,
                                                        keyboardType: TextInputType
                                                            .numberWithOptions(
                                                                signed: true,
                                                                decimal: true),
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  r"[0-9.]")),
                                                          TextInputFormatter
                                                              .withFunction(
                                                                  (oldValue,
                                                                      newValue) {
                                                            try {
                                                              final text =
                                                                  newValue.text;
                                                              if (text
                                                                  .isNotEmpty)
                                                                double.parse(
                                                                    text);
                                                              return newValue;
                                                            } catch (e) {}
                                                            return oldValue;
                                                          }),
                                                        ],
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Enter Received Gross Weight",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  isValidRcvdGrWt
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .red),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          8),
                                                          isDense: true,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 20.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Signature",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Color(
                                                                0xFF11249F),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          "OR",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Color(
                                                                0xFF11249F),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            List<CameraDescription>
                                                                cameraList =
                                                                await availableCameras();
                                                            if (cameraList
                                                                .isNotEmpty) {
                                                              var imagepath = await Navigator
                                                                      .of(
                                                                          context)
                                                                  .push(MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          CameraPage(
                                                                              cameras: cameraList)));

                                                              if (imagepath !=
                                                                  null) if (imagepath != "") {
                                                                File
                                                                    filenormal =
                                                                    File(imagepath
                                                                        .path);
                                                                List<int>
                                                                    fileInByte =
                                                                    filenormal
                                                                        .readAsBytesSync();
                                                                String
                                                                    fileConvertedInBase64 =
                                                                    base64Encode(
                                                                        fileInByte);

                                                                setState(() {
                                                                  fileInBase64 =
                                                                      fileConvertedInBase64;

                                                                  isSignature =
                                                                      false;
                                                                  signatureBytes =
                                                                      base64Decode(
                                                                          "");
                                                                  userPicture =
                                                                      imagepath;
                                                                });
                                                              }
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 32.0,
                                                            width: 32.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              gradient:
                                                                  LinearGradient(
                                                                begin: Alignment
                                                                    .topRight,
                                                                end: Alignment
                                                                    .bottomLeft,
                                                                colors: [
                                                                  Color(
                                                                      0xFF1220BC),
                                                                  Color(
                                                                      0xFF3540E8),
                                                                ],
                                                              ),
                                                            ),
                                                            child: Icon(
                                                              Icons
                                                                  .camera_enhance,
                                                              color:
                                                                  Colors.white,
                                                              size: 18,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    child: Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: !isSignature
                                                            ? Stack(
                                                                children: [
                                                                  Center(
                                                                    child: Image.file(
                                                                        File(userPicture
                                                                            .path),
                                                                        fit: BoxFit
                                                                            .contain),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              8.0),
                                                                      child:
                                                                          IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            isSignature =
                                                                                true;
                                                                            userPicture =
                                                                                XFile('');
                                                                            fileInBase64 =
                                                                                "";
                                                                            signatureBytes =
                                                                                base64Decode("");
                                                                          });
                                                                        },
                                                                        iconSize:
                                                                            24,
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        constraints:
                                                                            const BoxConstraints(),
                                                                        icon: const Icon(
                                                                            Icons
                                                                                .close,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : EasySignaturePad(
                                                                onChanged:
                                                                    (image) {
                                                                  setImage(
                                                                      image);
                                                                  setState(() {
                                                                    strImageString =
                                                                        image;
                                                                  });
                                                                },
                                                                penColor: Colors
                                                                    .blue
                                                                    .shade800,
                                                              ),
                                                        // child: Signature(
                                                        //   color: Colors
                                                        //       .black, // Color of the drawing path
                                                        //   strokeWidth: 5.0, // with
                                                        //   backgroundPainter:
                                                        //       null, // Additional custom painter to draw stuff like watermark
                                                        //   onSign:
                                                        //       null, // Callback called on user pan drawing
                                                        //   key:
                                                        //       null, // key that allow you to provide a GlobalKey that'll let you retrieve the image once user has signed
                                                        // ),
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          style:
                                                              BorderStyle.solid,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      height: 200,
                                                    ),
                                                  ),
                                                ]),
                                              ])))),
                              SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.only(right: 40.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        // if (fileInBase64.isEmpty &&
                                        //     signatureBytes.isEmpty) {
                                        //   showAlertDialog(
                                        //       context,
                                        //       "OK",
                                        //       "Alert",
                                        //       "Photo or Signature is Required");
                                        //   return;
                                        // }

                                        setState(() {
                                          rejectionReasonSelected = 0;
                                          strRejectionReasonText ="";
                                          damageTypeSelected = 0;
                                          txtDamagedPKGS.text = "";
                                          txtRejectRemarks.text = "";
                                          txtReceivedPKGS.text = "";
                                          txtReceivedGRWT.text = "";
                                          acceptanceReasonSelected = 0;
                                          isValidRcvdPkgs = true;
                                          isValidRcvdGrWt = true;
                                        });
                                        rejectionDetails = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    5.2,
                                                //  width: MediaQuery.of(context).size.width, //180,
                                                child: AlertDialog(
                                                  scrollable: true,
                                                  title: Text(
                                                      'Rejection Details',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors
                                                              .red)), // To display the title it is optional
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        child: Text(
                                                          "Rejection Reason",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Color(
                                                                0xFF11249F),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        child: Container(
                                                          height: 40,
                                                          child:
                                                              DropdownButtonFormField(
                                                            isExpanded: true,
                                                            isDense: true,
                                                            //isExpanded: true,
                                                            decoration:
                                                                InputDecoration(
                                                              //labelText: 'select option',
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          8,
                                                                          0,
                                                                          8,
                                                                          0),
                                                              // filled: true,
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
                                                                    width: 1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                              ),
                                                            ),

                                                            dropdownColor:
                                                                Colors.white,
                                                            value:
                                                                rejectionReasonSelected,
                                                            items:
                                                                rejectionReasonsList
                                                                    .map((at) {
                                                              return DropdownMenuItem(
                                                                child: Text(
                                                                    at.Reason,
                                                                    style: useMobileLayout
                                                                        ? mobileTextFontStyle
                                                                        : iPadTextFontStyle), //label of item
                                                                value: at
                                                                    .ReasonID, //value of item
                                                              );
                                                            }).toList(),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                rejectionReasonSelected =
                                                                    int.parse(value
                                                                        .toString());

                                                                          List<AcceptanceType>
                                                                matches = [];
                                                            matches.addAll(
                                                                rejectionReasonsList);
                                                            matches.retainWhere(
                                                                (AcceptanceType
                                                                        s) =>
                                                                    s.ReasonID ==
                                                                    value);

                                                            strRejectionReasonText =
                                                                matches[0]
                                                                    .Reason;

                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        child: Text(
                                                          "Damage Type (Opt.)",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Color(
                                                                0xFF11249F),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        child: Container(
                                                          height: 40,
                                                          child:
                                                              DropdownButtonFormField(
                                                            isExpanded: true,
                                                            isDense: true,
                                                            //isExpanded: true,
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          8,
                                                                          0,
                                                                          8,
                                                                          0),
                                                              // filled: true,
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
                                                                    width: 1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                              ),
                                                            ),
                                                            dropdownColor:
                                                                Colors.white,
                                                            value:
                                                                damageTypeSelected,
                                                            items:
                                                                damageTypeList
                                                                    .map((dt) {
                                                              return DropdownMenuItem(
                                                                child: Text(
                                                                    dt.Damage,
                                                                    style: useMobileLayout
                                                                        ? mobileTextFontStyle
                                                                        : iPadTextFontStyle), //label of item
                                                                value: dt
                                                                    .DamageID, //value of item
                                                              );
                                                            }).toList(),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                damageTypeSelected =
                                                                    int.parse(value
                                                                        .toString());
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        child: Text(
                                                          "Damaged Pieces",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Color(
                                                                0xFF11249F),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        child: Container(
                                                          height: 40,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3.2,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: isValidDmgPkgs
                                                                  ? Colors.grey
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : Colors.red,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                          ),
                                                          child: TextField(
                                                            // onChanged: (value) => _runFilter(value),
                                                            controller:
                                                                txtDamagedPKGS,
                                                            keyboardType: TextInputType
                                                                .numberWithOptions(
                                                                    decimal:
                                                                        false,
                                                                    signed:
                                                                        true),
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      '[0-9]')),
                                                            ],
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  "Enter Damaged Pieces count",
                                                              hintStyle: TextStyle(
                                                                  color: isValidDmgPkgs
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .red),
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          8),
                                                              isDense: true,
                                                            ),
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        child: Text(
                                                          "Rejection Remark",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Color(
                                                                0xFF11249F),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Container(
                                                        height: 150,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            width: 1.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                        ),
                                                        child: TextField(
                                                          //  expands: true,
                                                          // minLines: 1,
                                                          controller:
                                                              txtRejectRemarks,
                                                          minLines: 1,
                                                          maxLines:
                                                              5, // allow user to enter 5 line in textfield
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline, // user keyboard will have a button to move cursor to next line
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                "Enter Rejection Remarks",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            8,
                                                                        horizontal:
                                                                            8),
                                                            isDense: true,
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ), // Message which will be pop up on the screen
                                                  // Action widget which will provide the user to acknowledge the choice
                                                  actions: [
                                                    ElevatedButton(
                                                      //textColor: Colors.black,
                                                      onPressed: () {
                                                        List<String> returnVal =
                                                            [];
                                                        Navigator.of(context)
                                                            .pop(returnVal);
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    ElevatedButton(
                                                      //textColor: Colors.black,
                                                      onPressed: () {
                                                        //   print(
                                                        //     rejectionReasonSelected);
                                                        // print(txtRejectRemarks);
                                                        print(
                                                            rejectionReasonSelected);
                                                        print(txtRejectRemarks
                                                            .text);

                                                        if (rejectionReasonSelected ==
                                                            0) {
                                                          showAlertDialog(
                                                              context,
                                                              "OK",
                                                              "Alert",
                                                              "Select Rejection Reason");
                                                          return;
                                                        } else {
                                                          if (rejectionReasonSelected ==
                                                              1) {
                                                            if (txtDamagedPKGS
                                                                    .text ==
                                                                "") {
                                                              showAlertDialog(
                                                                  context,
                                                                  "OK",
                                                                  "Alert",
                                                                  "Enter damaged pieces quantity");
                                                              return;
                                                            } else {
                                                              if (int.parse(
                                                                      txtDamagedPKGS
                                                                          .text) >
                                                                  double.parse(
                                                                      awbPodDetails[
                                                                              0]
                                                                          .DONoOfPackage
                                                                          .toString())) {
                                                                setState(() {
                                                                  showAlertDialog(
                                                                      context,
                                                                      "OK",
                                                                      "Alert",
                                                                      "Damaged Pieces quantity must be less than or equal to Actual Packages");

                                                                  // isValidDmgPkgs =
                                                                  //     false;
                                                                });
                                                              } else {
                                                                if (txtRejectRemarks
                                                                        .text
                                                                        .trim()
                                                                        .toString() ==
                                                                    "") {
                                                                  showAlertDialog(
                                                                      context,
                                                                      "OK",
                                                                      "Alert",
                                                                      "Rejection Remark cannot be empty");
                                                                } else {
                                                                  List<String>
                                                                      returnVal =
                                                                      [];
                                                                  returnVal.add(
                                                                      rejectionReasonSelected
                                                                          .toString());
                                                                  returnVal.add(
                                                                      txtRejectRemarks
                                                                          .text
                                                                          .toString());

                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          returnVal);
                                                                }
                                                              }
                                                            }
                                                          } else {
                                                            List<String>
                                                                returnVal = [];
                                                            returnVal.add(
                                                                rejectionReasonSelected
                                                                    .toString());
                                                            returnVal.add(
                                                                txtRejectRemarks
                                                                    .text
                                                                    .toString());

                                                            Navigator.of(
                                                                    context)
                                                                .pop(returnVal);
                                                          }
                                                        }
                                                      },
                                                      child: Text('Okay'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                        if (rejectionDetails.isEmpty)
                                          print("User Cancelled");
                                        else {
                                          var submitCheckin =
                                              await submitForPOD();
                                          if (submitCheckin == true) {
                                            var dlgstatus = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomDialog(
                                                title: widget.vtNumber,
                                                description: "POD for AWB# " +
                                                    widget.prefix +
                                                    "-" +
                                                    widget.awbNumber +
                                                    " in VT# " +
                                                    widget.vtNumber +
                                                    " has been rejected successfully",
                                                buttonText: "Okay",
                                                imagepath:
                                                    'assets/images/successlines.gif',
                                                isMobile: useMobileLayout,
                                              ),
                                            );
                                            if (dlgstatus == true) {
                                              Navigator.of(context).pop(
                                                  true); // To close the form
                                            }
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  customAlertMessageDialog(
                                                      title: errMsgText == ""
                                                          ? "Error Occured"
                                                          : "POD Failed",
                                                      description: errMsgText ==
                                                              ""
                                                          ? "Error occured while performing POD, Please try again after some time"
                                                          : errMsgText,
                                                      buttonText: "Okay",
                                                      imagepath:
                                                          'assets/images/warn.gif',
                                                      isMobile:
                                                          useMobileLayout),
                                            );
                                          }
                                        }
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
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 18.0, bottom: 18.0),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Reject',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //Text('CONTAINED BUTTON'),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () async {
                                        // showSuccessMessage();
                                        setState(() {
                                          // isValidDmgPkgs = true;
                                          isValidRcvdGrWt = true;
                                          isValidRcvdPkgs = true;
                                          isValidDeliveryRemark = true;
                                        });

                                        if (txtReceivedPKGS.text.isEmpty)
                                          setState(() {
                                            isValidRcvdPkgs = false;
                                          });

                                        if (txtReceivedGRWT.text.isEmpty)
                                          setState(() {
                                            isValidRcvdGrWt = false;
                                          });

                                        if (txtReceivedPKGS.text != "") if (int
                                                .parse(txtReceivedPKGS.text) >
                                            double.parse(awbPodDetails[0]
                                                .DONoOfPackage
                                                .toString()))
                                          setState(() {
                                            showAlertDialog(
                                                context,
                                                "OK",
                                                "Alert",
                                                "Received Packages must be less than or equal to Actual Packages");
                                            isValidRcvdPkgs = false;
                                          });

                                        if (isValidRcvdPkgs) if (txtReceivedGRWT
                                                .text !=
                                            "") if (double.parse(
                                                txtReceivedGRWT.text) >
                                            double.parse(awbPodDetails[0]
                                                .DOGrossWeight
                                                .toString()))
                                          setState(() {
                                            showAlertDialog(
                                                context,
                                                "OK",
                                                "Alert",
                                                "Received GR. WT. must be less than or equal to Actual Weight");

                                            isValidRcvdGrWt = false;
                                          });

                                        // if (isValidRcvdGrWt) if (damageTypeSelected >
                                        //         0 &&
                                        //     txtDamagedPKGS.text == "")
                                        //   setState(() {
                                        //     showAlertDialog(
                                        //         context,
                                        //         "OK",
                                        //         "Alert",
                                        //         "Enter damaged pieces quantity");

                                        //     isValidDmgPkgs = false;
                                        //   });

                                        // if (isValidRcvdGrWt &&
                                        //     isValidDmgPkgs) if (int.parse(
                                        //         txtDamagedPKGS.text) >
                                        //     double.parse(awbPodDetails[0]
                                        //         .DONoOfPackage
                                        //         .toString()))
                                        //   setState(() {
                                        //     showAlertDialog(
                                        //         context,
                                        //         "OK",
                                        //         "Alert",
                                        //         "Damaged Pieces quantity must be less than or equal to Actual Packages");

                                        //     isValidDmgPkgs = false;
                                        //   });

                                        if (isValidRcvdGrWt &&
                                            isValidRcvdPkgs) {
                                          if (int.parse(txtReceivedPKGS.text) <
                                              double.parse(awbPodDetails[0]
                                                  .DONoOfPackage
                                                  .toString())) {
                                            if (acceptanceReasonSelected == 0)
                                              setState(() {
                                                showAlertDialog(
                                                    context,
                                                    "OK",
                                                    "Alert",
                                                    "Delivery Remark cannot be empty");
                                                isValidDeliveryRemark = false;
                                                return;
                                              });
                                          }
                                        }
                                        if (isValidRcvdGrWt &&
                                            isValidRcvdPkgs &&
                                            isValidDeliveryRemark) {
                                          // print("fileInBase64");
                                          // print(fileInBase64);
                                          // print("signatureBytes");
                                          // print(signatureBytes);

                                          // if (fileInBase64.isEmpty &&
                                          //     signatureBytes.isEmpty) {
                                          //   showAlertDialog(
                                          //       context,
                                          //       "OK",
                                          //       "Alert",
                                          //       "Photo or Signature is Required");
                                          // } else {
                                          var submitCheckin =
                                              await submitForPOD();
                                          if (submitCheckin == true) {
                                            var dlgstatus = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomDialog(
                                                title: widget.vtNumber,
                                                description: "POD for AWB# " +
                                                    widget.prefix +
                                                    "-" +
                                                    widget.awbNumber +
                                                    " in VT# " +
                                                    widget.vtNumber +
                                                    " has been completed successfully",
                                                buttonText: "Okay",
                                                imagepath:
                                                    'assets/images/successchk.gif',
                                                isMobile: useMobileLayout,
                                              ),
                                            );
                                            if (dlgstatus == true) {
                                              Navigator.of(context).pop(
                                                  true); // To close the form
                                            }
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  customAlertMessageDialog(
                                                      title: errMsgText == ""
                                                          ? "Error Occured"
                                                          : "POD Failed",
                                                      description: errMsgText ==
                                                              ""
                                                          ? "Error occured while performing POD, Please try again after some time"
                                                          : errMsgText,
                                                      buttonText: "Okay",
                                                      imagepath:
                                                          'assets/images/warn.gif',
                                                      isMobile:
                                                          useMobileLayout),
                                            );
                                          }
                                        }
                                        //  }
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
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                              top: 18.0, bottom: 18.0),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ),
        ]));
  }

  // process the base64 image
  Uint8List signatureBytes = base64Decode("");
  void setImage(String bytes) async {
    if (bytes.isNotEmpty) {
      Uint8List convertedBytes = base64Decode(bytes);
      setState(() {
        signatureBytes = convertedBytes;
      });
    }

    // else {
    //   setState(() {
    //     signatureBytes = null;
    //   });
    // }
  }

  getPODDetails() async {
    if (isLoading) return;

    awbPodDetails = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "OperationType": "6",
      "AirlinePrefix": widget.prefix.toString(),
      "AwbNumber": widget.awbNumber.toString(),
      "HawbNumber": widget.hawbnumber.toString(),
      "CreatedByUserId": loggedinUser.CreatedByUserId.toString(),
      "OrganizationId": loggedinUser.OrganizationId.toString(),
      "VehicleTokenNo": widget.vtNumber.toString(),
      "OrganizationBranchId":
          selectedTerminalID, // loggedinUser.OrganizationBranchId,
    };
    await Global()
        .postData(
      Settings.SERVICES['GetPODDets'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);
      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      setState(() {
        awbPodDetails =
            resp.map<AwbPod>((json) => AwbPod.fromJson(json)).toList();

        if (awbPodDetails.isNotEmpty)
          txtDriverName.text = awbPodDetails[0].DRIVERNAME;

        print("length awbPodDetails = " + awbPodDetails.length.toString());
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
  }

  Future<bool> submitForPOD() async {
    try {
      bool isValid = false;
      errMsgText = "";
      String responseTextUpdated = "";

      setState(() {
        isSavingData = true;
      });
      showSavingDialog(context, true);
      var queryParams = {
        "OperationType": "1",
        "AirlinePrefix": awbPodDetails[0].AirlinePrefix.toString(),
        "MAWBNumber": awbPodDetails[0].MAWBNumber.toString(),
        "HAWBNumber": awbPodDetails[0].HAWBNumber.toString(),
        "Pieces":
            txtReceivedPKGS.text == "" ? "0" : txtReceivedPKGS.text.toString(),
        "Weight":
            txtReceivedGRWT.text == "" ? "0" : txtReceivedGRWT.text.toString(),
        "DeliveryTo": txtDeliverto.text,
        "DriverName":
            txtDriverName.text, //  awbPodDetails[0].DRIVERNAME.toString(),
        "DelivaryStatus": null,
        "IsDeleted": "false",
        "CreatedBy": awbPodDetails[0].CreatedById.toString(),
        // "_imageDataFromCamera": "",
        // "signitureDataURL": "",
        "TOKENNO": awbPodDetails[0].TOKENNO.toString(),
        "ROWID": awbPodDetails[0].ROWID,
        "DamageType": damageTypeSelected,
        "DamagePieces":
            txtDamagedPKGS.text == "" ? 0 : int.parse(txtDamagedPKGS.text),
        "Reason":rejectionReasonSelected > 0
            ? rejectionReasonSelected.toString()
            : 0,
        "Remark": txtRejectRemarks.text,
        "p_LoginUser": loggedinUser.Name,
        "p_LoginEmailId": loggedinUser.EmailId,
        "p_rejectedReasonText":strRejectionReasonText, /// 
           
        "VehicleTokenID": awbPodDetails[0].VehicleTokenID.toString(),
        "AcceptanceReason": acceptanceReasonSelected,
        '_imageDataFromCamera': isSignature ? "" : fileInBase64.toString(),
        'signitureDataURL': isSignature ? strImageString.toString() : "",
      };
      // print(queryParams);
      // return true;

      await Global()
          .postData(
        Settings.SERVICES['PerformPOD'],
        queryParams,
      )
          .then((response) {
        print("data received ");
        print(json.decode(response.body)['d']);
        // isValid = true;
        showSavingDialog(context, false);
        if (json.decode(response.body)['d'] == null) {
          isValid = true;
        } else {
          if (json.decode(response.body)['d'] == "null") {
            isValid = true;
          } else {
            if (json.decode(response.body)['d'] == "") {
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
        }

        setState(() {
          isSavingData = false;
          if (responseTextUpdated != "") errMsgText = responseTextUpdated;
        });
      }).catchError((onError) {
        showSavingDialog(context, false);
        setState(() {
          isSavingData = false;
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
