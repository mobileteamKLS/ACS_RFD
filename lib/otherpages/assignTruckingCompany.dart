import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luxair/otherpages/submitITNDetails.dart';

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
import '../widgets/animated_toggle_switch.dart';
import '../widgets/timeline.dart';
import 'documentUploadChild.dart';
import 'documentupload.dart';

class AssignTruckingCompany extends StatefulWidget {
  const AssignTruckingCompany({Key? key}) : super(key: key);

  @override
  State<AssignTruckingCompany> createState() => _AssignTruckingCompanyState();
}

class _AssignTruckingCompanyState extends State<AssignTruckingCompany> {
  TextEditingController dateInput = TextEditingController();
  String scannedCodeReceived = "", selectedSlotDate = "";
  bool useMobileLayout = false;
  int modeSelected = 0;
  int trackingSelected = 0; //, modeSelected1 = 0;
  int trackingType = 0;
  String dropdownValue = 'Select';
  TextEditingController mawbPrefixController = TextEditingController();
  TextEditingController mawbNoController = TextEditingController();
  FocusNode mawbPrefixFocusNode = FocusNode();
  FocusNode mawbNoFocusNode = FocusNode();

  //  List<CodexPass> passList = [];
  // List<FilterArray> _filterArray = [];
  bool isLoading = false;
  bool isSearched = false;
  bool isImport = false;
  TextEditingController txtVTNO = new TextEditingController();
  final _controllerModeType = ValueNotifier<bool>(false);

  // List<VehicleToken> vehicleToeknListToBind = [];
  // List<VehicleToken> vehicleToeknListImport = [];
  // List<VehicleToken> vehicleToeknListExport = [];
  // List<VehicleToken> vehicleToeknListtRandom = [];

  List<AssignTruckingDetails> searchedList = [];
  List<AssignTruckingDetails> assignTruckList = [
    AssignTruckingDetails(
        MAWBNo: "999-56565670",
        ITNNo: "X20240212456565",
        ITNDate: "17-Jan-24",
        TruckingCompany: "APGTransport"),
    AssignTruckingDetails(
        MAWBNo: "125-56565671",
        ITNNo: "X20240212456566",
        ITNDate: "18-Jan-24",
        TruckingCompany: "APGTransport"),
    AssignTruckingDetails(
        MAWBNo: "999-56565672",
        ITNNo: "X20240212456567",
        ITNDate: "19-Jan-24",
        TruckingCompany: "APGTransport"),
    AssignTruckingDetails(
        MAWBNo: "125-56565673",
        ITNNo: "X20240212456568",
        ITNDate: "20-Jan-24",
        TruckingCompany: "APGTransport"),
    AssignTruckingDetails(
        MAWBNo: "999-56565674",
        ITNNo: "X20240212456569",
        ITNDate: "21-Jan-24",
        TruckingCompany: "APGTransport"),
    AssignTruckingDetails(
        MAWBNo: "125-56565675",
        ITNNo: "X20240212456570",
        ITNDate: "22-Jan-24",
        TruckingCompany: "APGTransport"),
    AssignTruckingDetails(
        MAWBNo: "999-56565676",
        ITNNo: "X20240212456571",
        ITNDate: "23-Jan-24",
        TruckingCompany: "APGTransport"),
  ];
  List<bool> isSelected = [true, false, false];

  @override
  void initState() {
    dateInput.text = "";
    // if (modeSelected == 0) vehicleToeknListToBind = vehicleToeknListExport;
    // if (modeSelected == 1) vehicleToeknListToBind = vehicleToeknListImport;
    // if (vehicleToeknListExport.isNotEmpty)
    //   vehicleToeknListToBind = vehicleToeknListExport;
    //
    _controllerModeType.addListener(() {
      setState(() {
        // //scannedCodeReceived = "";
        //
        // print("value chnaged heere");
        // txtVTNO.text = "";
        if (_controllerModeType.value) {
          print("_controllerModeType.value chnaged to import");

          isImport = true;
          // getVehicleToeknList(3); //Import
          // modeSelected = 1;
          // vehicleToeknListToBind = vehicleToeknListImport;
        } else {
          print("_controllerModeType.value chnaged to export");
          isImport = false;
          // modeSelected = 0;
          // getVehicleToeknList(4); //Export
          // vehicleToeknListToBind = vehicleToeknListExport;
        }
      });
    });
    //
    // if (modeSelected == 1) {
    //   getVehicleToeknList(3); //Import
    //   print("import");
    // } else {
    //   getVehicleToeknList(4); //Export
    //   print("export");
    // }
    super.initState();
  }

