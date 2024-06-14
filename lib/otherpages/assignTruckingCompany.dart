import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:luxair/widgets/common.dart';
import 'package:luxair/widgets/customdialogue.dart';
import 'package:luxair/widgets/headerclipper.dart';
import '../constants.dart';
import '../datastructure/trucker.dart';
import 'package:luxair/datastructure/vehicletoken.dart';
import 'package:luxair/dashboards/dashboard.dart';
import '../global.dart';


class AssignTruckingCompany extends StatefulWidget {
  final bool isExport;

  const AssignTruckingCompany(this.isExport, {Key? key}) : super(key: key);

  @override
  State<AssignTruckingCompany> createState() => _AssignTruckingCompanyState();
}

class _AssignTruckingCompanyState extends State<AssignTruckingCompany> {
  TextEditingController dateInput = TextEditingController();
  String finalTruckerString = "";
      String truckerTableString = "";
  String scannedCodeReceived = "", selectedSlotDate = "";
  bool useMobileLayout = false;
  int truckingAssigned = 0;

  int selectedID = 0; //, modeSelected1 = 0;

  String selectedText = "";
  String dropdownValue = 'Select';
  TextEditingController mawbPrefixController = TextEditingController();
  TextEditingController mawbNoController = TextEditingController();
  FocusNode mawbPrefixFocusNode = FocusNode();
  FocusNode mawbNoFocusNode = FocusNode();
  bool isSavingData = false;
  bool isLoading = false;
  TextEditingController txtVTNO = new TextEditingController();
  Set<int> _selectedIndices = {};
  List<ListingAssignTruckingDetails> searchedList = [];
  List<ListingAssignTruckingDetails> assignTruckList = [];
  List<ListingAssignTruckingDetails> filteredList =[];
  // List<bool> isSelected = [true, false, false];

