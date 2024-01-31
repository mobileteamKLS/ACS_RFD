import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:luxair/datastructure/ASIList.dart';
import 'package:luxair/datastructure/vehicletoken.dart';
import 'package:luxair/otherpages/dockindetails.dart';
import 'package:luxair/widgets/common.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:luxair/widgets/headers.dart';
import 'package:luxair/widgets/qrscan.dart';
import 'package:luxair/widgets/speech_recognition.dart';

import '../constants.dart';
import '../global.dart';

class ShippingBillASI extends StatefulWidget {
  ShippingBillASI({Key? key}) : super(key: key);

  @override
  State<ShippingBillASI> createState() => _ShippingBillASIState();
}

class _ShippingBillASIState extends State<ShippingBillASI> {
  String scannedCodeReceived = "";
  bool useMobileLayout = false;
  int modeSelected = 0; //, modeSelected1 = 0;
  //  List<CodexPass> passList = [];
  // List<FilterArray> _filterArray = [];
  bool isLoading = false;
  bool isSearched = false;
  bool checked = false;
  TextEditingController txtPrefix= new TextEditingController();
  TextEditingController txtAwbNo= new TextEditingController();
  final _controllerModeType = ValueNotifier<bool>(false);
  List<ASIList> ASIListToBind = [];
  List<ASIList> ASIListImport = [];
  List<ASIList> ASIListExport = [];
  List<ASIList> ASIListRandom = [];

  @override
  void initState() {
    // if (modeSelected == 0) ASIListToBind = ASIListExport;
    // if (modeSelected == 1) ASIListToBind = ASIListImport;
    if (ASIListExport.isNotEmpty)
      ASIListToBind = ASIListExport;

    _controllerModeType.addListener(() {
      setState(() {
        //scannedCodeReceived = "";

        print("value changed heere");
        txtPrefix.text = "";
        if (_controllerModeType.value) {
          checked = true;
          getDockInTokenList(1); //Import
          ASIListToBind = ASIListImport;
        } else {
          checked = false;
          getDockInTokenList(2); //Export
          ASIListToBind = ASIListExport;
        }
      });
    });
    if (modeSelected == 1)
      getDockInTokenList(1); //Import
    else
      getDockInTokenList(2); //Export
    super.initState();
  }

  @override
  void dispose() {
    _controllerModeType.dispose();

    super.dispose();
  }

