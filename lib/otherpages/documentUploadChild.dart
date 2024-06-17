import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
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
import 'documentupload.dart';

class DocumentUploadChild extends StatefulWidget {
  final DocUploadDetails docUploadDetails;

  const DocumentUploadChild(this.docUploadDetails, {Key? key})
      : super(key: key);

  @override
  State<DocumentUploadChild> createState() => _DocumentUploadChildState();
}

class _DocumentUploadChildState extends State<DocumentUploadChild> {
  String scannedCodeReceived = "",
      selectedSlotDate = "";
  bool useMobileLayout = false;
  int modeSelected = 0;
  late List<EdocDetails> docsDetailsList;
  double _sizeKbs = 0;
  final int maxSizeKbs = 2048;

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
  List<bool> isDocUploaded = [false, false, false];
  String dropdownValue = 'Select';

  @override
  void initState() {
    _controllerModeType.addListener(() {
      setState(() {
        if (_controllerModeType.value) {
          print("_controllerModeType.value chnaged to import");
          isImport = true;
        } else {
          print("_controllerModeType.value chnaged to export");
          isImport = false;
        }
      });
    });
    super.initState();
    docsDetailsList = EdocDetails.getCargo();
  }

  @override
  void dispose() {
    _controllerModeType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery
        .of(context)
        .size
        .shortestSide;
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
          } else {
            print("returnVal after replace " + returnVal);
          }
        },
        backgroundColor: Color(0xFF11249F),
        child: const Icon(Icons.record_voice_over_sharp),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderClipperWave(
                  color1: Color(0xFF3383CD),
                  color2: Color(0xFF11249F),
                  headerText: "e-Docket"),
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
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 4.3,
                            child: Text("MAWB No.",
                                style: mobileHeaderFontStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width /
                                  4.8, // hard coding child width
                              child: Container(
                                height: 40,
                                width:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2.4,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: TextField(
                                    keyboardType: TextInputType.text,
                                    textCapitalization:
                                    TextCapitalization.characters,
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
                                    style: mobileTextFontStyle),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width /
                                  2.6, // hard coding child width
                              child: Container(
                                height: 40,
                                width:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2.4,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: TextField(
                                    controller: txtVTNO,
                                    textAlign: TextAlign.right,
                                    keyboardType: TextInputType.text,
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
                                    style: mobileTextFontStyle),
                              ),
                            ),
                          ),
                        ]),
                        Container(
                          height: 1,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 1.05,
                          color: Color(0xFF11249F),
                        ),
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
                                  SizedBox(
                                    width:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width /
                                        2.45,
                                    child: Text(
                                      " MAWB No.",
                                      style: TextStyle(
                                        fontSize: 22,
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
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width /
                                              6.5,
                                          // hard coding child width
                                          child: Container(
                                            height: 60,
                                            width: MediaQuery
                                                .of(context)
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
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width /
                                              2.8,
                                          // hard coding child width
                                          child: Container(
                                            height: 60,
                                            width: MediaQuery
                                                .of(context)
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
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 1,
                                    width:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width /
                                        1.05,
                                    color: Color(0xFF11249F),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ]),
                  ),
                ),
              ),
              useMobileLayout
                  ? SizedBox(
                  child: isLoading
                      ? Center(
                      child: Container(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator()))
                      : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Column(
                              children: [
                                // SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width /
                                          2.2,
                                      child: Container(
                                        height: 30,
                                        color: Colors.yellow.shade300,
                                        child: Center(
                                          child: Text('MAWB No.',
                                              style:
                                              mobileYellowTextFontStyleBold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width /
                                          2.2,
                                      child: Container(
                                        height: 30,
                                        color: Colors.yellow.shade300,
                                        child: Center(
                                          child: Text('MAWB Date',
                                              style:
                                              mobileYellowTextFontStyleBold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width /
                                          2.2,
                                      child: Container(
                                        height: 30,
                                        color: Colors.yellow.shade100,
                                        child: Center(
                                          child: Text(
                                              "${widget.docUploadDetails
                                                  .MAWBNo}",
                                              style:
                                              mobileDetailsYellowBold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width /
                                          2.2,
                                      child: Container(
                                        height: 30,
                                        color: Colors.yellow.shade100,
                                        child: Center(
                                          child: Text(
                                              "${widget.docUploadDetails.Date}",
                                              // widget
                                              //     .selectedVtDetails
                                              //     .DRIVERNAME
                                              //     .toUpperCase(),
                                              style:
                                              mobileDetailsYellowBold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height:
                                    useMobileLayout ? 10 : 20),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      // textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        GestureDetector(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 8.0,
                                                right: 16.0),
                                            child: Icon(
                                              Icons.visibility,
                                              //FontAwesomeIcons.airbnb,
                                              size: 24,
                                              color: const Color(
                                                  0xFF11249F),
                                            ),
                                          ),
                                          onTap: () {
                                            // viewPdf(context, _documentDetails.FilePath);
                                          },
                                        ),
                                        if ("1" != "")
                                          Container(
                                            width: MediaQuery
                                                .of(
                                                context)
                                                .size
                                                .width /
                                                1.8, // hard coding child width
                                            child: Container(
                                              height: 38,
                                              width: MediaQuery
                                                  .of(
                                                  context)
                                                  .size
                                                  .width /
                                                  2.2,
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
                                                    borderRadius:
                                                    BorderRadius
                                                        .all(Radius
                                                        .circular(
                                                        5)),
                                                    color:
                                                    Colors.white,
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
                                                            MainAxisAlignment
                                                                .center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                value,
                                                                style: TextStyle(
                                                                  fontFamily: 'Roboto',
                                                                  fontSize: 12,
                                                                  color: isDocUploaded[0]
                                                                      ? Colors
                                                                      .green
                                                                      : Colors
                                                                      .black,
                                                                  fontWeight: FontWeight
                                                                      .w500,
                                                                  height: 1.4285714285714286,
                                                                ),
                                                                textHeightBehavior: TextHeightBehavior(
                                                                    applyHeightToFirstAscent: false),
                                                                textAlign: TextAlign
                                                                    .left,
                                                              ),
                                                            ],
                                                          ),
                                                        ),)
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            //labelText(context, _documentDetails.DocName),
                                          ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            GestureDetector(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Icon(
                                                  Icons.upload,
                                                  // FontAwesomeIcons.chevronRight,
                                                  size: 24,
                                                  color: const Color(
                                                      0xFF11249F),
                                                ),
                                              ),
                                              onTap: () async {
                                                // requestDownload(_documentDetails.FilePath);
                                                //viewPdf(context, _documentDetails.FilePath);
                                                if (dropdownValue == "Select") {
                                                  showSnackBar(context,
                                                    "Select Doc Type",);
                                                  return;
                                                }
                                                FilePickerResult?
                                                result =
                                                await FilePicker
                                                    .platform
                                                    .pickFiles(
                                                  type:
                                                  FileType.custom,
                                                  allowedExtensions: [
                                                    'pdf'
                                                  ],
                                                );

                                                //PlatformFile userDetails = result.files.first;

                                                if (result != null) {
                                                  File file = File(
                                                      result.files
                                                          .single.path
                                                          .toString());
                                                  print("file.path = " +
                                                      file.path
                                                          .toString());
                                                  print("file.absolute = " +
                                                      file.absolute
                                                          .toString());
                                                  print("file.uri = " +
                                                      file.uri
                                                          .toString());

                                                  var fileString =
                                                  file.path
                                                      .toString()
                                                      .split("/");
                                                  var fileNameString =
                                                  fileString[fileString
                                                      .length -
                                                      1]
                                                      .toString();
                                                  print("File.name == " +
                                                      fileNameString);

                                                  var fileExtString =
                                                  fileNameString
                                                      .toString()
                                                      .split(".");
                                                  if (fileExtString
                                                      .length >
                                                      0) {
                                                    var fileExt =
                                                    fileExtString[
                                                    1]
                                                        .toString();
                                                    print(
                                                        "File.eXTENSIO == " +
                                                            fileExt);
                                                    if (fileExt
                                                        .toString()
                                                        .trim()
                                                        .toLowerCase() !=
                                                        "pdf") {
                                                      // showAlert(context, 'Only .pdf files are allowed!',
                                                      //     "Invalid File");
                                                      return;
                                                    }
                                                  }

                                                  List<int>
                                                  fileInByte =
                                                  file.readAsBytesSync();
                                                  String
                                                  fileInBase64 =
                                                  base64Encode(
                                                      fileInByte);

                                                  setState(() {
                                                    // _documentDetails.FilePath = "";
                                                    print(
                                                        "-----------$fileNameString-----------");
                                                    print(
                                                        "-----------$fileInBase64-------------");
                                                    // _documentDetails.DocName = fileNameString;
                                                    // _documentDetails.FileBytes = fileInBase64;
                                                  });

                                                  // print(file.extension);
                                                  print(file.path);

                                                  //asyncFileUpload("", file);
                                                  // upload(file);
                                                } else {
                                                  print(
                                                      "User canceled the picker");
                                                }
                                              },
                                            ),
                                            GestureDetector(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 24,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onTap: () async {
                                                // var abc = await showAlertDialog(context, "Delete Confirm?",
                                                //     "Do you want to delete this row ?");
                                                // print(abc);
                                                // if (abc == "YES") {
                                                //   //delete from array
                                                //   //_documentList.removeAt(index);
                                                //   // print("_documentDetails.BookingID =" +
                                                //   //     _documentDetails.BookingID.toString());
                                                //   // print("_documentDetails.vehicleid =" +
                                                //   //     _documentDetails.vehicleid.toString());
                                                //   // print("_documentDetails.DocID =" +
                                                //   //     _documentDetails.DocID.toString());
                                                //
                                                //   // setState(() {
                                                //   //   _documentDetails.FilePath = "";
                                                //   //   _documentDetails.DocName = "";
                                                //   //   _documentDetails.File = "";
                                                //   // });
                                                // }
                                              },
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      // textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        GestureDetector(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 8.0,
                                                right: 16.0),
                                            child: Icon(
                                              Icons.visibility,
                                              //FontAwesomeIcons.airbnb,
                                              size: 24,
                                              color:
                                              Color(0xFF11249F),
                                            ),
                                          ),
                                          onTap: () {
                                            // viewPdf(context, _documentDetails.FilePath);
                                          },
                                        ),
                                        if ("1" != "")
                                          Container(
                                            width: MediaQuery
                                                .of(
                                                context)
                                                .size
                                                .width /
                                                1.8, // hard coding child width
                                            child: Container(
                                              height: 38,
                                              width: MediaQuery
                                                  .of(
                                                  context)
                                                  .size
                                                  .width /
                                                  2.8,
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
                                                    borderRadius:
                                                    BorderRadius
                                                        .all(Radius
                                                        .circular(
                                                        5)),
                                                    color:
                                                    Colors.white,
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
                                                            MainAxisAlignment
                                                                .center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                value,
                                                                style: TextStyle(
                                                                  fontFamily: 'Roboto',
                                                                  fontSize: 12,
                                                                  color: isDocUploaded[1]
                                                                      ? Colors
                                                                      .green
                                                                      : Colors
                                                                      .black,
                                                                  fontWeight: FontWeight
                                                                      .w500,
                                                                  height: 1.4285714285714286,
                                                                ),
                                                                textHeightBehavior: TextHeightBehavior(
                                                                    applyHeightToFirstAscent: false),
                                                                textAlign: TextAlign
                                                                    .left,
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            //labelText(context, _documentDetails.DocName),
                                          ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            GestureDetector(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Icon(
                                                  Icons.upload,
                                                  // FontAwesomeIcons.chevronRight,
                                                  size: 24,
                                                  color: Color(
                                                      0xFF11249F),
                                                ),
                                              ),
                                              onTap: () async {
                                                // requestDownload(_documentDetails.FilePath);
                                                //viewPdf(context, _documentDetails.FilePath);

                                                FilePickerResult?
                                                result =
                                                await FilePicker
                                                    .platform
                                                    .pickFiles(
                                                  type:
                                                  FileType.custom,
                                                  allowedExtensions: [
                                                    'pdf'
                                                  ],
                                                );

                                                //PlatformFile userDetails = result.files.first;

                                                if (result != null) {
                                                  File file = File(
                                                      result.files
                                                          .single.path
                                                          .toString());
                                                  print("file.path = " +
                                                      file.path
                                                          .toString());
                                                  print("file.absolute = " +
                                                      file.absolute
                                                          .toString());
                                                  print("file.uri = " +
                                                      file.uri
                                                          .toString());

                                                  var fileString =
                                                  file.path
                                                      .toString()
                                                      .split("/");
                                                  var fileNameString =
                                                  fileString[fileString
                                                      .length -
                                                      1]
                                                      .toString();
                                                  print("File.name == " +
                                                      fileNameString);

                                                  var fileExtString =
                                                  fileNameString
                                                      .toString()
                                                      .split(".");
                                                  if (fileExtString
                                                      .length >
                                                      0) {
                                                    var fileExt =
                                                    fileExtString[
                                                    1]
                                                        .toString();
                                                    print(
                                                        "File.eXTENSIO == " +
                                                            fileExt);
                                                    if (fileExt
                                                        .toString()
                                                        .trim()
                                                        .toLowerCase() !=
                                                        "pdf") {
                                                      // showAlert(context, 'Only .pdf files are allowed!',
                                                      //     "Invalid File");
                                                      return;
                                                    }
                                                  }

                                                  List<int>
                                                  fileInByte =
                                                  file.readAsBytesSync();
                                                  String
                                                  fileInBase64 =
                                                  base64Encode(
                                                      fileInByte);

                                                  setState(() {
                                                    // _documentDetails.FilePath = "";
                                                    // //file.path.toString();
                                                    // _documentDetails.DocName = fileNameString;
                                                    // _documentDetails.FileBytes = fileInBase64;
                                                  });

                                                  // print(file.extension);
                                                  // print(file.path);

                                                  //asyncFileUpload("", file);
                                                  // upload(file);
                                                } else {
                                                  print(
                                                      "User canceled the picker");
                                                }
                                              },
                                            ),
                                            GestureDetector(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 24,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onTap: () async {
                                                // var abc = await showAlertDialog(context, "Delete Confirm?",
                                                //     "Do you want to delete this row ?");
                                                // print(abc);
                                                // if (abc == "YES") {
                                                //   //delete from array
                                                //   //_documentList.removeAt(index);
                                                //   // print("_documentDetails.BookingID =" +
                                                //   //     _documentDetails.BookingID.toString());
                                                //   // print("_documentDetails.vehicleid =" +
                                                //   //     _documentDetails.vehicleid.toString());
                                                //   // print("_documentDetails.DocID =" +
                                                //   //     _documentDetails.DocID.toString());
                                                //
                                                //   // setState(() {
                                                //   //   _documentDetails.FilePath = "";
                                                //   //   _documentDetails.DocName = "";
                                                //   //   _documentDetails.File = "";
                                                //   // });
                                                // }
                                              },
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      // textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        GestureDetector(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 8.0,
                                                right: 16.0),
                                            child: Icon(
                                              Icons.visibility,
                                              //FontAwesomeIcons.airbnb,
                                              size: 24,
                                              color:
                                              Color(0xFF11249F),
                                            ),
                                          ),
                                          onTap: () {
                                            // viewPdf(context, _documentDetails.FilePath);
                                          },
                                        ),
                                        if ("1" != "")
                                          Container(
                                            width: MediaQuery
                                                .of(
                                                context)
                                                .size
                                                .width /
                                                1.8, // hard coding child width
                                            child: Container(
                                              height: 38,
                                              width: MediaQuery
                                                  .of(
                                                  context)
                                                  .size
                                                  .width /
                                                  2.8,
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
                                                    borderRadius:
                                                    BorderRadius
                                                        .all(Radius
                                                        .circular(
                                                        5)),
                                                    color:
                                                    Colors.white,
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
                                                            MainAxisAlignment
                                                                .center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                value,
                                                                style: TextStyle(
                                                                  fontFamily: 'Roboto',
                                                                  fontSize: 12,
                                                                  color: isDocUploaded[2]
                                                                      ? Colors
                                                                      .green
                                                                      : Colors
                                                                      .black,
                                                                  fontWeight: FontWeight
                                                                      .w500,
                                                                  height: 1.4285714285714286,
                                                                ),
                                                                textHeightBehavior: TextHeightBehavior(
                                                                    applyHeightToFirstAscent: false),
                                                                textAlign: TextAlign
                                                                    .left,
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            //labelText(context, _documentDetails.DocName),
                                          ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            GestureDetector(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Icon(
                                                  Icons.upload,
                                                  // FontAwesomeIcons.chevronRight,
                                                  size: 24,
                                                  color: Color(
                                                      0xFF11249F),
                                                ),
                                              ),
                                              onTap: () async {
                                                // requestDownload(_documentDetails.FilePath);
                                                //viewPdf(context, _documentDetails.FilePath);

                                                FilePickerResult?
                                                result =
                                                await FilePicker
                                                    .platform
                                                    .pickFiles(
                                                  type:
                                                  FileType.custom,
                                                  allowedExtensions: [
                                                    'pdf'
                                                  ],

                                                );
                                                //PlatformFile userDetails = result.files.first;
                                                if (result != null) {
                                                  final size = result.files
                                                      .first.size;
                                                  _sizeKbs = size / 1024;
                                                  if (_sizeKbs > maxSizeKbs) {
                                                    print(
                                                        'size should be less than $maxSizeKbs Kb');
                                                  } else {
                                                    print('file size accepted');
                                                    //Upload your file
                                                  }
                                                }
                                                if (result != null) {
                                                  File file = File(
                                                      result.files
                                                          .single.path
                                                          .toString());
                                                  print("file.path = " +
                                                      file.path
                                                          .toString());
                                                  print("file.absolute = " +
                                                      file.absolute
                                                          .toString());
                                                  print("file.uri = " +
                                                      file.uri
                                                          .toString());

                                                  var fileString =
                                                  file.path
                                                      .toString()
                                                      .split("/");
                                                  var fileNameString =
                                                  fileString[fileString
                                                      .length -
                                                      1]
                                                      .toString();
                                                  print("File.name == " +
                                                      fileNameString);

                                                  var fileExtString =
                                                  fileNameString
                                                      .toString()
                                                      .split(".");
                                                  if (fileExtString
                                                      .length >
                                                      0) {
                                                    var fileExt =
                                                    fileExtString[
                                                    1]
                                                        .toString();
                                                    print(
                                                        "File.eXTENSIO == " +
                                                            fileExt);
                                                    if (fileExt
                                                        .toString()
                                                        .trim()
                                                        .toLowerCase() !=
                                                        "pdf") {
                                                      // showAlert(context, 'Only .pdf files are allowed!',
                                                      //     "Invalid File");
                                                      return;
                                                    }
                                                  }

                                                  List<int>
                                                  fileInByte =
                                                  file.readAsBytesSync();
                                                  String
                                                  fileInBase64 =
                                                  base64Encode(
                                                      fileInByte);

                                                  setState(() {
                                                    // _documentDetails.FilePath = "";
                                                    // //file.path.toString();
                                                    // _documentDetails.DocName = fiileNameString;
                                                    // _documentDetails.FileBytes = fileInBase64;
                                                  });

                                                  // print(file.extension);
                                                  // print(file.path);

                                                  //asyncFileUpload("", file);
                                                  // upload(file);
                                                } else {
                                                  print(
                                                      "User canceled the picker");
                                                }
                                              },
                                            ),
                                            GestureDetector(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 24,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onTap: () async {
                                                // var abc = await showAlertDialog(context, "Delete Confirm?",
                                                //     "Do you want to delete this row ?");
                                                // print(abc);
                                                // if (abc == "YES") {
                                                //   //delete from array
                                                //   //_documentList.removeAt(index);
                                                //   // print("_documentDetails.BookingID =" +
                                                //   //     _documentDetails.BookingID.toString());
                                                //   // print("_documentDetails.vehicleid =" +
                                                //   //     _documentDetails.vehicleid.toString());
                                                //   // print("_documentDetails.DocID =" +
                                                //   //     _documentDetails.DocID.toString());
                                                //
                                                //   // setState(() {
                                                //   //   _documentDetails.FilePath = "";
                                                //   //   _documentDetails.DocName = "";
                                                //   //   _documentDetails.File = "";
                                                //   // });
                                                // }
                                              },
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        showSnackBar(
                                          context, "Clear Document",);
                                      },
                                      style: ButtonStyle(
                                        foregroundColor:
                                        MaterialStateProperty.all(
                                            const Color.fromARGB(
                                                255, 1, 36, 159)),
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            const Color.fromARGB(
                                                255,
                                                255,
                                                255,
                                                255)),
                                        shape:
                                        MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                12.0),
                                            side: const BorderSide(
                                                color: Color(
                                                    0xFF11249F)),
                                          ),
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            3.2,
                                        child: Center(
                                          child: const Text(
                                            "Clear",
                                            style: TextStyle(
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        showSnackBar(
                                            context, "Upload Document");
                                      },
                                      style: ButtonStyle(
                                        foregroundColor:
                                        MaterialStateProperty.all(
                                            const Color.fromARGB(
                                                255,
                                                255,
                                                255,
                                                255)),
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            const Color.fromARGB(
                                                255, 1, 36, 159)),
                                        shape:
                                        MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                12.0),
                                          ),
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            3.2,
                                        child: Center(
                                          child: const Text(
                                            "Upload",
                                            style: TextStyle(
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 35.0, bottom: 35.0),
                                    child: DataTable(
                                        dataRowHeight: 35.0,
                                        columnSpacing: 25.0,
                                        headingRowColor:
                                        MaterialStateProperty.all(
                                            const Color.fromARGB(
                                                255, 255, 241, 118)),
                                        showCheckboxColumn: true,
                                        headingRowHeight: 35,
                                        border: const TableBorder(
                                            horizontalInside: BorderSide(
                                                width: 0,
                                                color: Color.fromARGB(
                                                    255, 238, 237, 237),
                                                style: BorderStyle
                                                    .solid)),
                                        columns: const [
                                          DataColumn(
                                            label: Text(
                                              'Doc Name',
                                              style: TextStyle(
                                                  fontSize: 17.0),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Doc Status',
                                              style: TextStyle(
                                                  fontSize: 17.0),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Doc Remark',
                                              style: TextStyle(
                                                  fontSize: 17.0),
                                            ),
                                          ),
                                        ],
                                        rows: docsDetailsList
                                            .map((cargo) =>
                                            DataRow(
                                                color: MaterialStateProperty
                                                    .resolveWith<Color>(
                                                        (Set<MaterialState>
                                                    states) {
                                                      // Even rows will have a grey color.
                                                      if (0 == 0) {
                                                        return const Color
                                                            .fromARGB(
                                                            255,
                                                            255,
                                                            249,
                                                            196);
                                                      } else {
                                                        return Colors
                                                            .white;
                                                      }
                                                    }),
                                                cells: [
                                                  DataCell(Text(cargo
                                                      .docName)),
                                                  DataCell(Center(
                                                    child: Text(
                                                        "${cargo.docStatus}"),
                                                  )),
                                                  DataCell(Text(cargo
                                                      .docRemark)),
                                                ]))
                                            .toList()),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showSnackBar(context, "Save Document",);
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.all(
                                        const Color.fromARGB(
                                            255, 255, 255, 255)),
                                    backgroundColor:
                                    MaterialStateProperty.all(
                                        const Color.fromARGB(
                                            255, 1, 36, 159)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            12.0),
                                      ),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width /
                                        2.8,
                                    child: Center(
                                      child: const Text(
                                        "Save",
                                        style:
                                        TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                    height:
                                    useMobileLayout ? 10 : 20),
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
                        // if (!widget.isExport)
                        //   SizedBox(
                        //       height:
                        //       useMobileLayout ? 5 : 40),
                        // if (!widget.isExport)
                        //   Text(
                        //     "Shipment Details",
                        //     textAlign: TextAlign.start,
                        //     style: useMobileLayout
                        //         ? mobileHeaderFontStyle
                        //         : TextStyle(
                        //       fontSize: 24,
                        //       fontWeight:
                        //       FontWeight.normal,
                        //       color: Color(0xFF11249F),
                        //     ),
                        //   ),
                        // if (!widget.isExport)
                        //   SizedBox(
                        //       height:
                        //       useMobileLayout ? 5 : 40),
                        // for (DockInOutVTDetails dvd
                        // in dockInOutDets)
                        //   Card(
                        //     child: Padding(
                        //       padding:
                        //       const EdgeInsets.all(8.0),
                        //       child: Column(
                        //         children: [
                        //           Row(
                        //             mainAxisAlignment:
                        //             MainAxisAlignment
                        //                 .start,
                        //             crossAxisAlignment:
                        //             CrossAxisAlignment
                        //                 .start,
                        //             children: [
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     2.2,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade300,
                        //                   child: Center(
                        //                     child: Text(
                        //                         'AWB No.',
                        //                         style:
                        //                         mobileYellowTextFontStyleBold),
                        //                   ),
                        //                 ),
                        //               ),
                        //               SizedBox(width: 3),
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     2.3,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade300,
                        //                   child: Center(
                        //                     child: Text(
                        //                         'HAWB No.',
                        //                         style:
                        //                         mobileYellowTextFontStyleBold),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           Row(
                        //             mainAxisAlignment:
                        //             MainAxisAlignment
                        //                 .start,
                        //             crossAxisAlignment:
                        //             CrossAxisAlignment
                        //                 .start,
                        //             children: [
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     2.2,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade100,
                        //                   child: Center(
                        //                     child: Text(
                        //                         dvd.AirlinePrefix +
                        //                             "-" +
                        //                             dvd
                        //                                 .MAWBNumber,
                        //                         style:
                        //                         mobileDetailsYellowBold),
                        //                   ),
                        //                 ),
                        //               ),
                        //               SizedBox(width: 3),
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     2.3,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade100,
                        //                   child: Center(
                        //                     child: Text(
                        //                         dvd
                        //                             .HAWBNumber,
                        //                         style:
                        //                         mobileDetailsYellowBold),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //
                        //           // SizedBox(
                        //           //     height: useMobileLayout ? 10 : 20),
                        //
                        //           Row(
                        //             mainAxisAlignment:
                        //             MainAxisAlignment
                        //                 .start,
                        //             crossAxisAlignment:
                        //             CrossAxisAlignment
                        //                 .start,
                        //             children: [
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     2.6,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade300,
                        //                   child: Center(
                        //                     child: Text(
                        //                         'Flt Arr',
                        //                         style:
                        //                         mobileYellowTextFontStyleBold),
                        //                   ),
                        //                 ),
                        //               ),
                        //               SizedBox(width: 2),
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     4,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade300,
                        //                   child: Center(
                        //                     child: Text('CRN',
                        //                         style:
                        //                         mobileYellowTextFontStyleBold),
                        //                   ),
                        //                 ),
                        //               ),
                        //               SizedBox(width: 2),
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     4,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade300,
                        //                   child: Center(
                        //                     child: Text(
                        //                         'Pmt Cnf.',
                        //                         style:
                        //                         mobileYellowTextFontStyleBold),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           Row(
                        //             mainAxisAlignment:
                        //             MainAxisAlignment
                        //                 .start,
                        //             crossAxisAlignment:
                        //             CrossAxisAlignment
                        //                 .start,
                        //             children: [
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     2.6,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade100,
                        //                   child: Center(
                        //                       child: Text(
                        //                           dvd.FlightArrivalStatus ==
                        //                               ""
                        //                               ? ""
                        //                               : dvd.FlightArrivalStatus.toString().substring(
                        //                               0,
                        //                               12), //dvd.FlightArrivalStatus,
                        //                           style:
                        //                           mobileDetailsYellowBold)
                        //
                        //                     //       dvd.FlightArrivalStatus ==
                        //                     //     false
                        //                     // ? Text(" -- ",
                        //                     //     style:
                        //                     //         mobileDetailsYellowBold)
                        //                     // : Icon(
                        //                     //     Icons
                        //                     //         .task_alt,
                        //                     //     size: 28,
                        //                     //     color: Colors
                        //                     //         .green,
                        //                     //   ),
                        //                   ),
                        //                 ),
                        //               ),
                        //               SizedBox(width: 2),
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     4,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade100,
                        //                   child: Center(
                        //                       child: dvd.CustomReleaseNumber ==
                        //                           ""
                        //                           ? Text(
                        //                           " -- ",
                        //                           style:
                        //                           mobileDetailsYellowBold)
                        //                           : Icon(
                        //                         Icons
                        //                             .task_alt,
                        //                         size:
                        //                         28,
                        //                         color: Colors
                        //                             .green,
                        //                       )),
                        //                 ),
                        //               ),
                        //               SizedBox(width: 2),
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     4,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade100,
                        //                   child: Center(
                        //                       child: dvd.Payment ==
                        //                           ""
                        //                           ? Text(
                        //                           " -- ",
                        //                           style:
                        //                           mobileDetailsYellowBold)
                        //                           : Icon(
                        //                         Icons
                        //                             .task_alt,
                        //                         size:
                        //                         28,
                        //                         color: Colors
                        //                             .green,
                        //                       )),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   )
                      ],
                    ),
                  )
              )
                  : SizedBox(
                  child: isLoading
                      ? Center(
                      child: Container(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator()))
                      : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Column(
                              children: [
                                // SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width /
                                          2.2,
                                      child: Container(
                                        height: 50,
                                        color: Colors.yellow.shade300,
                                        child: Center(
                                          child: Text('MAWB No.',
                                              style:
                                              iPadYellowTextFontStyleNormal),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width /
                                          2.2,
                                      child: Container(
                                        height: 50,
                                        color: Colors.yellow.shade300,
                                        child: Center(
                                          child: Text('MAWB Date',
                                              style:
                                              iPadYellowTextFontStyleNormal),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width /
                                          2.2,
                                      child: Container(
                                        height: 50,
                                        color: Colors.yellow.shade100,
                                        child: Center(
                                          child: Text(
                                              "${widget.docUploadDetails
                                                  .MAWBNo}",
                                              style:
                                              iPadYellowTextFontStyleBold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width /
                                          2.2,
                                      child: Container(
                                        height: 50,
                                        color: Colors.yellow.shade100,
                                        child: Center(
                                          child: Text(
                                              "${widget.docUploadDetails.Date}",
                                              // widget
                                              //     .selectedVtDetails
                                              //     .DRIVERNAME
                                              //     .toUpperCase(),
                                              style:
                                              iPadYellowTextFontStyleBold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height:
                                    20),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      // textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        GestureDetector(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 8.0,
                                                right: 16.0),
                                            child: Icon(
                                              Icons.visibility,
                                              //FontAwesomeIcons.airbnb,
                                              size: 32,
                                              color: const Color(
                                                  0xFF11249F),
                                            ),
                                          ),
                                          onTap: () {
                                            // viewPdf(context, _documentDetails.FilePath);
                                          },
                                        ),
                                        if ("1" != "")
                                          Container(
                                            width: MediaQuery
                                                .of(
                                                context)
                                                .size
                                                .width /
                                                1.8, // hard coding child width
                                            child: Container(
                                              height: 46,
                                              width: MediaQuery
                                                  .of(
                                                  context)
                                                  .size
                                                  .width /
                                                  2.2,
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
                                                    borderRadius:
                                                    BorderRadius
                                                        .all(Radius
                                                        .circular(
                                                        5)),
                                                    color:
                                                    Colors.white,
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
                                                            MainAxisAlignment
                                                                .center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                value,
                                                                style: TextStyle(
                                                                  fontFamily: 'Roboto',
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight: FontWeight
                                                                      .w500,
                                                                  height: 1.4285714285714286,
                                                                ),
                                                                textHeightBehavior: TextHeightBehavior(
                                                                    applyHeightToFirstAscent: false),
                                                                textAlign: TextAlign
                                                                    .left,
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            //labelText(context, _documentDetails.DocName),
                                          ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            GestureDetector(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Icon(
                                                  Icons.upload,
                                                  // FontAwesomeIcons.chevronRight,
                                                  size: 32,
                                                  color: const Color(
                                                      0xFF11249F),
                                                ),
                                              ),
                                              onTap: () async {
                                                // requestDownload(_documentDetails.FilePath);
                                                //viewPdf(context, _documentDetails.FilePath);

                                                FilePickerResult?
                                                result =
                                                await FilePicker
                                                    .platform
                                                    .pickFiles(
                                                  type:
                                                  FileType.custom,
                                                  allowedExtensions: [
                                                    'pdf'
                                                  ],
                                                );

                                                //PlatformFile userDetails = result.files.first;

                                                if (result != null) {
                                                  File file = File(
                                                      result.files
                                                          .single.path
                                                          .toString());
                                                  print("file.path = " +
                                                      file.path
                                                          .toString());
                                                  print("file.absolute = " +
                                                      file.absolute
                                                          .toString());
                                                  print("file.uri = " +
                                                      file.uri
                                                          .toString());

                                                  var fileString =
                                                  file.path
                                                      .toString()
                                                      .split("/");
                                                  var fileNameString =
                                                  fileString[fileString
                                                      .length -
                                                      1]
                                                      .toString();
                                                  print("File.name == " +
                                                      fileNameString);

                                                  var fileExtString =
                                                  fileNameString
                                                      .toString()
                                                      .split(".");
                                                  if (fileExtString
                                                      .length >
                                                      0) {
                                                    var fileExt =
                                                    fileExtString[
                                                    1]
                                                        .toString();
                                                    print(
                                                        "File.eXTENSIO == " +
                                                            fileExt);
                                                    if (fileExt
                                                        .toString()
                                                        .trim()
                                                        .toLowerCase() !=
                                                        "pdf") {
                                                      // showAlert(context, 'Only .pdf files are allowed!',
                                                      //     "Invalid File");
                                                      return;
                                                    }
                                                  }

                                                  List<int>
                                                  fileInByte =
                                                  file.readAsBytesSync();
                                                  String
                                                  fileInBase64 =
                                                  base64Encode(
                                                      fileInByte);

                                                  setState(() {
                                                    // _documentDetails.FilePath = "";
                                                    // //file.path.toString();
                                                    // _documentDetails.DocName = fiileNameString;
                                                    // _documentDetails.FileBytes = fileInBase64;
                                                  });

                                                  // print(file.extension);
                                                  // print(file.path);

                                                  //asyncFileUpload("", file);
                                                  // upload(file);
                                                } else {
                                                  print(
                                                      "User canceled the picker");
                                                }
                                              },
                                            ),
                                            GestureDetector(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 32,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onTap: () async {
                                                // var abc = await showAlertDialog(context, "Delete Confirm?",
                                                //     "Do you want to delete this row ?");
                                                // print(abc);
                                                // if (abc == "YES") {
                                                //   //delete from array
                                                //   //_documentList.removeAt(index);
                                                //   // print("_documentDetails.BookingID =" +
                                                //   //     _documentDetails.BookingID.toString());
                                                //   // print("_documentDetails.vehicleid =" +
                                                //   //     _documentDetails.vehicleid.toString());
                                                //   // print("_documentDetails.DocID =" +
                                                //   //     _documentDetails.DocID.toString());
                                                //
                                                //   // setState(() {
                                                //   //   _documentDetails.FilePath = "";
                                                //   //   _documentDetails.DocName = "";
                                                //   //   _documentDetails.File = "";
                                                //   // });
                                                // }
                                              },
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      // textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        GestureDetector(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 8.0,
                                                right: 16.0),
                                            child: Icon(
                                              Icons.visibility,
                                              //FontAwesomeIcons.airbnb,
                                              size: 32,
                                              color: const Color(
                                                  0xFF11249F),
                                            ),
                                          ),
                                          onTap: () {
                                            // viewPdf(context, _documentDetails.FilePath);
                                          },
                                        ),
                                        if ("1" != "")
                                          Container(
                                            width: MediaQuery
                                                .of(
                                                context)
                                                .size
                                                .width /
                                                1.8, // hard coding child width
                                            child: Container(
                                              height: 46,
                                              width: MediaQuery
                                                  .of(
                                                  context)
                                                  .size
                                                  .width /
                                                  2.2,
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
                                                    borderRadius:
                                                    BorderRadius
                                                        .all(Radius
                                                        .circular(
                                                        5)),
                                                    color:
                                                    Colors.white,
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
                                                            MainAxisAlignment
                                                                .center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                value,
                                                                style: TextStyle(
                                                                  fontFamily: 'Roboto',
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight: FontWeight
                                                                      .w500,
                                                                  height: 1.4285714285714286,
                                                                ),
                                                                textHeightBehavior: TextHeightBehavior(
                                                                    applyHeightToFirstAscent: false),
                                                                textAlign: TextAlign
                                                                    .left,
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            //labelText(context, _documentDetails.DocName),
                                          ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            GestureDetector(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Icon(
                                                  Icons.upload,
                                                  // FontAwesomeIcons.chevronRight,
                                                  size: 32,
                                                  color: const Color(
                                                      0xFF11249F),
                                                ),
                                              ),
                                              onTap: () async {
                                                // requestDownload(_documentDetails.FilePath);
                                                //viewPdf(context, _documentDetails.FilePath);

                                                FilePickerResult?
                                                result =
                                                await FilePicker
                                                    .platform
                                                    .pickFiles(
                                                  type:
                                                  FileType.custom,
                                                  allowedExtensions: [
                                                    'pdf'
                                                  ],
                                                );

                                                //PlatformFile userDetails = result.files.first;

                                                if (result != null) {
                                                  File file = File(
                                                      result.files
                                                          .single.path
                                                          .toString());
                                                  print("file.path = " +
                                                      file.path
                                                          .toString());
                                                  print("file.absolute = " +
                                                      file.absolute
                                                          .toString());
                                                  print("file.uri = " +
                                                      file.uri
                                                          .toString());

                                                  var fileString =
                                                  file.path
                                                      .toString()
                                                      .split("/");
                                                  var fileNameString =
                                                  fileString[fileString
                                                      .length -
                                                      1]
                                                      .toString();
                                                  print("File.name == " +
                                                      fileNameString);

                                                  var fileExtString =
                                                  fileNameString
                                                      .toString()
                                                      .split(".");
                                                  if (fileExtString
                                                      .length >
                                                      0) {
                                                    var fileExt =
                                                    fileExtString[
                                                    1]
                                                        .toString();
                                                    print(
                                                        "File.eXTENSIO == " +
                                                            fileExt);
                                                    if (fileExt
                                                        .toString()
                                                        .trim()
                                                        .toLowerCase() !=
                                                        "pdf") {
                                                      // showAlert(context, 'Only .pdf files are allowed!',
                                                      //     "Invalid File");
                                                      return;
                                                    }
                                                  }

                                                  List<int>
                                                  fileInByte =
                                                  file.readAsBytesSync();
                                                  String
                                                  fileInBase64 =
                                                  base64Encode(
                                                      fileInByte);

                                                  setState(() {
                                                    // _documentDetails.FilePath = "";
                                                    // //file.path.toString();
                                                    // _documentDetails.DocName = fiileNameString;
                                                    // _documentDetails.FileBytes = fileInBase64;
                                                  });

                                                  // print(file.extension);
                                                  // print(file.path);

                                                  //asyncFileUpload("", file);
                                                  // upload(file);
                                                } else {
                                                  print(
                                                      "User canceled the picker");
                                                }
                                              },
                                            ),
                                            GestureDetector(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 32,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onTap: () async {
                                                // var abc = await showAlertDialog(context, "Delete Confirm?",
                                                //     "Do you want to delete this row ?");
                                                // print(abc);
                                                // if (abc == "YES") {
                                                //   //delete from array
                                                //   //_documentList.removeAt(index);
                                                //   // print("_documentDetails.BookingID =" +
                                                //   //     _documentDetails.BookingID.toString());
                                                //   // print("_documentDetails.vehicleid =" +
                                                //   //     _documentDetails.vehicleid.toString());
                                                //   // print("_documentDetails.DocID =" +
                                                //   //     _documentDetails.DocID.toString());
                                                //
                                                //   // setState(() {
                                                //   //   _documentDetails.FilePath = "";
                                                //   //   _documentDetails.DocName = "";
                                                //   //   _documentDetails.File = "";
                                                //   // });
                                                // }
                                              },
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      // textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        GestureDetector(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 8.0,
                                                right: 16.0),
                                            child: Icon(
                                              Icons.visibility,
                                              //FontAwesomeIcons.airbnb,
                                              size: 32,
                                              color: const Color(
                                                  0xFF11249F),
                                            ),
                                          ),
                                          onTap: () {
                                            // viewPdf(context, _documentDetails.FilePath);
                                          },
                                        ),
                                        if ("1" != "")
                                          Container(
                                            width: MediaQuery
                                                .of(
                                                context)
                                                .size
                                                .width /
                                                1.8, // hard coding child width
                                            child: Container(
                                              height: 46,
                                              width: MediaQuery
                                                  .of(
                                                  context)
                                                  .size
                                                  .width /
                                                  2.2,
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
                                                    borderRadius:
                                                    BorderRadius
                                                        .all(Radius
                                                        .circular(
                                                        5)),
                                                    color:
                                                    Colors.white,
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
                                                            MainAxisAlignment
                                                                .center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                value,
                                                                style: TextStyle(
                                                                  fontFamily: 'Roboto',
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight: FontWeight
                                                                      .w500,
                                                                  height: 1.4285714285714286,
                                                                ),
                                                                textHeightBehavior: TextHeightBehavior(
                                                                    applyHeightToFirstAscent: false),
                                                                textAlign: TextAlign
                                                                    .left,
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            //labelText(context, _documentDetails.DocName),
                                          ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            GestureDetector(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Icon(
                                                  Icons.upload,
                                                  // FontAwesomeIcons.chevronRight,
                                                  size: 32,
                                                  color: const Color(
                                                      0xFF11249F),
                                                ),
                                              ),
                                              onTap: () async {
                                                // requestDownload(_documentDetails.FilePath);
                                                //viewPdf(context, _documentDetails.FilePath);

                                                FilePickerResult?
                                                result =
                                                await FilePicker
                                                    .platform
                                                    .pickFiles(
                                                  type:
                                                  FileType.custom,
                                                  allowedExtensions: [
                                                    'pdf'
                                                  ],
                                                );

                                                //PlatformFile userDetails = result.files.first;

                                                if (result != null) {
                                                  File file = File(
                                                      result.files
                                                          .single.path
                                                          .toString());
                                                  print("file.path = " +
                                                      file.path
                                                          .toString());
                                                  print("file.absolute = " +
                                                      file.absolute
                                                          .toString());
                                                  print("file.uri = " +
                                                      file.uri
                                                          .toString());

                                                  var fileString =
                                                  file.path
                                                      .toString()
                                                      .split("/");
                                                  var fileNameString =
                                                  fileString[fileString
                                                      .length -
                                                      1]
                                                      .toString();
                                                  print("File.name == " +
                                                      fileNameString);

                                                  var fileExtString =
                                                  fileNameString
                                                      .toString()
                                                      .split(".");
                                                  if (fileExtString
                                                      .length >
                                                      0) {
                                                    var fileExt =
                                                    fileExtString[
                                                    1]
                                                        .toString();
                                                    print(
                                                        "File.eXTENSIO == " +
                                                            fileExt);
                                                    if (fileExt
                                                        .toString()
                                                        .trim()
                                                        .toLowerCase() !=
                                                        "pdf") {
                                                      // showAlert(context, 'Only .pdf files are allowed!',
                                                      //     "Invalid File");
                                                      return;
                                                    }
                                                  }

                                                  List<int>
                                                  fileInByte =
                                                  file.readAsBytesSync();
                                                  String
                                                  fileInBase64 =
                                                  base64Encode(
                                                      fileInByte);

                                                  setState(() {
                                                    // _documentDetails.FilePath = "";
                                                    // //file.path.toString();
                                                    // _documentDetails.DocName =
                                                    // .30;
                                                    // _documentDetails.FileBytes = fileInBase64;
                                                  });

                                                  // print(file.extension);
                                                  // print(file.path);

                                                  //asyncFileUpload("", file);
                                                  // upload(file);
                                                } else {
                                                  print(
                                                      "User canceled the picker");
                                                }
                                              },
                                            ),
                                            GestureDetector(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 32,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onTap: () async {
                                                // var abc = await showAlertDialog(context, "Delete Confirm?",
                                                //     "Do you want to delete this row ?");
                                                // print(abc);
                                                // if (abc == "YES") {
                                                //   //delete from array
                                                //   //_documentList.removeAt(index);
                                                //   // print("_documentDetails.BookingID =" +
                                                //   //     _documentDetails.BookingID.toString());
                                                //   // print("_documentDetails.vehicleid =" +
                                                //   //     _documentDetails.vehicleid.toString());
                                                //   // print("_documentDetails.DocID =" +
                                                //   //     _documentDetails.DocID.toString());
                                                //
                                                //   // setState(() {
                                                //   //   _documentDetails.FilePath = "";
                                                //   //   _documentDetails.DocName = "";
                                                //   //   _documentDetails.File = "";
                                                //   // });
                                                // }
                                              },
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                                SizedBox(
                                    height:
                                    20),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        showSnackBar(context, "Clear",);
                                      },
                                      style: ButtonStyle(
                                        foregroundColor:
                                        MaterialStateProperty.all(
                                            const Color.fromARGB(
                                                255, 1, 36, 159)),
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            const Color.fromARGB(
                                                255,
                                                255,
                                                255,
                                                255)),
                                        shape:
                                        MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                12.0),
                                            side: const BorderSide(
                                                color: Color(
                                                    0xFF11249F)),
                                          ),
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            3.8,
                                        height: 48,
                                        child: Center(
                                          child: const Text(
                                            "Clear",
                                            style: TextStyle(
                                                fontSize: 24),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        showSnackBar(
                                          context, "Upload Document",);
                                      },
                                      style: ButtonStyle(
                                        foregroundColor:
                                        MaterialStateProperty.all(
                                            const Color.fromARGB(
                                                255,
                                                255,
                                                255,
                                                255)),
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            const Color.fromARGB(
                                                255, 1, 36, 159)),
                                        shape:
                                        MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                12.0),
                                          ),
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            3.8,
                                        height: 48,
                                        child: Center(
                                          child: const Text(
                                            "Upload",
                                            style: TextStyle(
                                                fontSize: 24),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 35.0, bottom: 35.0),
                                    child: DataTable(
                                        dataRowHeight: 55.0,
                                        columnSpacing: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            4.8,
                                        headingRowColor:
                                        MaterialStateProperty.all(
                                            const Color.fromARGB(
                                                255, 255, 241, 118)),
                                        showCheckboxColumn: true,
                                        headingRowHeight: 50,
                                        border: const TableBorder(
                                            horizontalInside: BorderSide(
                                                width: 0,
                                                color: Color.fromARGB(
                                                    255, 238, 237, 237),
                                                style: BorderStyle
                                                    .solid)),
                                        columns: const [
                                          DataColumn(
                                            label: Text(
                                              'Doc Name',
                                              style: iPadYellowTextFontStyleNormal,
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Doc Status',
                                              style: iPadYellowTextFontStyleNormal,
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Doc Remark',
                                              style: iPadYellowTextFontStyleNormal,
                                            ),
                                          ),
                                        ],
                                        rows: docsDetailsList
                                            .map((cargo) =>
                                            DataRow(
                                                color: MaterialStateProperty
                                                    .resolveWith<Color>(
                                                        (Set<MaterialState>
                                                    states) {
                                                      // Even rows will have a grey color.
                                                      if (0 == 0) {
                                                        return const Color
                                                            .fromARGB(
                                                            255,
                                                            255,
                                                            249,
                                                            196);
                                                      } else {
                                                        return Colors
                                                            .white;
                                                      }
                                                    }),
                                                cells: [
                                                  DataCell(Text(cargo
                                                      .docName,
                                                    style: iPadYellowTextFontStyleBold,)),
                                                  DataCell(Center(
                                                    child: Text(
                                                      "${cargo.docStatus}",
                                                      style: iPadYellowTextFontStyleBold,),
                                                  )),
                                                  DataCell(Text(cargo
                                                      .docRemark,
                                                    style: iPadYellowTextFontStyleBold,)),
                                                ]))
                                            .toList()),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showSnackBar(context, "Save Document",);
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.all(
                                        const Color.fromARGB(
                                            255, 255, 255, 255)),
                                    backgroundColor:
                                    MaterialStateProperty.all(
                                        const Color.fromARGB(
                                            255, 1, 36, 159)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            12.0),
                                      ),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width /
                                        3.8,
                                    height: 48,
                                    child: Center(
                                      child: const Text(
                                        "Save",
                                        style:
                                        TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                    height:
                                    useMobileLayout ? 10 : 20),

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
                        // if (!widget.isExport)
                        //   SizedBox(
                        //       height:
                        //       useMobileLayout ? 5 : 40),
                        // if (!widget.isExport)
                        //   Text(
                        //     "Shipment Details",
                        //     textAlign: TextAlign.start,
                        //     style: useMobileLayout
                        //         ? mobileHeaderFontStyle
                        //         : TextStyle(
                        //       fontSize: 24,
                        //       fontWeight:
                        //       FontWeight.normal,
                        //       color: Color(0xFF11249F),
                        //     ),
                        //   ),
                        // if (!widget.isExport)
                        //   SizedBox(
                        //       height:
                        //       useMobileLayout ? 5 : 40),
                        // for (DockInOutVTDetails dvd
                        // in dockInOutDets)
                        //   Card(
                        //     child: Padding(
                        //       padding:
                        //       const EdgeInsets.all(8.0),
                        //       child: Column(
                        //         children: [
                        //           Row(
                        //             mainAxisAlignment:
                        //             MainAxisAlignment
                        //                 .start,
                        //             crossAxisAlignment:
                        //             CrossAxisAlignment
                        //                 .start,
                        //             children: [
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     2.2,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade300,
                        //                   child: Center(
                        //                     child: Text(
                        //                         'AWB No.',
                        //                         style:
                        //                         mobileYellowTextFontStyleBold),
                        //                   ),
                        //                 ),
                        //               ),
                        //               SizedBox(width: 3),
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     2.3,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade300,
                        //                   child: Center(
                        //                     child: Text(
                        //                         'HAWB No.',
                        //                         style:
                        //                         mobileYellowTextFontStyleBold),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           Row(
                        //             mainAxisAlignment:
                        //             MainAxisAlignment
                        //                 .start,
                        //             crossAxisAlignment:
                        //             CrossAxisAlignment
                        //                 .start,
                        //             children: [
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     2.2,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade100,
                        //                   child: Center(
                        //                     child: Text(
                        //                         dvd.AirlinePrefix +
                        //                             "-" +
                        //                             dvd
                        //                                 .MAWBNumber,
                        //                         style:
                        //                         mobileDetailsYellowBold),
                        //                   ),
                        //                 ),
                        //               ),
                        //               SizedBox(width: 3),
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     2.3,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade100,
                        //                   child: Center(
                        //                     child: Text(
                        //                         dvd
                        //                             .HAWBNumber,
                        //                         style:
                        //                         mobileDetailsYellowBold),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //
                        //           // SizedBox(
                        //           //     height: useMobileLayout ? 10 : 20),
                        //
                        //           Row(
                        //             mainAxisAlignment:
                        //             MainAxisAlignment
                        //                 .start,
                        //             crossAxisAlignment:
                        //             CrossAxisAlignment
                        //                 .start,
                        //             children: [
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     2.6,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade300,
                        //                   child: Center(
                        //                     child: Text(
                        //                         'Flt Arr',
                        //                         style:
                        //                         mobileYellowTextFontStyleBold),
                        //                   ),
                        //                 ),
                        //               ),
                        //               SizedBox(width: 2),
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     4,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade300,
                        //                   child: Center(
                        //                     child: Text('CRN',
                        //                         style:
                        //                         mobileYellowTextFontStyleBold),
                        //                   ),
                        //                 ),
                        //               ),
                        //               SizedBox(width: 2),
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     4,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade300,
                        //                   child: Center(
                        //                     child: Text(
                        //                         'Pmt Cnf.',
                        //                         style:
                        //                         mobileYellowTextFontStyleBold),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           Row(
                        //             mainAxisAlignment:
                        //             MainAxisAlignment
                        //                 .start,
                        //             crossAxisAlignment:
                        //             CrossAxisAlignment
                        //                 .start,
                        //             children: [
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     2.6,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade100,
                        //                   child: Center(
                        //                       child: Text(
                        //                           dvd.FlightArrivalStatus ==
                        //                               ""
                        //                               ? ""
                        //                               : dvd.FlightArrivalStatus.toString().substring(
                        //                               0,
                        //                               12), //dvd.FlightArrivalStatus,
                        //                           style:
                        //                           mobileDetailsYellowBold)
                        //
                        //                     //       dvd.FlightArrivalStatus ==
                        //                     //     false
                        //                     // ? Text(" -- ",
                        //                     //     style:
                        //                     //         mobileDetailsYellowBold)
                        //                     // : Icon(
                        //                     //     Icons
                        //                     //         .task_alt,
                        //                     //     size: 28,
                        //                     //     color: Colors
                        //                     //         .green,
                        //                     //   ),
                        //                   ),
                        //                 ),
                        //               ),
                        //               SizedBox(width: 2),
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     4,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade100,
                        //                   child: Center(
                        //                       child: dvd.CustomReleaseNumber ==
                        //                           ""
                        //                           ? Text(
                        //                           " -- ",
                        //                           style:
                        //                           mobileDetailsYellowBold)
                        //                           : Icon(
                        //                         Icons
                        //                             .task_alt,
                        //                         size:
                        //                         28,
                        //                         color: Colors
                        //                             .green,
                        //                       )),
                        //                 ),
                        //               ),
                        //               SizedBox(width: 2),
                        //               SizedBox(
                        //                 width: MediaQuery.of(
                        //                     context)
                        //                     .size
                        //                     .width /
                        //                     4,
                        //                 child: Container(
                        //                   height: 30,
                        //                   color: Colors.yellow
                        //                       .shade100,
                        //                   child: Center(
                        //                       child: dvd.Payment ==
                        //                           ""
                        //                           ? Text(
                        //                           " -- ",
                        //                           style:
                        //                           mobileDetailsYellowBold)
                        //                           : Icon(
                        //                         Icons
                        //                             .task_alt,
                        //                         size:
                        //                         28,
                        //                         color: Colors
                        //                             .green,
                        //                       )),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   )
                      ],
                    ),
                  )),
            ]),
      ),
    );
  }
}

class EdocDetails {
  EdocDetails(this.docName, this.docStatus, this.docRemark);

  final String docName;
  final int docStatus;
  final String docRemark;

  static List<EdocDetails> getCargo() {
    return <EdocDetails>[
      EdocDetails(
        "MAWB_99956565670",
        20,
        "ajhjgsasda",
      ),
      EdocDetails(
        "MAWB_99956565671",
        19,
        "ajdhasdjkhkj",
      ),
      EdocDetails(
        "MAWB_99956565672",
        24,
        "ljgkkgmhg",
      ),
      EdocDetails(
        "MAWB_99956565673",
        36,
        "skjfjfsjh",
      ),
    ];
  }
}
