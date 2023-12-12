import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:luxair/datastructure/vehicletoken.dart';
import 'package:luxair/global.dart';
import 'package:luxair/otherpages/walkindetails.dart';
import 'package:luxair/widgets/common.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:luxair/widgets/headers.dart';

import '../constants.dart';

class WalkInCustomer extends StatefulWidget {
  WalkInCustomer({Key? key}) : super(key: key);

  @override
  State<WalkInCustomer> createState() => _WalkInCustomerState();
}

class _WalkInCustomerState extends State<WalkInCustomer> {
  int modeSelected = 0, selectedVehicleID = -1; //, modeSelected1 = 0;
  int value = 0;
  bool useMobileLayout = false;
  String selectedVehicleText = "";
  final _controllerModeType = ValueNotifier<bool>(false);
  bool checked = false;

  bool isValidVehicleNo = true;
  bool isValidTruckingCompanyName = true;
  bool isValidDriverName = true;
  bool isValidDriverMobNo = true;
  bool isValidDriverLicNo = true;
  bool isValidVehicleType = true;

  TextEditingController txtVehicleNo = new TextEditingController();
  TextEditingController txtTruCompanyName = new TextEditingController();
  TextEditingController txtStaCode = new TextEditingController();
  TextEditingController txtDriverName = new TextEditingController();
  TextEditingController txtDriverMobNo = new TextEditingController();
  TextEditingController txtDriverLicNo = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();

  //final _controller03 = ValueNotifier<bool>(false);

  // void checkDeviceType()
  // {
  //      var smallestDimension = MediaQuery.of(context).size.shortestSide;
  //   print("smallestDimension");
  //   print(smallestDimension);
  //   setState(() {
  //     isMobile = smallestDimension < 600;
  //   });

