import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:luxair/datastructure/vehicletoken.dart';
import 'package:luxair/otherpages/truckeryardcheckindetails.dart';
import 'package:luxair/widgets/common.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:luxair/widgets/qrscan.dart';
import 'package:luxair/widgets/speech_recognition.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../global.dart';
import '../widgets/timeline.dart';

class TrackAndTrace extends StatefulWidget {
  final bool isExport;

  const TrackAndTrace(this.isExport, {Key? key}) : super(key: key);

  @override
  State<TrackAndTrace> createState() => _TrackAndTraceState();
}

class _TrackAndTraceState extends State<TrackAndTrace> {
  TextEditingController dateInputSB = TextEditingController();
  TextEditingController dateInputBOE = TextEditingController();
  final _controllerModeType = ValueNotifier<bool>(false);
  List<VehicleToken> vehicleToeknListToBind = [];
  List<VehicleToken> vehicleToeknListImport = [];
  List<VehicleToken> vehicleToeknListExport = [];
  List<EVTDetails> evtList = [
    EVTDetails(
        EVTno: "EVT2401190001",
        VehicleNo: "12341111",
        PendingArea: "15-01-2024 15.39",
        DockIn: "15-01-2024 15.39",
        DockOut: "15-01-2024 15.39"),
    EVTDetails(
        EVTno: "EVT2401190002",
        VehicleNo: "12341112",
        PendingArea: "15-01-2024 15.39",
        DockIn: "15-01-2024 15.39",
        DockOut: "15-01-2024 15.39"),
    EVTDetails(
        EVTno: "EVT2401190003",
        VehicleNo: "12341111",
        PendingArea: "15-01-2024 15.39",
        DockIn: "15-01-2024 15.39",
        DockOut: "15-01-2024 15.39"),
    EVTDetails(
        EVTno: "EVT2401190003",
        VehicleNo: "12341111",
        PendingArea: "15-01-2024 15.39",
        DockIn: "15-01-2024 15.39",
        DockOut: "15-01-2024 15.39"),
    EVTDetails(
        EVTno: "EVT2401190004",
        VehicleNo: "12341114",
        PendingArea: "15-01-2024 15.39",
        DockIn: "15-01-2024 15.39",
        DockOut: "15-01-2024 15.39"),
    EVTDetails(
        EVTno: "EVT2401190005",
        VehicleNo: "12341115",
        PendingArea: "15-01-2024 15.39",
        DockIn: "15-01-2024 15.39",
        DockOut: "15-01-2024 15.39"),
    EVTDetails(
        EVTno: "EVT2401190006",
        VehicleNo: "12341116",
        PendingArea: "15-01-2024 15.39",
        DockIn: "15-01-2024 15.39",
        DockOut: "15-01-2024 15.39"),
  ];
  bool isImport = false;
  bool isLoading = false;
  bool useMobileLayout = false;
  int modeSelected = 0;
  int trackingSelected = 0; //, modeSelected1 = 0;
  int trackingType = 0;
  String dropdownValue = 'Select';
  String selectedSlotDate = "";

  @override
  void initState() {
    super.initState();
    dateInputSB.text = "";
    dateInputBOE.text = "";
    // _controllerModeType.addListener(() {
    //   setState(() {
    //     if (_controllerModeType.value) {
    //       isImport = true;
    //     } else {
    //       isImport = false;
    //     }
    //   });
    // });
  }

