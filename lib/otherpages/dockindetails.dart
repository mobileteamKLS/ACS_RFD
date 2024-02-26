import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luxair/datastructure/vehicletoken.dart';
import 'package:luxair/widgets/common.dart';
import 'package:luxair/widgets/customdialogue.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:luxair/widgets/headers.dart';

import '../constants.dart';
import '../global.dart';

class DockInDetails extends StatefulWidget {
  bool isExport = false;
  final DockInOutVT selectedVtDetails;
  DockInDetails(
      {Key? key, required this.isExport, required this.selectedVtDetails})
      : super(key: key);

  @override
  State<DockInDetails> createState() => _DockInDetailsState();
}

class _DockInDetailsState extends State<DockInDetails> {
  bool useMobileLayout = false, isLoading = false, isSavingData = false;
  TextEditingController txtVTNO = new TextEditingController();
  List<DockInOutVTDetails> dockInOutDets = [];
  String errMsgText = "";

  @override
  void initState() {
    txtVTNO.text = widget.selectedVtDetails.VTNo; //"WIVT220627006";

    if (!widget.isExport) getTokenDetails(2);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = smallestDimension < 600;
    print("useMobileLayout");
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          HeaderClipperWave(
              color1: Color(0xFF3383CD),
              color2: Color(0xFF11249F),
              headerText: "Dock-In Details"),
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
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF11249F),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: useMobileLayout
                              ? MediaQuery.of(context).size.width / 1.8
                              : MediaQuery.of(context).size.width /
                                  2.5, // hard coding child width
                          child: Container(
                            height: useMobileLayout ? 40 : 65,
                            width: MediaQuery.of(context).size.width / 2.5,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextField(
                              controller: txtVTNO,
                              readOnly: true,
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
                        //SizedBox(width: 20),
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     elevation: 4.0,
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(10.0)), //
                        //     padding: const EdgeInsets.all(0.0),
                        //   ),
                        //   child: Container(
                        //     height: 65.0,
                        //     width: 65.0,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //       gradient: LinearGradient(
                        //         begin: Alignment.topRight,
                        //         end: Alignment.bottomLeft,
                        //         colors: [
                        //           Color(0xFF1220BC),
                        //           Color(0xFF3540E8),
                        //         ],
                        //       ),
                        //     ),
                        //     child: Icon(
                        //       Icons.search,
                        //       size: 32,
                        //     ),
                        //   ),
                        //   onPressed: () {},
                        // ),
                        // SizedBox(width: 20),
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     elevation: 4.0,
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(10.0)), //
                        //     padding: const EdgeInsets.all(0.0),
                        //   ),
                        //   child: Container(
                        //     height: 65.0,
                        //     width: 65.0,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //       gradient: LinearGradient(
                        //         begin: Alignment.topRight,
                        //         end: Alignment.bottomLeft,
                        //         colors: [
                        //           Color(0xFF1e81b0),
                        //           Color(0xFF0b65c5),
                        //         ],
                        //       ),
                        //     ),
                        //     child: Icon(
                        //       Icons.scanner,
                        //       size: 32,
                        //     ),
                        //   ),
                        //   onPressed: () {},
                        // ),

