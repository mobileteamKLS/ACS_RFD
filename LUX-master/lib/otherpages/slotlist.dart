import 'dart:convert';

import 'package:luxair/datastructure/slotbooking.dart';
import 'package:luxair/otherpages/newslotbooking.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import '../constants.dart';
import '../global.dart';

class SlotsList extends StatefulWidget {
  const SlotsList({Key? key}) : super(key: key);

  @override
  State<SlotsList> createState() => _SlotsListState();
}

class _SlotsListState extends State<SlotsList> {
  final _controllerModeType = ValueNotifier<bool>(false);
  bool checked = false;
  StepperType stepperType = StepperType.vertical;
  bool isOnLastStep = false;
  bool isLoading = false;
  String selectedMode = "Export";
  String selectedGHA = "";
  int selectedGHAID = 0;
  int totalSelect = 0;

  List<AWBDetail> shipmentList = [];
  List<AWBDetail> shipmentListMain = [];

  List<AWBDetailImport> shipmentListImport = [];
  List<AWBDetailImport> shipmentListMainImport = [];

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
                  headerText: "Shipment List "),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Text("Mode", style: mobileHeaderFontStyle),
                    ),
                    AdvancedSwitch(
                      activeColor: Color(0xFF11249F),
                      inactiveColor: Color(0xFF11249F),
                      activeChild:
                          Text('Import', style: mobileTextFontStyleWhite),
                      inactiveChild:
                          Text('Export', style: mobileTextFontStyleWhite),
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: 35,
                      controller: _controllerModeType,
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
                       // scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (selectedMode == "Import")
                              for (var i = 0;
                                  i < shipmentListImport.length;
                                  i++)
                                buildSlotsListImport(
                                    shipmentListImport[i], i),
                            if (selectedMode == "Export")
                              for (var i = 0; i < shipmentList.length; i++)
                                buildSlotsList(shipmentList[i], i),
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
                          // var outMsg =
                          //     "{\"message\":\"Vehicle Token(s) IVT2301110007 for Slot(s) 11/01/2023 05:00-06:00 already exists.Please select another Vehicle or Slot.\",\"description\":\"\"}";

                          // print(outMsg.replaceAll("\"", ""));
                          // outMsg = outMsg.replaceAll("\"", "");
                          // outMsg = outMsg.replaceAll("{", "");
                          // outMsg = outMsg.replaceAll("}", "");
                          // outMsg = outMsg.replaceAll("message:", "");

                          // var abc1 = outMsg.split("description");
                          // print(abc1[1]); // description
                          // print(abc1[0]); // message

                          List<AWBDetailImport> matches = [];
                          matches.addAll(shipmentListImport);
                          matches.retainWhere(
                              (AWBDetailImport s) => s.selected == true);
                          print(
                              "length matches = " + matches.length.toString());

                                print(
                              "selectedGHAID = " + selectedGHAID.toString());
                                       print(
                              "selectedGHA = " + selectedGHA);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewSlotBooking(
                                        selectedShipments: [],
                                        selectedShipmentsImport: matches,
                                        shipmentMode: selectedMode,
                                        GHA: selectedGHAID,
                                        GHAname: selectedGHA,
                                      )));
                        } else {
                          List<AWBDetail> matches = [];
                          matches.addAll(shipmentList);
                          matches
                              .retainWhere((AWBDetail s) => s.selected == true);
                          print(
                              "length matches = " + matches.length.toString());
  print(
                              "selectedGHAID = " + selectedGHAID.toString());
                                       print(
                              "selectedGHA = " + selectedGHA);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewSlotBooking(
                                        selectedShipments: matches,
                                        selectedShipmentsImport: [],
                                        shipmentMode: selectedMode,
                                        GHA: selectedGHAID,
                                        GHAname: selectedGHA,
                                      )));
                        }
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
                              'Book Slot',
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

  buildSlotsList1(AWBDetail awbDT, index) {
    //print("index is ==" + index.toString());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 40,
          height: 60,
          child: Checkbox(
            checkColor: Colors.white,
            value: awbDT.selected,
            onChanged: (bool? value) {
              setState(() {
                awbDT.selected = value!;
                if (value == true) {
                  selectedGHA = awbDT.Custodian;
                  selectedGHAID = awbDT.CustodianID;
                } else {
                  selectedGHA = "";
                  selectedGHAID = 0;
                }

                filterListByGHA();
              });
            },
          ),
        ),
        Container(
          width: 130,
          height: 60,
          //color: Colors.yellow.shade300,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              awbDT.AirlinePrefix.toString() +
                  "-" +
                  awbDT.MAWBNumber.toString(),
              style: mobileDetailsYellowNormal,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Container(
            width: 100,
            height: 70,
            // color: Colors.yellow.shade300,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                awbDT.Custodian.toString(),
                // "Swisspoer Handlung Services",// ,
                style: mobileDetailsYellowNormal,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        Container(
          width: 120,
          height: 70,
          //color: Colors.yellow.shade300,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              awbDT.FreightForwarder.toString(),
              // "Swisspoer Handlung Services",// awbDT.FreightForwarder.toString(),
              style: mobileDetailsYellowNormal,
            ),
          ),
        ),
        Container(
          width: 70,
          height: 60,
          //   color: Colors.yellow.shade300,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              awbDT.PiecesCount.toString(),
              style: mobileDetailsYellowNormal,
            ),
          ),
        ),
        Container(
          width: 120,
          height: 60,
          // color: Colors.yellow.shade300,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              awbDT.Weight.toStringAsFixed(3) +
                  " " +
                  awbDT.WeightUnitID.toString(),
              style: mobileDetailsYellowNormal,
            ),
          ),
        ),
        // Container(
        //   width: 70,
        //   height: 60,
        //  // color: Colors.yellow.shade300,
        //   child: Text(
        //     awbDT.WeightUnitID.toString(),
        //     style: mobileDetailsYellowNormal,
        //   ),
        // ),
      ],
    );
  }

  buildSlotsListImport1(AWBDetailImport awbDT, index) {
    //print("index is ==" + index.toString());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 40,
          height: 60,
          child: Checkbox(
            checkColor: Colors.white,
            value: awbDT.selected,
            onChanged: (bool? value) {
              setState(() {
                awbDT.selected = value!;
                if (value == true) {
                  selectedGHA = awbDT.GHA;
                  selectedGHAID = awbDT.CustodianID;
                } else {
                  selectedGHA = "";
                  selectedGHAID = 0;
                }

                filterListByGHA();
              });
            },
          ),
        ),
        Container(
          width: 130,
          height: 60,
          //color: Colors.yellow.shade300,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              awbDT.AirlinePrefix.toString() +
                  "-" +
                  awbDT.MAWBNumber.toString(),
              style: mobileDetailsYellowNormal,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Container(
            width: 100,
            height: 70,
            // color: Colors.yellow.shade300,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                awbDT.GHA.toString(),
                // "Swisspoer Handlung Services",// ,
                style: mobileDetailsYellowNormal,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        Container(
          width: 120,
          height: 70,
          //color: Colors.yellow.shade300,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              awbDT.FreightForwarder.toString(),
              // "Swisspoer Handlung Services",// awbDT.FreightForwarder.toString(),
              style: mobileDetailsYellowNormal,
            ),
          ),
        ),
        Container(
          width: 70,
          height: 60,
          //   color: Colors.yellow.shade300,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              awbDT.AWBPcs.toString(),
              style: mobileDetailsYellowNormal,
            ),
          ),
        ),
        Container(
          width: 120,
          height: 60,
          // color: Colors.yellow.shade300,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              awbDT.GrWt.toStringAsFixed(3) +
                  " " +
                  awbDT.WeightUnitId.toString(),
              style: mobileDetailsYellowNormal,
            ),
          ),
        ),
        // Container(
        //   width: 70,
        //   height: 60,
        //  // color: Colors.yellow.shade300,
        //   child: Text(
        //     awbDT.WeightUnitID.toString(),
        //     style: mobileDetailsYellowNormal,
        //   ),
        // ),
      ],
    );
  }


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
              onChanged: (bool? value) {
                setState(() {
                  awbDT.selected = value!;
                  // if (value == true) {
                  //   selectedGHA = awbDT.Custodian;
                  //   selectedGHAID = awbDT.CustodianID;
                  // } else {
                  //   selectedGHA = "";
                  //   selectedGHAID = 0;
                  // }

                    if (value == true) {
                    selectedGHA = awbDT.GHA;
                    selectedGHAID = awbDT.CustodianID;
                    totalSelect++;
                  } else {
                    totalSelect --;
                    if (totalSelect == 0) {
                      selectedGHA = "";
                      selectedGHAID = 0;
                    }
                  }

                  filterListByGHA();
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
                                .toString(),// + " services pvt ltd",
                            style: VTlistTextFontStyle,
                            textAlign: TextAlign.left,
                          ),  SizedBox(height: 3),
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
                    ),  SizedBox(height: 3),
                    Text(
                      awbDT.PiecesCount.toString() + " PCS",
                      style: VTlistTextFontStylesmall,
                      textAlign: TextAlign.left,
                    ),  SizedBox(height: 3),
                    Text(
                     // awbDT.GrossWeight.toStringAsFixed(2) +
                          "12345.00 " +
                          awbDT.WeightUnitID.toString(),
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
              onChanged: (bool? value) {
                setState(() {
                  awbDT.selected = value!;
                  if (value == true) {
                    selectedGHA = awbDT.GHA;
                    selectedGHAID = awbDT.CustodianID;
                    totalSelect++;
                  } else {
                    if (totalSelect == 0) {
                      selectedGHA = "";
                      selectedGHAID = 0;
                    }
                  }

                  filterListByGHA();
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
                  
                      "H# : " +
                      awbDT.HAWBNumber.toString(),
                  style: mobileGroupHeaderFontStyleBoldSmall,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.7,
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
    getShipmentList();
    _controllerModeType.addListener(() {
      setState(() {
        if (_controllerModeType.value) {
          checked = true;
          print("value chnaged heere TO === IMPORT");
          selectedMode = "Import";
        } else {
          checked = false;
          print("value chnaged heere TO === EXPORT");
          selectedMode = "Export";
        }
        getShipmentList();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controllerModeType.dispose();

    super.dispose();
  }

  // refreshList() {
  //   print("value for list is === " + selectedMode);
  // }

  getShipmentList() async {
    if (isLoading) return;

    shipmentList = [];
    shipmentListImport = [];

    shipmentListMain = [];
    shipmentListMainImport = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {};

    queryParams = selectedMode == "Import"
        ? {
            "createdByID": loggedinUser.CreatedByUserId,
            "organizationBranchID": loggedinUser.OrganizationBranchId,
            "filterCondition": "",
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
            "filterCondition": "",
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
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      if (selectedMode == "Import") {
        shipmentListImport = resp
            .map<AWBDetailImport>((json) => AWBDetailImport.fromJson(json))
            .toList();

        shipmentListMainImport.addAll(shipmentListImport);

        print("length shipmentListImport = " +
            shipmentListImport.length.toString());
      } else {
        shipmentList =
            resp.map<AWBDetail>((json) => AWBDetail.fromJson(json)).toList();

        shipmentListMain.addAll(shipmentList);

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

  filterListByGHA() {
    // print("selectedGHA = " + selectedGHA);
    // print("shipmentListMain matches = " + shipmentListMain.length.toString());

    if (selectedMode == "Import") {
      if (selectedGHA == "") {
        shipmentListImport = [];
        shipmentListImport.addAll(shipmentListMainImport);
      } else
        shipmentListImport
            .retainWhere((AWBDetailImport s) => s.GHA == selectedGHA);
      print("length matches = " + shipmentListImport.length.toString());
    } else {
      if (selectedGHA == "") {
        shipmentList = [];
        shipmentList.addAll(shipmentListMain);
      } else
        shipmentList.retainWhere((AWBDetail s) => s.Custodian == selectedGHA);
      print("length matches = " + shipmentList.length.toString());
    }
  }
}
