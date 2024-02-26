import 'package:flutter/material.dart';
import 'package:scan/scan.dart';
import 'package:luxair/datastructure/vehicletoken.dart';
import 'package:luxair/otherpages/recordpodawblist.dart';
import 'package:luxair/widgets/common.dart';
import 'package:luxair/widgets/customdialogue.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luxair/widgets/qrscan.dart';
import '../constants.dart';
import 'package:luxair/widgets/speech_recognition.dart';
import '../global.dart';
import 'dart:convert';

class RecordPodList extends StatefulWidget {
  RecordPodList({Key? key}) : super(key: key);

  @override
  State<RecordPodList> createState() => _RecordPodListState();
}

class _RecordPodListState extends State<RecordPodList> {
  String scannedCodeReceived = "";
  bool useMobileLayout = false;
  int modeSelected = 0; //, modeSelected1 = 0;
  //  List<CodexPass> passList = [];
  // List<FilterArray> _filterArray = [];
  bool isLoading = false;
  bool isSearched = false;
  bool checked = false;
  TextEditingController txtVTNO = new TextEditingController();
  final _controllerModeType = ValueNotifier<bool>(false);
  List<DockInOutVT> dockInOutVTListToBind = [];
  List<DockInOutVT> dockInOutVTListImport = [];
  //List<DockInOutVT> dockInOutVTListExport = [];
  List<DockInOutVT> dockInOutVTListRandom = [];

  @override
  void initState() {
    if (dockInOutVTListImport.isNotEmpty)
      dockInOutVTListToBind = dockInOutVTListImport;

    getWarehouseAcceptanceTokenList(6); //Import
    super.initState();
  }

  @override
  void dispose() {
    _controllerModeType.dispose();

    super.dispose();
  }