  @override
  void dispose() {
    _controllerModeType.dispose();

    super.dispose();
  }

  // ThemeColor darkMode = ThemeColor(
  //   gradient: [
  //     const Color(0xFF8983F7),
  //     const Color(0xFFA3DAFB),
  //   ],
  //   backgroundColor: const Color(0xFF26242e),
  //   textColor: const Color(0xFFFFFFFF),
  //   toggleButtonColor: const Color(0xFf34323d),
  //   toggleBackgroundColor: const Color(0xFF222029),
  //   shadow: const <BoxShadow>[
  //     BoxShadow(
  //       color: const Color(0x66000000),
  //       spreadRadius: 5,
  //       blurRadius: 10,
  //       offset: Offset(0, 5),
  //     ),
  //   ],
  // );
  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = smallestDimension < 600;
    print("useMobileLayout");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var returnVal = await showModalBottomSheet<String>(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              context: context,
              isDismissible: false,
              builder: (context) {
                return SpeechRecognition();
              });

          if (returnVal == null) return;
          if (returnVal == "") return;
          print("returnVal = " + returnVal);

          if ((returnVal.toLowerCase().contains("search")) ||
              (returnVal.toLowerCase().contains("look")) ||
              (returnVal.toLowerCase().contains("find")) ||
              (returnVal.toLowerCase().contains("get"))) {
            returnVal = returnVal.toLowerCase().replaceAll('search', "");
            returnVal = returnVal.toLowerCase().replaceAll('look', "");
            returnVal = returnVal.toLowerCase().replaceAll('for', "");
            returnVal = returnVal.toLowerCase().replaceAll('find', "");
            returnVal = returnVal.toLowerCase().replaceAll('get', "");
            print("returnVal after replace " + returnVal);
            setState(() {
              scannedCodeReceived = returnVal.toString().trim();
              mawbPrefixController.text = scannedCodeReceived.substring(0, 3);
              mawbNoController.text = scannedCodeReceived.substring(3, 11);
            });
          } else if (returnVal.toLowerCase().contains("scan")) {
            if (returnVal.toLowerCase().contains("document")) {
              var scannedCode =
                  await Navigator.of(context).push(MaterialPageRoute(
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
                  print("code returned from app =" + scannedCode);
                  setState(() {
                    scannedCodeReceived = scannedCode;
                    txtVTNO.text = scannedCodeReceived;
                  });
                  // await getShipmentDetails(scannedCode);
                }
              }
            }

            if (returnVal.toLowerCase().contains("gallery")) {
              final ImagePicker _picker = ImagePicker();
              final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery); // Pick an image
              if (image == null)
                return;
              else {
                String? str = await Scan.parse(image.path);
                if (str != null) {
                  setState(() {
                    scannedCodeReceived = str;
                    txtVTNO.text = scannedCodeReceived;
                  });
                }
              }
            }

            // returnVal = returnVal.toLowerCase().replaceAll('search', "");
            // print("returnVal after replace " + returnVal);