  // }
  @override
  void initState() {
    _controllerModeType.addListener(() {
      setState(() {
        //scannedCodeReceived = "";

        if (_controllerModeType.value) {
          checked = true;
        } else {
          checked = false;
        }
      });
    });
    super.initState();
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

    print(useMobileLayout);

    return Scaffold(
      // backgroundColor: Colors.blueAccent[200],

      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: NetworkImage(
        //         "https://static.vecteezy.com/system/resources/previews/005/658/973/non_2x/abstract-background-illustration-wallpaper-with-blue-light-color-blue-grid-mosaic-background-creative-design-templates-free-vector.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderClipperWave(
                color1: Color(0xFF3383CD),
                color2: Color(0xFF11249F),
                headerText: "Walk-in Details "),
            Expanded(
              child: Padding(
                padding: useMobileLayout
                    ? const EdgeInsets.only(left: 10.0)
                    : const EdgeInsets.only(left: 40.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        useMobileLayout
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text("Mode",
                                        style: mobileHeaderFontStyle),
                                  ),
                                  AdvancedSwitch(
                                    activeColor: Color(0xFF11249F),
                                    inactiveColor: Color(0xFF11249F),
                                    activeChild: Text('Import',
                                        style: mobileToggleTextFontStyleWhite),
                                    inactiveChild: Text('Export',
                                        style: mobileToggleTextFontStyleWhite),
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    height: 35,
                                    controller: _controllerModeType,
                                  ),
                                ],
                              )
                            : Text("Mode", style: iPadHeaderFontStyle),
                        if (!useMobileLayout) SizedBox(height: 10),
                        if (!useMobileLayout)
                          ToggleSwitch(
                            minWidth: useMobileLayout
                                ? MediaQuery.of(context).size.width / 3
                                : MediaQuery.of(context).size.width / 4.5,
                            //  width: useMobileLayout ?  MediaQuery.of(context).size.width / 1.4: MediaQuery.of(context).size.width / 2.2,
                            minHeight: 65.0,
                            initialLabelIndex: modeSelected,
                            cornerRadius: 20.0,
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.grey,
                            inactiveFgColor: Colors.white,
                            totalSwitches: 2,
                            customTextStyles: [
                              TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                              TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              )
                            ],
                            labels: ['Drop-off ', ' Pick-up'],
                            icons: [
                              Icons.south,
                              Icons.north,
                            ],
                            iconSize: 22.0,
                            activeBgColors: [
                              // [Colors.blueAccent, Colors.blue],
                              // [Colors.blueAccent, Colors.blue],

                              [Color(0xFF1220BC), Color(0xFF3540E8)],
                              [Color(0xFF1220BC), Color(0xFF3540E8)],
                            ],
                            animate:
                                true, // with just animate set to true, default curve = Curves.easeIn
                            curve: Curves
                                .bounceInOut, // animate must be set to true when using custom curve
                            onToggle: (index) {
                              print('switched to: $index');

                              setState(() {
                                //selectedText = "";
                                modeSelected = index!;
                                // if (index == 1)
                                //   isPremium = true;
                                // else
                                //   isPremium = false;
                              });
                            },
                          ),
                        SizedBox(height: 10),
                        //  SizedBox(height: 10),
                        Text("Select Terminal",
                            style: useMobileLayout
                                ? mobileHeaderFontStyle
                                : iPadHeaderFontStyle),
                        SizedBox(height: 10),
                        Container(
                          width: useMobileLayout
                              ? MediaQuery.of(context).size.width / 1.1
                              : MediaQuery.of(context).size.width / 2.2,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                              // filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 1),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),

                            dropdownColor: Colors.white,
                            // isExpanded: true,
                            //underline: SizedBox(),
                            //icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                            menuMaxHeight:
                                MediaQuery.of(context).size.height / 2.5,

                            hint: Text("---- Select ----",
                                style: iPadYellowTextFontStyleBold),
                            value: selectedTerminalID,
                            items: terminalsList.map((terminal) {
                              return DropdownMenuItem(
                                child: Text(terminal.custodianName,
                                    style: iPadTextFontStyle), //label of item
                                value: terminal.custudian, //value of item
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedTerminal = value.toString();
                                selectedTerminalID =
                                    int.parse(value.toString());
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      1.8, // hard coding child width
                                  child: Text("Vehicle Type",
                                      style: useMobileLayout
                                          ? mobileHeaderFontStyle
                                          : iPadHeaderFontStyle),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: useMobileLayout
                                      ? MediaQuery.of(context).size.width / 1.1
                                      : MediaQuery.of(context).size.width / 2.2,
                                  child: Container(
                                    height: 55,
                                    child: DropdownButtonFormField(
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(8, 0, 8, 0),
                                        // filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: isValidVehicleType
                                                  ? Colors.grey.withOpacity(0.5)
                                                  : Colors.red,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                      dropdownColor: Colors.white,
                                      menuMaxHeight:
                                          MediaQuery.of(context).size.height /
                                              2.5,
                                      hint: Text("---- Select ----",
                                          style: iPadYellowTextFontStyleBold),
                                      //  value: selectedVehicleID,
                                      items: vehicletypesList.map((vehicle) {
                                        return DropdownMenuItem(
                                          child: Text(vehicle.TruckTypeName,
                                              style:
                                                  iPadTextFontStyle), //label of item
                                          value: vehicle
                                              .TruckTypeId, //value of item
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedVehicleText =
                                              value.toString();
                                          selectedVehicleID =
                                              int.parse(value.toString());
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      1.8, // hard coding child width
                                  child: Text("Vehicle No.",
                                      style: useMobileLayout
                                          ? mobileHeaderFontStyle
                                          : iPadHeaderFontStyle),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: useMobileLayout
                                      ? MediaQuery.of(context).size.width / 1.1
                                      : MediaQuery.of(context).size.width /
                                          2.2, //d coding child width
                                  child: Container(
                                    height: 48,
                                    width: useMobileLayout
                                        ? MediaQuery.of(context).size.width /
                                            1.1
                                        : MediaQuery.of(context).size.width /
                                            2.2,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isValidVehicleNo
                                            ? Colors.grey.withOpacity(0.5)
                                            : Colors.red,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: TextField(
                                        controller: txtVehicleNo,
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Enter Vehicle No.",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          isDense: true,
                                        ),
                                        style: useMobileLayout
                                            ? mobileTextFontStyle
                                            : iPadTextFontStyle),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: useMobileLayout
                                      ? MediaQuery.of(context).size.width / 1.1
                                      : MediaQuery.of(context).size.width / 2.2,
                                  child: Text("Trucking Company Name",
                                      style: useMobileLayout
                                          ? mobileHeaderFontStyle
                                          : iPadHeaderFontStyle),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: useMobileLayout
                                      ? MediaQuery.of(context).size.width / 1.1
                                      : MediaQuery.of(context).size.width / 2.2,
                                  child: Container(
                                    height: 55,
                                    width: useMobileLayout
                                        ? MediaQuery.of(context).size.width /
                                            1.1
                                        : MediaQuery.of(context).size.width /
                                            2.2,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isValidTruckingCompanyName
                                            ? Colors.grey.withOpacity(0.5)
                                            : Colors.red,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: TextField(
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        controller: txtTruCompanyName,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              "Enter trucking company name",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          isDense: true,
                                        ),
                                        style: useMobileLayout
                                            ? mobileTextFontStyle
                                            : iPadTextFontStyle),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: useMobileLayout
                                      ? MediaQuery.of(context).size.width / 1.1
                                      : MediaQuery.of(context).size.width / 2.2,
                                  child: Text("Driver Name",
                                      style: useMobileLayout
                                          ? mobileHeaderFontStyle
                                          : iPadHeaderFontStyle),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: useMobileLayout
                                      ? MediaQuery.of(context).size.width / 1.1
                                      : MediaQuery.of(context).size.width / 2.2,
                                  child: Container(
                                    height: 55,
                                    width: useMobileLayout
                                        ? MediaQuery.of(context).size.width /
                                            1.1
                                        : MediaQuery.of(context).size.width /
                                            2.2,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isValidDriverName
                                            ? Colors.grey.withOpacity(0.5)
                                            : Colors.red,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: TextField(
                                        controller: txtDriverName,
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Enter driver name",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          isDense: true,
                                        ),
                                        style: useMobileLayout
                                            ? mobileTextFontStyle
                                            : iPadTextFontStyle),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 10),
                        Wrap(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: useMobileLayout
                                      ? MediaQuery.of(context).size.width / 1.1
                                      : MediaQuery.of(context).size.width / 2.2,
                                  child: Text("Driver Mobile No.",
                                      style: useMobileLayout
                                          ? mobileHeaderFontStyle
                                          : iPadHeaderFontStyle),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: useMobileLayout
                                      ? MediaQuery.of(context).size.width / 1.1
                                      : MediaQuery.of(context).size.width / 2.2,
                                  child: Container(
                                    height: 55,
                                    width: useMobileLayout
                                        ? MediaQuery.of(context).size.width /
                                            1.1
                                        : MediaQuery.of(context).size.width /
                                            2.2,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isValidDriverMobNo
                                            ? Colors.grey.withOpacity(0.5)
                                            : Colors.red,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: TextField(
                                        controller: txtDriverMobNo,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Enter driver Mobile No.",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          isDense: true,
                                        ),
                                        style: useMobileLayout
                                            ? mobileTextFontStyle
                                            : iPadTextFontStyle),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: useMobileLayout
                                      ? MediaQuery.of(context).size.width / 1.1
                                      : MediaQuery.of(context).size.width / 2.2,
                                  child: Text("Driver License No.",
                                      style: useMobileLayout
                                          ? mobileHeaderFontStyle
                                          : iPadHeaderFontStyle),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: useMobileLayout
                                      ? MediaQuery.of(context).size.width / 1.1
                                      : MediaQuery.of(context).size.width / 2.2,
                                  child: Container(
                                    height: 55,
                                    width: useMobileLayout
                                        ? MediaQuery.of(context).size.width /
                                            1.1
                                        : MediaQuery.of(context).size.width /
                                            2.2,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isValidDriverLicNo
                                            ? Colors.grey.withOpacity(0.5)
                                            : Colors.red,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: TextField(
                                        controller: txtDriverLicNo,
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Enter driver License No.",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          isDense: true,
                                        ),
                                        style: useMobileLayout
                                            ? mobileTextFontStyle
                                            : iPadTextFontStyle),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 10),
                        // SizedBox(height: 10),
                        Wrap(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: useMobileLayout
                                      ? MediaQuery.of(context).size.width / 1.1
                                      : MediaQuery.of(context).size.width / 2.2,
                                  child: Text(
                                      "STA code (Opt.)", // "Driver Name",
                                      style: useMobileLayout
                                          ? mobileHeaderFontStyle
                                          : iPadHeaderFontStyle),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: useMobileLayout
                                      ? MediaQuery.of(context).size.width / 1.1
                                      : MediaQuery.of(context).size.width / 2.2,
                                  child: Container(
                                    height: 55,
                                    width: useMobileLayout
                                        ? MediaQuery.of(context).size.width /
                                            1.1
                                        : MediaQuery.of(context).size.width /
                                            2.2,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: TextField(
                                        controller: txtStaCode,
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        maxLength: 13,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          counterText: "",
                                          hintText:
                                              "Enter 13 Digit STA Code", //"Enter driver name",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          isDense: true,
                                        ),
                                        style: useMobileLayout
                                            ? mobileTextFontStyle
                                            : iPadTextFontStyle),
                                  ),
                                ),
                                //   SizedBox(height: 10),
                              ],
                            ),

                            SizedBox(width: 10),
                            // SizedBox(height: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //  SizedBox(height: 10),
                                SizedBox(
                                  width: useMobileLayout
                                      ? MediaQuery.of(context).size.width / 1.1
                                      : MediaQuery.of(context).size.width / 2.2,
                                  child: Text("Email ID (Opt.)",
                                      style: useMobileLayout
                                          ? mobileHeaderFontStyle
                                          : iPadHeaderFontStyle),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: useMobileLayout
                                      ? MediaQuery.of(context).size.width / 1.1
                                      : MediaQuery.of(context).size.width / 2.2,
                                  child: Container(
                                    height: 55,
                                    width: useMobileLayout
                                        ? MediaQuery.of(context).size.width /
                                            1.1
                                        : MediaQuery.of(context).size.width /
                                            2.2,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: TextField(
                                        //keyboardType: TextInputType.text,
                                        controller: txtEmail,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        autocorrect: false,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Enter email id",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          isDense: true,
                                        ),
                                        style: useMobileLayout
                                            ? mobileTextFontStyle
                                            : iPadTextFontStyle),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        //  SizedBox(height: 30),

//                         useMobileLayout
//                             ? Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   ElevatedButton(
//                                     onPressed: () {},
//                                     style: ElevatedButton.styleFrom(
//                                       elevation: 4.0,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10.0)), //
//                                       padding: const EdgeInsets.all(0.0),
//                                     ),

//                                     child: Container(
//                                       height: 70,
//                                       width: MediaQuery.of(context).size.width /
//                                           3.5,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: Colors.white,
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(
//                                             top: 18.0, bottom: 18.0),
//                                         child: Align(
//                                           alignment: Alignment.center,
//                                           child: Text('Clear',
//                                               style: buttonBlueFontStyle),
//                                         ),
//                                       ),
//                                     ),
//                                     //Text('CONTAINED BUTTON'),
//                                   ),
//                                   SizedBox(width: 10),
//                                   ElevatedButton(
//                                     onPressed: () async {
// // print("selected mode = =" + _controller03.value.toString());

//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 WalkInAwbDetails(
//                                                   modeSelected: checked == false
//                                                       ? "Exports"
//                                                       : "Imports",
//                                                 )),
//                                       );
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       elevation: 4.0,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10.0)), //
//                                       padding: const EdgeInsets.all(0.0),
//                                     ),
//                                     child: Container(
//                                       height: 70,
//                                       width: MediaQuery.of(context).size.width /
//                                           3.5,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         gradient: LinearGradient(
//                                           begin: Alignment.topRight,
//                                           end: Alignment.bottomLeft,
//                                           colors: [
//                                             Color(0xFF1220BC),
//                                             Color(0xFF3540E8),
//                                           ],
//                                         ),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(
//                                             top: 18.0, bottom: 18.0),
//                                         child: Align(
//                                           alignment: Alignment.center,
//                                           child: Text('Next',
//                                               style: buttonWhiteFontStyle),
//                                         ),
//                                       ),
//                                     ),
//                                     //Text('CONTAINED BUTTON'),
//                                   ),
//                                 ],
//                               )
//                             :

                        Wrap(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0)), //
                                padding: const EdgeInsets.all(0.0),
                              ),

                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width / 5.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Clear',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xFF1220BC)),
                                    ),
                                  ),
                                ),
                              ),
                              //Text('CONTAINED BUTTON'),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () async {
                                isValidVehicleNo = true;
                                isValidTruckingCompanyName = true;
                                isValidDriverName = true;
                                isValidDriverMobNo = true;
                                isValidDriverLicNo = true;
                                isValidVehicleType = true;
                                if (selectedVehicleID == -1)
                                  setState(() {
                                    isValidVehicleType = false;
                                  });