  getWarehouseAcceptanceTokenList(modeType) async {
    if (isLoading) return;

    dockInOutVTListImport = [];
    dockInOutVTListToBind = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "OperationType": modeType.toString(), // "",
      "OrganizationBranchId":
          selectedTerminalID, //  loggedinUser.OrganizationBranchId,
    };
    await Global()
        .postData(
      Settings.SERVICES['DockOutList'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      dockInOutVTListImport =
          resp.map<DockInOutVT>((json) => DockInOutVT.fromJson(json)).toList();

      print("length dockInOutVTListImport = " +
          dockInOutVTListImport.length.toString());
      setState(() {
        dockInOutVTListToBind = dockInOutVTListImport;
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
              txtVTNO.text = scannedCodeReceived;
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
                    txtVTNO.text = scannedCodeReceived;
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
                    txtVTNO.text = scannedCodeReceived;
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
                headerText: "POD List"),
            useMobileLayout
                ? Expanded(
                    flex: 0,
                    child: Container(
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, bottom: 10.0, left: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 4.2,
                                child: Text("Search VT No.",
                                    style: mobileHeaderFontStyle),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      2.4, // hard coding child width
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
                                        controller: txtVTNO,
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Search VT No.",
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
                              GestureDetector(
                                  child: ScanContainerButton(),
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
                                          txtVTNO.text = scannedCodeReceived;
                                          _runFilter(scannedCodeReceived);
                                        });
                                        // await getShipmentDetails(scannedCode);
                                      }
                                    }
                                  }),
                              SizedBox(width: 5),
                              GestureDetector(
                                child: GalleryScanContainerButton(),
                                onTap: () async {
                                  final ImagePicker _picker = ImagePicker();
                                  final XFile? image = await _picker.pickImage(
                                      source:
                                          ImageSource.gallery); // Pick an image
                                  if (image == null)
                                    return;
                                  else {
                                    String? str = await Scan.parse(image.path);
                                    if (str != null) {
                                      setState(() {
                                        scannedCodeReceived = str;
                                        txtVTNO.text = scannedCodeReceived;
                                        _runFilter(scannedCodeReceived);
                                      });
                                    }
                                  }
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
                                                controller: txtVTNO,
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
                                                  txtVTNO.text =
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
                                                txtVTNO.text =
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
                                DockInOutVT _dockinlist =
                                    dockInOutVTListToBind.elementAt(index);
                                return buildDockList(_dockinlist, index);
                              },
                              itemCount: dockInOutVTListToBind.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.all(2),
                            )),
                      ),
                    ),
                  )
          ]),
    );
  }

  buildDockList(DockInOutVT _dl, index) {
    return index < 120
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RecordPodAwbList(vtNumber: _dl.VTNo)),
              );
            },
            child: Card(
              child: ListTile(
                leading: Container(
                  height: useMobileLayout ? 40 : 60,
                  width: useMobileLayout ? 40 : 60,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                        color: Colors.blue,
                      ),
                      shape: BoxShape.circle),
                  child: Center(
                    child: Text(_dl.DOCKNAME == "" ? "--" : _dl.DOCKNAME,
                        style: useMobileLayout
                            ? mobileGroupHeaderFontStyleBold
                            : iPadGroupHeaderFontStyleBold),
                  ),
                ),
                title: useMobileLayout
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_dl.VTNo, style: mobileGroupHeaderFontStyleBold),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 16,
                                color: Color(0xFF11249F),
                              ),
                              SizedBox(width: 5),
                              Text(_dl.SLOTTIME,
                                  style: VTlistTextFontStyleBold),
                            ],
                          ),
                        ],
                      )
                    : Text(_dl.VTNo, style: iPadGroupHeaderFontStyleBold),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!useMobileLayout) SizedBox(height: 10),
                    if (!useMobileLayout)
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 24,
                            color: Color(0xFF11249F),
                          ),
                          SizedBox(width: 10),
                          Text(_dl.SLOTTIME.toString().substring(0, 12),
                              style: VTlistTextFontStyleBoldiPad),
                          SizedBox(width: 10),
                          Icon(
                            Icons.schedule,
                            size: 24,
                            color: Color(0xFF11249F),
                          ),
                          SizedBox(width: 10),
                          Text(
                              _dl.SLOTTIME
                                  .toString()
                                  .substring(12, _dl.SLOTTIME.length),
                              style: VTlistTextFontStyleBoldiPad),
                        ],
                      ),
                    SizedBox(height: useMobileLayout ? 5 : 10),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width / 1.6,
                      color: Color(0xFF0461AA),
                    ),
                    SizedBox(height: useMobileLayout ? 5 : 10),
                    useMobileLayout
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 16,
                                    color: Color(0xFF11249F),
                                  ),
                                  SizedBox(width: 5),
                                  Text(_dl.DRIVERNAME.toUpperCase(),
                                      style: VTlistTextFontStyle),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.local_shipping,
                                    size: 16,
                                    color: Color(0xFF11249F),
                                  ),
                                  SizedBox(width: 5),
                                  Text(_dl.VEHICLENO.toUpperCase(),
                                      style: VTlistTextFontStyle),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.person,
                                size: 24,
                                color: Color(0xFF11249F),
                              ),
                              SizedBox(width: 10),
                              Text(_dl.DRIVERNAME.toUpperCase(),
                                  style: VTlistTextFontStyleBoldiPad),
                              SizedBox(width: 40),
                              Icon(
                                Icons.local_shipping,
                                size: 24,
                                color: Color(0xFF11249F),
                              ),
                              SizedBox(width: 10),
                              Text(_dl.VEHICLENO.toUpperCase(),
                                  style: VTlistTextFontStyleBoldiPad),
                            ],
                          ),
                    if (!useMobileLayout) SizedBox(height: 10),
                  ],
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  size: useMobileLayout ? 28 : 34,
                  color: Color(0xFF11249F),
                ),
              ),
            ),
          )
        : Card(
            child: ListTile(
              leading: Container(
                height: useMobileLayout ? 40 : 50,
                width: useMobileLayout ? 40 : 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: Colors.blue,
                    ),
                    shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    _dl.DOCKNAME == "" ? "--" : _dl.DOCKNAME,
                    style: useMobileLayout
                        ? mobileGroupHeaderFontStyleBold
                        : TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF11249F),
                          ),
                  ),
                ),
              ),

              title: useMobileLayout
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_dl.VTNo, style: mobileGroupHeaderFontStyleBold),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 16,
                              color: Color(0xFF11249F),
                            ),
                            SizedBox(width: 5),
                            Text(_dl.SLOTTIME, style: VTlistTextFontStyleBold),
                          ],
                        ),
                      ],
                    )
                  : Text(_dl.VTNo,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11249F))),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10.0),
              //   child: Text('IVT2207050027',
              //       style: TextStyle(
              //         fontSize:  useMobileLayout ? 18:20,
              //           fontWeight: FontWeight.bold,
              //           color: Color(0xFF11249F))),
              // ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!useMobileLayout) SizedBox(height: 10),
                  if (!useMobileLayout)
                    Text(
                      _dl.SLOTTIME,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  SizedBox(height: useMobileLayout ? 5 : 10),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width / 1.6,
                    color: Color(0xFF0461AA),
                  ),
                  SizedBox(height: useMobileLayout ? 5 : 10),
                  useMobileLayout
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Color(0xFF11249F),
                                ),
                                SizedBox(width: 5),
                                Text(_dl.DRIVERNAME,
                                    style: VTlistTextFontStyle),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.local_shipping,
                                  size: 16,
                                  color: Color(0xFF11249F),
                                ),
                                SizedBox(width: 5),
                                Text(_dl.VEHICLENO, style: VTlistTextFontStyle),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person,
                              size: 18,
                              color: Color(0xFF11249F),
                            ),
                            SizedBox(width: 10),
                            Text(
                              _dl.DRIVERNAME,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(width: 20),
                            Icon(
                              Icons.local_shipping,
                              size: 18,
                              color: Color(0xFF11249F),
                            ),
                            SizedBox(width: 10),
                            Text(
                              _dl.VEHICLENO,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                ],
              ),
              trailing: Icon(
                Icons.chevron_right,
                size: useMobileLayout ? 28 : 34,
                color: Color(0xFF11249F),
              ),
            ),
          );
  }

