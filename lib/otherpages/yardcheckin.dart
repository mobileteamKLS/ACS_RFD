import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luxair/datastructure/vehicletoken.dart';
import 'package:luxair/otherpages/checkin.dart';
import 'package:luxair/otherpages/dockstatus.dart';
import 'package:luxair/otherpages/qrscancode.dart';
import 'package:luxair/otherpages/walkin.dart';
import 'package:luxair/widgets/headers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../constants.dart';
import '../global.dart';

// ignore: must_be_immutable
class YardCheckIn extends StatefulWidget {
  YardCheckIn({Key? key, useMobileLayout}) : super(key: key);

  @override
  _YardCheckInState createState() => _YardCheckInState();
}

class _YardCheckInState extends State<YardCheckIn> {
  bool useMobileLayout = false, isLoading = false;

  @override
  void initState() {
   // getTerminalsList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = smallestDimension < 600;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Opacity(
                  //semi red clippath with more height and with 0.5 opacity
                  opacity: 0.5,
                  child: ClipPath(
                    clipper: WaveClipper(), //set our custom wave clipper
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xFF4364F7),
                            Color(0xFFa8c0ff),
                          ],
                        ),
                      ),
                      //color:Colors.deepOrangeAccent,
                      height: MediaQuery.of(context).size.height / 3.8, //200,
                    ),
                  ),
                ),
                ClipPath(
                  //upper clippath with less height
                  clipper: WaveClipper(), //set our custom wave clipper.
                  child: Container(
                    padding: EdgeInsets.only(bottom: 62),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFF3383CD),
                          Color(0xFF11249F),
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height / 4, //180,
                    alignment: Alignment.center,

                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, top: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Center(
                                    child: Icon(
                                      Icons.chevron_left,
                                      size: useMobileLayout
                                          ? 40
                                          : MediaQuery.of(context).size.width /
                                              18, //56,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: useMobileLayout ? 10 : 20),
                                Text(
                                  "Choose your request type ",
                                  style: TextStyle(
                                      fontSize: kIsWeb
                                          ? 48
                                          : MediaQuery.of(context).size.width /
                                              18, //48,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),

                  // ClipPath(
                  //   clipper: MyClippers1(),
                  //   child: Container(
                  //     padding: EdgeInsets.only(left: 40, top: 50, right: 20),
                  //     // height: 280,
                  //     // width: double.infinity,
                  //            height: MediaQuery.of(context).size.height / 3.8,
                  // width: MediaQuery.of(context).size.width, //180,
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         begin: Alignment.topRight,
                  //         end: Alignment.bottomLeft,
                  //         colors: [
                  //           Color(0xFF4364F7),
                  //           Color(0xFFa8c0ff),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // ClipPath(
                  //   clipper: MyClippers1(),
                  //   child: Container(
                  //     padding: EdgeInsets.only(left: 40, top: 50, right: 20),
                  //     // height: 250,
                  //     // width: double.infinity,
                  //            height: MediaQuery.of(context).size.height / 4,
                  // width: MediaQuery.of(context).size.width, //180,
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
                  //                 "Choose your request type ",
                  //                 style: TextStyle(
                  //                     fontSize:    MediaQuery.of(context).size.width / 18,//48,
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
                ),
              ],
            ),
            // isLoading
            //     ? Center(
            //         child: Container(
            //             height: 100,
            //             width: 100,
            //             child: CircularProgressIndicator()))
            //     : selectedTerminal == ""
            //         ? Center(
            //             child: Padding(
            //               padding: const EdgeInsets.only(top: 148.0),
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 children: [
            //                   SizedBox(height: 10),
            //                   Text("Select Terminal",
            //                       style: iPadGroupHeaderFontStyleTooBold),
            //                   SizedBox(height: 32),
            //                   Container(
            //                     width: useMobileLayout
            //                         ? MediaQuery.of(context).size.width / 1.1
            //                         : MediaQuery.of(context).size.width / 1.8,
            //                     child: DropdownButtonFormField(
            //                       decoration: InputDecoration(
            //                         contentPadding:
            //                             EdgeInsets.fromLTRB(8, 0, 8, 0),

            //                         // filled: true,
            //                         enabledBorder: OutlineInputBorder(
            //                           borderSide: BorderSide(
            //                               color: Colors.grey.withOpacity(0.5),
            //                               width: 1),
            //                           borderRadius: BorderRadius.circular(4.0),
            //                         ),
            //                       ),
            //                       dropdownColor: Colors.white,
            //                       menuMaxHeight:
            //                           MediaQuery.of(context).size.height / 2.5,
            //                       hint: Text("---- Select ----",
            //                           style: iPadYellowTextFontStyleBold),
            //                       items: terminalsList.map((terminal) {
            //                         return DropdownMenuItem(
            //                           child: Text(terminal.custodianName,
            //                               style:
            //                                   iPadYellowTextFontStyleBold), //label of item
            //                           value: terminal.custudian, //value of item
            //                         );
            //                       }).toList(),
            //                       onChanged: (value) {
            //                         setState(() {
            //                           selectedTerminal = value.toString();
            //                           selectedTerminalID =
            //                               int.parse(value.toString());
            //                         });
            //                       },
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           )
            //         : 
                    
                    
                    Padding(
                      padding: const EdgeInsets.only(top :32.0),
                      child: Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              SizedBox(height: 30),
                              RequestTypeMenuBlock(
                                  Color(0xFF4364F7),
                                  Color(0xFFa8c0ff),
                                  Icons.directions_walk,
                                  "Just Arrived ?",
                                  "Walk-in",
                                  WalkInCustomer(),
                                  useMobileLayout),
                              RequestTypeMenuBlock(
                                  Color(0xFF0052D4),
                                  Color(0xFF9CECFB),
                                  //Color(0xFF7F7FD5),

                                  Icons.bookmark,
                                  "Slot Booked ?",
                                  "Yard Check-in",
                                  CheckInYard(),
                                  useMobileLayout),
                              RequestTypeMenuBlock(
                                  Color(0xFFf2709c),
                                  Color(0xFFff9472),
                                  Icons.qr_code,
                                  "Have QR Code ?",
                                  "Scan & Check-in",
                                  ScanQRCode(),
                                  useMobileLayout),
                              // RequestTypeMenuBlock(
                              //     Color(0xFFff4b1f), // Color(0xFF1A2980),
                              //     Color(0xFFff9068),
                              //     Icons.live_tv,
                              //     "Dock Status ?",
                              //     "View Live",
                              //     LiveDockStatus(),
                              //     useMobileLayout),
                            ],
                          ),
                        ),
                    )
          ],
        ),
      ),
    );
  }

  getTerminalsList() async {
    if (isLoading) return;

    // vehicleToeknListExport = [];
    // vehicleToeknListImport = [];
    // vehicleToeknListToBind = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {};
    await Global()
        .postData(
      Settings.SERVICES['TerminalsList'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      terminalsList = resp
          .map<WarehouseTerminals>((json) => WarehouseTerminals.fromJson(json))
          .toList();

      print("length terminalsList = " + terminalsList.length.toString());

      setState(() {
        isLoading = false;
        getVehicleTypesList();
      });
    }).catchError((onError) {
      // setState(() {
      //   isLoading = false;
      // });
      print(onError);
    });
  }

  getVehicleTypesList() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var queryParams = {};
    await Global()
        .postData(
      Settings.SERVICES['VehicleTypesList'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      vehicletypesList = resp
          .map<Vehicletypes>((json) => Vehicletypes.fromJson(json))
          .toList();

      print("length vehicletypesList = " + vehicletypesList.length.toString());

      setState(() {
        isLoading = false;
        getAirportList();
      });
    }).catchError((onError) {
      // setState(() {
      //   isLoading = false;
      // });
      print(onError);
    });
  }

  getAirportList() async {
    return;

    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var queryParams = {};
    await Global()
        .postData(
      Settings.SERVICES['GetAiportsList'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      airportList =
          resp.map<Airport>((json) => Airport.fromJson(json)).toList();

      print("length airportList = " + airportList.length.toString());

      setState(() {
        isLoading = false;
        getAirlinePrefixList();
      });
    }).catchError((onError) {
      // setState(() {
      //   isLoading = false;
      // });
      print(onError);
    });
  }

  getAirlinePrefixList() async {
    return;

    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var queryParams = {"GHABranchId": selectedTerminalID};
    await Global()
        .postData(
      Settings.SERVICES['GetAirlinePrefixList'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      airlinesPrefixList = resp
          .map<AirlinesPrefix>((json) => AirlinesPrefix.fromJson(json))
          .toList();

      print("length airlinesPrefixList = " +
          airlinesPrefixList.length.toString());

      setState(() {
        isLoading = false;
      });
    }).catchError((onError) {
      // setState(() {
      //   isLoading = false;
      // });
      print(onError);
    });
  }
}

