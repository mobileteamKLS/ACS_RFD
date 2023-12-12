import 'dart:convert';

import 'package:luxair/datastructure/slotbooking.dart';
import 'package:luxair/otherpages/newslotbooking.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:luxair/widgets/headers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import '../constants.dart';
import '../global.dart';

class SlotsListAdditional extends StatefulWidget {
  final List<AWBDetail> selectedShipments;
  final List<AWBDetailImport> selectedShipmentsImports;
  final String custodianID;
  final String mode;
  const SlotsListAdditional(
      {Key? key,
      required this.selectedShipments,
      required this.selectedShipmentsImports,
      required this.custodianID,
      required this.mode})
      : super(key: key);

  @override
  State<SlotsListAdditional> createState() => _SlotsListAdditionalState();
}

class _SlotsListAdditionalState extends State<SlotsListAdditional> {
  final _controllerModeType = ValueNotifier<bool>(false);
  bool checked = false;
  StepperType stepperType = StepperType.vertical;
  bool isOnLastStep = false;
  bool isLoading = false;
  List<AWBDetail> shipmentList = [];
  List<AWBDetailImport> shipmentListImport = [];

  String selectedMode = "Export";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderClipperWaveAdditional(
                  color1: Color(0xFF3383CD),
                  color2: Color(0xFF11249F),
                  headerText: "Shipment List"),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Text("Mode", style: mobileHeaderFontStyle),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child:
                          Text(widget.mode, style: mobileHeaderFontStyleBold),
                    ),
                  ],
                ),
              ),
                SizedBox(height: 5),
                 Padding(
                padding:
                    const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.1,
                  color: Color(0xFF0461AA),
                ),
              ),
              isLoading
                  ? Center(
                      child: Container(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator()))
                  : Expanded(
                      child: SingleChildScrollView(
                        //scrollDirection: Axis.horizontal,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: [
                            //     Container(
                            //       width: 30,
                            //       height: 60,
                            //       color: Colors.yellow.shade300,
                            //       child: Padding(
                            //         padding:
                            //             const EdgeInsets.only(top: 16.0),
                            //         child: Text(
                            //           '', //'Select',
                            //           style: mobileDetailsYellowNormal,
                            //           textAlign: TextAlign.center,
                            //         ),
                            //       ),
                            //     ),
                            //     Container(
                            //       width: 130,
                            //       height: 60,
                            //       color: Colors.yellow.shade300,
                            //       child: Padding(
                            //         padding:
                            //             const EdgeInsets.only(top: 16.0),
                            //         child: Text(
                            //           'MAWB No.',
                            //           style: mobileDetailsYellowNormal,
                            //           textAlign: TextAlign.center,
                            //         ),
                            //       ),
                            //     ),
                            //     Container(
                            //       width: 100,
                            //       height: 60,
                            //       color: Colors.yellow.shade300,
                            //       child: Padding(
                            //         padding: const EdgeInsets.only(
                            //             top: 16.0, left: 8.0),
                            //         child: Text(
                            //           'Handler/\nLocation',
                            //           style: mobileDetailsYellowNormal,
                            //           textAlign: TextAlign.left,
                            //         ),
                            //       ),
                            //     ),
                            //     Container(
                            //       width: 120,
                            //       height: 60,
                            //       color: Colors.yellow.shade300,
                            //       child: Padding(
                            //         padding:
                            //             const EdgeInsets.only(top: 16.0),
                            //         child: Text(
                            //           'Freight\nForwarder',
                            //           style: mobileDetailsYellowNormal,
                            //           textAlign: TextAlign.left,
                            //         ),
                            //       ),
                            //     ),
                            //     Container(
                            //       width: 70,
                            //       height: 60,
                            //       color: Colors.yellow.shade300,
                            //       child: Padding(
                            //         padding: const EdgeInsets.only(
                            //             top: 16.0, left: 16),
                            //         child: Text(
                            //           'NOP',
                            //           style: mobileDetailsYellowNormal,
                            //           textAlign: TextAlign.left,
                            //         ),
                            //       ),
                            //     ),
                            //     Container(
                            //       width: 120,
                            //       height: 60,
                            //       color: Colors.yellow.shade300,
                            //       child: Padding(
                            //         padding:
                            //             const EdgeInsets.only(top: 16.0),
                            //         child: Text(
                            //           'Total Gr.Wt.',
                            //           style: mobileDetailsYellowNormal,
                            //           textAlign: TextAlign.center,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            if (selectedMode == "Export")
                              for (var i = 0; i < shipmentList.length; i++)
                                buildSlotsList(shipmentList[i], i),
                            if (selectedMode == "Import")
                              for (var i = 0;
                                  i < shipmentListImport.length;
                                  i++)
                                buildSlotsListImport(
                                    shipmentListImport[i], i),
                          ],
                        ),
                      ),
                    ),
              if (!isLoading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedMode == "Import") {
                          List<AWBDetailImport> matches = [];
                          matches.addAll(shipmentListImport);
                          matches.retainWhere((AWBDetailImport s) =>
                              s.selected == true && s.enabled == true);
                          print(
                              "length matches = " + matches.length.toString());

                          Navigator.of(context).pop(matches);
                        } else {
                          List<AWBDetail> matches = [];
                          matches.addAll(shipmentList);
                          matches.retainWhere((AWBDetail s) =>
                              s.selected == true && s.enabled == true);
                          print(
                              "length matches = " + matches.length.toString());

                          Navigator.of(context).pop(matches);
                        }

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => NewSlotBooking(
                        //               selectedShipments: matches,
                        //             )));
                      },

                      style: ElevatedButton.styleFrom(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)), //
                        padding: const EdgeInsets.all(0.0),
                      ),
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xFF3540E8),
                              Color(0xFF3540E8),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Done',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      //Text('CONTAINED BUTTON'),
                    ),
                  ),
                ),
            ]),
      ),
    );
    // Expanded();
  }

  // buildSlotsList(AWBDetail awbDT, index) {
  //   //print("index is ==" + index.toString());
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       SizedBox(
  //         width: 40,
  //         height: 60,
  //         child: Checkbox(
  //           checkColor: Colors.white,
  //           value: awbDT.selected,
  //           onChanged: awbDT.enabled == false
  //               ? null
  //               : (bool? value) {
  //                   setState(() {
  //                     awbDT.selected = value!;
  //                   });
  //                 },
  //         ),
  //       ),
  //       Container(
  //         width: 130,
  //         height: 60,
  //         //color: Colors.yellow.shade300,
  //         child: Padding(
  //           padding: const EdgeInsets.only(top: 16.0),
  //           child: Text(
  //             awbDT.AirlinePrefix.toString() +
  //                 "-" +
  //                 awbDT.MAWBNumber.toString(),
  //             style: mobileDetailsYellowNormal,
  //           ),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(left: 4.0),
  //         child: Container(
  //           width: 100,
  //           height: 70,
  //           // color: Colors.yellow.shade300,
  //           child: Padding(
  //             padding: const EdgeInsets.only(top: 16.0),
  //             child: Text(
  //               awbDT.Custodian.toString(),
  //               // "Swisspoer Handlung Services",// ,
  //               style: mobileDetailsYellowNormal,
  //               textAlign: TextAlign.left,
  //             ),
  //           ),
  //         ),
  //       ),
  //       Container(
  //         width: 120,
  //         height: 70,
  //         //color: Colors.yellow.shade300,
  //         child: Padding(
  //           padding: const EdgeInsets.only(top: 16.0),
  //           child: Text(
  //             awbDT.FreightForwarder.toString(),
  //             // "Swisspoer Handlung Services",// awbDT.FreightForwarder.toString(),
  //             style: mobileDetailsYellowNormal,
  //           ),
  //         ),
  //       ),
  //       Container(
  //         width: 70,
  //         height: 60,
  //         //   color: Colors.yellow.shade300,
  //         child: Padding(
  //           padding: const EdgeInsets.only(top: 16.0),
  //           child: Text(
  //             awbDT.PiecesCount.toString(),
  //             style: mobileDetailsYellowNormal,
  //           ),
  //         ),
  //       ),
  //       Container(
  //         width: 120,
  //         height: 60,
  //         // color: Colors.yellow.shade300,
  //         child: Padding(
  //           padding: const EdgeInsets.only(top: 16.0),
  //           child: Text(
  //             awbDT.Weight.toStringAsFixed(3) +
  //                 " " +
  //                 awbDT.WeightUnitID.toString(),
  //             style: mobileDetailsYellowNormal,
  //           ),
  //         ),
  //       ),
  //       // Container(
  //       //   width: 70,
  //       //   height: 60,
  //       //  // color: Colors.yellow.shade300,
  //       //   child: Text(
  //       //     awbDT.WeightUnitID.toString(),
  //       //     style: mobileDetailsYellowNormal,
  //       //   ),
  //       // ),
  //     ],
  //   );
  // }

  // buildSlotsListImport(AWBDetailImport awbDT, index) {
  //   //print("index is ==" + index.toString());
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       SizedBox(
  //         width: 40,
  //         height: 60,
  //         child: Checkbox(
  //           checkColor: Colors.white,
  //           value: awbDT.selected,
  //           onChanged: awbDT.enabled == false
  //               ? null
  //               : (bool? value) {
  //                   setState(() {
  //                     awbDT.selected = value!;
  //                   });
  //                 },
  //         ),
  //       ),
  //       Container(
  //         width: 130,
  //         height: 60,
  //         //color: Colors.yellow.shade300,
  //         child: Padding(
  //           padding: const EdgeInsets.only(top: 16.0),
  //           child: Text(
  //             awbDT.AirlinePrefix.toString() +
  //                 "-" +
  //                 awbDT.MAWBNumber.toString(),
  //             style: mobileDetailsYellowNormal,
  //           ),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(left: 4.0),
  //         child: Container(
  //           width: 100,
  //           height: 70,
  //           // color: Colors.yellow.shade300,
  //           child: Padding(
  //             padding: const EdgeInsets.only(top: 16.0),
  //             child: Text(
  //               awbDT.GHA.toString(),
  //               // "Swisspoer Handlung Services",// ,
  //               style: mobileDetailsYellowNormal,
  //               textAlign: TextAlign.left,
  //             ),
  //           ),
  //         ),
  //       ),
  //       Container(
  //         width: 120,
  //         height: 70,
  //         //color: Colors.yellow.shade300,
  //         child: Padding(
  //           padding: const EdgeInsets.only(top: 16.0),
  //           child: Text(
  //             awbDT.FreightForwarder.toString(),
  //             // "Swisspoer Handlung Services",// awbDT.FreightForwarder.toString(),
  //             style: mobileDetailsYellowNormal,
  //           ),
  //         ),
  //       ),
  //       Container(
  //         width: 70,
  //         height: 60,
  //         //   color: Colors.yellow.shade300,
  //         child: Padding(
  //           padding: const EdgeInsets.only(top: 16.0),
  //           child: Text(
  //             awbDT.AWBPcs.toString(),
  //             style: mobileDetailsYellowNormal,
  //           ),
  //         ),
  //       ),
  //       Container(
  //         width: 120,
  //         height: 60,
  //         // color: Colors.yellow.shade300,
  //         child: Padding(
  //           padding: const EdgeInsets.only(top: 16.0),
  //           child: Text(
  //             awbDT.GrWt.toStringAsFixed(3) +
  //                 " " +
  //                 awbDT.WeightUnitId.toString(),
  //             style: mobileDetailsYellowNormal,
  //           ),
  //         ),
  //       ),
  //       // Container(
  //       //   width: 70,
  //       //   height: 60,
  //       //  // color: Colors.yellow.shade300,
  //       //   child: Text(
  //       //     awbDT.WeightUnitID.toString(),
  //       //     style: mobileDetailsYellowNormal,
  //       //   ),
  //       // ),
  //     ],
  //   );
  // }

  buildSlotsList(AWBDetail awbDT, index) {
    return Card(
      elevation: awbDT.selected ? 4 : 2,
      shadowColor: awbDT.selected ? Colors.amber : Colors.grey.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              checkColor: Colors.white,
              value: awbDT.selected,
              onChanged: awbDT.enabled == false
                  ? null
                  : (bool? value) {
                      setState(() {
                        awbDT.selected = value!;
                      });
                    },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  awbDT.AirlinePrefix.toString() +
                      "-" +
                      awbDT.MAWBNumber.toString(),
                  style: mobileGroupHeaderFontStyleBold,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            awbDT.Custodian
                                .toString(), // + " services pvt ltd",
                            style: VTlistTextFontStyle,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 3),
                          Text(
                            awbDT.FreightForwarder.toString(),
                            style: VTlistTextFontStyle,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                height: 40,
                width: 3,
                color: Color(0xFF0461AA),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " ",
                      style: VTlistTextFontStylesmall,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 3),
                    Text(
                      awbDT.PiecesCount.toString() + " PCS",
                      style: VTlistTextFontStylesmall,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 3),
                    Text(
                      // awbDT.GrossWeight.toStringAsFixed(2) +
                      "12345.00 " + awbDT.WeightUnitID.toString(),
                      style: VTlistTextFontStylesmall,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSlotsListImport(AWBDetailImport awbDT, index) {
    return Card(
      elevation: awbDT.selected ? 4 : 2,
      shadowColor: awbDT.selected ? Colors.amber : Colors.grey.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              checkColor: Colors.white,
              value: awbDT.selected,
              onChanged: awbDT.enabled == false
                  ? null
                  : (bool? value) {
                      setState(() {
                        awbDT.selected = value!;
                      });
                    },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  awbDT.AirlinePrefix.toString() +
                      "-" +
                      awbDT.MAWBNumber.toString(),
                  style: mobileGroupHeaderFontStyleBold,
                ),
                Text(
                  "H# : " + awbDT.HAWBNumber.toString(),
                  style: mobileGroupHeaderFontStyleBoldSmall,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            awbDT.GHA.toString(), // + " services pvt ltd",
                            style: VTlistTextFontStyle,
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            awbDT.FreightForwarder.toString(),
                            style: VTlistTextFontStyle,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                height: 40,
                width: 3,
                color: Color(0xFF0461AA),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " ",
                    style: VTlistTextFontStylesmall,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    awbDT.AWBPcs.toString() + " PCS",
                    style: VTlistTextFontStylesmall,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    awbDT.GrWt.toStringAsFixed(2) +
                        " " +
                        awbDT.WeightUnitId.toString(),
                    style: VTlistTextFontStylesmall,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    selectedMode = widget.mode;
    getShipmentList();
    // _controllerModeType.addListener(() {
    //   setState(() {
    //     if (_controllerModeType.value) {
    //       checked = true;
    //       print("value chnaged heere TO === IMPORT");
    //       selectedMode = "Import";
    //     } else {
    //       checked = false;
    //       print("value chnaged heere TO === EXPORT");
    //       selectedMode = "Export";
    //     }
    //     getShipmentList();
    //   });
    // });
    super.initState();
  }

  @override
  void dispose() {
    _controllerModeType.dispose();

    super.dispose();
  }

  getShipmentList() async {
    if (isLoading) return;

    shipmentList = [];
    shipmentListImport = [];

    setState(() {
      isLoading = true;
    });

    // var queryParams = {
    //   "createdByID": loggedinUser.CreatedByUserId.toString(),
    //   "organizationBranchID": loggedinUser.OrganizationBranchId.toString(),
    //   "isWFSIntegrated": "0",
    //   "filterCondition": (widget.custodianID == "")
    //       ? ""
    //       : "CUSTODIAN like " + "'%" + widget.custodianID + "%'",
    //   "PageNumber": 0,
    //   "RecordsPerPage": 0,
    //   "sortOrder": "",
    //   "sortColumn": "",
    // };

    var queryParams = {};

    queryParams = selectedMode == "Import"
        ? {
            "createdByID": loggedinUser.CreatedByUserId,
            "organizationBranchID": loggedinUser.OrganizationBranchId,
            "filterCondition": (widget.custodianID == "")
                ? ""
                : "CUSTODIAN like " + "'%" + widget.custodianID + "%'",
            "PageNumber": 1,
            "RecordsPerPage": 1,
            "sortColumn": "",
            "sortOrder": "",
            "isWFSIntegrated": "0"
          }
        : {
            "createdByID": loggedinUser.CreatedByUserId.toString(),
            "organizationBranchID":
                loggedinUser.OrganizationBranchId.toString(),
            "isWFSIntegrated": "0",
            "filterCondition": (widget.custodianID == "")
                ? ""
                : "CUSTODIAN like " + "'%" + widget.custodianID + "%'",
            "PageNumber": 0,
            "RecordsPerPage": 0,
            "sortOrder": "",
            "sortColumn": "",
          };

    await Global()
        .postData(
      selectedMode == "Import"
          ? Settings.SERVICES['GetShipmentListImport']
          : Settings.SERVICES['GetShipmentListExport'],
      queryParams,
    )
        .then((response) {
      print("data received ");

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      if (selectedMode == "Import") {
        shipmentListImport = resp
            .map<AWBDetailImport>((json) => AWBDetailImport.fromJson(json))
            .toList();

        if (shipmentListImport.length > 0) {
          if (widget.selectedShipmentsImports.isNotEmpty) {
            for (int i = 0; i < widget.selectedShipmentsImports.length; i++) {
              for (int j = 0; j < shipmentListImport.length; j++) {
                if (widget.selectedShipmentsImports[i].DOID ==
                    shipmentListImport[j].DOID) {
                  shipmentListImport[j].selected = true;
                  shipmentListImport[j].enabled = false;
                }
              }
            }
          }
        }

        print("length shipmentListImport = " +
            shipmentListImport.length.toString());
      } else {
        shipmentList =
            resp.map<AWBDetail>((json) => AWBDetail.fromJson(json)).toList();

        if (shipmentList.length > 0) {
          if (widget.selectedShipments.isNotEmpty) {
            for (int i = 0; i < widget.selectedShipments.length; i++) {
              for (int j = 0; j < shipmentList.length; j++) {
                if (widget.selectedShipments[i].AWBID ==
                    shipmentList[j].AWBID) {
                  shipmentList[j].selected = true;
                  shipmentList[j].enabled = false;
                }
              }
            }
          }
        }

        print("length shipmentList = " + shipmentList.length.toString());
      }

      setState(() {
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
  }
}

class HeaderClipperWaveAdditional extends StatelessWidget {
  final Color color1;
  final Color color2;
  final String headerText;

  const HeaderClipperWaveAdditional(
      {Key? key,
      required this.color1,
      required this.color2,
      required this.headerText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool useMobileLayout = false;

    if (kIsWeb) {
      // running on the web!
      print("running on the web!");
      useMobileLayout = false;
    } else {
      var smallestDimension = MediaQuery.of(context).size.shortestSide;
      useMobileLayout = smallestDimension < 600;
    }
    return ClipPath(
      //upper clippath with less height
      clipper: kIsWeb
          ? WaveClipper()
          : useMobileLayout
              ? WaveClipperNew()
              : WaveClipper(), //set our custom wave clipper.
      child: Container(
        padding: EdgeInsets.only(
            bottom: kIsWeb
                ? 0
                : useMobileLayout
                    ? 40
                    : 60),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            colors: [
              color1, //  Color(0xFF3383CD),
              color2, //   Color(0xFF11249F),
            ],
          ),
        ),
        height: MediaQuery.of(context).size.height / 6, //180,
        alignment: Alignment.center,

        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //         builder: (BuildContext context) => Dashboards()));
                    //     //Navigator.of(context).pop();
                    //   },
                    //   child: Center(
                    //     child: Icon(
                    //       Icons.chevron_left,
                    //       size: useMobileLayout
                    //           ? 40
                    //           : MediaQuery.of(context).size.width / 18, //56,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(width: useMobileLayout ? 50 : 20),
                    Text(
                      headerText, // "Walk-in Details ",
                      style: TextStyle(
                          fontSize: kIsWeb
                              ? 48
                              : MediaQuery.of(context).size.width / 18, //48,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              if (headerText.contains("multiline"))
                Text(
                  " Mode : Export",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 18, //48,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
            ]),
      ),
    );
  }
}
