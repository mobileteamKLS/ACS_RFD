import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luxair/datastructure/vehicletoken.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:luxair/widgets/timeline.dart';

import '../constants.dart';
import '../global.dart';

class VehicleMovementTrackingDetails extends StatefulWidget {
  bool isExport = false;
  final VehicleToken selectedVtDetails;

  VehicleMovementTrackingDetails(
      {Key? key, required this.isExport, required this.selectedVtDetails})
      : super(key: key);

  @override
  _VehicleMovementTrackingDetailsState createState() =>
      _VehicleMovementTrackingDetailsState();
}

class _VehicleMovementTrackingDetailsState
    extends State<VehicleMovementTrackingDetails> {
  bool useMobileLayout = false;
  TextEditingController txtVTNO = new TextEditingController();
  List<VehicleShipmentDetails> vShipmentDets = [];
  List<VehicleTrackingDetails> vTrackingDets = [];
  bool isLoadingShipmentDetails = false;
  bool isLoadingTrackingDetails = false;

  @override
  void initState() {
    txtVTNO.text = widget.selectedVtDetails.VTNo; //"WIVT220627006";
    loadInitialData();
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
                headerText: widget.selectedVtDetails.VTNo),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(children: [
              // Padding(
              //   padding: useMobileLayout
              //       ? const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0)
              //       : const EdgeInsets.only(
              //           top: 10.0, bottom: 10.0, left: 40.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       SizedBox(
              //         width: useMobileLayout
              //             ? MediaQuery.of(context).size.width / 5
              //             : MediaQuery.of(context).size.width / 7,
              //         // hard coding child width
              //         child: Text(
              //           "VT No.",
              //           style: useMobileLayout
              //               ? mobileHeaderFontStyle
              //               : TextStyle(
              //                   fontSize: 24,
              //                   fontWeight: FontWeight.normal,
              //                   color: Color(0xFF11249F),
              //                 ),
              //         ),
              //       ),
              //       SizedBox(
              //         width: useMobileLayout
              //             ? MediaQuery.of(context).size.width / 1.8
              //             : MediaQuery.of(context).size.width /
              //                 2.5, // hard coding child width
              //         child: Container(
              //           height: useMobileLayout ? 40 : 65,
              //           width: MediaQuery.of(context).size.width / 2.5,
              //           decoration: BoxDecoration(
              //             border: Border.all(
              //               color: Colors.grey.withOpacity(0.5),
              //               width: 1.0,
              //             ),
              //             borderRadius: BorderRadius.circular(4.0),
              //           ),
              //           child: TextField(
              //             controller: txtVTNO,
              //             readOnly: true,
              //             keyboardType: TextInputType.text,
              //             decoration: InputDecoration(
              //               border: InputBorder.none,
              //               hintText: "Enter Vehicle No.",
              //               hintStyle: TextStyle(color: Colors.grey),
              //               contentPadding: EdgeInsets.symmetric(
              //                   vertical: 8, horizontal: 8),
              //               isDense: true,
              //             ),
              //             style: useMobileLayout
              //                 ? mobileTextFontStyle
              //                 : TextStyle(
              //                     fontSize: 24,
              //                     color: Colors.black,
              //                   ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              Padding(
                padding: useMobileLayout
                    ? const EdgeInsets.only(top: 0.0, bottom: 10.0, left: 8.0)
                    : const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // if (!useMobileLayout) SizedBox(height: 10),
                    // Container(
                    //   height: 1,
                    //   width: MediaQuery.of(context).size.width / 1.15,
                    //   color: Color(0xFF0461AA),
                    // ),
                    SizedBox(height: useMobileLayout ? 5 : 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Text(
                        "Vehicle Details",
                        style: useMobileLayout
                            ? mobileHeaderFontStyle
                            : TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF11249F),
                              ),
                      ),
                    ),
                    SizedBox(height: useMobileLayout ? 5 : 20),
                    SizedBox(
                        width: useMobileLayout
                            ? MediaQuery.of(context).size.width / 1.05
                            : MediaQuery.of(context).size.width / 1.1,
                        child: useMobileLayout
                            ? Card(
                                color: Colors.yellow.shade100,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 8.0, bottom: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: Text('Vehicle No.',
                                                style: mobileHeaderFontStyle),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Text(
                                                widget.selectedVtDetails
                                                    .VEHICLENO,
                                                style:
                                                    mobileYellowTextFontStyleBold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: Text('Driver Name',
                                                style: mobileHeaderFontStyle),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Text(
                                                widget.selectedVtDetails
                                                    .DRIVERNAME,
                                                style:
                                                    mobileYellowTextFontStyleBold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: Text('Mobile No.',
                                                style: mobileHeaderFontStyle),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Text(
                                                widget.selectedVtDetails
                                                    .DRIVERMOBILENO,
                                                style:
                                                    mobileYellowTextFontStyleBold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width / 1.15,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        // SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.8,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text('Vehicle No.',
                                                      style:
                                                          iPadYellowTextFontStyleBold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.3,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text('Driver Name',
                                                      style:
                                                          iPadYellowTextFontStyleBold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.6,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade300,
                                                child: Center(
                                                  child: Text('Mobile No.',
                                                      style:
                                                          iPadYellowTextFontStyleBold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.8,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                      widget.selectedVtDetails
                                                          .VEHICLENO,
                                                      style:
                                                          iPadDetailsYellowBold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.3,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                      widget.selectedVtDetails
                                                          .DRIVERNAME,
                                                      style:
                                                          iPadDetailsYellowBold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.6,
                                              child: Container(
                                                height: 50,
                                                color: Colors.yellow.shade100,
                                                child: Center(
                                                  child: Text(
                                                      widget.selectedVtDetails
                                                          .DRIVERMOBILENO,
                                                      style:
                                                          iPadDetailsYellowBold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                    SizedBox(height: useMobileLayout ? 5 : 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Text(
                        "Tracking Details",
                        style: useMobileLayout
                            ? mobileHeaderFontStyle
                            : TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF11249F),
                              ),
                      ),
                    ),
                    SizedBox(height: useMobileLayout ? 5 : 10),
                    SizedBox(
                        width: useMobileLayout
                            ? MediaQuery.of(context).size.width / 1.05
                            : MediaQuery.of(context).size.width / 1.1,
                        child: isLoadingTrackingDetails
                            ? Center(
                                child: Container(
                                    height: 100,
                                    width: 100,
                                    child: CircularProgressIndicator()))
                            : Card(
                                color: Colors.yellow.shade100,
                                child: Timeline(
                                  children: <Widget>[
                                    for (VehicleTrackingDetails vtd
                                        in vTrackingDets)
                                      Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: useMobileLayout
                                              ? EdgeInsets.only(
                                                  top: 12.0, left: 8)
                                              : EdgeInsets.only(
                                                  top: 12.0, left: 16),
                                          child: Text(
                                              vtd.Status == "Pending"
                                                  ? vtd.Name +
                                                      " : " +
                                                      vtd.Status
                                                  : vtd.Name +
                                                      " : " +
                                                      vtd.VehicleDateTime,
                                              style: useMobileLayout
                                                  ? vtd.Status == "Pending"
                                                      ? pendingGreyText
                                                      : completedBlackText
                                                  : vtd.Status == "Pending"
                                                      ? iPadYellowTextFontStyleBoldGray
                                                      : iPadYellowTextFontStyleBoldBlack),
                                        ),
                                      ),
                                  ],
                                  indicators: <Widget>[
                                    for (VehicleTrackingDetails vtd
                                        in vTrackingDets)
                                      Icon(
                                        vtd.Status == "Pending"
                                            ? Icons.schedule
                                            : Icons.check_circle_outline,
                                        size: useMobileLayout ? 32 : 40,
                                        color: vtd.Status == "Pending"
                                            ? Colors.red.shade300
                                            : Colors.green.shade200,
                                      ),
                                  ],
                                ),
                              )),
                    SizedBox(height: useMobileLayout ? 5 : 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Text(
                        "Shipment Details",
                        style: useMobileLayout
                            ? mobileHeaderFontStyle
                            : TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF11249F),
                              ),
                      ),
                    ),
                    SizedBox(height: useMobileLayout ? 5 : 10),
                    SizedBox(
                        width: useMobileLayout
                            ? MediaQuery.of(context).size.width / 1.05
                            : MediaQuery.of(context).size.width / 1.1,
                        child: useMobileLayout
                            ? isLoadingShipmentDetails
                                ? Center(
                                    child: Container(
                                        height: 100,
                                        width: 100,
                                        child: CircularProgressIndicator()))
                                : Column(
                                    children: [
                                      for (VehicleShipmentDetails vsd
                                          in vShipmentDets)
                                        Card(
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
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.2,
                                                          child: Text('AWB No.',
                                                              style:
                                                                  mobileHeaderFontStyle),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                          child: Text('Status',
                                                              style:
                                                                  mobileHeaderFontStyle),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.2,
                                                          child: Text(vsd.AWBNo,
                                                              style:
                                                                  mobileYellowTextFontStyleBold),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                          child: Text(
                                                              vsd.Status,
                                                              style:
                                                                  mobileYellowTextFontStyleBold),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                if (vsd.Reason != "")
                                                  Container(
                                                    height: 1,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.18,
                                                    color: Color(0xFF0461AA),
                                                  ),
                                                if (vsd.Reason != "")
                                                  SizedBox(height: 5),
                                                if (vsd.Reason != "")
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            4,
                                                        child: Text(
                                                            'Rejection Reason',
                                                            style:
                                                                mobileHeaderFontStyle),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.7,
                                                        child: Text(vsd.Reason,
                                                            style:
                                                                mobileYellowTextFontStyleBold),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      // Card(
                                      //   color: Colors.yellow.shade100,
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.only(
                                      //         left: 8.0, top: 8.0, bottom: 8.0),
                                      //     child: Column(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.start,
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.start,
                                      //       children: [
                                      //         Column(
                                      //           children: [
                                      //             Row(
                                      //               children: [
                                      //                 SizedBox(
                                      //                   width:
                                      //                       MediaQuery.of(context)
                                      //                               .size
                                      //                               .width /
                                      //                           2.2,
                                      //                   child: Text('AWB No.',
                                      //                       style:
                                      //                           mobileHeaderFontStyle),
                                      //                 ),
                                      //                 SizedBox(
                                      //                   width:
                                      //                       MediaQuery.of(context)
                                      //                               .size
                                      //                               .width /
                                      //                           3,
                                      //                   child: Text('Status',
                                      //                       style:
                                      //                           mobileHeaderFontStyle),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //             Row(
                                      //               children: [
                                      //                 SizedBox(
                                      //                   width:
                                      //                       MediaQuery.of(context)
                                      //                               .size
                                      //                               .width /
                                      //                           2.2,
                                      //                   child: Text('777-12345321',
                                      //                       style:
                                      //                           mobileYellowTextFontStyleBold),
                                      //                 ),
                                      //                 SizedBox(
                                      //                   width:
                                      //                       MediaQuery.of(context)
                                      //                               .size
                                      //                               .width /
                                      //                           3,
                                      //                   child: Text('Pending',
                                      //                       style:
                                      //                           mobileYellowTextFontStyleBold),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ],
                                      //         ),
                                      //         // SizedBox(height: 5),
                                      //         // Row(
                                      //         //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //         //   children: [
                                      //         //     SizedBox(
                                      //         //       width: MediaQuery.of(context)
                                      //         //               .size
                                      //         //               .width /
                                      //         //           4,
                                      //         //       child: Text('Rejection Reason',
                                      //         //           style: mobileHeaderFontStyle),
                                      //         //     ),
                                      //         //      SizedBox(
                                      //         //   width: MediaQuery.of(context)
                                      //         //           .size
                                      //         //           .width /
                                      //         //       1.7,
                                      //         //   child:Text(
                                      //         //           '',
                                      //         //           style:
                                      //         //               mobileYellowTextFontStyleBold),
                                      //         // ),
                                      //         //   ],
                                      //         // ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      // Card(
                                      //   color: Colors.yellow.shade100,
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.only(
                                      //         left: 8.0, top: 8.0, bottom: 8.0),
                                      //     child: Column(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.start,
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.start,
                                      //       children: [
                                      //         Column(
                                      //           children: [
                                      //             Row(
                                      //               children: [
                                      //                 SizedBox(
                                      //                   width:
                                      //                       MediaQuery.of(context)
                                      //                               .size
                                      //                               .width /
                                      //                           2.2,
                                      //                   child: Text('AWB No.',
                                      //                       style:
                                      //                           mobileHeaderFontStyle),
                                      //                 ),
                                      //                 SizedBox(
                                      //                   width:
                                      //                       MediaQuery.of(context)
                                      //                               .size
                                      //                               .width /
                                      //                           3,
                                      //                   child: Text('Status',
                                      //                       style:
                                      //                           mobileHeaderFontStyle),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //             Row(
                                      //               children: [
                                      //                 SizedBox(
                                      //                   width:
                                      //                       MediaQuery.of(context)
                                      //                               .size
                                      //                               .width /
                                      //                           2.2,
                                      //                   child: Text('777-34568533',
                                      //                       style:
                                      //                           mobileYellowTextFontStyleBold),
                                      //                 ),
                                      //                 SizedBox(
                                      //                   width:
                                      //                       MediaQuery.of(context)
                                      //                               .size
                                      //                               .width /
                                      //                           3,
                                      //                   child: Text('Pending',
                                      //                       style:
                                      //                           mobileYellowTextFontStyleBold),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ],
                                      //         ),
                                      //         // SizedBox(height: 5),
                                      //         // Row(
                                      //         //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //         //   children: [
                                      //         //     SizedBox(
                                      //         //       width: MediaQuery.of(context)
                                      //         //               .size
                                      //         //               .width /
                                      //         //           4,
                                      //         //       child: Text('Rejection Reason',
                                      //         //           style: mobileHeaderFontStyle),
                                      //         //     ),
                                      //         //      SizedBox(
                                      //         //   width: MediaQuery.of(context)
                                      //         //           .size
                                      //         //           .width /
                                      //         //       1.7,
                                      //         //   child:Text(
                                      //         //           '',
                                      //         //           style:
                                      //         //               mobileYellowTextFontStyleBold),
                                      //         // ),
                                      //         //   ],
                                      //         // ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  )
                            : isLoadingShipmentDetails
                                ? Center(
                                    child: Container(
                                        height: 100,
                                        width: 100,
                                        child: CircularProgressIndicator()))
                                : SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        1.15,
                                    child: Column(
                                      children: [
                                        for (VehicleShipmentDetails vsd
                                            in vShipmentDets)
                                          Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  // SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            4.3,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade300,
                                                          child: Center(
                                                            child: Text(
                                                                'AWB No.',
                                                                style:
                                                                    iPadYellowTextFontStyleBold),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            5,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade300,
                                                          child: Center(
                                                            child: Text(
                                                                'Status',
                                                                style:
                                                                    iPadYellowTextFontStyleBold),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.4,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade300,
                                                          child: Center(
                                                            child: Text(
                                                                'Rejection Reason',
                                                                style:
                                                                    iPadYellowTextFontStyleBold),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            4.3,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade100,
                                                          child: Center(
                                                            child: Text(
                                                                vsd.AWBNo,
                                                                style:
                                                                    iPadDetailsYellowBold),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            5,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade100,
                                                          child: Center(
                                                            child: Text(
                                                                vsd.Status,
                                                                style:
                                                                    iPadDetailsYellowBold),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.4,
                                                        child: Container(
                                                          height: 50,
                                                          color: Colors
                                                              .yellow.shade100,
                                                          child: Center(
                                                            child: Text(
                                                                vsd.Reason,
                                                                style:
                                                                    iPadDetailsYellowBold),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        // Card(
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.all(8.0),
                                        //     child: Column(
                                        //       children: [
                                        //         // SizedBox(height: 20),
                                        //         Row(
                                        //           mainAxisAlignment:
                                        //               MainAxisAlignment.start,
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment.start,
                                        //           children: [
                                        //             SizedBox(
                                        //               width: MediaQuery.of(context)
                                        //                       .size
                                        //                       .width /
                                        //                   4.3,
                                        //               child: Container(
                                        //                 height: 50,
                                        //                 color:
                                        //                     Colors.yellow.shade300,
                                        //                 child: Center(
                                        //                   child: Text('AWB No.',
                                        //                       style:
                                        //                           iPadYellowTextFontStyleBold),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //             SizedBox(width: 10),
                                        //             SizedBox(
                                        //               width: MediaQuery.of(context)
                                        //                       .size
                                        //                       .width /
                                        //                   5,
                                        //               child: Container(
                                        //                 height: 50,
                                        //                 color:
                                        //                     Colors.yellow.shade300,
                                        //                 child: Center(
                                        //                   child: Text('Status',
                                        //                       style:
                                        //                           iPadYellowTextFontStyleBold),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //             SizedBox(width: 10),
                                        //             SizedBox(
                                        //               width: MediaQuery.of(context)
                                        //                       .size
                                        //                       .width /
                                        //                   2.4,
                                        //               child: Container(
                                        //                 height: 50,
                                        //                 color:
                                        //                     Colors.yellow.shade300,
                                        //                 child: Center(
                                        //                   child: Text(
                                        //                       'Rejection Reason',
                                        //                       style:
                                        //                           iPadYellowTextFontStyleBold),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         ),

                                        //         Row(
                                        //           mainAxisAlignment:
                                        //               MainAxisAlignment.start,
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment.start,
                                        //           children: [
                                        //             SizedBox(
                                        //               width: MediaQuery.of(context)
                                        //                       .size
                                        //                       .width /
                                        //                   4.3,
                                        //               child: Container(
                                        //                 height: 50,
                                        //                 color:
                                        //                     Colors.yellow.shade100,
                                        //                 child: Center(
                                        //                   child: Text(
                                        //                       '777-12345321',
                                        //                       style:
                                        //                           iPadDetailsYellowBold),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //             SizedBox(width: 10),
                                        //             SizedBox(
                                        //               width: MediaQuery.of(context)
                                        //                       .size
                                        //                       .width /
                                        //                   5,
                                        //               child: Container(
                                        //                 height: 50,
                                        //                 color:
                                        //                     Colors.yellow.shade100,
                                        //                 child: Center(
                                        //                   child: Text('Pending',
                                        //                       style:
                                        //                           iPadDetailsYellowBold),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //             SizedBox(width: 10),
                                        //             SizedBox(
                                        //               width: MediaQuery.of(context)
                                        //                       .size
                                        //                       .width /
                                        //                   2.4,
                                        //               child: Container(
                                        //                 height: 50,
                                        //                 color:
                                        //                     Colors.yellow.shade100,
                                        //                 child: Center(
                                        //                   child: Text('',
                                        //                       style:
                                        //                           iPadDetailsYellowBold),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                        // Card(
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.all(8.0),
                                        //     child: Column(
                                        //       children: [
                                        //         // SizedBox(height: 20),
                                        //         Row(
                                        //           mainAxisAlignment:
                                        //               MainAxisAlignment.start,
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment.start,
                                        //           children: [
                                        //             SizedBox(
                                        //               width: MediaQuery.of(context)
                                        //                       .size
                                        //                       .width /
                                        //                   4.3,
                                        //               child: Container(
                                        //                 height: 50,
                                        //                 color:
                                        //                     Colors.yellow.shade300,
                                        //                 child: Center(
                                        //                   child: Text('AWB No.',
                                        //                       style:
                                        //                           iPadYellowTextFontStyleBold),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //             SizedBox(width: 10),
                                        //             SizedBox(
                                        //               width: MediaQuery.of(context)
                                        //                       .size
                                        //                       .width /
                                        //                   5,
                                        //               child: Container(
                                        //                 height: 50,
                                        //                 color:
                                        //                     Colors.yellow.shade300,
                                        //                 child: Center(
                                        //                   child: Text('Status',
                                        //                       style:
                                        //                           iPadYellowTextFontStyleBold),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //             SizedBox(width: 10),
                                        //             SizedBox(
                                        //               width: MediaQuery.of(context)
                                        //                       .size
                                        //                       .width /
                                        //                   2.4,
                                        //               child: Container(
                                        //                 height: 50,
                                        //                 color:
                                        //                     Colors.yellow.shade300,
                                        //                 child: Center(
                                        //                   child: Text(
                                        //                       'Rejection Reason',
                                        //                       style:
                                        //                           iPadYellowTextFontStyleBold),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         ),

                                        //         Row(
                                        //           mainAxisAlignment:
                                        //               MainAxisAlignment.start,
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment.start,
                                        //           children: [
                                        //             SizedBox(
                                        //               width: MediaQuery.of(context)
                                        //                       .size
                                        //                       .width /
                                        //                   4.3,
                                        //               child: Container(
                                        //                 height: 50,
                                        //                 color:
                                        //                     Colors.yellow.shade100,
                                        //                 child: Center(
                                        //                   child: Text(
                                        //                       '777-34568533',
                                        //                       style:
                                        //                           iPadDetailsYellowBold),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //             SizedBox(width: 10),
                                        //             SizedBox(
                                        //               width: MediaQuery.of(context)
                                        //                       .size
                                        //                       .width /
                                        //                   5,
                                        //               child: Container(
                                        //                 height: 50,
                                        //                 color:
                                        //                     Colors.yellow.shade100,
                                        //                 child: Center(
                                        //                   child: Text('Pending',
                                        //                       style:
                                        //                           iPadDetailsYellowBold),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //             SizedBox(width: 10),
                                        //             SizedBox(
                                        //               width: MediaQuery.of(context)
                                        //                       .size
                                        //                       .width /
                                        //                   2.4,
                                        //               child: Container(
                                        //                 height: 50,
                                        //                 color:
                                        //                     Colors.yellow.shade100,
                                        //                 child: Center(
                                        //                   child: Text('',
                                        //                       style:
                                        //                           iPadDetailsYellowBold),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  )),
                  ],
                ),
              ),
            ])))
          ]),
    );
  }

  loadInitialData() async {
    if (widget.isExport) {
      await getVehicleTrackingDetails(6);
      await getVehicleShipmentDetails(5);
    } else {
      await getVehicleTrackingDetails(3);
      await getVehicleShipmentDetails(2);
    }
  }

  getVehicleTrackingDetails(modeType) async {
    if (isLoadingTrackingDetails) return;

    vTrackingDets = [];

    setState(() {
      isLoadingTrackingDetails = true;
    });

    var queryParams = {
      "OperationType": modeType.toString(), // "",
      "VTNo": widget.selectedVtDetails.VTNo,
      "CreatedByUserId": loggedinUser.CreatedByUserId,
      "OrganizationBranchId": loggedinUser.OrganizationBranchId.toString(),
      "OrganizationId": loggedinUser.OrganizationId.toString(),
    };
    await Global()
        .postData(
      Settings.SERVICES['VehicleMovementTrackingDetails'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      setState(() {
        vTrackingDets = resp
            .map<VehicleTrackingDetails>(
                (json) => VehicleTrackingDetails.fromJson(json))
            .toList();

        print("length vTrackingDets = " + vTrackingDets.length.toString());
        isLoadingTrackingDetails = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoadingTrackingDetails = false;
      });
      print(onError);
    });
  }

  getVehicleShipmentDetails(modeType) async {
    if (isLoadingShipmentDetails) return;

    vShipmentDets = [];

    setState(() {
      isLoadingShipmentDetails = true;
    });

    var queryParams = {
      "OperationType": modeType.toString(), // "",
      "VTNo": widget.selectedVtDetails.VTNo,
      "CreatedByUserId": loggedinUser.CreatedByUserId,
      "OrganizationBranchId": loggedinUser.OrganizationBranchId.toString(),
      "OrganizationId": loggedinUser.OrganizationId.toString(),
    };
    await Global()
        .postData(
      Settings.SERVICES['VehicleMovementTrackingDetails'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      setState(() {
        vShipmentDets = resp
            .map<VehicleShipmentDetails>(
                (json) => VehicleShipmentDetails.fromJson(json))
            .toList();

        print("length vShipmentDets = " + vShipmentDets.length.toString());
        isLoadingShipmentDetails = false;
// //vehicleSMSToBind=[];
        // if (vehicleSMSToBind.length == 0) vehicleSMSToBind = vehicleSMSToBind1;
      });
    }).catchError((onError) {
      setState(() {
        isLoadingShipmentDetails = false;
      });
      print(onError);
    });
  }
}