class RequestTypeMenuBlock extends StatelessWidget {
  RequestTypeMenuBlock(this.color1, this.color2, this.lblicon, this.btnText1,
      this.btnText2, this.pageroute, this.isMobile);

  final Color color1;
  final Color color2;
  final IconData lblicon;
  final String btnText1;
  final String btnText2;
  final pageroute;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 320.0,
      // width: 320.0,
      height: kIsWeb ? 320 : MediaQuery.of(context).size.height / 2.8,
      width: kIsWeb ? 320 : MediaQuery.of(context).size.width / 2.2, //180,
      color: Colors.transparent,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pageroute),
                );
              },
              //padding: const EdgeInsets.all(0.0),
              style: ElevatedButton.styleFrom(
                elevation: 1.0,
                // side: BorderSide(
                //     color: Colors.yellow,
                //     width: 2.0,
                //     style: BorderStyle.solid), //set border for the button
                shape: RoundedRectangleBorder(
                  //borderRadius: BorderRadius.circular(10.0)

                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(180),
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ), //
                padding: const EdgeInsets.all(0.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                height: kIsWeb ? 220 : MediaQuery.of(context).size.height / 3.8,
                width: kIsWeb
                    ? 220
                    : MediaQuery.of(context).size.width / 2.8, //180,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(10),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(180),
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topCenter,
                    colors: [
                      // Color(0xFFdd5e89),
                      // Color(0xFFF7BB97),
                      color1, color2
                      // Colors.blue.shade700,
                      // Colors.blue,
                      //Color(0xFF0AA1FA),
                      //Color(0xFF0A92DF),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      btnText1, // 'Scan',
                      style: TextStyle(
                          fontSize: kIsWeb
                              ? 30
                              : isMobile
                                  ? MediaQuery.of(context).size.width / 22
                                  : MediaQuery.of(context).size.width /
                                      25, //28,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                    Text(
                      btnText2, // 'QR code',
                      style: TextStyle(
                          fontSize: kIsWeb
                              ? 30
                              : isMobile
                                  ? MediaQuery.of(context).size.width / 20
                                  : MediaQuery.of(context).size.width /
                                      25, //28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              //Text('CONTAINED BUTTON'),
            ),
          ),
          // Positioned(
          //   // top: -30,
          //   right: 30,
          //   child: CircleAvatar(
          //     radius: 36.0,
          //   ),
          // ),

          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: kIsWeb
                  ? MediaQuery.of(context).size.height / 8
                  : MediaQuery.of(context).size.height / 12, //108.0,
              width: kIsWeb
                  ? MediaQuery.of(context).size.height / 8
                  : MediaQuery.of(context).size.height / 12, //108.0,
              decoration: BoxDecoration(
                  // border: Border.all(
                  //   width: 2,
                  //   color: Colors.white,
                  // ),
                  // color: Color(0xFF008000),
                  color: Colors.white,
                  //Colors.blue.withOpacity(0.5),
                  shape: BoxShape.circle),
              child:

                  // Image(
                  //   // height: 50.0,
                  //   // width: 50.0,
                  //   // fit: BoxFit.scaleDown,
                  //   image: AssetImage(
                  //       'assets/icons/qr-code-3.png'),
                  // )

                  Icon(lblicon, // Icons.qr_code,
                      size: kIsWeb
                          ? 72
                          : isMobile
                              ? MediaQuery.of(context).size.width / 9
                              : 72, //72,
                      color: color1
                      //  Color(0xFFdd5e89), //Colors.blue.shade700, //Colors.white,
                      ),
            ),
          )
        ],
      ),
    );
  }
}