  @override
  void initState() {
    dateInput.text = "";
    print(widget.isExport);
    if (truckingAssigned == 0) {
      if(widget.isExport){
        getAssignedNotAssignedList(1, "E");
      }else{
        getAssignedNotAssignedList(1, "I"); //AssignTrucker
      }
      print("AssignTrucker");
    } else {

      if(widget.isExport){
        getAssignedNotAssignedList(2, "E");
      }else{
        getAssignedNotAssignedList(2, "I"); //UnassignTrucker
      }

      print("UnassignTrucker");
    }
    filteredList.clear();
    _selectedIndices = {};
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getAssignedNotAssignedList(operationType, mode) async {
    if (isLoading) return;
    assignTruckList = [];
    searchedList = [];
    _selectedIndices = {};
    setState(() {
      isLoading = true;
    });
    var queryParams = {
      "OperationType": operationType.toString(),
      "Mode":mode,
      "CreatedByUserId": loggedinUser.CreatedByUserId,
      "OrganizationBranchId": loggedinUser.OrganizationBranchId,
      "OrganizationId": loggedinUser.OrganizationId,
    };
    await Global()
        .postData(
      Settings.SERVICES['GetAssignTruckerAWBList'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();
      assignTruckList = resp
          .map<ListingAssignTruckingDetails>((json) => ListingAssignTruckingDetails.fromJson(json))
          .toList();

      print("length assignTruckList = " +
          assignTruckList.length.toString());
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

  void selectTruckerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedItem = 'Option 1';
        List<String> items = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
        return AlertDialog(
          title: Text('Select an option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedItem,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    selectedItem = newValue;
                  }
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle the selected item here
                if (selectedItem != null) {
                  print('Selected item: $selectedItem');
                }
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = smallestDimension < 600;
    print("useMobileLayout");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     var returnVal = await showModalBottomSheet<String>(
      //         shape: const RoundedRectangleBorder(
      //           borderRadius: BorderRadius.vertical(
      //             top: Radius.circular(20),
      //           ),
      //         ),
      //         context: context,
      //         isDismissible: false,
      //         builder: (context) {
      //           return SpeechRecognition();
      //         });
      //
      //     if (returnVal == null) return;
      //     if (returnVal == "") return;
      //     print("returnVal = " + returnVal);
      //
      //     if ((returnVal.toLowerCase().contains("search")) ||
      //         (returnVal.toLowerCase().contains("look")) ||
      //         (returnVal.toLowerCase().contains("find")) ||
      //         (returnVal.toLowerCase().contains("get"))) {
      //       returnVal = returnVal.toLowerCase().replaceAll('search', "");
      //       returnVal = returnVal.toLowerCase().replaceAll('look', "");
      //       returnVal = returnVal.toLowerCase().replaceAll('for', "");
      //       returnVal = returnVal.toLowerCase().replaceAll('find', "");
      //       returnVal = returnVal.toLowerCase().replaceAll('get', "");
      //       print("returnVal after replace " + returnVal);
      //       setState(() {
      //         scannedCodeReceived = returnVal.toString().trim();
      //         mawbPrefixController.text = scannedCodeReceived.substring(0, 3);
      //         mawbNoController.text = scannedCodeReceived.substring(3, 11);
      //       });
      //     } else if (returnVal.toLowerCase().contains("scan")) {
      //       if (returnVal.toLowerCase().contains("document")) {
      //         var scannedCode =
      //             await Navigator.of(context).push(MaterialPageRoute(
      //           builder: (context) => const QRViewExample(),
      //         ));
      //         print("code returned from app");
      //         print(scannedCode);
      //         if (scannedCode == null)
      //           setState(() {
      //             scannedCodeReceived = "";
      //           });
      //         if (scannedCode == "")
      //           setState(() {
      //             scannedCodeReceived = "";
      //           });
      //         if (scannedCode != null) {
      //           if (scannedCode != "") {
      //             print("code returned from app =" + scannedCode);
      //             setState(() {
      //               scannedCodeReceived = scannedCode;
      //               txtVTNO.text = scannedCodeReceived;
      //             });
      //             // await getShipmentDetails(scannedCode);
      //           }
      //         }
      //       }
      //
      //       if (returnVal.toLowerCase().contains("gallery")) {
      //         final ImagePicker _picker = ImagePicker();
      //         final XFile? image = await _picker.pickImage(
      //             source: ImageSource.gallery); // Pick an image
      //         if (image == null)
      //           return;
      //         else {
      //           String? str = await Scan.parse(image.path);
      //           if (str != null) {
      //             setState(() {
      //               scannedCodeReceived = str;
      //               txtVTNO.text = scannedCodeReceived;
      //             });
      //           }
      //         }
      //       }
      //
      //       // returnVal = returnVal.toLowerCase().replaceAll('search', "");
      //       // print("returnVal after replace " + returnVal);
      //
      //       // setState(() {
      //       //   scannedCodeReceived = returnVal.toString().trim();
      //       //   txtVTNO.text = scannedCodeReceived;
      //       //   _runFilter(scannedCodeReceived);
      //       // });
      //     } else {
      //       print("returnVal after replace " + returnVal);
      //     }
      //   },
      //   backgroundColor: Color(0xFF11249F), //Colors.green,
      //   child: const Icon(Icons.record_voice_over_sharp),
      // ),
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
                                initialLabelIndex: truckingAssigned,
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
                                labels: [
                                  ' Assign Trucker ',
                                  ' Unassign Trucker '
                                ],

                                onToggle: (index) {
                                  setState(() {
                                    filteredList.clear();
                                    _selectedIndices = {};
                                    truckingAssigned = index!;
                                    if (truckingAssigned == 0) {

                                      if(widget.isExport){
                                        getAssignedNotAssignedList(1, "E");
                                      }else{
                                        getAssignedNotAssignedList(1, "I"); //AssignTrucker
                                      }
                                      print("AssignTrucker");
                                    } else {
                                      if(widget.isExport){
                                        getAssignedNotAssignedList(2, "E");
                                      }else{
                                        getAssignedNotAssignedList(2, "I"); //UnassignTrucker
                                      }

                                      print("UnassignTrucker");
                                    }
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
                              // GestureDetector(
                              //     child: SearchContainerButton(),
                              //     onTap: () async {
                              //       //export
                              //     }),
                              // SizedBox(width: 5),
                              GestureDetector(
                                child: DeleteScanContainerButton(),
                                onTap: () async {
                                  mawbPrefixController.text = "";
                                  mawbNoController.text = "";
                                },
                              )
                            ]),
                            SizedBox(
                              height: 2,
                            ),

                            truckingAssigned == 0
                                ? Row(children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    3.4,
                                child: Text("Assign Trucker",
                                    style: mobileHeaderFontStyle),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width /
                                      1.7, // hard coding child width
                                  child: Container(
                                    height: 40,
                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        2.4,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                        Colors.grey.withOpacity(0.5),
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(4.0),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: Container(
                                        constraints:
                                        BoxConstraints(minHeight: 50),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey,
                                              width: 0.2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Colors.white,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: DropdownButton(
                                          items: trucker.map((list) {
                                            return DropdownMenuItem(
                                              child: Text(list.name,
                                                  style: iPadTextFontStyle),
                                              //label of item
                                              value: list
                                                  .branchId, //value of item
                                            );
                                          }).toList(),
                                          value: selectedID,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedText =
                                                  value.toString();
                                              selectedID =
                                                  int.parse(value.toString());
                                            });
                                          },

                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ])

                                : SizedBox(),
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
                                            initialLabelIndex: truckingAssigned,
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
                                                truckingAssigned = index!;
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
                                              ListingAssignTruckingDetails docListItem =
                                              searchedList.elementAt(index);
                                          final isSelected =
                                              _selectedIndices.contains(index);
                                          return mawbListItem(context,
                                              docListItem, index, isSelected);
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
                                        itemCount: assignTruckList.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                              ListingAssignTruckingDetails docListItem =
                                              assignTruckList.elementAt(index);
                                          final isSelected =
                                              _selectedIndices.contains(index);
                                          return mawbListItem(context,
                                              docListItem, index, isSelected);
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: useMobileLayout ? 20 : 180,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Dashboards()),
                                );
                              },
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 1, 36, 159)),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 255, 255, 255)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                        color: Color(0xFF11249F)),
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                width: useMobileLayout
                                    ? MediaQuery.of(context).size.width / 3.2
                                    : MediaQuery.of(context).size.width / 3.8,
                                height: useMobileLayout ? 38 : 48,
                                child: Center(
                                  child: const Text(
                                    "Back",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            ElevatedButton(

                              onPressed: () async {
                                var submitAssign;
                                var submitUnAssign;
                                // showSuccessMessage();
                                if (truckingAssigned == 0) {
                                  if(widget.isExport){
                                    submitAssign = await UnassignTruckerSave(3,"E"); //AssignTrucker
                                  }else{
                                    submitAssign = await UnassignTruckerSave(4,"I"); //AssignTrucker
                                  }

                                  print("AssignTrucker");
                                } else {
                                  if(widget.isExport){
                                    submitUnAssign = await UnassignTruckerSave(5,"E"); //UnassignTrucker
                                  }else{
                                    submitUnAssign = await UnassignTruckerSave(5,"I"); //UnassignTrucker
                                  }
                                  print("UnassignTrucker");
                                }
                                if (submitAssign == true) {
                                  var dlgstatus = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomDialog(
                                          title: "Message",
                                          description: "Shipment assigned successfully",
                                          buttonText: "Okay",
                                          imagepath: 'assets/images/successchk.gif',
                                          isMobile: useMobileLayout,
                                        ),
                                  );


                                  if (dlgstatus == true) {
                                    Navigator.of(context)
                                        .pop(true); // To close the form
                                  }
                                }else{
                                  var dlgstatus = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomDialog(
                                          title: "Message",
                                          description: "Shipment unassigned successfully",
                                          buttonText: "Okay",
                                          imagepath: 'assets/images/successchk.gif',
                                          isMobile: useMobileLayout,
                                        ),
                                  );
                                }
                              },

                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 255, 255, 255)),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 1, 36, 159)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),

                              child: SizedBox(
                                width: useMobileLayout
                                    ? MediaQuery.of(context).size.width / 3.2
                                    : MediaQuery.of(context).size.width / 3.8,
                                height: useMobileLayout ? 38 : 48,

                                child: Center(
                                  child: const Text(
                                    "Assign Trucker",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
          ]),
    );
  }

  void _onItemTap(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        filteredList.remove(assignTruckList[index]);
      } else {
        _selectedIndices.add(index);
        filteredList.add(assignTruckList[index]);
      }

    });




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
    setState(() {
      searchedList = assignTruckList.where((item) {
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
  //       searchedList = assignTruckList.where((item) {
  //         List parts = item.mawbNumber.split('-');
  //         bool prefixMatches = prefix.isEmpty ||
  //             (parts.length > 0 &&
  //                 parts[0].contains(
  //                     prefix)); // Check if item prefix contains search prefix
  //         bool suffixMatches = suffix.isEmpty ||
  //             (parts.length > 1 &&
  //                 parts[1].contains(
  //                     suffix)); // Check if item suffix contains search suffix
  //         print("----${parts[0]}-${parts[1]}----");
  //         return prefixMatches && suffixMatches;
  //       }).toList();
  //     }
  //   });
  // }

  mawbListItem(BuildContext context, ListingAssignTruckingDetails assignTruckDetails, index,
      isSelected) {

    return GestureDetector(
      onLongPress: () => _onItemTap(index),
      child: Card(
        elevation: 3,
        margin: useMobileLayout
            ? EdgeInsets.all(8)
            : EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // color: assignTruckDetails.isSelected!?Colors.blue:Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: BorderSide(
            color: isSelected ?? false ? Color(0xFF11249F) : Colors.transparent,
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
                      assignTruckDetails.prefix + "-" + assignTruckDetails.mawbNumber,
                      style: useMobileLayout
                          ? mobileGroupHeaderFontStyleBold
                          : iPadGroupHeaderFontStyleBold,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 2),
              SizedBox(height: useMobileLayout ? 6 : 18),
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
                          " ${assignTruckDetails.truckingCompany}",
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
                    height: useMobileLayout ? 40 : 50,
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
              //       child: Padding(F
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

  Future<bool> UnassignTruckerSave(op, mode) async {
    String type;
    if (truckingAssigned == 0) {
     type = "\"Type\": \"A\"";
    } else {
      type = "\"Type\": \"U\"";
    }
    print(type);
    print(_selectedIndices);
    if (truckingAssigned == 0) {
    if (selectedID == 0) {
      var dlgstatus = await showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomDialog(
              title: "Message",
              description: "Please select trucker",
              buttonText: "Okay",
              imagepath: 'assets/images/question.gif',
              isMobile: useMobileLayout,
            ),
      );
    }
    }

    if (_selectedIndices.length == 0) {
      var dlgstatus = await showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomDialog(
              title: "Message",
              description: "Please select shipment",
              buttonText: "Okay",
              imagepath: 'assets/images/question.gif',
              isMobile: useMobileLayout,
            ),
      );
    }

    int i = 0;
    String a;
    for (ListingAssignTruckingDetails u in filteredList) {
      if(widget.isExport){
        a = "{\"AWBID\": \"${u.awbId}\"," +
            "\"ParentId\":\"${u.OrganizationBranchID}\"," +
            "\"ChildId\":\"${selectedID}\"," +
            "\"CreatedById\":\"${u.CreatedBy}\"}";
      }else{
        a = "{\"AWBID\": \"${u.awbId}\"," +
            "\"HAWBID\":\"${u.hawbID}\"," +
            "\"ParentId\":\"${u.OrganizationBranchID}\"," +
            "\"ChildId\":\"${selectedID}\"," +
            "\"CreatedById\":\"${u.CreatedBy}\"}";
      }
     // print("json a");
      print(a);
      //print(json.decode(a));
      //print(json.encode(a));
      if (i == 0)
        truckerTableString = truckerTableString + a;
      else
        truckerTableString = truckerTableString + "," + a;

      i++;
    }
   // truckerTableString + "," + type;
    finalTruckerString = "[" + truckerTableString + "]," + type;
    print(json.decode(finalTruckerString));
    var ab = json.decode(finalTruckerString);
    try {
      bool isValid = false;

      // setState(() {
      //   isSavingData = true;
      // });

      var queryParams = {
        "OperationType": op,
        "Mode":mode,
        "CreatedByUserId": loggedinUser.CreatedByUserId,
        "OrganizationBranchId": loggedinUser.OrganizationBranchId,
        "OrganizationId": loggedinUser.OrganizationId,
        "TruckerData":ab,
      };
      await Global()
          .postData(
        Settings.SERVICES['SaveAssignUnAssignTrucker'],
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
                // responseTextUpdated =
                //     responseText.toString().replaceAll("ErrorMSG", "");
                // responseTextUpdated =
                //     responseTextUpdated.toString().replaceAll(":", "");
                // responseTextUpdated =
                //     responseTextUpdated.toString().replaceAll("\"", "");
                // responseTextUpdated =
                //     responseTextUpdated.toString().replaceAll("{", "");
                // responseTextUpdated =
                //     responseTextUpdated.toString().replaceAll("}", "");
                // print(responseTextUpdated.toString());
              }
              // print(responseText.toString().replaceAll("ErrorMSG", ""));
              // print(responseText.toString().replaceAll(":", ""));
              // print(responseText.toString().replaceAll("\"", ""));

              isValid = false;
            }
          }
        }

        // setState(() {
        //   isSavingData = false;
        //
        // });
      }).catchError((onError) {
        // setState(() {
        //   isSavingData = false;
        // });
        print(onError);
      });
      return isValid;
    } catch (Exc) {
      print(Exc);
      return false;
    }
  }


}



//
