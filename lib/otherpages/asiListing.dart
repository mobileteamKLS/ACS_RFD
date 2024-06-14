import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:luxair/widgets/common.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:luxair/widgets/qrscan.dart';
import 'package:luxair/widgets/speech_recognition.dart';
import '../constants.dart';
import '../datastructure/trucker.dart';
import '../global.dart';

class ASIListing extends StatefulWidget {
  const ASIListing({Key? key}) : super(key: key);

  @override
  State<ASIListing> createState() => _ASIListingState();
}

class _ASIListingState extends State<ASIListing> {
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
  List<ListingDetails> searchedList = [];
  List<ListingDetails> ASIMawbListExport = [];
  List<bool> isSelected = [true, false, false];

  @override
  void initState() {
    getASIList();
    dateInput.text = "";
    _controllerModeType.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controllerModeType.dispose();

    super.dispose();
  }

  getASIList() async {
    print("in ASI list");
    if (isLoading) return;
    txtVTNO.text = "";
    ASIMawbListExport = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "OperationType": "1",
      "AirlinePrefix": "0",
      "AwbNumber": "0",
      "HawbNumber": "",
      "CreatedByUserId": "22617",
      "OrganizationBranchId": "22642",
      "OrganizationId": "22597",
      "AWBID": 0,
      "SBID": 0
    };
    await Global()
        .postData(
      Settings.SERVICES['ListingPageExport'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      ASIMawbListExport = resp
          .map<ListingDetails>((json) => ListingDetails.fromJson(json))
          .toList();

      print(
          "length ASIMawbListExport = " + ASIMawbListExport.length.toString());
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
                headerText: "ASI"),
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
                                            labels: ['Assign ', ' Unassign'],

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
                                              });
                                            },
                                          ),
                                        ),
                                      ),
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
                    child: Stack(
                    children: [
                      Container(
                        child: SingleChildScrollView(
                          // padding: EdgeInsets.only(bottom: 64),
                          child: Column(
                            children: [
                              searchedList.isNotEmpty ||
                                      (mawbPrefixController.text.isNotEmpty ||
                                          mawbPrefixController.text.isNotEmpty)
                                  ? Padding(
                                      padding: useMobileLayout
                                          ? const EdgeInsets.only(bottom: 60.0)
                                          : const EdgeInsets.only(bottom: 80.0),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: searchedList.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          ListingDetails ListItem =
                                              searchedList.elementAt(index);
                                          return mawbListItem(
                                              context, ListItem, index);
                                        },
                                      ),
                                    )
                                  : Padding(
                                      padding: useMobileLayout
                                          ? const EdgeInsets.only(bottom: 60.0)
                                          : const EdgeInsets.only(bottom: 80.0),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: ASIMawbListExport.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          ListingDetails ListItem =
                                              ASIMawbListExport.elementAt(
                                                  index);
                                          return mawbListItem(
                                              context, ListItem, index);
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
          ]),
    );
  }

  void onSearchTextChanged() {
    String prefix = mawbPrefixController.text.trim();
    String suffix = mawbNoController.text.trim();
    if (prefix.isEmpty && suffix.isEmpty) {
      setState(() {
        searchedList.clear();
      });
      return;
    }
    // String searchText = prefix.isEmpty
    //     ? suffix
    //     : suffix.isEmpty
    //         ? prefix
    //         : prefix.isNotEmpty && suffix.isNotEmpty
    //             ? "$prefix-$suffix"
    //             : "";
    //
    // print(searchText);
    // setState(() {
    //   searchedList = docUploadList
    //       .where((item) => item.MAWBNo.contains(searchText))
    //       .toList();
    // });

    setState(() {
      searchedList = ASIMawbListExport.where((item) {
        return prefix.isEmpty
            ? item.mawbNumber.contains(suffix)
            : suffix.isEmpty
                ? item.mawbNumber.contains(prefix)
                : prefix.isNotEmpty && suffix.isNotEmpty
                    ? item.mawbNumber.contains(suffix) &&
                        item.mawbNumber.contains(prefix)
                    : false;
      }).toList();
    });
  }

  // void onSearchTextChanged() {
  //   String prefix = mawbPrefixController.text.trim();
  //   String suffix = mawbNoController.text.trim();
  //
  //   setState(() {
  //     if (prefix.isEmpty && suffix.isEmpty) {
  //       searchedList.clear();
  //     } else {
  //       searchedList = ASIMawbListExport.where((item) {
  //
  //         List parts = item.mawbNumber.split('-');
  //         bool prefixMatches = prefix.isEmpty || (parts.length > 0 && parts[0].contains(prefix)); // Check if item prefix contains search prefix
  //         bool suffixMatches = suffix.isEmpty || (parts.length > 1 && parts[1].contains(suffix)); // Check if item suffix contains search suffix
  //         return prefixMatches && suffixMatches;
  //       }).toList();
  //     }
  //   });
  // }

  mawbListItem(BuildContext context, ListingDetails listDetails, index) {
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
                    listDetails.mawbNumber,
                    style: useMobileLayout
                        ? mobileGroupHeaderFontStyleBold
                        : iPadGroupHeaderFontStyleBold,
                  ),
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //           DocumentUploadChild(asiDetails)),
                      // );
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
                        listDetails.truckerName,
                        style: useMobileLayout
                            ? VTlistTextFontStyle
                            : iPadcompletedBlackText,
                      ),

                      Text(
                        listDetails.origin,
                        style: useMobileLayout
                            ? VTlistTextFontStyle
                            : iPadcompletedBlackText,
                        textAlign: TextAlign.left,
                        // softWrap: true,
                        // maxLines: 3,
                      ),
                      Text(
                        listDetails.destination,
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
                        ? MediaQuery.of(context).size.width / 3.5
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
                              listDetails.flightDate,
                              style: useMobileLayout
                                  ? VTlistTextFontStyle
                                  : iPadcompletedBlackText,
                            ),
                          ],
                        ),
                        Text(
                          "${listDetails.piecesCount}" + " PCS",
                          style: useMobileLayout
                              ? VTlistTextFontStyle
                              : iPadcompletedBlackText,
                        ),
                        Text(
                          "${listDetails.weight}" + " " + "${listDetails.unit}",
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