                        // IconButton(
                        //   iconSize: 48,
                        //   color: Colors.green,
                        //   splashColor: Colors.purple,
                        //   icon: const Icon(
                        //     Icons.add,
                        //   ),
                        //   onPressed: () {},
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: useMobileLayout
                        ? const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 10.0)
                        : const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 16.0),
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
                        if (!isLoading)
                          Text(
                            "Vehicle Details",
                            style: useMobileLayout
                                ? mobileHeaderFontStyle
                                : TextStyle(
                                    fontSize: 28,
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
                                                                widget
                                                                    .selectedVtDetails
                                                                    .VEHICLENO
                                                                    .toUpperCase(),
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
                                                                widget
                                                                    .selectedVtDetails
                                                                    .DRIVERNAME
                                                                    .toUpperCase(),
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
                                                                widget
                                                                    .selectedVtDetails
                                                                    .SLOTTIME,
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

                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment.spaceEvenly,
                                                  //   crossAxisAlignment:
                                                  //       CrossAxisAlignment.start,
                                                  //   children: [
                                                  //     SizedBox(
                                                  //       width: MediaQuery.of(context)
                                                  //               .size
                                                  //               .width /
                                                  //           2.2,
                                                  //       child: Container(
                                                  //         height: 40,
                                                  //         color: Colors.yellow.shade300,
                                                  //         child: Center(
                                                  //           child: Text(
                                                  //               'Slot/ Dock Details',
                                                  //               style:
                                                  //                   mobileYellowTextFontStyleBold),
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //     SizedBox(
                                                  //       width: MediaQuery.of(context)
                                                  //               .size
                                                  //               .width /
                                                  //           2.2,
                                                  //       child: Container(
                                                  //         height: 40,
                                                  //         color: Colors.yellow.shade300,
                                                  //         child: Center(
                                                  //           child: Text('Flt Arr.',
                                                  //               style:
                                                  //                   mobileYellowTextFontStyleBold),
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // ),

                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment.spaceEvenly,
                                                  //   crossAxisAlignment:
                                                  //       CrossAxisAlignment.start,
                                                  //   children: [
                                                  //     SizedBox(
                                                  //       width: MediaQuery.of(context)
                                                  //               .size
                                                  //               .width /
                                                  //           2.2,
                                                  //       child: Container(
                                                  //         height: 40,
                                                  //         color: Colors.yellow.shade100,
                                                  //         child: Center(
                                                  //           child: Text(
                                                  //               widget.selectedVtDetails
                                                  //                   .SLOTTIME,
                                                  //               style:
                                                  //                   mobileDetailsYellowBold),
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //     SizedBox(
                                                  //       width: MediaQuery.of(context)
                                                  //               .size
                                                  //               .width /
                                                  //           2.2,
                                                  //       child: Container(
                                                  //         height: 40,
                                                  //         color: Colors.yellow.shade100,
                                                  //         child: Center(
                                                  //           child: Text('18:00',
                                                  //               style:
                                                  //                   mobileDetailsYellowBold),
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  // SizedBox(
                                                  //     height: useMobileLayout ? 10 : 20),
                                                  //  SizedBox(height: 20),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (!widget.isExport)
                                            SizedBox(
                                                height:
                                                    useMobileLayout ? 5 : 40),
                                          if (!widget.isExport)
                                            Text(
                                              "Shipment Details",
                                              textAlign: TextAlign.start,
                                              style: useMobileLayout
                                                  ? mobileHeaderFontStyle
                                                  : TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Color(0xFF11249F),
                                                    ),
                                            ),
                                          if (!widget.isExport)
                                            SizedBox(
                                                height:
                                                    useMobileLayout ? 5 : 40),
                                          for (DockInOutVTDetails dvd
                                              in dockInOutDets)
                                            Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
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
                                                            color: Colors.yellow
                                                                .shade300,
                                                            child: Center(
                                                              child: Text(
                                                                  'AWB No.',
                                                                  style:
                                                                      mobileYellowTextFontStyleBold),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 3),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.3,
                                                          child: Container(
                                                            height: 30,
                                                            color: Colors.yellow
                                                                .shade300,
                                                            child: Center(
                                                              child: Text(
                                                                  'HAWB No.',
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
                                                              .start,
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
                                                            color: Colors.yellow
                                                                .shade100,
                                                            child: Center(
                                                              child: Text(
                                                                  dvd.AirlinePrefix +
                                                                      "-" +
                                                                      dvd
                                                                          .MAWBNumber,
                                                                  style:
                                                                      mobileDetailsYellowBold),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 3),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.3,
                                                          child: Container(
                                                            height: 30,
                                                            color: Colors.yellow
                                                                .shade100,
                                                            child: Center(
                                                              child: Text(
                                                                  dvd
                                                                      .HAWBNumber,
                                                                  style:
                                                                      mobileDetailsYellowBold),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    // SizedBox(
                                                    //     height: useMobileLayout ? 10 : 20),

                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.6,
                                                          child: Container(
                                                            height: 30,
                                                            color: Colors.yellow
                                                                .shade300,
                                                            child: Center(
                                                              child: Text(
                                                                  'Flt Arr',
                                                                  style:
                                                                      mobileYellowTextFontStyleBold),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 2),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                          child: Container(
                                                            height: 30,
                                                            color: Colors.yellow
                                                                .shade300,
                                                            child: Center(
                                                              child: Text('CRN',
                                                                  style:
                                                                      mobileYellowTextFontStyleBold),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 2),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                          child: Container(
                                                            height: 30,
                                                            color: Colors.yellow
                                                                .shade300,
                                                            child: Center(
                                                              child: Text(
                                                                  'Pmt Cnf.',
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
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.6,
                                                          child: Container(
                                                            height: 30,
                                                            color: Colors.yellow
                                                                .shade100,
                                                            child: Center(
                                                                child: Text(
                                                                    dvd.FlightArrivalStatus ==
                                                                            ""
                                                                        ? ""
                                                                        : dvd.FlightArrivalStatus.toString().substring(
                                                                            0,
                                                                            12), //dvd.FlightArrivalStatus,
                                                                    style:
                                                                        mobileDetailsYellowBold)

                                                                //       dvd.FlightArrivalStatus ==
                                                                //     false
                                                                // ? Text(" -- ",
                                                                //     style:
                                                                //         mobileDetailsYellowBold)
                                                                // : Icon(
                                                                //     Icons
                                                                //         .task_alt,
                                                                //     size: 28,
                                                                //     color: Colors
                                                                //         .green,
                                                                //   ),
                                                                ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 2),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                          child: Container(
                                                            height: 30,
                                                            color: Colors.yellow
                                                                .shade100,
                                                            child: Center(
                                                                child: dvd.CustomReleaseNumber ==
                                                                        ""
                                                                    ? Text(
                                                                        " -- ",
                                                                        style:
                                                                            mobileDetailsYellowBold)
                                                                    : Icon(
                                                                        Icons
                                                                            .task_alt,
                                                                        size:
                                                                            28,
                                                                        color: Colors
                                                                            .green,
                                                                      )),
                                                          ),
                                                        ),
                                                        SizedBox(width: 2),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                          child: Container(
                                                            height: 30,
                                                            color: Colors.yellow
                                                                .shade100,
                                                            child: Center(
                                                                child: dvd.Payment ==
                                                                        ""
                                                                    ? Text(
                                                                        " -- ",
                                                                        style:
                                                                            mobileDetailsYellowBold)
                                                                    : Icon(
                                                                        Icons
                                                                            .task_alt,
                                                                        size:
                                                                            28,
                                                                        color: Colors
                                                                            .green,
                                                                      )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                              )
                            : isLoading
                                ? Center(
                                    child: Container(
                                        height: 100,
                                        width: 100,
                                        child: CircularProgressIndicator()))
                                : SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        1.07,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Card(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 20),
                                              Row(
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
                                                            4.5,
                                                    child: Container(
                                                      height: 50,
                                                      color: Colors
                                                          .yellow.shade300,
                                                      child: Center(
                                                        child: Text(
                                                            'Vehicle No.',
                                                            style:
                                                                iPadYellowTextFontStyleNormal),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4,
                                                    child: Container(
                                                      height: 50,
                                                      color: Colors
                                                          .yellow.shade300,
                                                      child: Center(
                                                        child: Text(
                                                            'Driver Name',
                                                            style:
                                                                iPadYellowTextFontStyleNormal),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    child: Container(
                                                      height: 50,
                                                      color: Colors
                                                          .yellow.shade300,
                                                      child: Center(
                                                        child: Text(
                                                            'Slot/ Dock Details',
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4.5,
                                                    child: Container(
                                                      height: 50,
                                                      color: Colors
                                                          .yellow.shade100,
                                                      child: Center(
                                                        child: Text(
                                                            widget
                                                                .selectedVtDetails
                                                                .VEHICLENO
                                                                .toUpperCase(),
                                                            style:
                                                                iPadYellowTextFontStyleBold),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4,
                                                    child: Container(
                                                      height: 50,
                                                      color: Colors
                                                          .yellow.shade100,
                                                      child: Center(
                                                        child: Text(
                                                            widget
                                                                .selectedVtDetails
                                                                .DRIVERNAME
                                                                .toUpperCase(),
                                                            style:
                                                                iPadYellowTextFontStyleBold),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    child: Container(
                                                      height: 50,
                                                      color: Colors
                                                          .yellow.shade100,
                                                      child: Center(
                                                        child: Text(
                                                            widget
                                                                .selectedVtDetails
                                                                .SLOTTIME,
                                                            style:
                                                                iPadYellowTextFontStyleBold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 20),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        if (!widget.isExport)
                                          Text(
                                            "Shipment Details",
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.normal,
                                              color: Color(0xFF11249F),
                                            ),
                                          ),
                                        if (!widget.isExport)
                                          SizedBox(height: 20),
                                        if (!widget.isExport)
                                          for (DockInOutVTDetails dvd
                                              in dockInOutDets)
                                            Card(
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 20),
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
                                                            3,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade300,
                                                          child: Center(
                                                            child: Text(
                                                                'AWB No.',
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
                                                            3,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade300,
                                                          child: Center(
                                                            child: Text(
                                                                'HAWB No.',
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
                                                            4.5,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade300,
                                                          child: Center(
                                                            child: Text(
                                                                'Flt Arr.',
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
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade100,
                                                          child: Center(
                                                            child: Text(
                                                              dvd.AirlinePrefix +
                                                                  "-" +
                                                                  dvd.MAWBNumber,
                                                              style:
                                                                  iPadYellowTextFontStyleBold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade100,
                                                          child: Center(
                                                            child: Text(
                                                                dvd.HAWBNumber,
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
                                                            4.5,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade100,
                                                          child: Center(
                                                              child:
                                                                  //  dvd.FlightArrivalStatus ==
                                                                  //         false
                                                                  //     ?

                                                                  Text(
                                                                      dvd.FlightArrivalStatus ==
                                                                              ""
                                                                          ? ""
                                                                          : dvd.FlightArrivalStatus.toString().substring(
                                                                              0,
                                                                              12), //dvd.FlightArrivalStatus,
                                                                      style:
                                                                          iPadYellowTextFontStyleBold)
                                                              // : Icon(
                                                              //     Icons
                                                              //         .task_alt,
                                                              //     size: 28,
                                                              //     color: Colors
                                                              //         .green,
                                                              //   ),
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade300,
                                                          child: Center(
                                                            child: Text('CRN',
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
                                                            3,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade300,
                                                          child: Center(
                                                            child: Text(
                                                                'Pmt Cnf.',
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
                                                            4.5,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors.white,
                                                          child: Center(
                                                            child: Text(
                                                              '',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
                                                            ),
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
                                                            3,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade100,
                                                          child: Center(
                                                            child: dvd.CustomReleaseNumber ==
                                                                    ""
                                                                ? Text(" -- ",
                                                                    style:
                                                                        iPadYellowTextFontStyleBold)
                                                                : Icon(
                                                                    Icons
                                                                        .task_alt,
                                                                    size: 36,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade100,
                                                          child: Center(
                                                              child: dvd.Payment ==
                                                                      ""
                                                                  ? Text(" -- ",
                                                                      style:
                                                                          iPadYellowTextFontStyleBold)
                                                                  : Icon(
                                                                      Icons
                                                                          .task_alt,
                                                                      size: 36,
                                                                      color: Colors
                                                                          .green,
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
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            4.5,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors.white,
                                                          child: Center(
                                                            child: Text(
                                                              '',
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
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
                                      ],
                                    ),
                                  ),
                        SizedBox(height: useMobileLayout ? 10 : 10),
                      ],
                    ),
                  ),
                  if (!isLoading)
                    Padding(
                      padding: useMobileLayout
                          ? const EdgeInsets.only(right: 00.0)
                          : const EdgeInsets.only(right: 40.0),
                      child: Align(
                        alignment: useMobileLayout
                            ? Alignment.center
                            : Alignment.topRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (isSavingData) return;
                                // showSuccessMessage();
                                var submitCheckin = await submitForDockIn(
                                    widget.isExport ? '2' : '1',
                                    'false',
                                    'true',
                                    'false');
                                if (submitCheckin == true) {
                                  var dlgstatus = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomDialog(
                                      title: widget.selectedVtDetails.VTNo,
                                      description: "Dock-In for VT# " +
                                          widget.selectedVtDetails.VTNo +
                                          " has been completed successfully",
                                      buttonText: "Okay",
                                      imagepath: 'assets/images/successchk.gif',
                                      isMobile: useMobileLayout,
                                    ),
                                  );
                                  var isSent = await sendSMS(
                                      widget.selectedVtDetails.DRIVERMOBILENO,
                                      widget.selectedVtDetails.VTNo,
                                      widget.selectedVtDetails.DRIVERNAME);
                                  if (isSent == true) print("SMS sent");

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
                                                : "Dock-In Failed",
                                            description: errMsgText == ""
                                                ? "Error occured while performing Dock-In, Please try again after some time"
                                                : errMsgText,
                                            buttonText: "Okay",
                                            imagepath: 'assets/images/warn.gif',
                                            isMobile: useMobileLayout),
                                  );
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
                                height: useMobileLayout ? 70 : 90,
                                width: useMobileLayout ? 250 : 350,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      isSavingData
                                          ? Colors.grey
                                          : Color(0xFF1220BC),
                                      isSavingData
                                          ? Colors.grey
                                          : Color(0xFF3540E8),
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
                                          fontSize: useMobileLayout
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  22
                                              : 28,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              //Text('CONTAINED BUTTON'),
                            ),
                            if (isSavingData) SizedBox(width: 10),
                            if (isSavingData)
                              Center(
                                  child: Container(
                                      height: useMobileLayout
                                          ? MediaQuery.of(context).size.height /
                                              13
                                          : 90,
                                      width: useMobileLayout
                                          ? MediaQuery.of(context).size.height /
                                              13
                                          : 90,
                                      child: CircularProgressIndicator()))
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ]));
  }

  getTokenDetails(modeType) async {
    if (isLoading) return;

    dockInOutDets = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "OperationType": modeType.toString(), // "",
      "VTNo": widget.selectedVtDetails.VTNo,
      "CreatedByUserId": loggedinUser.CreatedByUserId.toString(),
      "OrganizationBranchId": selectedTerminalID
          .toString(), //  loggedinUser.OrganizationBranchId.toString(),
      "OrganizationId": loggedinUser.OrganizationId.toString(),
    };
    await Global()
        .postData(
      Settings.SERVICES['DockInOutDetails'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      setState(() {
        dockInOutDets = resp
            .map<DockInOutVTDetails>(
                (json) => DockInOutVTDetails.fromJson(json))
            .toList();

        print("length dockInOutDets = " + dockInOutDets.length.toString());
        isLoading = false;
      });
    }).catchError((onError) {
      // setState(() {
      //   isLoading = false;
      // });
      print(onError);
    });
  }

  Future<bool> submitForDockIn(modeType, checkin, dockin, dockout) async {
    try {
      bool isValid = false;
      errMsgText = "";
      String responseTextUpdated = "";

      setState(() {
        isSavingData = true;
      });

      var queryParams = {
        "OperationType": modeType.toString(),
        "pVTNo": widget.selectedVtDetails.VTNo,
        "pTPS_CHECK_IN": checkin,
        "pDOCK_IN": dockin,
        "pDOCK_OUT": dockout,
        "CreatedByUserId": loggedinUser.CreatedByUserId,
        "OrganizationBranchId":
            selectedTerminalID.toString(), // loggedinUser.OrganizationBranchId,
        "OrganizationId": loggedinUser.OrganizationId,
        "IsGeoFencing": "true",
      };
      await Global()
          .postData(
        Settings.SERVICES['UpdateVT'],
        queryParams,
      )
          .then((response) {
        print("data received ");
        print(json.decode(response.body)['d']);
        // isValid = true;

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