  getTrackAndTraceDetails(modeType) async {
    if (isLoading) return;

    // txtVTNO.text = "";
    vehicleToeknListExport = [];
    vehicleToeknListImport = [];
    vehicleToeknListToBind = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "OperationType": "1", // "",
      "AirlinePrefix": "999",
      "AwbNumber": "56565670",
      "CreatedByUserId": "22438",
      "HawbNumber": "",
      "OrganizationBranchId": "22462",
      "OrganizationId": "22426" // loggedinUser.OrganizationBranchId,
    };
    await Global()
        .postData(
      Settings.SERVICES['TrackAndTrace'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      if (modeType == 2) //export
        vehicleToeknListExport = resp
            .map<VehicleToken>((json) => VehicleToken.fromJson(json))
            .toList();
      else
        vehicleToeknListImport = resp
            .map<VehicleToken>((json) => VehicleToken.fromJson(json))
            .toList();

      print("length vehicleToeknListExport = " +
          vehicleToeknListExport.length.toString());
      print("length vehicleToeknListImport = " +
          vehicleToeknListImport.length.toString());
      // setState(() {
      //   modeType == 2 ? modeSelected = 0 : modeSelected = 1;
      //   vehicleToeknListToBind =
      //       modeType == 2 ? vehicleToeknListExport : vehicleToeknListImport;
      //   isLoading = false;
      // });

      setState(() {
        // modeType == 2 ? modeSelected = 0 : modeSelected = 1;
        // vehicleToeknListToBind =
        // modeType == 2 ? vehicleToeknListExport : vehicleToeknListImport;
        // isLoading = false;
      });

      // if (response.statusCode == HttpStatus.notFound) {
      //   setState(() {
      //     isLoading = false;
      //   });
      //   // print('Provided username and password is incorrect');
      //   // showAlertDialog(context, "OK", "Alert", "username or password is incorrect");
      // } else {
      //   var parsed = json.decode(response.body)['response'];
      //   // print(parsed);
      //   var resp = json.decode(parsed).cast<Map<String, dynamic>>();
      //   passList =
      //       resp.map<CodexPass>((json) => CodexPass.fromJson(json)).toList();
      //   setState(() {
      //     isLoading = false;
      //     passList = resp
      //         .map<CodexPass>((json) => CodexPass.fromJson(json))
      //         .toList();
      //     print(passList.length.toString());
      //   });
      // }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = smallestDimension < 600;
    print("useMobileLayout");
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeaderClipperWave(
              color1: Color(0xFF3383CD),
              color2: Color(0xFF11249F),
              headerText: "Track And Trace"),
          useMobileLayout
              ? Expanded(
                  flex: 0,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, bottom: 10.0, left: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: MediaQuery.of(context).size.width / 4,
                          //       child:
                          //           Text("Mode", style: mobileHeaderFontStyle),
                          //     ),
                          //     AdvancedSwitch(
                          //       activeColor: Color(0xFF11249F),
                          //       inactiveColor: Color(0xFF11249F),
                          //       activeChild: Text('Import',
                          //           style: mobileTextFontStyleWhite),
                          //       inactiveChild: Text('Export',
                          //           style: mobileTextFontStyleWhite),
                          //       width: MediaQuery.of(context).size.width / 2.5,
                          //       height: 35,
                          //       controller: _controllerModeType,
                          //     ),
                          //   ],
                          // ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ToggleSwitch(
                              minWidth: useMobileLayout
                                  ? MediaQuery.of(context).size.width / 2
                                  : MediaQuery.of(context).size.width / 4.5,
                              minHeight: 45.0,
                              fontSize: 16.0,
                              // cornerRadius: 20.0,
                              initialLabelIndex: trackingType,
                              activeBgColors: [
                                [Color(0xFF1220BC), Color(0xFF3540E8)],
                                [Color(0xFF1220BC), Color(0xFF3540E8)],
                                [Color(0xFF1220BC), Color(0xFF3540E8)],
                              ],
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey,
                              inactiveFgColor: Colors.white,
                              totalSwitches: 2,
                              animate: true,
                              curve: Curves.bounceInOut,
                              customTextStyles: [
                                TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                                TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                                TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                )
                              ],
                              labels: isImport
                                  ? [' AWB ', ' Vehicle ']
                                  : [' AWB ', ' Vehicle '],
                              icons: [
                                FontAwesomeIcons.box,
                                FontAwesomeIcons.truckMoving,
                                FontAwesomeIcons.fileAlt,
                              ],
                              onToggle: (index) {
                                setState(() {
                                  trackingType = index!;
                                  print(trackingType);
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          trackingType == 0
                              ? !widget.isExport
                                  ? Column(
                                      children: [
                                        Row(children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4.3,
                                            child: Text("MAWB No.",
                                                style: mobileHeaderFontStyle),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  7.0, // hard coding child width
                                              child: Container(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.4,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: TextField(
                                                    // onChanged: (value) =>
                                                    //     _runFilter(value),
                                                    // controller: txtVTNO,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    textAlign: TextAlign.right,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "Prefix",
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8,
                                                              horizontal: 8),
                                                      isDense: true,
                                                    ),
                                                    style: mobileTextFontStyle),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5, // hard coding child width
                                              child: Container(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.4,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: TextField(
                                                    // onChanged: (value) =>
                                                    //     _runFilter(value),
                                                    // controller: txtVTNO,
                                                    textAlign: TextAlign.right,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "MAWB No.",
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8,
                                                              horizontal: 8),
                                                      isDense: true,
                                                    ),
                                                    style: mobileTextFontStyle),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                              child: SearchContainerButton(),
                                              onTap: () async {
                                                getTrackAndTraceDetails(
                                                    1); //export
                                              }),
                                          SizedBox(width: 5),
                                          GestureDetector(
                                            child: DeleteScanContainerButton(),
                                            onTap: () async {},
                                          )
                                        ]),
                                        Row(children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4.2,
                                            child: Text("HAWB No.(Opt)",
                                                style: mobileHeaderFontStyle),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.25, // hard coding child width
                                              child: Container(
                                                height: 48,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.4,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                // child: TextField(
                                                //     onChanged: (value) =>
                                                //         _runFilter(value),
                                                //     controller: dateInput,
                                                //     keyboardType:
                                                //     TextInputType
                                                //         .text,
                                                //     textAlign:
                                                //     TextAlign.right,
                                                //     textCapitalization:
                                                //     TextCapitalization
                                                //         .characters,
                                                //     decoration:
                                                //     InputDecoration(
                                                //       border: InputBorder
                                                //           .none,
                                                //       hintText:
                                                //       "Select Date",
                                                //       hintStyle: TextStyle(
                                                //           color: Colors
                                                //               .grey),
                                                //       contentPadding:
                                                //       EdgeInsets
                                                //           .symmetric(
                                                //           vertical:
                                                //           8,
                                                //           horizontal:
                                                //           8),
                                                //       isDense: true,
                                                //     ),
                                                //     style:
                                                //     mobileTextFontStyle),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                        minHeight: 50),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 0.2),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      color: Colors.white,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: DropdownButton(
                                                      value: dropdownValue,
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          dropdownValue =
                                                              newValue!;
                                                        });
                                                      },
                                                      items: [
                                                        "Select",
                                                        "Two",
                                                        "Three"
                                                      ]
                                                          .map((String value) =>
                                                              DropdownMenuItem(
                                                                value: value,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      value,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ))
                                                          .toList(),
                                                    ),
                                                  ),
                                                ),
                                                //     DropdownButtonFormField(
                                                //   isDense: true,
                                                //   decoration: InputDecoration(
                                                //       border:
                                                //           InputBorder.none),
                                                //   value: dropdownValue,
                                                //   onChanged:
                                                //       (String? newValue) {
                                                //     setState(() {
                                                //       dropdownValue =
                                                //           newValue!;
                                                //     });
                                                //   },
                                                //   items: <String>[
                                                //     'Select',
                                                //     'Cat',
                                                //     'Tiger',
                                                //     'Lion'
                                                //   ].map<
                                                //           DropdownMenuItem<
                                                //               String>>(
                                                //       (String value) {
                                                //     return DropdownMenuItem<
                                                //         String>(
                                                //       value: value,
                                                //       child: Text(
                                                //         value,
                                                //         style: TextStyle(
                                                //           fontSize: 14,
                                                //           fontWeight:
                                                //               FontWeight
                                                //                   .normal,
                                                //           color: Colors.black,
                                                //         ),
                                                //       ),
                                                //     );
                                                //   }).toList(),
                                                // ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ],
                                    )
                                  : Row(children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4.3,
                                        child: Text("MAWB No.",
                                            style: mobileHeaderFontStyle),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              7.0, // hard coding child width
                                          child: Container(
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.4,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: TextField(
                                                // onChanged: (value) =>
                                                //     _runFilter(value),
                                                // controller: txtVTNO,
                                                keyboardType:
                                                    TextInputType.number,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .characters,
                                                textAlign: TextAlign.right,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Prefix",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 8,
                                                          horizontal: 8),
                                                  isDense: true,
                                                ),
                                                style: mobileTextFontStyle),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.5, // hard coding child width
                                          child: Container(
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.4,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: TextField(
                                                // onChanged: (value) =>
                                                //     _runFilter(value),
                                                // controller: txtVTNO,
                                                textAlign: TextAlign.right,
                                                keyboardType:
                                                    TextInputType.number,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .characters,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "MAWB No.",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 8,
                                                          horizontal: 8),
                                                  isDense: true,
                                                ),
                                                style: mobileTextFontStyle),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                          child: SearchContainerButton(),
                                          onTap: () async {
                                            getTrackAndTraceDetails(1); //export
                                          }),
                                      SizedBox(width: 5),
                                      GestureDetector(
                                        child: DeleteScanContainerButton(),
                                        onTap: () async {},
                                      )
                                    ])
                              : trackingType == 1
                                  ? !widget.isExport
                                      ? Column(
                                          children: [
                                            Row(children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4.2,
                                                child: Text("BoE No.",
                                                    style:
                                                        mobileHeaderFontStyle),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.4, // hard coding child width
                                                  child: Container(
                                                    height: 40,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.4,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                    child: TextField(
                                                        // onChanged: (value) =>
                                                        //     _runFilter(value),
                                                        // controller: txtVTNO,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textAlign:
                                                            TextAlign.right,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .characters,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Enter BoE No.",
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
                                                        style:
                                                            mobileTextFontStyle),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                  child:
                                                      SearchContainerButton(),
                                                  onTap: () async {
                                                    getTrackAndTraceDetails(
                                                        1); //export
                                                  }),
                                              SizedBox(width: 5),
                                              GestureDetector(
                                                child:
                                                    DeleteScanContainerButton(),
                                                onTap: () async {},
                                              )
                                            ]),
                                            Row(children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4.2,
                                                child: Text("Date",
                                                    style:
                                                        mobileHeaderFontStyle),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.4, // hard coding child width
                                                  child: Container(
                                                    height: 40,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.4,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                    child: TextField(
                                                        // onChanged: (value) =>
                                                        //     _runFilter(value),
                                                        controller:
                                                            dateInputBOE,
                                                        keyboardType:
                                                            TextInputType
                                                                .datetime,
                                                        textAlign:
                                                            TextAlign.right,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .characters,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Select Date",
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
                                                        style:
                                                            mobileTextFontStyle),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                child:
                                                    DatePickerContainerButton(),
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime.now(),
                                                          lastDate:
                                                              DateTime(2100),
                                                          builder:
                                                              (context, child) {
                                                            return Theme(
                                                              data: Theme.of(
                                                                      context)
                                                                  .copyWith(
                                                                colorScheme:
                                                                    ColorScheme
                                                                        .light(
                                                                  primary: Color(
                                                                      0xFF1220BC),
                                                                  // <-- SEE HERE
                                                                  onPrimary:
                                                                      Colors
                                                                          .white,
                                                                  // <-- SEE HERE
                                                                  onSurface: Color(
                                                                      0xFF3540E8), // <-- SEE HERE
                                                                ),
                                                                textButtonTheme:
                                                                    TextButtonThemeData(
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    foregroundColor:
                                                                        Color(
                                                                            0xFF3540E8), // button text color
                                                                  ),
                                                                ),
                                                              ),
                                                              child: child!,
                                                            );
                                                          });

                                                  if (pickedDate != null) {
                                                    print(
                                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                                    String formattedDate =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(pickedDate);

                                                    print(
                                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                                    setState(() {
                                                      selectedSlotDate =
                                                          DateFormat(
                                                                  'dd MMM yyyy')
                                                              .format(
                                                                  pickedDate);
                                                      dateInputBOE.text =
                                                          formattedDate; //set output date to TextField value.

                                                      // getSlotsList(); // refesh slots
                                                    });
                                                  }
                                                },
                                              )
                                            ]),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            Row(children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4.2,
                                                child: Text("SB No.",
                                                    style:
                                                        mobileHeaderFontStyle),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.4, // hard coding child width
                                                  child: Container(
                                                    height: 40,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.4,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                    child: TextField(
                                                        // onChanged: (value) =>
                                                        //     _runFilter(value),
                                                        // controller: txtVTNO,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textAlign:
                                                            TextAlign.right,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .characters,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Enter Shipping Bill No.",
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
                                                        style:
                                                            mobileTextFontStyle),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                  child:
                                                      SearchContainerButton(),
                                                  onTap: () async {
                                                    getTrackAndTraceDetails(
                                                        1); //export
                                                  }),
                                              SizedBox(width: 5),
                                              GestureDetector(
                                                child:
                                                    DeleteScanContainerButton(),
                                                onTap: () async {},
                                              )
                                            ]),
                                            Row(children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4.2,
                                                child: Text("Date",
                                                    style:
                                                        mobileHeaderFontStyle),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.4, // hard coding child width
                                                  child: Container(
                                                    height: 40,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.4,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                    child: TextField(
                                                        // onChanged: (value) =>
                                                        //     _runFilter(value),
                                                        controller: dateInputSB,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textAlign:
                                                            TextAlign.right,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .characters,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Select Date",
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
                                                        style:
                                                            mobileTextFontStyle),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                child:
                                                    DatePickerContainerButton(),
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime.now(),
                                                          lastDate:
                                                              DateTime(2100),
                                                          builder:
                                                              (context, child) {
                                                            return Theme(
                                                              data: Theme.of(
                                                                      context)
                                                                  .copyWith(
                                                                colorScheme:
                                                                    ColorScheme
                                                                        .light(
                                                                  primary: Color(
                                                                      0xFF1220BC),
                                                                  // <-- SEE HERE
                                                                  onPrimary:
                                                                      Colors
                                                                          .white,
                                                                  // <-- SEE HERE
                                                                  onSurface: Color(
                                                                      0xFF3540E8), // <-- SEE HERE
                                                                ),
                                                                textButtonTheme:
                                                                    TextButtonThemeData(
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    foregroundColor:
                                                                        Color(
                                                                            0xFF3540E8), // button text color
                                                                  ),
                                                                ),
                                                              ),
                                                              child: child!,
                                                            );
                                                          });

                                                  if (pickedDate != null) {
                                                    print(
                                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                                    String formattedDate =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(pickedDate);

                                                    print(
                                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                                    setState(() {
                                                      selectedSlotDate =
                                                          DateFormat(
                                                                  'dd MMM yyyy')
                                                              .format(
                                                                  pickedDate);
                                                      dateInputSB.text =
                                                          formattedDate; //set output date to TextField value.

                                                      // getSlotsList(); // refesh slots
                                                    });
                                                  }
                                                },
                                              )
                                            ]),
                                          ],
                                        )
                                  : Row(children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4.3,
                                        child: Text("MAWB No.",
                                            style: mobileHeaderFontStyle),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              7.0, // hard coding child width
                                          child: Container(
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.4,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: TextField(
                                                // onChanged: (value) =>
                                                //     _runFilter(value),
                                                // controller: txtVTNO,
                                                keyboardType:
                                                    TextInputType.text,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .characters,
                                                textAlign: TextAlign.right,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Prefix",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 8,
                                                          horizontal: 8),
                                                  isDense: true,
                                                ),
                                                style: mobileTextFontStyle),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.5, // hard coding child width
                                          child: Container(
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.4,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: TextField(
                                                // onChanged: (value) =>
                                                //     _runFilter(value),
                                                // controller: txtVTNO,
                                                textAlign: TextAlign.right,
                                                keyboardType:
                                                    TextInputType.text,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .characters,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "MAWB No.",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 8,
                                                          horizontal: 8),
                                                  isDense: true,
                                                ),
                                                style: mobileTextFontStyle),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                          child: SearchContainerButton(),
                                          onTap: () async {
                                            getTrackAndTraceDetails(1); //export
                                          }),
                                      SizedBox(width: 5),
                                      GestureDetector(
                                        child: DeleteScanContainerButton(),
                                        onTap: () async {},
                                      )
                                    ]),
                          SizedBox(
                            height: 5,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     ElevatedButton(
                          //       onPressed: () {
                          //         // if (txtVTNO.text.isEmpty &&
                          //         //     txtVehicleNo.text.isEmpty) {
                          //         //   setState(() {
                          //         //     isValidTextBoxes = false;
                          //         //   });
                          //         // } else {
                          //         //   setState(() {
                          //         //     isSearched = true;
                          //         //   });
                          //         //   if (txtVTNO.text.trim() == "")
                          //         //     getTokenDetailsByVehicleNo();
                          //         //   else
                          //         //     getTokenDetailsByVTNO(1);
                          //         // }
                          //       },
                          //       style: ElevatedButton.styleFrom(
                          //         elevation: 4.0,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius:
                          //                 BorderRadius.circular(10.0)), //
                          //         padding: const EdgeInsets.all(0.0),
                          //       ),
                          //       child: Container(
                          //         height: useMobileLayout ? 40 : 70,
                          //         width: useMobileLayout
                          //             ? MediaQuery.of(context).size.width /
                          //                 4.4
                          //             : MediaQuery.of(context).size.width / 5,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(10),
                          //           gradient: LinearGradient(
                          //             begin: Alignment.topRight,
                          //             end: Alignment.bottomLeft,
                          //             colors: [
                          //               Color(0xFF1220BC),
                          //               Color(0xFF3540E8),
                          //             ],
                          //           ),
                          //         ),
                          //         child: Padding(
                          //           padding: useMobileLayout
                          //               ? const EdgeInsets.only(
                          //                   top: 8.0, bottom: 8.0)
                          //               : const EdgeInsets.only(
                          //                   top: 8.0, bottom: 8.0),
                          //           child: Align(
                          //             alignment: Alignment.center,
                          //             child: Text(
                          //               'Search',
                          //               style: TextStyle(
                          //                   fontSize: useMobileLayout
                          //                       ? MediaQuery.of(context)
                          //                               .size
                          //                               .width /
                          //                           24
                          //                       : 24,
                          //                   fontWeight: FontWeight.normal,
                          //                   color: Colors.white),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //
                          //       //Text('CONTAINED BUTTON'),
                          //     ),
                          //     SizedBox(width: 15),
                          //     ElevatedButton(
                          //       onPressed: () {
                          //         setState(() {
                          //           // isSearched = false;
                          //           // txtVTNO.text = "";
                          //           // txtVehicleNo.text = "";
                          //           // walkInTokensList = [];
                          //         });
                          //       },
                          //       style: ElevatedButton.styleFrom(
                          //         elevation: 4.0,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius:
                          //                 BorderRadius.circular(10.0)), //
                          //         padding: const EdgeInsets.all(0.0),
                          //       ),
                          //
                          //       child: Container(
                          //         height: useMobileLayout ? 40 : 70,
                          //         width: useMobileLayout
                          //             ? MediaQuery.of(context).size.width /
                          //                 4.3
                          //             : MediaQuery.of(context).size.width /
                          //                 5.5,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(10),
                          //           color: Colors.white,
                          //         ),
                          //         child: Padding(
                          //           padding: useMobileLayout
                          //               ? const EdgeInsets.only(
                          //                   top: 8.0, bottom: 8.0)
                          //               : const EdgeInsets.only(
                          //                   top: 8.0, bottom: 8.0),
                          //           child: Align(
                          //             alignment: Alignment.center,
                          //             child: Text(
                          //               'Clear',
                          //               style: TextStyle(
                          //                   fontSize: useMobileLayout
                          //                       ? MediaQuery.of(context)
                          //                               .size
                          //                               .width /
                          //                           24
                          //                       : 24,
                          //                   fontWeight: FontWeight.normal,
                          //                   color: Color(0xFF1220BC)),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //       //Text('CONTAINED BUTTON'),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                )
              : Expanded(
                  flex: 0,
                  child: Container(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 16.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.45,
                                        child: Text(
                                          " Mode",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF11249F),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.8,
                                          child: ToggleSwitch(
                                            minWidth: 160,
                                            minHeight: 65.0,
                                            initialLabelIndex: modeSelected,
                                            cornerRadius: 20.0,
                                            activeFgColor: Colors.white,
                                            inactiveBgColor: Colors.grey,
                                            inactiveFgColor: Colors.white,
                                            totalSwitches: 2,
                                            customTextStyles: [
                                              TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                              ),
                                              TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                              )
                                            ],
                                            labels: ['Exports ', ' Imports'],
                                            icons: [
                                              Icons.north,
                                              Icons.south,
                                            ],
                                            iconSize: 22.0,
                                            activeBgColors: [
                                              // [Colors.blueAccent, Colors.blue],
                                              // [Colors.blueAccent, Colors.blue],
                                              [
                                                Color(0xFF1220BC),
                                                Color(0xFF3540E8)
                                              ],
                                              [
                                                Color(0xFF1220BC),
                                                Color(0xFF3540E8)
                                              ],
                                            ],
                                            animate: true,
                                            // with just animate set to true, default curve = Curves.easeIn
                                            curve: Curves.bounceInOut,
                                            // animate must be set to true when using custom curve
                                            onToggle: (index) {
                                              print('switched to: $index');

                                              setState(() {
                                                //selectedText = "";
                                                modeSelected = index!;
                                                if (index == 1) {
                                                  isImport = true;
                                                  // getVehicleToeknList(
                                                  //     3); //Import
                                                  // vehicleToeknListToBind =
                                                  //     vehicleToeknListImport;
                                                } else {
                                                  isImport = false;
                                                  // getVehicleToeknList(
                                                  //     4); //Export
                                                  // vehicleToeknListToBind =
                                                  //     vehicleToeknListExport;
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.45,
                                        child: Text(
                                          " Tracking Type",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF11249F),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.8,
                                          child: ToggleSwitch(
                                            minWidth: 160,
                                            minHeight: 65.0,
                                            initialLabelIndex: trackingType,
                                            cornerRadius: 20.0,
                                            activeFgColor: Colors.white,
                                            inactiveBgColor: Colors.grey,
                                            inactiveFgColor: Colors.white,
                                            totalSwitches: 2,
                                            customTextStyles: [
                                              TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                              ),
                                              TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                              )
                                            ],
                                            labels: [' AWB ', '  Vehicle'],
                                            icons: [
                                              FontAwesomeIcons.box,
                                              FontAwesomeIcons.truckMoving,
                                            ],
                                            iconSize: 22.0,
                                            activeBgColors: [
                                              // [Colors.blueAccent, Colors.blue],
                                              // [Colors.blueAccent, Colors.blue],
                                              [
                                                Color(0xFF1220BC),
                                                Color(0xFF3540E8)
                                              ],
                                              [
                                                Color(0xFF1220BC),
                                                Color(0xFF3540E8)
                                              ],
                                            ],
                                            animate: true,
                                            // with just animate set to true, default curve = Curves.easeIn
                                            curve: Curves.bounceInOut,
                                            // animate must be set to true when using custom curve
                                            onToggle: (index) {
                                              print('switched to: $index');

                                              setState(() {
                                                //selectedText = "";
                                                trackingType = index!;
                                                // if (index == 1) {
                                                //   getVehicleToeknList(
                                                //       3); //Import
                                                //   vehicleToeknListToBind =
                                                //       vehicleToeknListImport;
                                                // } else {
                                                //   getVehicleToeknList(
                                                //       4); //Export
                                                //   vehicleToeknListToBind =
                                                //       vehicleToeknListExport;
                                                // }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                              trackingType == 0
                                  ? !widget.isExport
                                      ? Column(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.45,
                                                  child: Text(
                                                    " MAWB No.",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Color(0xFF11249F),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            8.8,
                                                        // hard coding child width
                                                        child: Container(
                                                          height: 60,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              8.8,
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
                                                            textAlign:
                                                                TextAlign.right,
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            textCapitalization:
                                                                TextCapitalization
                                                                    .characters,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  "Prefix",
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          8),
                                                              isDense: true,
                                                            ),
                                                            style: TextStyle(
                                                              fontSize: 24.0,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            4.6,
                                                        // hard coding child width
                                                        child: Container(
                                                          height: 60,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              4.8,
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
                                                            textAlign:
                                                                TextAlign.right,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  "MAWB No.",
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          8),
                                                              isDense: true,
                                                            ),
                                                            style: TextStyle(
                                                              fontSize: 24.0,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child: GestureDetector(
                                                          child:
                                                              SearchContainerButtonIpad(),
                                                          onTap: () async {
                                                            getTrackAndTraceDetails(
                                                                1); //export
                                                          }),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child: GestureDetector(
                                                          child:
                                                              DeleteScanContainerButtonIpad(),
                                                          onTap: () async {
                                                            getTrackAndTraceDetails(
                                                                1); //export
                                                          }),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.45,
                                                  child: Text(
                                                    " HAWB No. (Opt)",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Color(0xFF11249F),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.9, // hard coding child width
                                                        child: Container(
                                                          height: 60,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.9,
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
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child: Container(
                                                              constraints:
                                                                  BoxConstraints(
                                                                      minHeight:
                                                                          50),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 0.2),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              child:
                                                                  DropdownButton(
                                                                value:
                                                                    dropdownValue,
                                                                onChanged: (String?
                                                                    newValue) {
                                                                  setState(() {
                                                                    dropdownValue =
                                                                        newValue!;
                                                                  });
                                                                },
                                                                items: [
                                                                  "Select",
                                                                  "Two",
                                                                  "Three"
                                                                ]
                                                                    .map((String
                                                                            value) =>
                                                                        DropdownMenuItem(
                                                                          value:
                                                                              value,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                value,
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ))
                                                                    .toList(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(width: 8),
                                          ],
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.45,
                                              child: Text(
                                                " MAWB No.",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xFF11249F),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            8.8,
                                                    // hard coding child width
                                                    child: Container(
                                                      height: 60,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              8.8,
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
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textAlign:
                                                            TextAlign.right,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .characters,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText: "Prefix",
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
                                                          fontSize: 24.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4.6,
                                                    // hard coding child width
                                                    child: Container(
                                                      height: 60,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4.8,
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
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .characters,
                                                        textAlign:
                                                            TextAlign.right,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText: "MAWB No.",
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
                                                          fontSize: 24.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: GestureDetector(
                                                      child:
                                                          SearchContainerButtonIpad(),
                                                      onTap: () async {
                                                        getTrackAndTraceDetails(
                                                            1); //export
                                                      }),
                                                ),
                                                SizedBox(width: 5),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: GestureDetector(
                                                      child:
                                                          DeleteScanContainerButtonIpad(),
                                                      onTap: () async {
                                                        getTrackAndTraceDetails(
                                                            1); //export
                                                      }),
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                  : trackingType == 1
                                      ? !widget.isExport
                                          ? Column(
                                              children: [
                                                Column(
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
                                                              2.45,
                                                      child: Text(
                                                        " BoE No.",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              Color(0xFF11249F),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.9,
                                                            // hard coding child width
                                                            child: Container(
                                                              height: 60,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2.9,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey
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
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                textCapitalization:
                                                                    TextCapitalization
                                                                        .characters,
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      "Enter BoE No.",
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                  contentPadding:
                                                                      EdgeInsets.symmetric(
                                                                          vertical:
                                                                              8,
                                                                          horizontal:
                                                                              8),
                                                                  isDense: true,
                                                                ),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      24.0,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 8.0),
                                                          child: GestureDetector(
                                                              child: SearchContainerButtonIpad(),
                                                              onTap: () async {
                                                                getTrackAndTraceDetails(
                                                                    1); //export
                                                              }),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 8.0),
                                                          child: GestureDetector(
                                                              child: DeleteScanContainerButtonIpad(),
                                                              onTap: () async {
                                                                getTrackAndTraceDetails(
                                                                    1); //export
                                                              }),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 8),
                                                Column(
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
                                                              2.45,
                                                      child: Text(
                                                        " Date",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              Color(0xFF11249F),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.9, // hard coding child width
                                                            child: Container(
                                                              height: 60,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2.9,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey
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
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                textCapitalization:
                                                                    TextCapitalization
                                                                        .characters,
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      "Enter Date",
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                  contentPadding:
                                                                      EdgeInsets.symmetric(
                                                                          vertical:
                                                                              8,
                                                                          horizontal:
                                                                              8),
                                                                  isDense: true,
                                                                ),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      24.0,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 8.0),
                                                          child: GestureDetector(
                                                              child: DatePickerContainerButtonIpad(),
                                                              onTap: () async {
                                                                // getTrackAndTraceDetails(
                                                                //     1); //export
                                                              }),
                                                        ),
                                                        SizedBox(width: 5),
                                                        // Padding(
                                                        //   padding:
                                                        //       const EdgeInsets
                                                        //               .only(
                                                        //           bottom: 8.0),
                                                        //   child: GestureDetector(
                                                        //       child: DeleteScanContainerButtonIpad(),
                                                        //       onTap: () async {
                                                        //         getTrackAndTraceDetails(
                                                        //             1); //export
                                                        //       }),
                                                        // )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 8),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                Column(
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
                                                              2.45,
                                                      child: Text(
                                                        " SB No.",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              Color(0xFF11249F),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.9,
                                                            // hard coding child width
                                                            child: Container(
                                                              height: 60,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2.9,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey
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
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                textCapitalization:
                                                                    TextCapitalization
                                                                        .characters,
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      "Enter Shipping Bill No.",
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                  contentPadding:
                                                                      EdgeInsets.symmetric(
                                                                          vertical:
                                                                              8,
                                                                          horizontal:
                                                                              8),
                                                                  isDense: true,
                                                                ),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      24.0,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 8.0),
                                                          child: GestureDetector(
                                                              child: SearchContainerButtonIpad(),
                                                              onTap: () async {
                                                                getTrackAndTraceDetails(
                                                                    1); //export
                                                              }),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 8.0),
                                                          child: GestureDetector(
                                                              child: DeleteScanContainerButtonIpad(),
                                                              onTap: () async {
                                                                getTrackAndTraceDetails(
                                                                    1); //export
                                                              }),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 8),
                                                Column(
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
                                                              2.45,
                                                      child: Text(
                                                        " Date",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              Color(0xFF11249F),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.9, // hard coding child width
                                                            child: Container(
                                                              height: 60,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2.9,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey
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
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                textCapitalization:
                                                                    TextCapitalization
                                                                        .characters,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      "Enter Date",
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                  contentPadding:
                                                                      EdgeInsets.symmetric(
                                                                          vertical:
                                                                              8,
                                                                          horizontal:
                                                                              8),
                                                                  isDense: true,
                                                                ),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      24.0,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 8.0),
                                                          child: GestureDetector(
                                                              child: DatePickerContainerButtonIpad(),
                                                              onTap: () async {
                                                                // getTrackAndTraceDetails(
                                                                //     1); //export
                                                              }),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 8),
                                              ],
                                            )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.45,
                                              child: Text(
                                                "  No.",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xFF11249F),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            8.8,
                                                    // hard coding child width
                                                    child: Container(
                                                      height: 60,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              8.8,
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
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textAlign:
                                                            TextAlign.right,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .characters,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Search VT No.",
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
                                                          fontSize: 24.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4.6,
                                                    // hard coding child width
                                                    child: Container(
                                                      height: 60,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4.8,
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
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textAlign:
                                                            TextAlign.right,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .characters,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Search VT No.",
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
                                                          fontSize: 24.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: GestureDetector(
                                                      child:
                                                          SearchContainerButtonIpad(),
                                                      onTap: () async {
                                                        getTrackAndTraceDetails(
                                                            1); //export
                                                      }),
                                                ),
                                                SizedBox(width: 5),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: GestureDetector(
                                                      child:
                                                          DeleteScanContainerButtonIpad(),
                                                      onTap: () async {
                                                        getTrackAndTraceDetails(
                                                            1); //export
                                                      }),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                              SizedBox(height: 10),
                            ])),
                  ),
                ),
          isLoading
              ? Center(
                  child: Container(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator()))
              : trackingType == 0
                  ? Expanded(
                      child: SingleChildScrollView(
                      child: Timeline(
                        children: <Widget>[
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 10.0)
                                  : const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                        " MAWB Creation",
                                        style: useMobileLayout
                                            ? mobileTimeLineHeaderFontStyle
                                            : mobileGroupHeaderFontStyle,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                          // _bookingDetails.length == 0
                                          // ? ""
                                          // : _bookingDetails[0]
                                          // .CreatedOn
                                          // .toString()
                                          // .contains("1900")
                                          // ? ""
                                          // : getCustomFormattedDateTime(
                                          // _bookingDetails[0].CreatedOn,
                                          // 'dd-MM-yyyy HH:mm')
                                          "15-01-2024 15:39",
                                          style: useMobileLayout
                                              ? TextStyle(fontSize: 15.0)
                                              : TextStyle(fontSize: 18.0))),
                                  // : _bookingDetails[0].CreatedOn)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 10.0)
                                  : const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                        " MAWB ASI",
                                        style: useMobileLayout
                                            ? mobileTimeLineHeaderFontStyle
                                            : mobileGroupHeaderFontStyle,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                          // _bookingDetails.length == 0
                                          // ? ""
                                          // : _bookingDetails[0]
                                          // .GateOutDate
                                          // .toString()
                                          // .contains("1900")
                                          // ? ""
                                          // : getCustomFormattedDateTime(
                                          // _bookingDetails[0].GateOutDate,
                                          // 'dd-MM-yyyy HH:mm')
                                          "15-01-2024 15:39",
                                          style: useMobileLayout
                                              ? TextStyle(fontSize: 15.0)
                                              : TextStyle(fontSize: 18.0))),
                                  // : _bookingDetails[0].GateOutDate)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 10.0)
                                  : const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                        " e-AWB Submit",
                                        style: useMobileLayout
                                            ? mobileTimeLineHeaderFontStyle
                                            : mobileGroupHeaderFontStyle,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                          // _bookingDetails.length == 0
                                          // ? ""
                                          // : _bookingDetails[0]
                                          // .ConfirmedOn
                                          // .toString()
                                          // .contains("1900")
                                          // ? ""
                                          // : getCustomFormattedDateTime(
                                          // _bookingDetails[0].ConfirmedOn,
                                          // 'dd-MM-yyyy HH:mm')
                                          "15-01-2024 15:39",
                                          style: useMobileLayout
                                              ? TextStyle(fontSize: 15.0)
                                              : TextStyle(fontSize: 18.0))),
                                  // : _bookingDetails[0].ConfirmedOn)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 10.0)
                                  : const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                        " Assign to Trucking Company",
                                        style: useMobileLayout
                                            ? mobileTimeLineHeaderFontStyle
                                            : mobileGroupHeaderFontStyle,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                          // _bookingDetails.length == 0
                                          // ? ""
                                          // : _bookingDetails[0]
                                          // .PreGateDate
                                          // .toString()
                                          // .contains("1900")
                                          // ? ""
                                          // : getCustomFormattedDateTime(
                                          // _bookingDetails[0].PreGateDate,
                                          // 'dd-MM-yyyy HH:mm')
                                          "15-01-2024 15:39",
                                          style: useMobileLayout
                                              ? TextStyle(fontSize: 15.0)
                                              : TextStyle(fontSize: 18.0))),
                                  // : _bookingDetails[0].ConfirmedOn)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 10.0)
                                  : const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                        " Slot Status",
                                        style: useMobileLayout
                                            ? mobileTimeLineHeaderFontStyle
                                            : mobileGroupHeaderFontStyle,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                          // _bookingDetails.length == 0
                                          // ? ""
                                          // : _bookingDetails[0]
                                          // .GateInDate
                                          // .toString()
                                          // .contains("1900")
                                          // ? ""
                                          // : getCustomFormattedDateTime(
                                          // _bookingDetails[0].GateInDate,
                                          // 'dd-MM-yyyy HH:mm')
                                          "15-01-2024 15:39",
                                          style: useMobileLayout
                                              ? TextStyle(fontSize: 15.0)
                                              : TextStyle(fontSize: 18.0))),
                                  // : _bookingDetails[0].GateInDate)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 10.0)
                                  : const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                        " Yard check-in",
                                        style: useMobileLayout
                                            ? mobileTimeLineHeaderFontStyle
                                            : mobileGroupHeaderFontStyle,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                          // _bookingDetails.length == 0
                                          // ? ""
                                          // : _bookingDetails[0]
                                          // .ConfirmedOn
                                          // .toString()
                                          // .contains("1900")
                                          // ? ""
                                          // : getCustomFormattedDateTime(
                                          // _bookingDetails[0].ConfirmedOn,
                                          // 'dd-MM-yyyy HH:mm')
                                          "15-01-2024 15:39",
                                          style: useMobileLayout
                                              ? TextStyle(fontSize: 15.0)
                                              : TextStyle(fontSize: 18.0))),
                                  // : _bookingDetails[0].ConfirmedOn)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 10.0)
                                  : const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                        " Dock-in",
                                        style: useMobileLayout
                                            ? mobileTimeLineHeaderFontStyle
                                            : mobileGroupHeaderFontStyle,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                          // _bookingDetails.length == 0
                                          // ? ""
                                          // : _bookingDetails[0]
                                          // .PreGateDate
                                          // .toString()
                                          // .contains("1900")
                                          // ? ""
                                          // : getCustomFormattedDateTime(
                                          // _bookingDetails[0].PreGateDate,
                                          // 'dd-MM-yyyy HH:mm')
                                          "15-01-2024 15:39",
                                          style: useMobileLayout
                                              ? TextStyle(fontSize: 15.0)
                                              : TextStyle(fontSize: 18.0))),
                                  // : _bookingDetails[0].ConfirmedOn)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 10.0)
                                  : const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                        " Warehouse \n Acceptance",
                                        style: useMobileLayout
                                            ? mobileTimeLineHeaderFontStyle
                                            : mobileGroupHeaderFontStyle,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                          // _bookingDetails.length == 0
                                          // ? ""
                                          // : _bookingDetails[0]
                                          // .GateInDate
                                          // .toString()
                                          // .contains("1900")
                                          // ? ""
                                          // : getCustomFormattedDateTime(
                                          // _bookingDetails[0].GateInDate,
                                          // 'dd-MM-yyyy HH:mm')
                                          "15-01-2024 15:39",
                                          style: useMobileLayout
                                              ? TextStyle(fontSize: 15.0)
                                              : TextStyle(fontSize: 18.0))),
                                  // : _bookingDetails[0].GateInDate)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 10.0)
                                  : const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                        " Dock-out",
                                        style: useMobileLayout
                                            ? mobileTimeLineHeaderFontStyle
                                            : mobileGroupHeaderFontStyle,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                          // _bookingDetails.length == 0
                                          // ? ""
                                          // : _bookingDetails[0]
                                          // .GateOutDate
                                          // .toString()
                                          // .contains("1900")
                                          // ? ""
                                          // : getCustomFormattedDateTime(
                                          // _bookingDetails[0].GateOutDate,
                                          // 'dd-MM-yyyy HH:mm')
                                          "15-01-2024 15:39",
                                          style: useMobileLayout
                                              ? TextStyle(fontSize: 15.0)
                                              : TextStyle(fontSize: 18.0))),
                                  // : _bookingDetails[0].GateOutDate)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 10.0)
                                  : const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                        " Customs Release",
                                        style: useMobileLayout
                                            ? mobileTimeLineHeaderFontStyle
                                            : mobileGroupHeaderFontStyle,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                          // _bookingDetails.length == 0
                                          // ? ""
                                          // : _bookingDetails[0]
                                          // .GateOutDate
                                          // .toString()
                                          // .contains("1900")
                                          // ? ""
                                          // : getCustomFormattedDateTime(
                                          // _bookingDetails[0].GateOutDate,
                                          // 'dd-MM-yyyy HH:mm')
                                          "15-01-2024 15:39",
                                          style: useMobileLayout
                                              ? TextStyle(fontSize: 15.0)
                                              : TextStyle(fontSize: 18.0))),
                                  // : _bookingDetails[0].GateOutDate)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 10.0)
                                  : const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                        " DOC",
                                        style: useMobileLayout
                                            ? mobileTimeLineHeaderFontStyle
                                            : mobileGroupHeaderFontStyle,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                          // _bookingDetails.length == 0
                                          // ? ""
                                          // : _bookingDetails[0]
                                          // .GateOutDate
                                          // .toString()
                                          // .contains("1900")
                                          // ? ""
                                          // : getCustomFormattedDateTime(
                                          // _bookingDetails[0].GateOutDate,
                                          // 'dd-MM-yyyy HH:mm')
                                          "15-01-2024 15:39",
                                          style: useMobileLayout
                                              ? TextStyle(fontSize: 15.0)
                                              : TextStyle(fontSize: 18.0))),
                                  // : _bookingDetails[0].GateOutDate)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 10.0)
                                  : const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                        " RCS",
                                        style: useMobileLayout
                                            ? mobileTimeLineHeaderFontStyle
                                            : mobileGroupHeaderFontStyle,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                          // _bookingDetails.length == 0
                                          // ? ""
                                          // : _bookingDetails[0]
                                          // .GateOutDate
                                          // .toString()
                                          // .contains("1900")
                                          // ? ""
                                          // : getCustomFormattedDateTime(
                                          // _bookingDetails[0].GateOutDate,
                                          // 'dd-MM-yyyy HH:mm')
                                          "15-01-2024 15:39",
                                          style: useMobileLayout
                                              ? TextStyle(fontSize: 15.0)
                                              : TextStyle(fontSize: 18.0))),
                                  // : _bookingDetails[0].GateOutDate)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 10.0)
                                  : const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                        " SCR",
                                        style: useMobileLayout
                                            ? mobileTimeLineHeaderFontStyle
                                            : mobileGroupHeaderFontStyle,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                          // _bookingDetails.length == 0
                                          // ? ""
                                          // : _bookingDetails[0]
                                          // .GateOutDate
                                          // .toString()
                                          // .contains("1900")
                                          // ? ""
                                          // : getCustomFormattedDateTime(
                                          // _bookingDetails[0].GateOutDate,
                                          // 'dd-MM-yyyy HH:mm')
                                          "15-01-2024 15:39",
                                          style: useMobileLayout
                                              ? TextStyle(fontSize: 15.0)
                                              : TextStyle(fontSize: 18.0))),
                                  // : _bookingDetails[0].GateOutDate)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 10.0)
                                  : const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                        " Flight Dep.",
                                        style: useMobileLayout
                                            ? mobileTimeLineHeaderFontStyle
                                            : mobileGroupHeaderFontStyle,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                          // _bookingDetails.length == 0
                                          // ? ""
                                          // : _bookingDetails[0]
                                          // .GateOutDate
                                          // .toString()
                                          // .contains("1900")
                                          // ? ""
                                          // : getCustomFormattedDateTime(
                                          // _bookingDetails[0].GateOutDate,
                                          // 'dd-MM-yyyy HH:mm')
                                          "15-01-2024 15:39",
                                          style: useMobileLayout
                                              ? TextStyle(fontSize: 15.0)
                                              : TextStyle(fontSize: 18.0))),
                                  // : _bookingDetails[0].GateOutDate)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 10.0)
                                  : const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                        " Export Manifest",
                                        style: useMobileLayout
                                            ? mobileTimeLineHeaderFontStyle
                                            : mobileGroupHeaderFontStyle,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      child: Text(
                                          // _bookingDetails.length == 0
                                          // ? ""
                                          // : _bookingDetails[0]
                                          // .GateOutDate
                                          // .toString()
                                          // .contains("1900")
                                          // ? ""
                                          // : getCustomFormattedDateTime(
                                          // _bookingDetails[0].GateOutDate,
                                          // 'dd-MM-yyyy HH:mm')
                                          "15-01-2024 15:39",
                                          style: useMobileLayout
                                              ? TextStyle(fontSize: 15.0)
                                              : TextStyle(fontSize: 18.0))),
                                  // : _bookingDetails[0].GateOutDate)),
                                ],
                              ),
                            ),
                          ),
                        ],
                        indicators: <Widget>[
                          Icon(
                            // _bookingDetails.length == 0
                            //     ? Icons.schedule
                            //     : _bookingDetails[0]
                            //     .CreatedOn
                            //     .toString()
                            //     .contains("1900")
                            0 == 0
                                ? Icons.schedule
                                : Icons.check_circle_outline,
                            size: useMobileLayout ? 40 : 50,
                            color:
                                // _bookingDetails.length == 0
                                //     ? const Color(0xff3a3a3a)
                                //     : _bookingDetails[0]
                                //     .CreatedOn
                                //     .toString()
                                //     .contains("1900")
                                0 == 0
                                    ? Colors.red.shade200
                                    : Colors.green.shade200,
                          ),
                          Icon(
                            // _bookingDetails.length == 0
                            0 == 0
                                ? Icons.schedule
                                :
                                // _bookingDetails[0]
                                // .ConfirmedOn
                                // .toString()
                                // .contains("1900")
                                0 == 0
                                    ?
                                    // _bookingDetails[0].Status == 0
                                    0 == 0
                                        ? Icons.highlight_off
                                        : Icons.schedule
                                    : Icons.check_circle_outline,
                            size: useMobileLayout ? 40 : 50,
                            color:
                                // _bookingDetails.length == 0
                                0 == 0
                                    ? const Color(0xff3a3a3a)
                                    :
                                    // _bookingDetails[0]
                                    //   .ConfirmedOn
                                    //   .toString()
                                    //   .contains("1900")
                                    0 == 0
                                        ? Colors.red.shade200
                                        : Colors.green.shade200,
                          ),
                          Icon(
                            // _bookingDetails.length == 0
                            0 == 0
                                ? Icons.schedule
                                :
                                // _bookingDetails[0]
                                //                                     .PreGateDate
                                //                                     .toString()
                                //                                     .contains("1900")
                                0 == 0
                                    ? Icons.schedule
                                    :
                                    // _bookingDetails[0].PreGate == 2
                                    0 == 0
                                        ? Icons.highlight_off
                                        : Icons.check_circle_outline,
                            size: useMobileLayout ? 40 : 50,
                            color:
                                // _bookingDetails.length == 0
                                0 == 0
                                    ? const Color(0xff3a3a3a)
                                    :
                                    // _bookingDetails[0]
                                    //   .PreGateDate
                                    //   .toString()
                                    //   .contains("1900")
                                    0 == 0
                                        ? Colors.red.shade200
                                        :
                                        // _bookingDetails[0].PreGate == 1
                                        0 == 0
                                            ? Colors.green.shade200
                                            : Colors.red.shade200,
                          ),
                          Icon(
                            //  _bookingDetails.length == 0
                            0 == 0
                                ? Icons.schedule
                                :
                                // _bookingDetails[0]
                                //     .GateInDate
                                //     .toString()
                                //     .contains("1900")
                                0 == 0
                                    ? Icons.schedule
                                    :
                                    // _bookingDetails[0].GateIn == 2
                                    0 == 0
                                        ? Icons.highlight_off
                                        : Icons.check_circle_outline,
                            size: useMobileLayout ? 40 : 50,
                            color:
                                // _bookingDetails.length == 0
                                0 == 0
                                    ? const Color(0xff3a3a3a)
                                    :
                                    // _bookingDetails[0]
                                    //     .GateInDate
                                    //     .toString()
                                    //     .contains("1900")
                                    0 == 0
                                        ? Colors.red.shade200
                                        :
                                        // _bookingDetails[0].GateIn == 1
                                        0 == 0
                                            ? Colors.green.shade200
                                            : Colors.red.shade200,
                          ),
                          Icon(
                            // _bookingDetails.length == 0
                            0 == 0
                                ? Icons.schedule
                                :
                                // _bookingDetails[0]
                                //     .GateOutDate
                                //     .toString()
                                //     .contains("1900")
                                0 == 0
                                    ? Icons.schedule
                                    :
                                    // _bookingDetails[0].GateOut == 2
                                    0 == 0
                                        ? Icons.highlight_off
                                        : Icons.check_circle_outline,
                            size: useMobileLayout ? 40 : 50,
                            color:
                                // _bookingDetails.length == 0
                                0 == 0
                                    ? const Color(0xff3a3a3a)
                                    :
                                    // _bookingDetails[0]
                                    //     .GateOutDate
                                    //     .toString()
                                    //     .contains("1900")
                                    0 == 0
                                        ? Colors.red.shade200
                                        :
                                        // _bookingDetails[0].GateOut == 1
                                        0 == 0
                                            ? Colors.green.shade200
                                            : Colors.red.shade200,
                          ),
                          Icon(
                            // _bookingDetails.length == 0
                            0 == 0
                                ? Icons.schedule
                                :
                                // _bookingDetails[0]
                                // .ConfirmedOn
                                // .toString()
                                // .contains("1900")
                                0 == 0
                                    ?
                                    // _bookingDetails[0].Status == 0
                                    0 == 0
                                        ? Icons.highlight_off
                                        : Icons.schedule
                                    : Icons.check_circle_outline,
                            size: useMobileLayout ? 40 : 50,
                            color:
                                // _bookingDetails.length == 0
                                0 == 0
                                    ? const Color(0xff3a3a3a)
                                    :
                                    // _bookingDetails[0]
                                    //   .ConfirmedOn
                                    //   .toString()
                                    //   .contains("1900")
                                    0 == 0
                                        ? Colors.red.shade200
                                        : Colors.green.shade200,
                          ),
                          Icon(
                            // _bookingDetails.length == 0
                            0 == 0
                                ? Icons.schedule
                                :
                                // _bookingDetails[0]
                                //                                     .PreGateDate
                                //                                     .toString()
                                //                                     .contains("1900")
                                0 == 0
                                    ? Icons.schedule
                                    :
                                    // _bookingDetails[0].PreGate == 2
                                    0 == 0
                                        ? Icons.highlight_off
                                        : Icons.check_circle_outline,
                            size: useMobileLayout ? 40 : 50,
                            color:
                                // _bookingDetails.length == 0
                                0 == 0
                                    ? const Color(0xff3a3a3a)
                                    :
                                    // _bookingDetails[0]
                                    //   .PreGateDate
                                    //   .toString()
                                    //   .contains("1900")
                                    0 == 0
                                        ? Colors.red.shade200
                                        :
                                        // _bookingDetails[0].PreGate == 1
                                        0 == 0
                                            ? Colors.green.shade200
                                            : Colors.red.shade200,
                          ),
                          Icon(
                            //  _bookingDetails.length == 0
                            0 == 0
                                ? Icons.schedule
                                :
                                // _bookingDetails[0]
                                //     .GateInDate
                                //     .toString()
                                //     .contains("1900")
                                0 == 0
                                    ? Icons.schedule
                                    :
                                    // _bookingDetails[0].GateIn == 2
                                    0 == 0
                                        ? Icons.highlight_off
                                        : Icons.check_circle_outline,
                            size: useMobileLayout ? 40 : 50,
                            color:
                                // _bookingDetails.length == 0
                                0 == 0
                                    ? const Color(0xff3a3a3a)
                                    :
                                    // _bookingDetails[0]
                                    //     .GateInDate
                                    //     .toString()
                                    //     .contains("1900")
                                    0 == 0
                                        ? Colors.red.shade200
                                        :
                                        // _bookingDetails[0].GateIn == 1
                                        0 == 0
                                            ? Colors.green.shade200
                                            : Colors.red.shade200,
                          ),
                          Icon(
                            // _bookingDetails.length == 0
                            0 == 0
                                ? Icons.schedule
                                :
                                // _bookingDetails[0]
                                //     .GateOutDate
                                //     .toString()
                                //     .contains("1900")
                                0 == 0
                                    ? Icons.schedule
                                    :
                                    // _bookingDetails[0].GateOut == 2
                                    0 == 0
                                        ? Icons.highlight_off
                                        : Icons.check_circle_outline,
                            size: useMobileLayout ? 40 : 50,
                            color:
                                // _bookingDetails.length == 0
                                0 == 0
                                    ? const Color(0xff3a3a3a)
                                    :
                                    // _bookingDetails[0]
                                    //     .GateOutDate
                                    //     .toString()
                                    //     .contains("1900")
                                    0 == 0
                                        ? Colors.red.shade200
                                        :
                                        // _bookingDetails[0].GateOut == 1
                                        0 == 0
                                            ? Colors.green.shade200
                                            : Colors.red.shade200,
                          ),
                          Icon(
                            // _bookingDetails.length == 0
                            0 == 0
                                ? Icons.schedule
                                :
                                // _bookingDetails[0]
                                //     .GateOutDate
                                //     .toString()
                                //     .contains("1900")
                                0 == 0
                                    ? Icons.schedule
                                    :
                                    // _bookingDetails[0].GateOut == 2
                                    0 == 0
                                        ? Icons.highlight_off
                                        : Icons.check_circle_outline,
                            size: useMobileLayout ? 40 : 50,
                            color:
                                // _bookingDetails.length == 0
                                0 == 0
                                    ? const Color(0xff3a3a3a)
                                    :
                                    // _bookingDetails[0]
                                    //     .GateOutDate
                                    //     .toString()
                                    //     .contains("1900")
                                    0 == 0
                                        ? Colors.red.shade200
                                        :
                                        // _bookingDetails[0].GateOut == 1
                                        0 == 0
                                            ? Colors.green.shade200
                                            : Colors.red.shade200,
                          ),
                          Icon(
                            // _bookingDetails.length == 0
                            0 == 0
                                ? Icons.schedule
                                :
                                // _bookingDetails[0]
                                //     .GateOutDate
                                //     .toString()
                                //     .contains("1900")
                                0 == 0
                                    ? Icons.schedule
                                    :
                                    // _bookingDetails[0].GateOut == 2
                                    0 == 0
                                        ? Icons.highlight_off
                                        : Icons.check_circle_outline,
                            size: useMobileLayout ? 40 : 50,
                            color:
                                // _bookingDetails.length == 0
                                0 == 0
                                    ? const Color(0xff3a3a3a)
                                    :
                                    // _bookingDetails[0]
                                    //     .GateOutDate
                                    //     .toString()
                                    //     .contains("1900")
                                    0 == 0
                                        ? Colors.red.shade200
                                        :
                                        // _bookingDetails[0].GateOut == 1
                                        0 == 0
                                            ? Colors.green.shade200
                                            : Colors.red.shade200,
                          ),
                          Icon(
                            // _bookingDetails.length == 0
                            0 == 0
                                ? Icons.schedule
                                :
                                // _bookingDetails[0]
                                //     .GateOutDate
                                //     .toString()
                                //     .contains("1900")
                                0 == 0
                                    ? Icons.schedule
                                    :
                                    // _bookingDetails[0].GateOut == 2
                                    0 == 0
                                        ? Icons.highlight_off
                                        : Icons.check_circle_outline,
                            size: useMobileLayout ? 40 : 50,
                            color:
                                // _bookingDetails.length == 0
                                0 == 0
                                    ? const Color(0xff3a3a3a)
                                    :
                                    // _bookingDetails[0]
                                    //     .GateOutDate
                                    //     .toString()
                                    //     .contains("1900")
                                    0 == 0
                                        ? Colors.red.shade200
                                        :
                                        // _bookingDetails[0].GateOut == 1
                                        0 == 0
                                            ? Colors.green.shade200
                                            : Colors.red.shade200,
                          ),
                          Icon(
                            // _bookingDetails.length == 0
                            0 == 0
                                ? Icons.schedule
                                :
                                // _bookingDetails[0]
                                //     .GateOutDate
                                //     .toString()
                                //     .contains("1900")
                                0 == 0
                                    ? Icons.schedule
                                    :
                                    // _bookingDetails[0].GateOut == 2
                                    0 == 0
                                        ? Icons.highlight_off
                                        : Icons.check_circle_outline,
                            size: useMobileLayout ? 40 : 50,
                            color:
                                // _bookingDetails.length == 0
                                0 == 0
                                    ? const Color(0xff3a3a3a)
                                    :
                                    // _bookingDetails[0]
                                    //     .GateOutDate
                                    //     .toString()
                                    //     .contains("1900")
                                    0 == 0
                                        ? Colors.red.shade200
                                        :
                                        // _bookingDetails[0].GateOut == 1
                                        0 == 0
                                            ? Colors.green.shade200
                                            : Colors.red.shade200,
                          ),
                          Icon(
                            // _bookingDetails.length == 0
                            0 == 0
                                ? Icons.schedule
                                :
                                // _bookingDetails[0]
                                //     .GateOutDate
                                //     .toString()
                                //     .contains("1900")
                                0 == 0
                                    ? Icons.schedule
                                    :
                                    // _bookingDetails[0].GateOut == 2
                                    0 == 0
                                        ? Icons.highlight_off
                                        : Icons.check_circle_outline,
                            size: useMobileLayout ? 40 : 50,
                            color:
                                // _bookingDetails.length == 0
                                0 == 0
                                    ? const Color(0xff3a3a3a)
                                    :
                                    // _bookingDetails[0]
                                    //     .GateOutDate
                                    //     .toString()
                                    //     .contains("1900")
                                    0 == 0
                                        ? Colors.red.shade200
                                        :
                                        // _bookingDetails[0].GateOut == 1
                                        0 == 0
                                            ? Colors.green.shade200
                                            : Colors.red.shade200,
                          ),
                          Icon(
                            // _bookingDetails.length == 0
                            0 == 0
                                ? Icons.schedule
                                :
                                // _bookingDetails[0]
                                //     .GateOutDate
                                //     .toString()
                                //     .contains("1900")
                                0 == 0
                                    ? Icons.schedule
                                    :
                                    // _bookingDetails[0].GateOut == 2
                                    0 == 0
                                        ? Icons.highlight_off
                                        : Icons.check_circle_outline,
                            size: useMobileLayout ? 40 : 50,
                            color:
                                // _bookingDetails.length == 0
                                0 == 0
                                    ? const Color(0xff3a3a3a)
                                    :
                                    // _bookingDetails[0]
                                    //     .GateOutDate
                                    //     .toString()
                                    //     .contains("1900")
                                    0 == 0
                                        ? Colors.red.shade200
                                        :
                                        // _bookingDetails[0].GateOut == 1
                                        0 == 0
                                            ? Colors.green.shade200
                                            : Colors.red.shade200,
                          ),
                        ],
                      ),
                    )
                      // Container(
                      //   height: isImport
                      //       ? trackingType == 0 || trackingType == 1
                      //           ? MediaQuery.of(context).size.height / 1.85
                      //           : trackingType == 2
                      //               ? MediaQuery.of(context).size.height / 1.62
                      //               : MediaQuery.of(context).size.height / 1.85
                      //       : trackingType == 1
                      //           ? MediaQuery.of(context).size.height / 1.85
                      //           : MediaQuery.of(context).size.height / 1.62,
                      //   width: MediaQuery.of(context).size.width,
                      //   margin: EdgeInsets.only(right: 8, top: 8),
                      //   child:,
                      // ),

                      // SingleChildScrollView(
                      //   child: Padding(
                      //     padding: useMobileLayout
                      //         ? const EdgeInsets.only(top: 2.0, left: 0.0)
                      //         : const EdgeInsets.only(
                      //             top: 2.0, bottom: 10.0, left: 40.0),
                      //     child: SizedBox(
                      //         width: useMobileLayout
                      //             ? MediaQuery.of(context).size.width / 1.01
                      //             : MediaQuery.of(context).size.width / 1.19,
                      //         child: ListView.builder(
                      //           physics: NeverScrollableScrollPhysics(),
                      //           itemBuilder: (BuildContext, index) {
                      //             VehicleToken _dockinlist =
                      //                 vehicleToeknListToBind.elementAt(index);
                      //             return buildDockList(_dockinlist, index);
                      //           },
                      //           itemCount: vehicleToeknListToBind.length,
                      //           shrinkWrap: true,
                      //           padding: EdgeInsets.all(2),
                      //         )),
                      //   ),
                      // ),
                      )
                  : Expanded(
                      child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: useMobileLayout ? 40 : 60,
                            color: Color(0xFF11249F),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 20, left: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.8,
                                      child: Text(
                                        " EVT Number",
                                        style: useMobileLayout
                                            ? mobileHeaderFontStyleBold2
                                            : iPadGroupHeaderFontStyleBold2,
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.4,
                                      child: Text(
                                        "Vehicle Number",
                                        style: useMobileLayout
                                            ? mobileHeaderFontStyleBold2
                                            : iPadGroupHeaderFontStyleBold2,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: evtList.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              EVTDetails evtListItems =
                                  evtList.elementAt(index);
                              return evtListItem(context, evtListItems, index);
                            },
                          ),
                        ],
                      ),
                    )
                      // Container(
                      //   height: isImport
                      //       ? trackingType == 0 || trackingType == 1
                      //           ? MediaQuery.of(context).size.height / 1.85
                      //           : trackingType == 2
                      //               ? MediaQuery.of(context).size.height / 1.62
                      //               : MediaQuery.of(context).size.height / 1.85
                      //       : trackingType == 1
                      //           ? MediaQuery.of(context).size.height / 1.85
                      //           : MediaQuery.of(context).size.height / 1.62,
                      //   width: MediaQuery.of(context).size.width,
                      //   margin: EdgeInsets.only(right: 8, top: 8),
                      //   child:,
                      // ),

                      // SingleChildScrollView(
                      //   child: Padding(
                      //     padding: useMobileLayout
                      //         ? const EdgeInsets.only(top: 2.0, left: 0.0)
                      //         : const EdgeInsets.only(
                      //             top: 2.0, bottom: 10.0, left: 40.0),
                      //     child: SizedBox(
                      //         width: useMobileLayout
                      //             ? MediaQuery.of(context).size.width / 1.01
                      //             : MediaQuery.of(context).size.width / 1.19,
                      //         child: ListView.builder(
                      //           physics: NeverScrollableScrollPhysics(),
                      //           itemBuilder: (BuildContext, index) {
                      //             VehicleToken _dockinlist =
                      //                 vehicleToeknListToBind.elementAt(index);
                      //             return buildDockList(_dockinlist, index);
                      //           },
                      //           itemCount: vehicleToeknListToBind.length,
                      //           shrinkWrap: true,
                      //           padding: EdgeInsets.all(2),
                      //         )),
                      //   ),
                      // ),
                      ),
        ],
      ),
    );
  }

  evtListItem(BuildContext context, EVTDetails evtDetails, index) {
    return Card(
      color: Colors.white,
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
        child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Text(
                    " EVT2401190001",
                    style: useMobileLayout
                        ? mobileTimeLineHeaderFontStyle
                        : mobileGroupHeaderFontStyle,
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 3.1,
                  child: Text(
                    " 12341111",
                    style: useMobileLayout
                        ? mobileTimeLineHeaderFontStyle
                        : mobileGroupHeaderFontStyle,
                  )),
            ],
          ),
          // subtitle: Text(" 1234",style: TextStyle(color: Colors.black87),),
          children: [
            Timeline(
              children: <Widget>[
                Container(
                  height: 50,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        SizedBox(
                            width: useMobileLayout
                                ? MediaQuery.of(context).size.width / 2.6
                                : MediaQuery.of(context).size.width / 1.9,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 2.0)
                                  : const EdgeInsets.only(left: 14.0),
                              child: Text(
                                " Parking Area",
                                style: useMobileLayout
                                    ? mobileTimeLineHeaderFontStyle
                                    : mobileGroupHeaderFontStyle,
                              ),
                            )),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 2.6,
                            child: Text(
                              // _bookingDetails.length == 0
                              // ? ""
                              // : _bookingDetails[0]
                              // .CreatedOn
                              // .toString()
                              // .contains("1900")
                              // ? ""
                              // : getCustomFormattedDateTime(
                              // _bookingDetails[0].CreatedOn,
                              // 'dd-MM-yyyy HH:mm')
                              "15-01-2024 15:39",
                              style: useMobileLayout
                                  ? mobileTimeLineHeaderFontStyle
                                  : mobileGroupHeaderFontStyle,
                            )),
                        // : _bookingDetails[0].CreatedOn)),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        SizedBox(
                            width: useMobileLayout
                                ? MediaQuery.of(context).size.width / 2.6
                                : MediaQuery.of(context).size.width / 1.9,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 2.0)
                                  : const EdgeInsets.only(left: 14.0),
                              child: Text(
                                " Dock-IN",
                                style: useMobileLayout
                                    ? mobileTimeLineHeaderFontStyle
                                    : mobileGroupHeaderFontStyle,
                              ),
                            )),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 2.6,
                            child: Text(
                              // _bookingDetails.length == 0
                              // ? ""
                              // : _bookingDetails[0]
                              // .GateOutDate
                              // .toString()
                              // .contains("1900")
                              // ? ""
                              // : getCustomFormattedDateTime(
                              // _bookingDetails[0].GateOutDate,
                              // 'dd-MM-yyyy HH:mm')
                              "15-01-2024 15:39",
                              style: useMobileLayout
                                  ? mobileTextFontStyle
                                  : iPadTextFontStyle,
                            )),
                        // : _bookingDetails[0].GateOutDate)),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        SizedBox(
                            width: useMobileLayout
                                ? MediaQuery.of(context).size.width / 2.6
                                : MediaQuery.of(context).size.width / 1.9,
                            child: Padding(
                              padding: useMobileLayout
                                  ? const EdgeInsets.only(left: 2.0)
                                  : const EdgeInsets.only(left: 14.0),
                              child: Text(
                                " Dock-OUT",
                                style: useMobileLayout
                                    ? mobileTextFontStyle
                                    : mobileGroupHeaderFontStyle,
                              ),
                            )),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 2.6,
                            child: Text(
                              // _bookingDetails.length == 0
                              // ? ""
                              // : _bookingDetails[0]
                              // .ConfirmedOn
                              // .toString()
                              // .contains("1900")
                              // ? ""
                              // : getCustomFormattedDateTime(
                              // _bookingDetails[0].ConfirmedOn,
                              // 'dd-MM-yyyy HH:mm')
                              "15-01-2024 15:39",
                              style: useMobileLayout
                                  ? mobileTextFontStyle
                                  : iPadTextFontStyle,
                            )),
                        // : _bookingDetails[0].ConfirmedOn)),
                      ],
                    ),
                  ),
                ),
              ],
              indicators: <Widget>[
                Icon(
                  // _bookingDetails.length == 0
                  //     ? Icons.schedule
                  //     : _bookingDetails[0]
                  //     .CreatedOn
                  //     .toString()
                  //     .contains("1900")
                  0 == 0 ? Icons.schedule : Icons.check_circle_outline,
                  size: useMobileLayout ? 40 : 50,
                  color:
                      // _bookingDetails.length == 0
                      //     ? const Color(0xff3a3a3a)
                      //     : _bookingDetails[0]
                      //     .CreatedOn
                      //     .toString()
                      //     .contains("1900")
                      0 == 0 ? Colors.red.shade200 : Colors.green.shade200,
                ),
                Icon(
                  // _bookingDetails.length == 0
                  0 == 0
                      ? Icons.schedule
                      :
                      // _bookingDetails[0]
                      // .ConfirmedOn
                      // .toString()
                      // .contains("1900")
                      0 == 0
                          ?
                          // _bookingDetails[0].Status == 0
                          0 == 0
                              ? Icons.highlight_off
                              : Icons.schedule
                          : Icons.check_circle_outline,
                  size: useMobileLayout ? 40 : 50,
                  color:
                      // _bookingDetails.length == 0
                      0 == 0
                          ? const Color(0xff3a3a3a)
                          :
                          // _bookingDetails[0]
                          //   .ConfirmedOn
                          //   .toString()
                          //   .contains("1900")
                          0 == 0
                              ? Colors.red.shade200
                              : Colors.green.shade200,
                ),
                Icon(
                  // _bookingDetails.length == 0
                  0 == 0
                      ? Icons.schedule
                      :
                      // _bookingDetails[0]
                      //                                     .PreGateDate
                      //                                     .toString()
                      //                                     .contains("1900")
                      0 == 0
                          ? Icons.schedule
                          :
                          // _bookingDetails[0].PreGate == 2
                          0 == 0
                              ? Icons.highlight_off
                              : Icons.check_circle_outline,
                  size: useMobileLayout ? 40 : 50,
                  color:
                      // _bookingDetails.length == 0
                      0 == 0
                          ? const Color(0xff3a3a3a)
                          :
                          // _bookingDetails[0]
                          //   .PreGateDate
                          //   .toString()
                          //   .contains("1900")
                          0 == 0
                              ? Colors.red.shade200
                              :
                              // _bookingDetails[0].PreGate == 1
                              0 == 0
                                  ? Colors.green.shade200
                                  : Colors.red.shade200,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EVTDetails {
  final String EVTno;
  final String VehicleNo;
  final String PendingArea;
  final String DockIn;
  final String DockOut;

  EVTDetails({
    required this.EVTno,
    required this.VehicleNo,
    required this.PendingArea,
    required this.DockIn,
    required this.DockOut,
  });
}