// This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<DockInOutVT> results = [];
    if (enteredKeyword.isEmpty) {
      results = dockInOutVTListImport;
      setState(() {
        dockInOutVTListToBind = results;
        isSearched = false;
      });
    } else {
      if (enteredKeyword.length < 3) return;

      if (enteredKeyword.isEmpty) {
        results = dockInOutVTListImport;
      } else {
        if (!enteredKeyword.startsWith("I")) if (enteredKeyword
            .startsWith("0")) {
          print("enteredKeyword == " + enteredKeyword.toLowerCase());
          print("modeSelected == " + modeSelected.toString());
          print("isSearched == " + isSearched.toString());

          results.addAll(dockInOutVTListImport);
          if (isSearched) {
            setState(() {
              // print("results.length == ");
              dockInOutVTListToBind = dockInOutVTListRandom;
            });
          } else {
            print("results.length == " + results.length.toString());

            results.retainWhere((DockInOutVT element) =>
                element.VTNo.toLowerCase()
                    .contains(enteredKeyword.toLowerCase()));

            print(
                "results.length after filter == " + results.length.toString());

            setState(() {
              // print("results.length == ");
              dockInOutVTListToBind = results;
            });
          }
        } else {
          txtVTNO.text = "";
          showDialog(
            context: context,
            builder: (BuildContext context) => customAlertMessageDialog(
                title: "Invalid VT",
                description: "Kindly enter valid VT No.",
                buttonText: "Okay",
                imagepath: 'assets/images/warn.gif',
                isMobile: useMobileLayout),
          );
        }
      }
    }
    // Refresh the UI
  }
}