            // setState(() {
            //   scannedCodeReceived = returnVal.toString().trim();
            //   txtVTNO.text = scannedCodeReceived;
            //   _runFilter(scannedCodeReceived);
            // });
          } else {
            print("returnVal after replace " + returnVal);
          }
        },
        backgroundColor: Color(0xFF11249F), //Colors.green,
        child: const Icon(Icons.record_voice_over_sharp),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderClipperWave(
                color1: Color(0xFF3383CD),
                color2: Color(0xFF11249F),
                headerText: "Assign Trucking Company"),
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
                                labels: [' Assign Truck ', ' Unassign Truck '],

                                onToggle: (index) {
                                  setState(() {
                                    trackingType = index!;
                                    print(trackingType);
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 4.3,
                                child: Text("MAWB No.",
                                    style: mobileHeaderFontStyle),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      7.0, // hard coding child width
                                  child: Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width / 2.4,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(3)
                                      ],
                                      controller: mawbPrefixController,
                                      focusNode: mawbPrefixFocusNode,
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Prefix",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        isDense: true,
                                      ),
                                      style: mobileTextFontStyle,
                                      onChanged: (value) {
                                        onSearchTextChanged();
                                        if (value.length == 3) {
                                          mawbPrefixFocusNode.unfocus();
                                          mawbNoFocusNode.requestFocus();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      3.5, // hard coding child width
                                  child: Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width / 2.4,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: TextField(
                                      controller: mawbNoController,
                                      focusNode: mawbNoFocusNode,
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(9)
                                      ],
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "MAWB No.",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        isDense: true,
                                      ),
                                      style: mobileTextFontStyle,
                                      onChanged: (value) {
                                        onSearchTextChanged();
                                        if (value.length == 3) {
                                          // mawbPrefixFocusNode.unfocus();
                                          // mawbNoFocusNode.requestFocus();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  child: SearchContainerButton(),
                                  onTap: () async {
                                    //export
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
                          ],
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    flex: 0,
                    child: Container(
                      height: 135,
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
                                  //SizedBox(width: 10),
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  8.8,
                                              // hard coding child width
                                              child: Container(
                                                height: 60,
                                                width: MediaQuery.of(context)
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
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: TextField(
                                                  controller:
                                                      mawbPrefixController,
                                                  focusNode:
                                                      mawbPrefixFocusNode,
                                                  textAlign: TextAlign.right,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .characters,
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
                                                  style: TextStyle(
                                                    fontSize: 24.0,
                                                    color: Colors.black,
                                                  ),
                                                  onChanged: (value) {
                                                    onSearchTextChanged();
                                                    if (value.length == 3) {
                                                      mawbPrefixFocusNode
                                                          .unfocus();
                                                      mawbNoFocusNode
                                                          .requestFocus();
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4.6,
                                              // hard coding child width
                                              child: Container(
                                                height: 60,
                                                width: MediaQuery.of(context)
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
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: TextField(
                                                  controller: mawbNoController,
                                                  focusNode: mawbNoFocusNode,
                                                  textAlign: TextAlign.right,
                                                  keyboardType:
                                                      TextInputType.number,
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
                                                  style: TextStyle(
                                                    fontSize: 24.0,
                                                    color: Colors.black,
                                                  ),
                                                  onChanged: (value) {
                                                    onSearchTextChanged();
                                                    if (value.length == 3) {
                                                      // mawbPrefixFocusNode.unfocus();
                                                      // mawbNoFocusNode.requestFocus();
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: GestureDetector(
                                                child:
                                                    SearchContainerButtonIpad(),
                                                onTap: () async {
                                                  // getTrackAndTraceDetails(
                                                  //     1); //export
                                                }),
                                          ),
                                          SizedBox(width: 5),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: GestureDetector(
                                                child:
                                                    DeleteScanContainerButtonIpad(),
                                                onTap: () async {
                                                  // getTrackAndTraceDetails(
                                                  //     1); //export
                                                }),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ]),
                      ),
                    ),
                  ),
            isLoading
                ? Center(
                    child: Container(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator()))
                : Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4.8,
                      child: SingleChildScrollView(
                          // padding: EdgeInsets.only(bottom: 64),
                          child: Column(
                        children: [
                          searchedList.isNotEmpty &&
                                  (mawbPrefixController.text.isNotEmpty ||
                                      mawbPrefixController.text.isNotEmpty)
                              ? ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: searchedList.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    AssignTruckingDetails docListItem =
                                        searchedList.elementAt(index);
                                    return mawbListItem(
                                        context, docListItem, index);
                                  },
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: assignTruckList.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    AssignTruckingDetails docListItem =
                                        assignTruckList.elementAt(index);
                                    return mawbListItem(
                                        context, docListItem, index);
                                  },
                                ),
                        ],
                      )),
                    ),
                  ),
            SizedBox(
              height: 60,
              child: Positioned(
                top: 16.0,
                right: 16.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 1, 36, 159)),
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 255, 255)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Color(0xFF11249F)),
                          ),
                        ),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 4.8,
                        height: 38,
                        child: Center(
                          child: const Text(
                            "Back",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 255, 255)),
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 1, 36, 159)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 4.8,
                        height: 38,
                        child: Center(
                          child: const Text(
                            "Save",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
    );
  }

  // onSearchTextChanged(String text) async {
  //   searchedList.clear();
  //   if (mawbPrefixController.text.isEmpty && mawbNoController.text.isEmpty) {
  //     setState(() {});
  //     return;
  //   }
  //   for (var item in assignTruckList) {
  //     var searchText="${mawbPrefixController.text.trim()}-${mawbNoController.text.trim()}";
  //     if (item.MAWBNo.contains(searchText)) {
  //       searchedList.add(item);
  //     }
  //   }
  //   setState(() {});
  // }

  void onSearchTextChanged() {
    String prefix = mawbPrefixController.text.trim();
    String suffix = mawbNoController.text.trim();
    if (prefix.isEmpty && suffix.isEmpty) {
      setState(() {
        searchedList.clear();
      });
      return;
    }
    String searchText = prefix.isEmpty ? suffix : "$prefix-$suffix";
    setState(() {
      searchedList = assignTruckList
          .where((item) => item.MAWBNo.contains(searchText))
          .toList();
    });
  }

  mawbListItem(
      BuildContext context, AssignTruckingDetails assignTruckDetails, index) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          assignTruckDetails.isSelected = !assignTruckDetails.isSelected!;
        });
      },
      child: Card(
        elevation: 3,
        margin: useMobileLayout
            ? EdgeInsets.all(8)
            : EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // color: assignTruckDetails.isSelected!?Colors.blue:Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: BorderSide(
            color: assignTruckDetails.isSelected ?? false
                ? Color(0xFF11249F)
                : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.0,
                    // height: 70,
                    // color: Colors.red,
                    child: Text(
                      assignTruckDetails.MAWBNo,
                      style: useMobileLayout
                          ? mobileGroupHeaderFontStyleBold
                          : iPadGroupHeaderFontStyleBold,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 2),
              SizedBox(height: 3),
              SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: useMobileLayout
                        ? MediaQuery.of(context).size.width / 1.7
                        : MediaQuery.of(context).size.width / 1.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " ${assignTruckDetails.ITNNo}",
                          style: useMobileLayout
                              ? VTlistTextFontStyle
                              : iPadcompletedBlackText,
                        ),

                        Text(
                          " ${assignTruckDetails.TruckingCompany}",
                          style: useMobileLayout
                              ? VTlistTextFontStyle
                              : iPadcompletedBlackText,
                          textAlign: TextAlign.left,
                          // softWrap: true,
                          // maxLines: 3,
                        ),

                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width / 1.2,
                        //   // height: 70,
                        //   // color: Colors.white,
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(top: 8.0),
                        //     child: Text(
                        //       bawbd.FreightForwarder,
                        //       style: mobileDetailsGridView,
                        //       textAlign: TextAlign.left,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    height: useMobileLayout ? 40 : 70,
                    width: 3,
                    color: Color(0xFF0461AA),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: useMobileLayout
                          ? MediaQuery.of(context).size.width / 4.2
                          : MediaQuery.of(context).size.width / 4.6,
                      // height: 70,
                      // color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.calendar_month,
                                size: useMobileLayout ? 16 : 28,
                                color: Color(0xFF11249F),
                              ),
                              //              SizedBox(width: 10),
                              Text(
                                " ${assignTruckDetails.ITNDate}",
                                style: useMobileLayout
                                    ? VTlistTextFontStyle
                                    : iPadcompletedBlackText,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width / 1.2,
              //       // height: 70,
              //       // color: Colors.white,
              //       child: Padding(
              //         padding: const EdgeInsets.only(top: 8.0),
              //         child: Text(
              //           bawbd.FreightForwarder,
              //           style: mobileDetailsGridView,
              //           textAlign: TextAlign.left,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssignTruckingDetails {
  final String MAWBNo;
  final String ITNNo;
  final String ITNDate;
  final String TruckingCompany;
  bool? isSelected;

  AssignTruckingDetails(
      {required this.MAWBNo,
      required this.ITNNo,
      required this.ITNDate,
      required this.TruckingCompany,
      this.isSelected = false});
}
