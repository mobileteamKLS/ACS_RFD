import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';
import 'package:luxair/widgets/common.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:luxair/widgets/qrscan.dart';
import 'package:luxair/widgets/speech_recognition.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import 'documentupload.dart';

class ImportServiceFeeDetails extends StatefulWidget {
  final DocUploadDetails docUploadDetails;

  const ImportServiceFeeDetails(this.docUploadDetails, {Key? key})
      : super(key: key);

  @override
  State<ImportServiceFeeDetails> createState() =>
      _ImportServiceFeeDetailsState();
}

class _ImportServiceFeeDetailsState extends State<ImportServiceFeeDetails> {
  String scannedCodeReceived = "", selectedSlotDate = "";
  bool useMobileLayout = false;
  int modeSelected = 0;
  String payableAmount="Payable Amount is \$1,250.25";
  late List<EdocDetails> docsDetailsList;
  TextEditingController dateInput = TextEditingController();

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
  List<bool> isSelected = [true, false, false];
  String dropdownValue = 'Select';

  @override
  void initState() {
    dateInput.text = "";
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
          } else {
            print("returnVal after replace " + returnVal);
          }
        },
        backgroundColor: Color(0xFF11249F), //Colors.green,
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
                  headerText: "Import Service Fee"),
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

                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(payableAmount,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500
                                        )),
                                  ),
                                ),
                              ]),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width / 1.05,
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
                                              fontSize: 22,
                                              fontWeight: FontWeight.normal,
                                              color: Color(0xFF11249F),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 1,
                                          width: MediaQuery.of(context)
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 0.0,
                                      bottom: 10.0,
                                      left: 012.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width /
                                                3.4,
                                            child: Text("Cargo Type",
                                                style: mobileHeaderFontStyle),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  1.6, // hard coding child width
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
                                                child: DropdownButtonHideUnderline(
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
                                        ]),
                                        Row(children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width /
                                                3.4,
                                            child: Text("Commodity Name",
                                                style: mobileHeaderFontStyle),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  1.6, // hard coding child width
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
                                                child: DropdownButtonHideUnderline(
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

                                        ]),
                                        Row(children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width /
                                                3.4,
                                            child: Text("HSN Code (Opt.)",
                                                style: mobileHeaderFontStyle),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  1.6, // hard coding child width
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
                                                    controller: txtVTNO,
                                                    textAlign: TextAlign.right,
                                                    keyboardType:
                                                    TextInputType.text,
                                                    textCapitalization:
                                                    TextCapitalization
                                                        .characters,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "Enter HSN Code",
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
                                        ]),

                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('HAWB No.',
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text(
                                                "${widget.docUploadDetails.MAWBNo}",
                                                style: mobileDetailsYellowBold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text(
                                                "${widget.docUploadDetails.MAWBNo}",
                                                style: mobileDetailsYellowBold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.09,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('Slot/ Dock Details',
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.09,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text("ZZ700 / 10 Feb 2024",
                                                style: mobileDetailsYellowBold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Row(children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.0,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text("Customs Entry Details ",
                                            style: mobileHeaderFontStyle),
                                      ),
                                    ),
                                  ]),
                                  Container(
                                    height: 1,
                                    margin: EdgeInsets.only(
                                        right: 16.0,
                                        top: 8.0,
                                        bottom: 16.0,
                                        left: 16.0),
                                    width: MediaQuery.of(context).size.width /
                                        1.00,
                                    color: Color(0xFF11249F),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('Segregation Date',
                                                style:
                                                    mobileYellowTextFontStyleBold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('Customs Entry No.',
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text(
                                                "${widget.docUploadDetails.MAWBNo}",
                                                style: mobileDetailsYellowBold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text(
                                                "${widget.docUploadDetails.PCS}",
                                                // widget
                                                //     .selectedVtDetails
                                                //     .DRIVERNAME
                                                //     .toUpperCase(),
                                                style: mobileDetailsYellowBold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('Customs Entry Date',
                                                style:
                                                    mobileYellowTextFontStyleBold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text("128.00",
                                                style: mobileDetailsYellowBold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text("128.00",
                                                // widget
                                                //     .selectedVtDetails
                                                //     .DRIVERNAME
                                                //     .toUpperCase(),
                                                style: mobileDetailsYellowBold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('HAWB No.',
                                                style:
                                                    mobileYellowTextFontStyleBold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('NOP',
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text("128.00",
                                                style: mobileDetailsYellowBold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text("128.00",
                                                // widget
                                                //     .selectedVtDetails
                                                //     .DRIVERNAME
                                                //     .toUpperCase(),
                                                style: mobileDetailsYellowBold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('Gr.Wt.(Kgs)',
                                                style:
                                                    mobileYellowTextFontStyleBold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('Charg. Wt.(Kgs)',
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text("128.00",
                                                style: mobileDetailsYellowBold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text("128.00",
                                                // widget
                                                //     .selectedVtDetails
                                                //     .DRIVERNAME
                                                //     .toUpperCase(),
                                                style: mobileDetailsYellowBold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('Unit',
                                                style:
                                                    mobileYellowTextFontStyleBold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('Ch.Wt.(Kgs)',
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text("128.00",
                                                style: mobileDetailsYellowBold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text("128.00",
                                                // widget
                                                //     .selectedVtDetails
                                                //     .DRIVERNAME
                                                //     .toUpperCase(),
                                                style: mobileDetailsYellowBold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('Custom Broker Code',
                                                style:
                                                    mobileYellowTextFontStyleBold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('Custom Broker Name',
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text("128.00",
                                                style: mobileDetailsYellowBold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 30,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text("128.00",
                                                // widget
                                                //     .selectedVtDetails
                                                //     .DRIVERNAME
                                                //     .toUpperCase(),
                                                style: mobileDetailsYellowBold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    const Color.fromARGB(
                                                        255, 1, 36, 159)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    const Color.fromARGB(
                                                        255, 255, 255, 255)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: const BorderSide(
                                                    color: Color(0xFF11249F)),
                                              ),
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.8,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                10.8,
                                            child: Center(
                                              child: const Text(
                                                "Back",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Container(
                                        //   height:MediaQuery.of(context).size.width /
                                        //       10.8,
                                        //   width: MediaQuery.of(context).size.width /
                                        //      2.8, //65.0,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(10),
                                        //     gradient: LinearGradient(
                                        //       begin: Alignment.center,
                                        //       end: Alignment.topCenter,
                                        //       colors: [
                                        //         Color(0xFF1220BC),
                                        //         Color(0xFF3540E8),
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   child: ElevatedButton(
                                        //     onPressed: () {},
                                        //     style: ElevatedButton.styleFrom(
                                        //         backgroundColor: Colors.transparent,
                                        //         shadowColor: Colors.transparent),
                                        //     child: Text('Save'),
                                        //   ),
                                        // ),
                                        ElevatedButton(
                                          onPressed: () {},
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
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.8,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                10.8,
                                            child: Center(
                                              child: const Text(
                                                "Pay Now",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 50,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('NOP',
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 50,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text(
                                                "${widget.docUploadDetails.MAWBNo}",
                                                style:
                                                    iPadYellowTextFontStyleBold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 50,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text(
                                                "${widget.docUploadDetails.PCS}",
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 50,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('Gr.Wt.(Kgs)',
                                                style:
                                                    iPadYellowTextFontStyleNormal),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 50,
                                          color: Colors.yellow.shade300,
                                          child: Center(
                                            child: Text('Ch.Wt.(Kgs)',
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 50,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text("128.00",
                                                style:
                                                    iPadYellowTextFontStyleBold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Container(
                                          height: 50,
                                          color: Colors.yellow.shade100,
                                          child: Center(
                                            child: Text("128.00",
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
                                  Container(
                                    height: 1,
                                    margin: EdgeInsets.all(16.0),
                                    width: MediaQuery.of(context).size.width /
                                        1.00,
                                    color: Color(0xFF11249F),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 0.0,
                                      bottom: 10.0,
                                      left: 18.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.0,
                                            child: Text("ITN No.",
                                                style:
                                                    iPadTextFontStyleNormalBlue),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.8, // hard coding child width
                                              child: Container(
                                                height: 46,
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
                                                    controller: txtVTNO,
                                                    textAlign: TextAlign.right,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "ITN No.",
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 14,
                                                              horizontal: 8),
                                                      isDense: true,
                                                    ),
                                                    style: mobileTextFontStyle),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        Row(children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.0,
                                            child: Text("Date",
                                                style:
                                                    iPadTextFontStyleNormalBlue),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.1, // hard coding child width
                                              child: Container(
                                                height: 46,
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
                                                    controller: dateInput,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textAlign: TextAlign.right,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "Select Date",
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12,
                                                              horizontal: 8),
                                                      isDense: true,
                                                    ),
                                                    style: mobileTextFontStyle),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            child:
                                                DatePickerContainerButtonIpad(),
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime(2100),
                                                      builder:
                                                          (context, child) {
                                                        return Theme(
                                                          data:
                                                              Theme.of(context)
                                                                  .copyWith(
                                                            colorScheme:
                                                                ColorScheme
                                                                    .light(
                                                              primary: Color(
                                                                  0xFF1220BC),
                                                              // <-- SEE HERE
                                                              onPrimary:
                                                                  Colors.white,
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
                                                      DateFormat('dd MMM yyyy')
                                                          .format(pickedDate);
                                                  dateInput.text =
                                                      formattedDate; //set output date to TextField value.

                                                  // getSlotsList(); // refesh slots
                                                });
                                              }
                                            },
                                          )
                                        ]),
                                        Row(children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.0,
                                            child: Text("NOP",
                                                style:
                                                    iPadTextFontStyleNormalBlue),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.8, // hard coding child width
                                              child: Container(
                                                height: 46,
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
                                                    controller: txtVTNO,
                                                    textAlign: TextAlign.right,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "NoP",
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12,
                                                              horizontal: 8),
                                                      isDense: true,
                                                    ),
                                                    style: mobileTextFontStyle),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        Row(children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.0,
                                            child: Text("Gr.Wt.(Kgs)",
                                                style:
                                                    iPadTextFontStyleNormalBlue),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.8, // hard coding child width
                                              child: Container(
                                                height: 46,
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
                                                    controller: txtVTNO,
                                                    textAlign: TextAlign.right,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "Gr.Wt.(Kgs)",
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12,
                                                              horizontal: 8),
                                                      isDense: true,
                                                    ),
                                                    style: mobileTextFontStyle),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        Row(children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.0,
                                            child: Text("Ch.Wt.(Kgs)",
                                                style:
                                                    iPadTextFontStyleNormalBlue),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.8, // hard coding child width
                                              child: Container(
                                                height: 46,
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
                                                    controller: txtVTNO,
                                                    textAlign: TextAlign.right,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "Ch.Wt.(Kgs)",
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12,
                                                              horizontal: 8),
                                                      isDense: true,
                                                    ),
                                                    style: mobileTextFontStyle),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        Row(children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.0,
                                            child: Text("Exporter Name",
                                                style:
                                                    iPadTextFontStyleNormalBlue),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.8, // hard coding child width
                                              child: Container(
                                                height: 46,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.8,
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
                                                    controller: txtVTNO,
                                                    textAlign: TextAlign.right,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "Exporter Name",
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12,
                                                              horizontal: 8),
                                                      isDense: true,
                                                    ),
                                                    style: mobileTextFontStyle),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    const Color.fromARGB(
                                                        255, 1, 36, 159)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    const Color.fromARGB(
                                                        255, 255, 255, 255)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: const BorderSide(
                                                    color: Color(0xFF11249F)),
                                              ),
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4.8,
                                            height: 48,
                                            child: Center(
                                              child: const Text(
                                                "Back",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Container(
                                        //   height:MediaQuery.of(context).size.width /
                                        //       10.8,
                                        //   width: MediaQuery.of(context).size.width /
                                        //      2.8, //65.0,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(10),
                                        //     gradient: LinearGradient(
                                        //       begin: Alignment.center,
                                        //       end: Alignment.topCenter,
                                        //       colors: [
                                        //         Color(0xFF1220BC),
                                        //         Color(0xFF3540E8),
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   child: ElevatedButton(
                                        //     onPressed: () {},
                                        //     style: ElevatedButton.styleFrom(
                                        //         backgroundColor: Colors.transparent,
                                        //         shadowColor: Colors.transparent),
                                        //     child: Text('Save'),
                                        //   ),
                                        // ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {},
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
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4.8,
                                            height: 48,
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
                            ),
                    )
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
        "ABCD12345678",
      ),
      EdocDetails(
        "MAWB_99956565670",
        20,
        "ABCD12345678",
      ),
      EdocDetails(
        "MAWB_99956565670",
        20,
        "ABCD12345678",
      ),
      EdocDetails(
        "MAWB_99956565670",
        20,
        "ABCD12345678",
      ),
    ];
  }
}