                                if (txtVehicleNo.text.trim() == "")
                                  setState(() {
                                    isValidVehicleNo = false;
                                  });

                                if (txtTruCompanyName.text.trim() == "")
                                  setState(() {
                                    isValidTruckingCompanyName = false;
                                  });
                                if (txtDriverName.text.trim() == "")
                                  setState(() {
                                    isValidDriverName = false;
                                  });
                                if (txtDriverMobNo.text.trim() == "")
                                  setState(() {
                                    isValidDriverMobNo = false;
                                  });
                                if (txtDriverLicNo.text.trim() == "")
                                  setState(() {
                                    isValidDriverLicNo = false;
                                  });

                                if (isValidVehicleType &&
                                    isValidVehicleNo &&
                                    isValidTruckingCompanyName &&
                                    isValidDriverName &&
                                    isValidDriverMobNo &&
                                    isValidDriverLicNo) {
                                  List<WalkinMain> walkInTable = [];
                                  WalkinMain walkinInfo = new WalkinMain(
                                      driName: txtDriverName.text,
                                      driSTA: txtStaCode.text,
                                      email: txtEmail.text,
                                      lisNo: txtDriverLicNo.text,
                                      mobNo: txtDriverMobNo.text,
                                      mobNoPrefix: "852",
                                      terminal: selectedTerminal.toString(),
                                      truckCompany: txtTruCompanyName.text,
                                      vehNo: txtVehicleNo.text,
                                      vehType: selectedVehicleID.toString());
                                  walkInTable.add(walkinInfo);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WalkInAwbDetails(
                                              walkinTable: walkInTable,
                                              modeSelected: modeSelected == 0
                                                  ? "Drop-off"
                                                  : "Pick-up",
                                            )),
                                  );
                                } else {
                                  showAlertDialog(context, "OK", "Alert",
                                      "Kindly fill all fields highlighted in Red");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0)), //
                                padding: const EdgeInsets.all(0.0),
                              ),
                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width / 5.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color(0xFF1220BC),
                                      Color(0xFF3540E8),
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      ' Next',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              //Text('CONTAINED BUTTON'),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