  getDockInTokenList(modeType) async {
    if (isLoading) return;
    txtPrefix.text = "";
    ASIListExport = [];
    ASIListImport = [];
    ASIListToBind = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {
        "OperationType":2,
        "AirlinePrefix":"",
        "AwbNumber":"",
        "HawbNumber":"",
        "IGMNo":0,
        "IGMYear":0,
        "CreatedByUserId":loggedinUser.CreatedByUserId.toString(),
        "OrganizationBranchId":loggedinUser.OrganizationBranchId.toString(),
        "OrganizationId":loggedinUser.OrganizationId.toString(),
        "GHAID":"11843"
    };
    await Global()
        .postData(
      Settings.SERVICES['GetImpHAWB_detailsForVT'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      if (modeType == 2) //export
        ASIListExport = resp
            .map<ASIList>((json) => ASIList.fromJson(json))
            .toList();
      else
        ASIListImport = resp
            .map<ASIList>((json) => ASIList.fromJson(json))
            .toList();

      print("length ASIListExport = " +
          ASIListExport.length.toString());
      print("length ASIListImport = " +
          ASIListImport.length.toString());
      setState(() {
        modeType == 2 ? modeSelected = 0 : modeSelected = 1;
        ASIListToBind =
            modeType == 2 ? ASIListExport : ASIListImport;
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
              txtPrefix.text = scannedCodeReceived;
              _runFilter(scannedCodeReceived);
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
                    txtPrefix.text = scannedCodeReceived;
                    _runFilter(scannedCodeReceived);
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
                    txtPrefix.text = scannedCodeReceived;
                    _runFilter(scannedCodeReceived);
                  });
                }
              }
            }
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
                headerText: "ASI List"),
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

                      SizedBox(height: 5),
                      Row(children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4.2,
                          child: Text("MAWB No.",
                              style: mobileHeaderFontStyle),
                        ),
                        Padding(

                          padding: const EdgeInsets.all(8.0),
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
                                  onChanged: (value) => _runFilter(value),
                                  controller: txtPrefix,
                                  keyboardType: TextInputType.number,
                                  textCapitalization:
                                  TextCapitalization.characters,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Prefix",
                                    hintStyle:
                                    TextStyle(color: Colors.grey),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    isDense: true,
                                  ),
                                  style: mobileTextFontStyle)

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
                                  onChanged: (value) => _runFilter(value),
                                  controller: txtAwbNo,
                                  keyboardType: TextInputType.number,
                                  textCapitalization:
                                  TextCapitalization.characters,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "AWB No.",
                                    hintStyle:
                                    TextStyle(color: Colors.grey),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    isDense: true,
                                  ),
                                  style: mobileTextFontStyle)

                            ),

                          ),
                        ),

                        GestureDetector(
                            child: SearchContainerButton(),
                            onTap: () async {
                              var scannedCode =
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) =>
                                const QRViewExample(),
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
                                  print("code returned from app =" +
                                      scannedCode);
                                  setState(() {
                                    scannedCodeReceived = scannedCode;
                                    txtPrefix.text = scannedCodeReceived;
                                    _runFilter(scannedCodeReceived);
                                  });
                                  // await getShipmentDetails(scannedCode);
                                }
                              }
                            }),
                        SizedBox(width: 5),
                        GestureDetector(
                          child: DeleteScanContainerButton(),
                          onTap: () async {
                            txtPrefix.clear();
                            txtAwbNo.clear();
                          },
                        )
                      ]),
                    ],
                  ),
                ),
              ),
            )
                : Expanded(
              flex: 0,
              child: Container(
                height: 140,
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
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        3.11,
                                    child: Text(" Search VT No.",
                                        style: iPadGroupHeaderFontStyle),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width /
                                          3.2, // hard coding child width
                                      child: Container(
                                        height: 60,
                                        width: MediaQuery.of(context)
                                            .size
                                            .width /
                                            3.2,
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
                                          onChanged: (value) =>
                                              _runFilter(value),
                                          controller: txtPrefix,
                                          keyboardType:
                                          TextInputType.text,
                                          textCapitalization:
                                          TextCapitalization
                                              .characters,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Search VT No.",
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
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 8),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 16.0),
                              //   child: ElevatedButton(
                              //     style: ElevatedButton.styleFrom(
                              //       elevation: 4.0,
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius:
                              //               BorderRadius.circular(
                              //                   10.0)), //
                              //       padding: const EdgeInsets.all(0.0),
                              //     ),
                              //     child: Container(
                              //       height: 65.0,
                              //       width: 65.0,
                              //       decoration: BoxDecoration(
                              //         borderRadius:
                              //             BorderRadius.circular(10),
                              //         gradient: LinearGradient(
                              //           begin: Alignment.topRight,
                              //           end: Alignment.bottomLeft,
                              //           colors: [
                              //             Color(0xFF1220BC),
                              //             Color(0xFF3540E8),
                              //           ],
                              //         ),
                              //       ),
                              //       child: Icon(
                              //         Icons.search,
                              //         size: 32,
                              //       ),
                              //     ),
                              //     onPressed: () {
                              //       setState(() {
                              //         isSearched = true;
                              //         _runFilter(txtPrefix.text);
                              //       });
                              //     },
                              //   ),
                              // ),

                              Padding(
                                padding:
                                const EdgeInsets.only(bottom: 8.0),
                                child: GestureDetector(
                                    child: ScanContainerButtonIpad(),
                                    onTap: () async {
                                      var scannedCode =
                                      await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                        const QRViewExample(),
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
                                          print(
                                              "code returned from app =" +
                                                  scannedCode);
                                          setState(() {
                                            scannedCodeReceived =
                                                scannedCode;
                                            txtPrefix.text =
                                                scannedCodeReceived;
                                            _runFilter(
                                                scannedCodeReceived);
                                          });
                                          // await getShipmentDetails(scannedCode);
                                        }
                                      }
                                    }),
                              ),
                              SizedBox(width: 5),
                              Padding(
                                padding:
                                const EdgeInsets.only(bottom: 8.0),
                                child: GestureDetector(
                                  child: GallaryScanContainerButtonIpad(),
                                  onTap: () async {
                                    final ImagePicker _picker =
                                    ImagePicker();
                                    final XFile? image =
                                    await _picker.pickImage(
                                        source: ImageSource
                                            .gallery); // Pick an image
                                    if (image == null)
                                      return;
                                    else {
                                      String? str =
                                      await Scan.parse(image.path);
                                      if (str != null) {
                                        setState(() {
                                          scannedCodeReceived = str;
                                          txtPrefix.text =
                                              scannedCodeReceived;
                                          _runFilter(scannedCodeReceived);
                                        });
                                      }
                                    }
                                  },
                                ),
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
                : Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: useMobileLayout
                            ? const EdgeInsets.only(top: 2.0, left: 0.0)
                            : const EdgeInsets.only(
                                top: 2.0, bottom: 10.0, left: 16.0),
                        child: SizedBox(
                            width: useMobileLayout
                                ? MediaQuery.of(context).size.width / 1.01
                                : MediaQuery.of(context).size.width / 1.05,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext, index) {
                                ASIList _ASIinlist =
                                    ASIListToBind.elementAt(index);
                                if (_ASIinlist.MAWBNumber != "")
                                  return buildDockList(_ASIinlist, index);
                                else
                                  return Container();
                              },
                              itemCount: ASIListToBind.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.all(2),
                            )),
                      ),
                    ),
                  )
          ]),
    );
  }

  buildDockList(ASIList awbDT, index) {
    print("IN buildDockList");
    return Card(
      // elevation: awbDT.selected ? 4 : 2,
      // shadowColor: awbDT.selected ? Colors.amber : Colors.grey.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
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
                            awbDT.GHANAME
                                .toString(),// + " services pvt ltd",
                            style: VTlistTextFontStyle,
                            textAlign: TextAlign.left,
                          ),  SizedBox(height: 3),
                          Text(
                            awbDT.HAWBNumber
                                .toString(),
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
                      awbDT.HAWB_Total_Nop.toString() + " PCS",
                      style: VTlistTextFontStylesmall,
                      textAlign: TextAlign.left,
                    ),  SizedBox(height: 3),
                    Text(
                          awbDT.HAWB_Total_GrossWt.toString()+ " Kgs",
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

// This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<ASIList> results = [];
    if (enteredKeyword.isEmpty) {
      results =
          modeSelected == 0 ? ASIListExport : ASIListImport;
      setState(() {
        ASIListToBind = results;
        isSearched = false;
      });
    } else {
      if (enteredKeyword.length < 3) return;

      if (enteredKeyword.isEmpty) {
        results =
            modeSelected == 0 ? ASIListExport : ASIListImport;
      } else {
        print("enteredKeyword == " + enteredKeyword.toLowerCase());
        print("modeSelected == " + modeSelected.toString());
        print("isSearched == " + isSearched.toString());

        modeSelected == 0
            ? results.addAll(ASIListExport)
            : results.addAll(ASIListImport);
        if (isSearched) {
          setState(() {
            // print("results.length == ");
            ASIListToBind = ASIListRandom;
          });
        } else {
          print("results.length == " + results.length.toString());

          results.retainWhere((ASIList element) =>
              element.MAWBNumber.toLowerCase()
                  .contains(enteredKeyword.toLowerCase()));

          print("results.length after filter == " + results.length.toString());

          setState(() {
            // print("results.length == ");
            ASIListToBind = results;
          });
        }
      }
    }
    // Refresh the UI
  }
}
