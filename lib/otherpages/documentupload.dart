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
import 'documentUploadChild.dart';

class DocumentUpload extends StatefulWidget {
  const DocumentUpload({Key? key}) : super(key: key);

  @override
  State<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
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

  bool isLoading = false;
  bool isSearched = false;
  bool isImport = false;
  TextEditingController txtVTNO = new TextEditingController();
  final _controllerModeType = ValueNotifier<bool>(false);

  List<DocUploadDetails> searchedList = [];
  List<DocUploadDetails> docUploadList = [
    DocUploadDetails(
        MAWBNo: '999-56565670',
        Date: '17-Jan-24',
        PCS: '20',
        Weight: '55.00',
        Unit: 'kgs'),
    DocUploadDetails(
        MAWBNo: '125-56565671',
        Date: '18-Jan-24',
        PCS: '20',
        Weight: '96.00',
        Unit: 'kgs'),
    DocUploadDetails(
        MAWBNo: '125-56565672',
        Date: '19-Jan-24',
        PCS: '20',
        Weight: '71.00',
        Unit: 'kgs'),
    DocUploadDetails(
        MAWBNo: '999-56565673',
        Date: '20-Jan-24',
        PCS: '20',
        Weight: '45.00',
        Unit: 'kgs'),
    DocUploadDetails(
        MAWBNo: '999-56565674',
        Date: '21-Jan-24',
        PCS: '20',
        Weight: '80.00',
        Unit: 'kgs'),
    DocUploadDetails(
        MAWBNo: '165-56565675',
        Date: '22-Jan-24',
        PCS: '20',
        Weight: '60.00',
        Unit: 'kgs'),
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
    mawbPrefixController.dispose();
    mawbNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = smallestDimension < 600;
    print("useMobileLayout");
    return Scaffold(
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
              txtVTNO.text = scannedCodeReceived;
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
                headerText: "Document Upload"),
            // ClipPath(
            //   clipper: MyClippers1(),
            //   child: Container(
            //     padding: EdgeInsets.only(left: 40, top: 50, right: 20),
            //     // height: 250,
            //     // width: double.infinity,
            //       height: MediaQuery.of(context).size.height / 5.2,
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
            //                 "Dock-In List ",
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
                                      6.5, // hard coding child width
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
                                      2.8, // hard coding child width
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
                              // GestureDetector(
                              //     child: SearchContainerButton(),
                              //     onTap: () async {
                              //       //export
                              //     }),
                              // SizedBox(width: 3),
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
                                                 6.5,
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
                                                  2.8,
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
                                          // Padding(
                                          //   padding: const EdgeInsets.only(
                                          //       bottom: 8.0),
                                          //   child: GestureDetector(
                                          //       child:
                                          //           SearchContainerButtonIpad(),
                                          //       onTap: () async {
                                          //         // getTrackAndTraceDetails(
                                          //         //     1); //export
                                          //       }),
                                          // ),
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
                    child: SingleChildScrollView(
                      child: searchedList.isNotEmpty ||
                              (mawbPrefixController.text.isNotEmpty ||
                                  mawbPrefixController.text.isNotEmpty)
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: searchedList.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                DocUploadDetails docListItem =
                                    searchedList.elementAt(index);
                                return mawbListItem(
                                    context, docListItem, index);
                              },
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: docUploadList.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                DocUploadDetails docListItem =
                                    docUploadList.elementAt(index);
                                return mawbListItem(
                                    context, docListItem, index);
                              },
                            ),
                    ),
                  )
          ]),
    );
  }

  void onSearchTextChanged() {
    String prefix = mawbPrefixController.text.trim();
    String suffix = mawbNoController.text.trim();

    setState(() {
      if (prefix.isEmpty && suffix.isEmpty) {
        searchedList.clear();
      } else {
        searchedList = docUploadList.where((item) {

          List parts = item.MAWBNo.split('-');
          bool prefixMatches = prefix.isEmpty || (parts.length > 0 && parts[0].contains(prefix)); // Check if item prefix contains search prefix
          bool suffixMatches = suffix.isEmpty || (parts.length > 1 && parts[1].contains(suffix)); // Check if item suffix contains search suffix
          return prefixMatches && suffixMatches;
        }).toList();
      }
    });
  }

  // void onSearchTextChanged() {
  //   String prefix = mawbPrefixController.text.trim();
  //   String suffix = mawbNoController.text.trim();
  //   if (prefix.isEmpty && suffix.isEmpty) {
  //     setState(() {
  //       searchedList.clear();
  //     });
  //     return;
  //   }
  //   String searchText = prefix.isEmpty
  //       ? suffix
  //       : suffix.isEmpty
  //           ? prefix
  //           : prefix.isNotEmpty && suffix.isNotEmpty
  //               ? "$prefix-$suffix"
  //               : "";
  //
  //   print(searchText);
  //   setState(() {
  //     searchedList = docUploadList
  //         .where((item) => item.MAWBNo.contains(searchText))
  //         .toList();
  //   });
  //
  //  // setState(() {
  //  //   searchedList = docUploadList
  //  //       .where((item) {
  //  //     return prefix.isEmpty
  //  //         ? item.MAWBNo.contains(searchText)
  //  //         : suffix.isEmpty
  //  //         ? item.MAWBNo.contains(searchText)
  //  //         : prefix.isNotEmpty && suffix.isNotEmpty
  //  //         ? item.MAWBNo.contains(searchText) &&
  //  //         item.MAWBNo.contains(searchText)
  //  //         : false;
  //  //   })
  //  //       .toList();
  //  // });
  // }

  mawbListItem(BuildContext context, DocUploadDetails docUploadDetails, index) {
    return Card(
      elevation: 3,
      margin: useMobileLayout
          ? EdgeInsets.all(8)
          : EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
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
                  width: MediaQuery.of(context).size.width / 2,
                  // height: 70,
                  // color: Colors.white,
                  child: Text(
                    docUploadDetails.MAWBNo,
                    style: useMobileLayout
                        ? mobileGroupHeaderFontStyleBold
                        : iPadGroupHeaderFontStyleBold,
                  ),
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DocumentUploadChild(docUploadDetails)),
                      );
                    },
                    child: Icon(
                      FontAwesomeIcons.chevronRight,
                      color: Colors.white,
                      size: useMobileLayout ? 24 : 34,
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                      backgroundColor: MaterialStateProperty.all(
                          Color(0xFF11249F)), // <-- Button color
                      // overlayColor:
                      //     MaterialStateProperty.resolveWith<Color?>((states) {
                      //   if (states.contains(MaterialState.pressed))
                      //     return Colors.red; // <-- Splash color
                      // }),
                    ),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 2),

            SizedBox(height: 3),

            //  Container(
            //       height: 1,
            //       width: MediaQuery.of(context).size.width / 1.2,
            //       color: Color(0xFF0461AA),
            //     ),
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
                        "Trucking Company Name",
                        style: useMobileLayout
                            ? VTlistTextFontStyle
                            : iPadcompletedBlackText,
                      ),

                      Text(
                        "Origin",
                        style: useMobileLayout
                            ? VTlistTextFontStyle
                            : iPadcompletedBlackText,
                        textAlign: TextAlign.left,
                        // softWrap: true,
                        // maxLines: 3,
                      ),
                      Text(
                        "Destination",
                        style: useMobileLayout
                            ? VTlistTextFontStyle
                            : iPadcompletedBlackText,
                        textAlign: TextAlign.left,
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
                  height: useMobileLayout ? 60 : 70,
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
                              " ${docUploadDetails.Date}",
                              style: useMobileLayout
                                  ? VTlistTextFontStyle
                                  : iPadcompletedBlackText,
                            ),
                          ],
                        ),
                        Text(
                          "${docUploadDetails.PCS}" + " PCS",
                          style: useMobileLayout
                              ? VTlistTextFontStyle
                              : iPadcompletedBlackText,
                        ),
                        Text(
                          "${docUploadDetails.Weight}" +
                              " " +
                              "${docUploadDetails.Unit}",
                          style: useMobileLayout
                              ? VTlistTextFontStyle
                              : iPadcompletedBlackText,
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
    );
  }
}

class DocUploadDetails {
  final String MAWBNo;
  final String Date;
  final String PCS;
  final String Weight;
  final String Unit;

  DocUploadDetails({
    required this.MAWBNo,
    required this.Date,
    required this.PCS,
    required this.Weight,
    required this.Unit,
  });

  factory DocUploadDetails.fromJson(Map<String, dynamic> json) {
    return DocUploadDetails(
      MAWBNo: json['MAWBNo'] == null ? "" : json['MAWBNo'],
      Date: json['Date'] == null ? "" : json['Date'],
      PCS: json['PCS'] == null ? "" : json['PCS'],
      Weight: json['Weight'] == null ? "" : json['Weight'],
      Unit: json['Unit'] == null ? "" : json['Unit'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["MAWBNo"] = MAWBNo;
    map["Date"] = Date;
    map["PCS"] = PCS;
    map["Weight"] = Weight;
    map["Unit"] = Unit;
    return map;
  }
}
