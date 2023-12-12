import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:luxair/datastructure/livedockstatus.dart';
import 'package:luxair/widgets/customdialogue.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../constants.dart';
import '../global.dart';

class LiveDockStatus extends StatefulWidget {
  LiveDockStatus({Key? key}) : super(key: key);

  @override
  State<LiveDockStatus> createState() => _LiveDockStatusState();
}

class _LiveDockStatusState extends State<LiveDockStatus> {
  int modeSelected = 0, modeSelected1 = 0;
  bool dockOccupied = true,
      vehicleEnroute = true,
      dockAvailable = true,
      dockUnavailable = true,
      walkIn = true,
      pickup = true,
      dropoff = true,
      selectAll = true;
  String errMsgText = "", selectedSlot = "";
  bool useMobileLayout = false, isLoading = false, isSavingData = false;

  final _controller01 = ValueNotifier<bool>(false);
  final _controller02 = ValueNotifier<bool>(false);

  List<DockStatusLive> liveDockStatusList = [];
  List<DockStatusLive> liveDockStatusListBind = [];

  List<DockStatusLive> avlDockList = [];
  List<QueueStatusLive> liveQueueStatusList = [];

  List<VehicleAndDocks> vehicleAndDocksList = [];

  // List avlDockList = [
  //   "W2",
  //   "W3",
  //   "RP",
  //   "T2",
  //   "T1",
  //   "W5",
  //   "W6",
  //   "RE",
  //   "T9",
  //   "W99"
  // ];

  @override
  void initState() {
    getDockStatusInfo("1");

    _controller01.addListener(() {
      print("_controller02.value == " + _controller02.value.toString());
      // setState(() async {
      //   if (_controller01.value == true) popupLists(1);
      //   if (_controller01.value == false) popupLists(0);
      // });
      setState(() async {
        if (_controller01.value == true) {
          modeSelected = 1;
          popupLists(1, 1);
        }
        if (_controller01.value == false) {
          modeSelected = 0;
          popupLists(0, 1);
        }
      });
    });

    _controller02.addListener(() {
      setState(() async {
        if (_controller02.value == true) {
          modeSelected1 = 1;
          popupLists(1, 2);
        }
        if (_controller02.value == false) {
          modeSelected1 = 0;
          popupLists(0, 2);
        }
      });
    });

    // if (_controller01.value == true) //import
    // {
    //   if (_controller02.value == true) // queue
    //   {
    //     print("import queue");
    //     await getDockQueueInfo("2");
    //     await getQueueDockStatusInfo("2");
    //   } else // at dock
    //   {
    //     print("import at dock");
    //     getDockStatusInfo("2");
    //   }
    // } else // export
    // {
    //   if (_controller02.value == true) // queue
    //   {
    //     print("export queue");
    //     await getDockQueueInfo("2");
    //     await getQueueDockStatusInfo("2");
    //   } else // at dock
    //   {
    //     print("export at dock");
    //     getDockStatusInfo("2");
    //   }
    // }

    // _controller02.addListener(() {
    //   setState(() {
    //     print(_controller01.value.toString());
    //   });
    // });

    super.initState();
  }

  popupLists(index, controller) async {
    print("controller ==" + controller.toString());
    print("index ==" + index.toString());
    print("modeSelected1 ==" + modeSelected1.toString());
    print("modeSelected ==" + modeSelected.toString());

    if (controller == 1) {
      // import export chnaged
      if (index == 0) // export selected
      {
        if (modeSelected1 == 1) //queue
        {
          print("export queue");
          await getDockQueueInfo("1");
        } else // at dock
        {
          print("export at dock");
          getDockStatusInfo("1");
        }
      } else // import selected
      {
        if (modeSelected1 == 1) //queue
        {
          print("import queue");
          await getDockQueueInfo("2");
        } else // at dock
        {
          print("import at dock");
          getDockStatusInfo("2");
        }
      }
    } else {
      if (index == 0) // at dock selected
      {
        if (modeSelected == 0) //export
        {
          print("export at dock");
          getDockStatusInfo("1");
        } else // import
        {
          print("import at dock");
          getDockStatusInfo("2");
        }
      } else // queue selected
      {
        if (modeSelected == 1) //export
        {
          print("import queue");
          getDockQueueInfo("2");

          // await getQueueDockStatusInfo("1");
        } else // import
        {
          print("export queue");
          getDockQueueInfo("1");
          // await getQueueDockStatusInfo("2");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // running on the web!
      print("running on the web!");
      useMobileLayout = false;
    } else {
      var smallestDimension = MediaQuery.of(context).size.shortestSide;
      print("smallestDimension = " + smallestDimension.toString());
      useMobileLayout = smallestDimension < 600;
      print("useMobileLayout");
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderClipperWave(
              color1: Color(0xFF3383CD),
              color2: Color(0xFF11249F),
              headerText: "Live Dock Status"),
          //     "Live Dock Status ",
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 0.0, right: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    useMobileLayout
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AdvancedSwitch(
                                    activeColor: Color(0xFF11249F),
                                    inactiveColor: Color(0xFF11249F),
                                    activeChild: Text('Import',
                                        style: mobileToggleTextFontStyleWhite),
                                    inactiveChild: Text('Export',
                                        style: mobileToggleTextFontStyleWhite),
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height: 35,
                                    controller: _controller01,
                                  ), //['At Dock ', ' Queue'],
                                  SizedBox(height: 10),
                                  AdvancedSwitch(
                                    activeColor: Color(0xFF11249F),
                                    inactiveColor: Color(0xFF11249F),
                                    activeChild: Text('Queue',
                                        style: mobileToggleTextFontStyleWhite),
                                    inactiveChild: Text('At Dock',
                                        style: mobileToggleTextFontStyleWhite),
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height: 35,
                                    controller: _controller02,
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.68,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Select Terminal",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF11249F),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: useMobileLayout
                                          ? 260
                                          : MediaQuery.of(context).size.width /
                                              2.2,
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.fromLTRB(8, 0, 0, 0),
                                          // filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),

                                        dropdownColor: Colors.white,
                                        // isExpanded: true,
                                        //underline: SizedBox(),
                                        //icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                                        hint: Text("---- Select ----",
                                            style: iPadYellowTextFontStyleBold),

                                        value: selectedTerminalID,
                                        items: terminalsList.map((terminal) {
                                          return DropdownMenuItem(
                                            child: Text(
                                                terminal.custodianName
                                                    .toUpperCase(),
                                                style: useMobileLayout
                                                    ? mobileTextFontStyle
                                                    : iPadTextFontStyle), //label of item
                                            value: terminal
                                                .custudian, //value of item
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
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      "Select Terminal",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF11249F),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: useMobileLayout
                                          ? MediaQuery.of(context).size.width /
                                              2.2
                                          : MediaQuery.of(context).size.width /
                                              2.2,
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.fromLTRB(8, 0, 8, 0),
                                          // filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        hint: Text("---- Select ----",
                                            style: iPadYellowTextFontStyleBold),
                                        dropdownColor: Colors.white,
                                        value: selectedTerminalID,
                                        items: terminalsList.map((terminal) {
                                          return DropdownMenuItem(
                                            child: Text(
                                                terminal.custodianName
                                                    .toUpperCase(),
                                                style: useMobileLayout
                                                    ? mobileTextFontStyle
                                                    : iPadTextFontStyle), //label of item
                                            value: terminal
                                                .custudian, //value of item
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedTerminal = value.toString();
                                            selectedTerminalID =
                                                int.parse(value.toString());
                                          });
                                        },
                                        // isExpanded: true,
                                        //underline: SizedBox(),
                                        //icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                                        // value: "JFK-09",
                                        // items: [
                                        //   'ABC GH Services',
                                        //   'AdminGHA',
                                        //   'Bldg_151',
                                        //   'Bldg_76',
                                        //   'Bldg_9',
                                        //   'JFK-09',
                                        //   'JFK-151'
                                        // ].map<DropdownMenuItem<String>>(
                                        //     (String value) {
                                        //   return DropdownMenuItem<String>(
                                        //     value: value,
                                        //     child: Text(
                                        //       value,
                                        //       style: TextStyle(
                                        //         fontSize: useMobileLayout
                                        //             ? MediaQuery.of(context)
                                        //                     .size
                                        //                     .width /
                                        //                 26
                                        //             : 20,
                                        //         fontWeight: FontWeight.normal,
                                        //       ),
                                        //     ),
                                        //   );
                                        // }).toList(),
                                        // onChanged: (value) {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(height: 10),
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     AdvancedSwitch(
                              //       activeColor: Color(0xFF11249F),
                              //       inactiveColor: Color(0xFF11249F),
                              //       activeChild: Text(
                              //         'Import',
                              //         style: TextStyle(
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.normal,
                              //           color: Colors.white,
                              //         ),
                              //       ),
                              //       inactiveChild: Text(
                              //         'Export',
                              //         style: TextStyle(
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.normal,
                              //           color: Colors.white,
                              //         ),
                              //       ),
                              //       width:
                              //           MediaQuery.of(context).size.width / 2.5,
                              //       height: 35,
                              //       controller: _controller01,
                              //     ), //['At Dock ', ' Queue'],
                              //     SizedBox(height: 10),
                              //     AdvancedSwitch(
                              //       activeColor: Color(0xFF11249F),
                              //       inactiveColor: Color(0xFF11249F),
                              //       activeChild: Text(
                              //         'At Dock',
                              //         style: TextStyle(
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.normal,
                              //           color: Colors.white,
                              //         ),
                              //       ),
                              //       inactiveChild: Text(
                              //         'Queue',
                              //         style: TextStyle(
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.normal,
                              //           color: Colors.white,
                              //         ),
                              //       ),
                              //       width:
                              //           MediaQuery.of(context).size.width / 2.5,
                              //       height: 35,
                              //       controller: _controller02,
                              //     ),
                              //   ],
                              // )

                              // Padding(
                              //   padding: useMobileLayout
                              //       ? const EdgeInsets.only(right: 20.0, top: 10.0)
                              //       : const EdgeInsets.only(right: 20.0),
                              //   child: Container(
                              //     height: useMobileLayout ? 70 : 100,
                              //     width: useMobileLayout ? 70 : 100,
                              //     decoration: BoxDecoration(
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(10)),
                              //       border: Border.all(
                              //         width: 1,
                              //         color: Colors.blue,
                              //       ),
                              //     ),
                              //     child: Column(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       crossAxisAlignment: CrossAxisAlignment.center,
                              //       children: [
                              //         Icon(
                              //           Icons.refresh_sharp,
                              //           size: useMobileLayout ? 24 : 44,
                              //           color: Colors.blue,
                              //         ),
                              //         Text(
                              //           "Refresh",
                              //           style: TextStyle(
                              //             fontSize: useMobileLayout ? 12 : 20,
                              //             fontWeight: FontWeight.normal,
                              //             color: Color(0xFF11249F),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),

                              // Padding(
                              //   padding: const EdgeInsets.only(right: 88.0),
                              //   child: Container(
                              //     height: 100,
                              //     width: 100,
                              //     decoration: BoxDecoration(
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(10)),
                              //       border: Border.all(
                              //         width: 1,
                              //         color: Colors.blue,
                              //       ),
                              //     ),
                              //     child: Column(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       crossAxisAlignment: CrossAxisAlignment.center,
                              //       children: [
                              //         Icon(
                              //           Icons.filter_list_alt,
                              //           size: 44,
                              //           color: Colors.blue,
                              //         ),
                              //         Text(
                              //           "Filters",
                              //           style: TextStyle(
                              //             fontSize: 20,
                              //             fontWeight: FontWeight.normal,
                              //             color: Color(0xFF11249F),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                    SizedBox(height: 10),
                    useMobileLayout
                        ? Container()

                        // Column(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           AdvancedSwitch(
                        //             activeColor: Color(0xFF11249F),
                        //             inactiveColor: Color(0xFF11249F),
                        //             activeChild: Text(
                        //               'Import',
                        //               style: TextStyle(
                        //                 fontSize: 16,
                        //                 fontWeight: FontWeight.normal,
                        //                 color: Colors.white,
                        //               ),
                        //             ),
                        //             inactiveChild: Text(
                        //               'Export',
                        //               style: TextStyle(
                        //                 fontSize: 16,
                        //                 fontWeight: FontWeight.normal,
                        //                 color: Colors.white,
                        //               ),
                        //             ),
                        //             width:
                        //                 MediaQuery.of(context).size.width / 2.5,
                        //             height: 50,
                        //             controller: _controller01,
                        //           ),//['At Dock ', ' Queue'],
                        //            SizedBox(width: 10),
                        //           AdvancedSwitch(
                        //             activeColor: Color(0xFF11249F),
                        //             inactiveColor: Color(0xFF11249F),
                        //             activeChild: Text(
                        //               'At Dock',
                        //               style: TextStyle(
                        //                 fontSize: 16,
                        //                 fontWeight: FontWeight.normal,
                        //                 color: Colors.white,
                        //               ),
                        //             ),
                        //             inactiveChild: Text(
                        //               'Queue',
                        //               style: TextStyle(
                        //                 fontSize: 16,
                        //                 fontWeight: FontWeight.normal,
                        //                 color: Colors.white,
                        //               ),
                        //             ),
                        //             width:
                        //                 MediaQuery.of(context).size.width / 2.5,
                        //             height: 50,
                        //             controller: _controller02,
                        //           ),
                        //         ],
                        //       )

                        // Row(
                        //   children: [
                        //     SizedBox(
                        //       width:
                        //           MediaQuery.of(context).size.width / 4,
                        //       child: Text(
                        //         "Mode",
                        //         style: TextStyle(
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.normal,
                        //           color: Color(0xFF11249F),
                        //         ),
                        //       ),
                        //     ),
                        //     ToggleSwitch(
                        //       minWidth: useMobileLayout
                        //           ? MediaQuery.of(context).size.width / 3
                        //           : MediaQuery.of(context).size.width /
                        //               4.5,
                        //       //  width: useMobileLayout ?  MediaQuery.of(context).size.width / 1.4: MediaQuery.of(context).size.width / 2.2,
                        //       minHeight: 55.0,
                        //       initialLabelIndex: modeSelected,
                        //       cornerRadius: 20.0,
                        //       activeFgColor: Colors.white,
                        //       inactiveBgColor: Colors.grey,
                        //       inactiveFgColor: Colors.white,
                        //       totalSwitches: 2,
                        //       customTextStyles: [
                        //         TextStyle(
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.normal,
                        //           color: Colors.white,
                        //         ),
                        //         TextStyle(
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.normal,
                        //           color: Colors.white,
                        //         )
                        //       ],
                        //       labels: ['Exports ', ' Imports'],
                        //       icons: [
                        //         Icons.north,
                        //         Icons.south,
                        //       ],
                        //       iconSize: 22.0,
                        //       activeBgColors: [
                        //         // [Colors.blueAccent, Colors.blue],
                        //         // [Colors.blueAccent, Colors.blue],

                        //         [Color(0xFF1220BC), Color(0xFF3540E8)],
                        //         [Color(0xFF1220BC), Color(0xFF3540E8)],
                        //       ],
                        //       animate:
                        //           true, // with just animate set to true, default curve = Curves.easeIn
                        //       curve: Curves
                        //           .bounceInOut, // animate must be set to true when using custom curve
                        //       onToggle: (index) {
                        //         print('switched to: $index');

                        //         setState(() {
                        //           //selectedText = "";
                        //           modeSelected = index!;
                        //         });
                        //       },
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 10),
                        // Row(children: [
                        //   SizedBox(
                        //     width: MediaQuery.of(context).size.width / 4,
                        //     child: Text(
                        //       "Category",
                        //       style: TextStyle(
                        //         fontSize: 20,
                        //         fontWeight: FontWeight.normal,
                        //         color: Color(0xFF11249F),
                        //       ),
                        //     ),
                        //   ),
                        //   ToggleSwitch(
                        //     minWidth: useMobileLayout
                        //         ? MediaQuery.of(context).size.width / 3
                        //         : MediaQuery.of(context).size.width / 4.5,
                        //     //  width: useMobileLayout ?  MediaQuery.of(context).size.width / 1.4: MediaQuery.of(context).size.width / 2.2,
                        //     minHeight: 55.0,
                        //     initialLabelIndex: modeSelected1,
                        //     cornerRadius: 20.0,
                        //     activeFgColor: Colors.white,
                        //     inactiveBgColor: Colors.grey,
                        //     inactiveFgColor: Colors.white,
                        //     totalSwitches: 2,
                        //     customTextStyles: [
                        //       TextStyle(
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.normal,
                        //         color: Colors.white,
                        //       ),
                        //       TextStyle(
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.normal,
                        //         color: Colors.white,
                        //       )
                        //     ],
                        //     labels: ['At Dock ', ' Queue'],
                        //     icons: [
                        //       Icons.corporate_fare,
                        //       Icons.subject,
                        //     ],
                        //     iconSize: 22.0,
                        //     activeBgColors: [
                        //       // [Colors.blueAccent, Colors.blue],
                        //       // [Colors.blueAccent, Colors.blue],
                        //       [Color(0xFF1220BC), Color(0xFF3540E8)],
                        //       [Color(0xFF1220BC), Color(0xFF3540E8)],
                        //     ],
                        //     animate:
                        //         true, // with just animate set to true, default curve = Curves.easeIn
                        //     curve: Curves
                        //         .bounceInOut, // animate must be set to true when using custom curve
                        //     onToggle: (index) {
                        //       print('modeSelected1 switched to: $index');

                        //       setState(() {
                        //         //selectedText = "";
                        //         modeSelected1 = index!;
                        //         // if (index == 1)
                        //         //   isPremium = true;
                        //         // else
                        //         //   isPremium = false;
                        //       });
                        //     },
                        //   ),
                        // ]),
                        // ],
                        //)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.3,
                                child: Text(
                                  "Mode",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF11249F),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: Text(
                                  "Category",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF11249F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(height: 10),
                    if (!useMobileLayout)
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.60,
                            child: ToggleSwitch(
                              minWidth: 146, minHeight: 65.0,
                              initialLabelIndex: modeSelected,
                              cornerRadius: 20.0,
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey,
                              inactiveFgColor: Colors.white,
                              totalSwitches: 2,
                              customTextStyles: [
                                TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                                TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                )
                              ],
                              labels: ['Exports ', ' Imports'],
                              icons: [
                                Icons.north,
                                Icons.south,
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

                                  // if (modeSelected1 == 1) //queue
                                  // {
                                  //   if (index == 1) {
                                  //     print("imports queue");
                                  //   } else {
                                  //     print("imports at dock");
                                  //     getDockStatusInfo("2");
                                  //   }
                                  // } else {
                                  //   // at dock
                                  //   if (index == 1) {
                                  //     print("export queue");
                                  //   } else {
                                  //     print("export at dock");
                                  //     getDockStatusInfo("1");
                                  //   }
                                  // }
                                });
                                if (index == 0) // export selected
                                {
                                  if (modeSelected1 == 1) //queue
                                  {
                                    print("export queue");
                                    getDockQueueInfo("1");
                                    // await getQueueDockStatusInfo("1");
                                  } else // at dock
                                  {
                                    print("export at dock");
                                    getDockStatusInfo("1");
                                  }
                                } else // import selected
                                {
                                  if (modeSelected1 == 1) //queue
                                  {
                                    print("import queue");
                                    getDockQueueInfo("2");
                                    // await getQueueDockStatusInfo("2");
                                  } else // at dock
                                  {
                                    print("import at dock");
                                    getDockStatusInfo("2");
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 98),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.60,
                            child: ToggleSwitch(
                              minWidth:
                                  146, //minWidth: MediaQuery.of(context).size.width / 5.5,
                              minHeight: 65.0,
                              initialLabelIndex: modeSelected1,
                              cornerRadius: 20.0,
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey,
                              inactiveFgColor: Colors.white,
                              totalSwitches: 2,
                              customTextStyles: [
                                TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                                TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                )
                              ],
                              labels: ['At Dock ', ' Queue'],
                              icons: [
                                Icons.corporate_fare,
                                Icons.subject,
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
                                print('modeSelected1 switched to: $index');

                                setState(() {
                                  //selectedText = "";
                                  modeSelected1 = index!;

                                  if (index == 0) // at dock selected
                                  {
                                    if (modeSelected == 0) //export
                                    {
                                      print("export at dock");
                                      getDockStatusInfo("1");
                                    } else // import
                                    {
                                      print("import at dock");
                                      getDockStatusInfo("2");
                                    }
                                  } else // queue selected
                                  {
                                    if (modeSelected == 1) //export
                                    {
                                      print("import queue");
                                      getDockQueueInfo("2");

                                      // await getQueueDockStatusInfo("1");
                                    } else // import
                                    {
                                      print("export queue");
                                      getDockQueueInfo("1");
                                      // await getQueueDockStatusInfo("2");
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    if (!useMobileLayout) SizedBox(height: 10),
                    // SizedBox(height: 10),
                    // SizedBox(height: 10),
                    // SizedBox(height: 10),
                    isLoading
                        ? Center(
                            child: Container(
                                height: 100,
                                width: 100,
                                child: CircularProgressIndicator()))
                        : modeSelected1 == 1
                            ? Container()
                            : SizedBox(
                                width: MediaQuery.of(context).size.width / 1.01,
                                child: Card(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      // scrollDirection: Axis.horizontal,
                                      children: [
                                        Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                runFilter("ALL");
                                                //   void runFilter(String enteredKeyword) {
                                                //ALL1
                                                // D - occupied - D for export , P for import
                                                //A - available
                                                //B- unavailable
                                                // Y -  enroute - - D for export , P for import
                                                // else walkin
                                                setState(() {
                                                  selectAll = !selectAll;

                                                  if (selectAll == true) {
                                                    dockOccupied = true;
                                                    vehicleEnroute = true;
                                                    dockAvailable = true;
                                                    dockUnavailable = true;
                                                    walkIn = true;
                                                    pickup = true;
                                                    dropoff = true;
                                                  } else {
                                                    dockOccupied = false;
                                                    vehicleEnroute = false;
                                                    dockAvailable = false;
                                                    dockUnavailable = false;
                                                    walkIn = false;
                                                    pickup = false;
                                                    dropoff = false;
                                                    liveDockStatusListBind = [];
                                                  }
                                                });
                                              },
                                              child: DockTileContainer(
                                                  isMobile: useMobileLayout,
                                                  colorBorder: Colors.blue,
                                                  colorBackground: Colors.white,
                                                  colorText: Color(0xFF11249F),
                                                  lblText1: "Show",
                                                  lblText2: "All"),
                                            ),
                                            selectAll
                                                ? Align(
                                                    alignment:
                                                        Alignment(1.05, -1.05),
                                                    child: InkWell(
                                                      child: Container(
                                                        height: 24,
                                                        width: 24,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  width: 2,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                color: Color(
                                                                    0xFF008000),
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      // ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                        Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  dockOccupied = !dockOccupied;
                                                  print("dockOccupied == " +
                                                      dockOccupied.toString());
                                                  vehicleEnroute = false;
                                                  dockAvailable = false;
                                                  dockUnavailable = false;
                                                  walkIn = false;
                                                  pickup = false;
                                                  dropoff = false;

                                                  if (dockOccupied == false)
                                                    selectAll = false;
                                                });
                                                runFilter("D");
                                              },
                                              child: DockTileContainer(
                                                  isMobile: useMobileLayout,
                                                  colorBorder:
                                                      Color(0xFFB41212),
                                                  colorBackground:
                                                      Color(0xFFB41212),
                                                  colorText: Colors.white,
                                                  lblText1: "Dock",
                                                  lblText2: "Occupied"),
                                            ),
                                            dockOccupied
                                                ? Align(
                                                    alignment:
                                                        Alignment(1.05, -1.05),
                                                    child: InkWell(
                                                      child: Container(
                                                        height: 24,
                                                        width: 24,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  width: 2,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                color: Color(
                                                                    0xFF008000),
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      // ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                        Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                runFilter("Y");
                                                setState(() {
                                                  vehicleEnroute =
                                                      !vehicleEnroute;
                                                  dockOccupied = false;
                                                  dockAvailable = false;
                                                  dockUnavailable = false;
                                                  walkIn = false;
                                                  pickup = false;
                                                  dropoff = false;
                                                  if (vehicleEnroute == false)
                                                    selectAll = false;
                                                });
                                              },
                                              child: DockTileContainer(
                                                  isMobile: useMobileLayout,
                                                  colorBorder:
                                                      Color(0xFFFCC900),
                                                  colorBackground:
                                                      Color(0xFFFCC900),
                                                  colorText: Colors.white,
                                                  lblText1: "Vehicle",
                                                  lblText2: "Enroute"),
                                            ),
                                            vehicleEnroute
                                                ? Align(
                                                    alignment:
                                                        Alignment(1.05, -1.05),
                                                    child: InkWell(
                                                      child: Container(
                                                        height: 24,
                                                        width: 24,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  width: 2,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                color: Color(
                                                                    0xFF008000),
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      // ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                        Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                runFilter("A");
                                                setState(() {
                                                  dockAvailable =
                                                      !dockAvailable;
                                                  vehicleEnroute = false;
                                                  dockOccupied = false;
                                                  dockUnavailable = false;
                                                  walkIn = false;
                                                  pickup = false;
                                                  dropoff = false;

                                                  if (dockAvailable == false)
                                                    selectAll = false;
                                                });
                                              },
                                              child: DockTileContainer(
                                                  isMobile: useMobileLayout,
                                                  colorBorder:
                                                      Color(0xFF008000),
                                                  colorBackground:
                                                      Color(0xFF008000),
                                                  colorText: Colors.white,
                                                  lblText1: "Dock",
                                                  lblText2: "Available"),
                                            ),
                                            dockAvailable
                                                ? Align(
                                                    alignment:
                                                        Alignment(1.05, -1.05),
                                                    child: InkWell(
                                                      child: Container(
                                                        height: 24,
                                                        width: 24,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  width: 2,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                color: Color(
                                                                    0xFF008000),
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      // ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                        Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                runFilter("B");
                                                setState(() {
                                                  dockUnavailable =
                                                      !dockUnavailable;
                                                  vehicleEnroute = false;
                                                  dockOccupied = false;
                                                  dockAvailable = false;
                                                  walkIn = false;
                                                  pickup = false;
                                                  dropoff = false;
                                                  if (dockUnavailable == false)
                                                    selectAll = false;
                                                });
                                              },
                                              child: DockTileContainer(
                                                  isMobile: useMobileLayout,
                                                  colorBorder: Colors.grey,
                                                  colorBackground: Colors.grey,
                                                  colorText: Colors.white,
                                                  lblText1: "Dock",
                                                  lblText2: "Unavailable"),
                                            ),
                                            dockUnavailable
                                                ? Align(
                                                    alignment:
                                                        Alignment(1.05, -1.05),
                                                    child: InkWell(
                                                      child: Container(
                                                        height: 24,
                                                        width: 24,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  width: 2,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                color: Color(
                                                                    0xFF008000),
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      // ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                        Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                runFilter("W");
                                                setState(() {
                                                  walkIn = !walkIn;
                                                  vehicleEnroute = false;
                                                  dockOccupied = false;
                                                  dockAvailable = false;
                                                  dockUnavailable = false;
                                                  pickup = false;
                                                  dropoff = false;
                                                  if (walkIn == false)
                                                    selectAll = false;
                                                });
                                              },
                                              child: DockTileContainer(
                                                  isMobile: useMobileLayout,
                                                  colorBorder:
                                                      Color(0xFF72B6ED),
                                                  colorBackground:
                                                      Color(0xFF72B6ED),
                                                  colorText: Colors.white,
                                                  lblText1: "Walk-in",
                                                  lblText2: "Dock"),
                                            ),
                                            walkIn
                                                ? Align(
                                                    alignment:
                                                        Alignment(1.05, -1.05),
                                                    child: InkWell(
                                                      child: Container(
                                                        height: 24,
                                                        width: 24,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  width: 2,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                color: Color(
                                                                    0xFF008000),
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      // ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                        // Stack(
                                        //   children: [
                                        GestureDetector(
                                          onTap: () {
                                            // setState(() {
                                            //   pickup = !pickup;
                                            //   vehicleEnroute = false;
                                            //   dockOccupied = false;
                                            //   dockAvailable = false;
                                            //   dockUnavailable = false;
                                            //   walkIn = false;
                                            //   dropoff = false;
                                            //   if (pickup == false)
                                            //     selectAll = false;
                                            // });
                                          },
                                          child: DockTileContainer(
                                              isMobile: useMobileLayout,
                                              colorBorder: Colors.blue,
                                              colorBackground: Colors.white,
                                              colorText: Color(0xFF11249F),
                                              lblText1: "P",
                                              lblText2: "Pick-up from Airport"),
                                        ),
                                        // pickup
                                        //     ? Align(
                                        //         alignment:
                                        //             Alignment(1.05, -1.05),
                                        //         child: InkWell(
                                        //           child: Container(
                                        //             height: 24,
                                        //             width: 24,
                                        //             decoration:
                                        //                 BoxDecoration(
                                        //                     border:
                                        //                         Border.all(
                                        //                       width: 2,
                                        //                       color: Colors
                                        //                           .white,
                                        //                     ),
                                        //                     color: Color(
                                        //                         0xFF008000),
                                        //                     shape: BoxShape
                                        //                         .circle),
                                        //             child: Icon(
                                        //               Icons.check,
                                        //               color: Colors.white,
                                        //               size: 18,
                                        //             ),
                                        //           ),
                                        //           // ),
                                        //         ),
                                        //       )
                                        //     : Container(),
                                        //],
                                        //  ),
                                        // Stack(
                                        //   children: [
                                        //    dropoff
                                        //         ? Align(
                                        //             alignment:
                                        //                 Alignment(1.05, -1.05),
                                        //             child: InkWell(
                                        //               child: Container(
                                        //                 height: 24,
                                        //                 width: 24,
                                        //                 decoration:
                                        //                     BoxDecoration(
                                        //                         border:
                                        //                             Border.all(
                                        //                           width: 2,
                                        //                           color: Colors
                                        //                               .white,
                                        //                         ),
                                        //                         color: Color(
                                        //                             0xFF008000),
                                        //                         shape: BoxShape
                                        //                             .circle),
                                        //                 child: Icon(
                                        //                   Icons.check,
                                        //                   color: Colors.white,
                                        //                   size: 18,
                                        //                 ),
                                        //               ),
                                        //               // ),
                                        //             ),
                                        //           )
                                        //         : Container(),
                                        //   ],
                                        // ),
                                        GestureDetector(
                                          onTap: () {
                                            // setState(() {
                                            //   dropoff = !dropoff;
                                            //   pickup = false;
                                            //   vehicleEnroute = false;
                                            //   dockOccupied = false;
                                            //   dockAvailable = false;
                                            //   dockUnavailable = false;
                                            //   walkIn = false;

                                            //   if (dropoff == false)
                                            //     selectAll = false;
                                            // });
                                          },
                                          child: DockTileContainer(
                                              isMobile: useMobileLayout,
                                              colorBorder: Colors.blue,
                                              colorBackground: Colors.white,
                                              colorText: Color(0xFF11249F),
                                              lblText1: "D",
                                              lblText2: "Drop-off to Airport"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                    if (!useMobileLayout) SizedBox(height: 10),
                    if (modeSelected1 == 0)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (DockStatusLive dsl in liveDockStatusListBind)

                            //       Color(0xFFFCC900),
                            //       Color(0xFFF3E8C6),

                            dsl.DockStatus != "A"
                                ? dsl.DockStatus == "Y"
                                    ? Slidable(
                                        actionPane: SlidableDrawerActionPane(),
                                        
                                        // closeOnCanceled: true,
                                        // dismissal: SlidableDismissal(
                                        //    closeOnCanceled: true,
                                        //   child: SlidableDrawerDismissal(),
                                        //   // onDismissed: (actionType) {
                                        //   //   // _showSnackBar(
                                        //   //   //     context,
                                        //   //   //     actionType == SlideActionType.primary
                                        //   //   //         ? 'Dismiss Archive'
                                        //   //   //         : 'Dimiss Delete');
                                        //   //   // setState(() {
                                        //   //   //   items.removeAt(index);
                                        //   //   // });
                                        //   // },
                                        // ),
                                        actionExtentRatio: 0.15,
                                        child:

                                            // isSavingData
                                            //     ? Center(
                                            //         child: Container(
                                            //             height: 100,
                                            //             width: 100,
                                            //             child:
                                            //                 CircularProgressIndicator()))
                                            //     :
                                            DockstatusListWeidget(
                                                dsl.DockStatus == "D"
                                                    ? Color(0xFFB41212)
                                                    : dsl.DockStatus == "Y"
                                                        ? Color(0xFFFCC900)
                                                        : Color(0xFF72B6ED),
                                                dsl.DockStatus == "D"
                                                    ? Color(0xFFF7CECE)
                                                    : dsl.DockStatus == "Y"
                                                        ? Color(0xFFF3E8C6)
                                                        : Color(0xFFC1E1FB),
                                                dsl.DockStatus, //"D",
                                                dsl.DockName, //  "19",
                                                dsl.Dockin, //  "15:25",
                                                dsl.TimeAtDock, //  "29044",
                                                dsl.VTNo, // "EVT2206020018",
                                                dsl.TruckCompany, // "Emirates",
                                                dsl.DRIVERMOBILENO, // "990909090",
                                                useMobileLayout,
                                                modeSelected),
                                        secondaryActions: <Widget>[
                                          IconSlideAction(
                                            caption: 'Update',
                                            color: Colors.blue,
                                            icon: Icons.edit,
                                            onTap: () async {
                                              print("avlDockList.length === " +
                                                  avlDockList.length
                                                      .toString());
                                              if (avlDockList.isNotEmpty) {
                                                await getDocksToUpdate(
                                                    modeSelected == 1
                                                        ? "2"
                                                        : "1");

                                                if (!isSavingData) {
                                                  if (vehicleAndDocksList
                                                      .isEmpty) {
                                                  } else {
                                                    var newDockSelected =
                                                        await showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext
                                                          context) {
                                                        return UpdateDockDialog(
                                                          isMobile:
                                                              useMobileLayout,
                                                          dockname:
                                                              dsl.DockName,
                                                          vtnum: dsl.VTNo,
                                                          vehicleAndDocksList:
                                                              vehicleAndDocksList,
                                                          isAssign: false,
                                                        );
                                                      },
                                                    );
                                                    print("newDockSelected");
                                                    print(newDockSelected);
                                                    if (newDockSelected !=
                                                        null) {
                                                      var submitCheckin =
                                                          await submitForDockUpdate(
                                                        "Update",
                                                        dsl.VTNo,
                                                        modeSelected == 1
                                                            ? "2"
                                                            : "1",
                                                        newDockSelected
                                                            .toString(),
                                                        dsl.DockName,
                                                      );
                                                      print(submitCheckin);
                                                      if (submitCheckin ==
                                                          true) {
                                                        var dlgstatus =
                                                            await showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              CustomDialog(
                                                            title: dsl.VTNo,
                                                            description: "VT# " +
                                                                dsl.VTNo +
                                                                " has been updated to new dock successfully",
                                                            buttonText: "Okay",
                                                            imagepath:
                                                                'assets/images/successchk.gif',
                                                            isMobile:
                                                                useMobileLayout,
                                                          ),
                                                        );
                                                        if (dlgstatus == true) {
                                                          setState(() {
                                                            refreshList();
                                                          }); // To close the form
                                                        }
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) => customAlertMessageDialog(
                                                              title: errMsgText ==
                                                                      ""
                                                                  ? "Error Occured"
                                                                  : "Update Dock Failed",
                                                              description:
                                                                  errMsgText ==
                                                                          ""
                                                                      ? "Error occured while Updating Dock, Please try again after some time"
                                                                      : errMsgText,
                                                              buttonText:
                                                                  "Okay",
                                                              imagepath:
                                                                  'assets/images/warn.gif',
                                                              isMobile:
                                                                  useMobileLayout),
                                                        );
                                                      }
                                                    }
                                                  }
                                                }
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      customAlertMessageDialog(
                                                          title:
                                                              "Update Failed",
                                                          description:
                                                              "No Docks Available at the moment to Assign",
                                                          buttonText: "Okay",
                                                          imagepath:
                                                              'assets/images/warn.gif',
                                                          isMobile:
                                                              useMobileLayout),
                                                );
                                              }
                                            },
                                          ),
                                          IconSlideAction(
                                              caption: 'Push in Queue',
                                              color: Colors.indigo,
                                              icon: Icons.redo,
                                              onTap: () async {
                                                var submitCheckin =
                                                    await submitForPushToQueue(
                                                        "MoveToQueue",
                                                        dsl.VTNo,
                                                        modeSelected == 1
                                                            ? "2"
                                                            : "1");
                                                print(submitCheckin);
                                                if (submitCheckin == true) {
                                                  var dlgstatus =
                                                      await showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        CustomDialog(
                                                      title: dsl.VTNo,
                                                      description: "VT# " +
                                                          dsl.VTNo +
                                                          " has been pushed to queue successfully",
                                                      buttonText: "Okay",
                                                      imagepath:
                                                          'assets/images/successchk.gif',
                                                      isMobile: useMobileLayout,
                                                    ),
                                                  );
                                                  if (dlgstatus == true) {
                                                    setState(() {
                                                      refreshList();
                                                    }); // To close the form
                                                  }
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        customAlertMessageDialog(
                                                            title: errMsgText ==
                                                                    ""
                                                                ? "Error Occured"
                                                                : "Push To Queue Failed",
                                                            description:
                                                                errMsgText == ""
                                                                    ? "Error occured while performing Push To Queue, Please try again after some time"
                                                                    : errMsgText,
                                                            buttonText: "Okay",
                                                            imagepath:
                                                                'assets/images/warn.gif',
                                                            isMobile:
                                                                useMobileLayout),
                                                  );
                                                }
                                              }),
                                        ],
                                      )
                                    : DockstatusListWeidget(
                                        dsl.DockStatus == "D"
                                            ? Color(0xFFB41212)
                                            : dsl.DockStatus == "Y"
                                                ? Color(0xFFFCC900)
                                                : Color(0xFF72B6ED),
                                        dsl.DockStatus == "D"
                                            ? Color(0xFFF7CECE)
                                            : dsl.DockStatus == "Y"
                                                ? Color(0xFFF3E8C6)
                                                : Color(0xFFC1E1FB),
                                        dsl.DockStatus, //"D",
                                        dsl.DockName, //  "19",
                                        dsl.Dockin, //  "15:25",
                                        dsl.TimeAtDock, //  "29044",
                                        dsl.VTNo, // "EVT2206020018",
                                        dsl.TruckCompany, // "Emirates",
                                        dsl.DRIVERMOBILENO, // "990909090",
                                        useMobileLayout,
                                        modeSelected)
                                : Container(),
                          if (dockAvailable)
                            if (avlDockList.length > 0)
                              //  if (  useMobileLayout)
                              if (!isLoading)
                                SizedBox(
                                  width: useMobileLayout
                                      ? MediaQuery.of(context).size.width / 1.01
                                      : MediaQuery.of(context).size.width /
                                          1.02,
                                  child: Card(
                                      color: Color(0xFFCDF7CD),
                                      clipBehavior: Clip.antiAlias,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, left: 10.0),
                                          child: Wrap(
                                              // mainAxisAlignment: MainAxisAlignment.start,
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              alignment: WrapAlignment.start,
                                              children: [
                                                for (var i = 0;
                                                    i < avlDockList.length;
                                                    i++)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0,
                                                            bottom: 8.0),
                                                    child: Container(
                                                      height: useMobileLayout
                                                          ? 48
                                                          : 60, //60,
                                                      width: useMobileLayout
                                                          ? 48
                                                          : 60, //60,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xFF008000),
                                                          shape:
                                                              BoxShape.circle),
                                                      child: Center(
                                                        child: Text(
                                                            avlDockList[i]
                                                                .DockName,
                                                            style: useMobileLayout
                                                                ? mobileCircleLabelFontStyleWhite
                                                                : iPADCircleLabelFontStyleWhite),
                                                      ),
                                                    ),
                                                  ),
                                              ]))),
                                ),
                        ],
                      ),

                    if (modeSelected1 == 1)
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (QueueStatusLive qsl in liveQueueStatusList)
                              buildQueueListWidget(qsl),
                            // QueueListWeidget(
                            //     Colors.grey.shade200,
                            //     qsl.TOKENNO, //"D",
                            //     qsl.SLOTTIME, //  "19",
                            //     qsl.ServiceTime, //  "15:25",
                            //     qsl.VEHICLENO, //  "29044",
                            //     qsl.VEHICLETYPE, // "EVT2206020018",
                            //     qsl.DRIVERNAME, // "Emirates",
                            //     qsl.DRIVERMOBILENO, // "990909090",
                            //     useMobileLayout,
                            //     modeSelected)
                          ]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildQueueListWidget(QueueStatusLive qsl) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.02,
      child: useMobileLayout
          ? Card(
              color: Colors.grey.shade200,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Text('Dock No.'),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Text('VT No.',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                26, //20,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF11249F))),
                                  ),
                                  Text(
                                    qsl.TOKENNO,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                26, //20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     //Text('Dock No.'),
                              //     SizedBox(
                              //       width:
                              //           MediaQuery.of(context).size.width / 2.5,
                              //       child: Text('Dock No.',
                              //           style: TextStyle(
                              //               fontSize: MediaQuery.of(context)
                              //                       .size
                              //                       .width /
                              //                   26, //20,
                              //               fontWeight: FontWeight.normal,
                              //               color: Color(0xFF11249F))),
                              //     ),
                              //     Text(
                              //       qsl.DockStatus,
                              //       style: TextStyle(
                              //           fontSize:
                              //               MediaQuery.of(context).size.width /
                              //                   26, //20,
                              //           fontWeight: FontWeight.bold,
                              //           color: Colors.black),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Text('Slot Timing',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                26, //20,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF11249F))),
                                  ),
                                  Text(
                                    qsl.SLOTTIME,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                26, //20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Text(
                                        'Service Time Est. (Mins.)', //'VT No.',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                26, //20,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF11249F))),
                                  ),
                                  Text(
                                    qsl.ServiceTime, //, //'EVT2206020018',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                26, //22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 1,
                                      width: MediaQuery.of(context).size.width /
                                          1.9,
                                      color: Color(0xFF0461AA),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        print("avlDockList.length === " +
                                            avlDockList.length.toString());

                                        if (avlDockList.isNotEmpty) {
                                          await getDocksToUpdate(
                                              modeSelected == 1 ? "2" : "1");

                                          if (!isSavingData) {
                                            if (vehicleAndDocksList.isEmpty) {
                                            } else {
                                              var newDockSelected =
                                                  await showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return UpdateDockDialog(
                                                    isMobile: useMobileLayout,
                                                    dockname: "",
                                                    vtnum: qsl.TOKENNO,
                                                    vehicleAndDocksList:
                                                        vehicleAndDocksList,
                                                    isAssign: true,
                                                  );
                                                },
                                              );
                                              print("newDockSelected");
                                              print(newDockSelected);
                                              if (newDockSelected != null) {
                                                var submitCheckin =
                                                    await submitForDockUpdate(
                                                  "Update",
                                                  qsl.TOKENNO,
                                                  modeSelected == 1 ? "2" : "1",
                                                  newDockSelected.toString(),
                                                  "",
                                                );
                                                print(submitCheckin);
                                                if (submitCheckin == true) {
                                                  var dlgstatus =
                                                      await showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        CustomDialog(
                                                      title: qsl.TOKENNO,
                                                      description: "Dock " +
                                                          newDockSelected +
                                                          " has been assigned to VT# " +
                                                          qsl.TOKENNO +
                                                          " successfully",
                                                      buttonText: "Okay",
                                                      imagepath:
                                                          'assets/images/successchk.gif',
                                                      isMobile: useMobileLayout,
                                                    ),
                                                  );
                                                  if (dlgstatus == true) {
                                                    setState(() {
                                                      refreshList();
                                                    }); // To close the form
                                                  }
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        customAlertMessageDialog(
                                                            title: errMsgText ==
                                                                    ""
                                                                ? "Error Occured"
                                                                : "Dock Assign Failed",
                                                            description:
                                                                errMsgText == ""
                                                                    ? "Error occured while Assigning Dock, Please try again after some time"
                                                                    : errMsgText,
                                                            buttonText: "Okay",
                                                            imagepath:
                                                                'assets/images/warn.gif',
                                                            isMobile:
                                                                useMobileLayout),
                                                  );
                                                }
                                              }
                                            }
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                customAlertMessageDialog(
                                                    title: "Assign Failed",
                                                    description:
                                                        "No Docks Available at the moment to Assign",
                                                    buttonText: "Okay",
                                                    imagepath:
                                                        'assets/images/warn.gif',
                                                    isMobile: useMobileLayout),
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: useMobileLayout ? 48 : 60, //60,
                                        width: useMobileLayout ? 48 : 60, //60,
                                        decoration: BoxDecoration(
                                            color: Color(0xFF11249F),
                                            shape: BoxShape.circle),
                                        child: Center(
                                            child: Icon(
                                          Icons.assignment,
                                          color: Colors.white,
                                          size: 32,
                                        )),
                                      ),
                                    ),
                                  ]),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Text('Vehicle No.', //'VT No.',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                26, //20,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF11249F))),
                                  ),
                                  //SizedBox(width: 10),
                                  Text(
                                    qsl.VEHICLENO,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                26, //22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Text('Vehicle Type',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                26, //20,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF11249F))),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    child: Text(
                                      qsl.VEHICLETYPE,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              26, //22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Text('Driver Name',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                26, //20,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF11249F))),
                                  ),
                                  Text(
                                    qsl.DRIVERNAME,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                26, //22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Text('Driver' 's Mobile No.',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                26, //20,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF11249F))),
                                  ),
                                  Text(
                                    qsl.DRIVERMOBILENO,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                26, //22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Card(
              color: Colors.grey.shade200,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4.4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Text('Dock No.'),
                                  Text('VT No.',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF11249F))),
                                  Text(
                                    qsl.TOKENNO,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 5.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Slot Timing',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF11249F))),
                                  Text(
                                    qsl.SLOTTIME,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3.25,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Service Time Est.(Mins.)', //'VT No.',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF11249F))),
                                  Text(
                                    qsl.ServiceTime, //'EVT2206020018',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Vehicle No.', //'VT No.',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF11249F))),
                                Text(
                                  qsl.VEHICLENO, //'EVT2206020018',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Container(
                                  height: 1,
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  color: Color(0xFF0461AA),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  print("avlDockList.length === " +
                                      avlDockList.length.toString());

                                  if (avlDockList.isNotEmpty) {
                                    await getDocksToUpdate(
                                        modeSelected == 1 ? "2" : "1");

                                    if (!isSavingData) {
                                      if (vehicleAndDocksList.isEmpty) {
                                      } else {
                                        var newDockSelected = await showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return UpdateDockDialog(
                                              isMobile: useMobileLayout,
                                              dockname: "",
                                              vtnum: qsl.TOKENNO,
                                              vehicleAndDocksList:
                                                  vehicleAndDocksList,
                                              isAssign: true,
                                            );
                                          },
                                        );
                                        print("newDockSelected");
                                        print(newDockSelected);
                                        if (newDockSelected != null) {
                                          var submitCheckin =
                                              await submitForDockUpdate(
                                            "Update",
                                            qsl.TOKENNO,
                                            modeSelected == 1 ? "2" : "1",
                                            newDockSelected.toString(),
                                            "",
                                          );
                                          print(submitCheckin);
                                          if (submitCheckin == true) {
                                            var dlgstatus = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomDialog(
                                                title: qsl.TOKENNO,
                                                description: "Dock " +
                                                    newDockSelected +
                                                    " has been assigned to VT# " +
                                                    qsl.TOKENNO +
                                                    " successfully",
                                                buttonText: "Okay",
                                                imagepath:
                                                    'assets/images/successchk.gif',
                                                isMobile: useMobileLayout,
                                              ),
                                            );
                                            if (dlgstatus == true) {
                                              setState(() {
                                                refreshList();
                                              }); // To close the form
                                            }
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  customAlertMessageDialog(
                                                      title: errMsgText == ""
                                                          ? "Error Occured"
                                                          : "Dock Assign Failed",
                                                      description: errMsgText ==
                                                              ""
                                                          ? "Error occured while Assigning Dock, Please try again after some time"
                                                          : errMsgText,
                                                      buttonText: "Okay",
                                                      imagepath:
                                                          'assets/images/warn.gif',
                                                      isMobile:
                                                          useMobileLayout),
                                            );
                                          }
                                        }
                                      }
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          customAlertMessageDialog(
                                              title: "Assign Failed",
                                              description:
                                                  "No Docks Available at the moment to Assign",
                                              buttonText: "Okay",
                                              imagepath:
                                                  'assets/images/warn.gif',
                                              isMobile: useMobileLayout),
                                    );
                                  }
                                },
                                child: Container(
                                  height: useMobileLayout ? 48 : 60, //60,
                                  width: useMobileLayout ? 48 : 60, //60,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF11249F),
                                      shape: BoxShape.circle),
                                  child: Center(
                                      child: Icon(
                                    Icons.assignment,
                                    color: Colors.white,
                                    size: 32,
                                  )),
                                ),
                              ),
                            ]),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 8.0),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.43,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Text('Dock No.'),
                                    Text('Vehicle Type',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF11249F))),
                                    Text(
                                      qsl.VEHICLETYPE,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Driver Name',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF11249F))),
                                    Text(
                                      qsl.DRIVERNAME,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 4.15,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Driver Mobile No.', //'VT No.',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF11249F))),
                                    Text(
                                      qsl.DRIVERMOBILENO, //'EVT2206020018',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // buildAssignDocksPopUpIpad(dockname, vtnum) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height / 5, // height: 250,
  //     width: MediaQuery.of(context).size.width / 6,
  //     child: AlertDialog(
  //       scrollable: true,
  //       title: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           SizedBox(
  //             width: MediaQuery.of(context).size.width / 1.5,
  //             child: Text('Update dock for VT# ' + vtnum,
  //                 style: TextStyle(
  //                   fontSize: 24,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color(0xFF11249F),
  //                 )),
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Container(
  //               height: 48,
  //               width: 48,
  //               decoration: BoxDecoration(
  //                   border: Border.all(
  //                     width: 2,
  //                     color: Colors.white,
  //                   ),
  //                   color: Colors.red,
  //                   shape: BoxShape.circle),
  //               child: Icon(
  //                 Icons.close,
  //                 color: Colors.white,
  //                 size: 40,
  //               ),
  //             ),
  //           ),
  //           // ),
  //         ],
  //       ), // To display the title it is optional
  //       content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 Text(
  //                   "Dock Currently Assigned",
  //                   style: TextStyle(
  //                     fontSize: 22,
  //                     fontWeight: FontWeight.bold,
  //                     color: Color(0xFF11249F),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: useMobileLayout ? 15 : 30,
  //                 ),
  //                 Container(
  //                   height: useMobileLayout ? 40 : 70,
  //                   width: useMobileLayout ? 40 : 70,
  //                   decoration: BoxDecoration(
  //                     color: Colors.orange.shade400,
  //                     borderRadius: BorderRadius.all(Radius.circular(5)),
  //                     border: Border.all(
  //                       width: 1,
  //                       color: Colors.orange, //Colors.blue,
  //                     ),
  //                   ),
  //                   child: Center(
  //                     child: Text(
  //                       dockname,
  //                       style: TextStyle(
  //                         fontSize: 26,
  //                         fontWeight: FontWeight.bold,
  //                         color: Color(0xFF11249F),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
  //               child: Container(
  //                 height: 1,
  //                 width: MediaQuery.of(context).size.width / 1.6,
  //                 color: Color(0xFF0461AA),
  //               ),
  //             ),
  //             Text('Available Docks',
  //                 style: TextStyle(
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color(0xFF11249F),
  //                 )),
  //             // buildAvailableDocksMain(),
  //             SizedBox(height: useMobileLayout ? 10 : 30),
  //             Container(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: List.generate(vehicleAndDocksList.length, (index) {
  //                   return buildAvilDocksChildren(
  //                       vehicleAndDocksList[index].strEmptySlots,
  //                       vehicleAndDocksList[index].TruckTypeIds);
  //                 }),
  //               ),
  //             ),
  //           ]),
  //       // Message which will be pop up on the screen
  //       // Action widget which will provide the user to acknowledge the choice
  //       actions: [
  //         Padding(
  //           padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
  //           child: ElevatedButton(
  //             //textColor: Colors.black,
  //             onPressed: () {},
  //             style: ElevatedButton.styleFrom(
  //               elevation: 4.0,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10.0)), //
  //               padding: const EdgeInsets.all(0.0),
  //             ),
  //             child: Container(
  //               height: 50,
  //               width: 150,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 gradient: LinearGradient(
  //                   begin: Alignment.topRight,
  //                   end: Alignment.bottomLeft,
  //                   colors: [
  //                     Color(0xFF1220BC),
  //                     Color(0xFF3540E8),
  //                   ],
  //                 ),
  //               ),
  //               child: Padding(
  //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
  //                 child: Align(
  //                   alignment: Alignment.center,
  //                   child: Text(
  //                     'Update',
  //                     style: TextStyle(
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.normal,
  //                         color: Colors.white),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  refreshList() async {
    if (modeSelected1 == 0) // at dock selected
    {
      if (modeSelected == 0) //export
      {
        print("export at dock");
        getDockStatusInfo("1");
      } else // import
      {
        print("import at dock");
        getDockStatusInfo("2");
      }
    } else // queue selected
    {
      if (modeSelected == 1) //export
      {
        print("export queue");
        await getDockQueueInfo("1");
      } else // import
      {
        print("import queue");
        await getDockQueueInfo("2");
      }
    }
  }

  getDockStatusInfo(modeType) async {
    if (isLoading) return;

    liveDockStatusList = [];
    liveDockStatusListBind = [];

    setState(() {
      isLoading = true;
      selectAll = true;
      dockOccupied = true;
      vehicleEnroute = true;
      dockAvailable = true;
      dockUnavailable = true;
      walkIn = true;
      pickup = true;
      dropoff = true;
    });

    var queryParams = {
      "OperationType": modeType.toString(), // "",
      "strGHAId":
          selectedTerminalID.toString(), // loggedinUser.OrganizationBranchId,
    };

    await Global()
        .postData(
      Settings.SERVICES['LiveDockStatus'],
      queryParams,
    )
        .then((response) {
      // print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      liveDockStatusList = resp
          .map<DockStatusLive>((json) => DockStatusLive.fromJson(json))
          .toList();

      liveDockStatusListBind = liveDockStatusList;

      print("length liveDockStatusList = " +
          liveDockStatusList.length.toString());

      print("length liveDockStatusListBind = " +
          liveDockStatusListBind.length.toString());
      if (liveDockStatusList.isNotEmpty) runFilterForAvlDocks();
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

  getDocksToUpdate(modeType) async {
    if (isSavingData) return;

    // liveDockStatusListBind = [];

    setState(() {
      isSavingData = true;
    });

    var queryParams = {
      "OperationType": modeType.toString(), // "",
      "strGHAId":
          selectedTerminalID.toString(), // loggedinUser.OrganizationBranchId,
    };

    await Global()
        .postData(
      Settings.SERVICES['LiveQueuedockStatus'],
      queryParams,
    )
        .then((response) {
      // print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      vehicleAndDocksList = resp
          .map<VehicleAndDocks>((json) => VehicleAndDocks.fromJson(json))
          .toList();

      print("length vehicleAndDocksList = " +
          vehicleAndDocksList.length.toString());

      setState(() {
        isSavingData = false;
      });
    }).catchError((onError) {
      setState(() {
        isSavingData = false;
      });
      print(onError);
    });
  }

  getQueueDockStatusInfo(modeType) {
    // if (isLoading) return;

    // liveDockStatusList = [];
    // liveDockStatusListBind = [];

    // var queryParams = {
    //   "OperationType": modeType.toString(), // "",
    //   "strGHAId":
    //       selectedTerminalID.toString(), // loggedinUser.OrganizationBranchId,
    // };

    // await Global()
    //     .postData(
    //   Settings.SERVICES['LiveQueueStatus'],
    //   queryParams,
    // )
    //     .then((response) {
    //   // print("data received ");
    //   print(json.decode(response.body)['d']);

    // var msg = json.decode(response.body)['d'];
    // var resp = json.decode(msg).cast<Map<String, dynamic>>();

    // liveDockStatusList = resp
    //     .map<DockStatusLive>((json) => DockStatusLive.fromJson(json))
    //     .toList();

    // liveDockStatusListBind = liveDockStatusList;

    // print("length liveDockStatusList = " +
    //     liveDockStatusList.length.toString());

    // print("length liveDockStatusListBind = " +
    //     liveDockStatusListBind.length.toString());
    // if (liveDockStatusList.isNotEmpty) runFilterForAvlDocks();
    //   setState(() {
    //     isLoading = false;
    //   });
    // }).catchError((onError) {
    //   // setState(() {
    //   //   isLoading = false;
    //   // });
    //   print(onError);
    // });
  }

  Future<bool> submitForPushToQueue(operation, vehToken, operationType) async {
    try {
      // return true;
      errMsgText = "";
      String responseTextUpdated = "";
      bool isValid = false;

      setState(() {
        isSavingData = true;
      });

      var queryParams = {
        "OperationType": operationType.toString(),
        "TokenNo": vehToken,
        "UpdateType": operation,
        "AssignedDocks": "",
        "comment": "",
        "UnAssignedDocks": "",
      };
      await Global()
          .postData(
        Settings.SERVICES['UpdateDocks'],
        queryParams,
      )
          .then((response) {
        print("data received ");
        print(json.decode(response.body)['d']);
        if (json.decode(response.body)['d'] == null) {
          isValid = true;
        } else {
          if (json.decode(response.body)['d'] == "") {
            isValid = true;
          } else {
            var responseText = json.decode(response.body)['d'].toString();

            if (responseText.toLowerCase().contains("errormsg")) {
              responseTextUpdated =
                  responseText.toString().replaceAll("ErrorMSG", "");
              responseTextUpdated =
                  responseTextUpdated.toString().replaceAll(":", "");
              responseTextUpdated =
                  responseTextUpdated.toString().replaceAll("\"", "");
              responseTextUpdated =
                  responseTextUpdated.toString().replaceAll("{", "");
              responseTextUpdated =
                  responseTextUpdated.toString().replaceAll("}", "");
              print(responseTextUpdated.toString());
            }
            // print(responseText.toString().replaceAll("ErrorMSG", ""));
            // print(responseText.toString().replaceAll(":", ""));
            // print(responseText.toString().replaceAll("\"", ""));

            isValid = false;
          }
        }

        setState(() {
          isSavingData = false;
          if (responseTextUpdated != "") errMsgText = responseTextUpdated;
        });
      }).catchError((onError) {
        setState(() {
          isSavingData = false;
        });
        print(onError);
      });
      return isValid;
    } catch (Exc) {
      print(Exc);
      return false;
    }
  }

  Future<bool> submitForDockUpdate(
      operation, vehToken, operationType, newDockName, oldDockName) async {
    try {
      // return true;
      errMsgText = "";
      String responseTextUpdated = "";
      bool isValid = false;

      setState(() {
        isSavingData = true;
      });

      var queryParams = {
        "OperationType": operationType.toString(),
        "TokenNo": vehToken,
        "UpdateType": operation,
        "AssignedDocks": oldDockName,
        "comment": "",
        "UnAssignedDocks": newDockName,
      };
      await Global()
          .postData(
        Settings.SERVICES['UpdateDocks'],
        queryParams,
      ) //successMsg\
          .then((response) {
        print("data received ");
        print(json.decode(response.body)['d']);
        if (json.decode(response.body)['d'] == null) {
          isValid = true;
        } else {
          if (json.decode(response.body)['d'] == "") {
            isValid = true;
          } else {
            var responseText = json.decode(response.body)['d'].toString();
            if (responseText.toLowerCase().contains("successmsg"))
              isValid = true;
            else {
              if (responseText.toLowerCase().contains("errormsg")) {
                responseTextUpdated =
                    responseText.toString().replaceAll("ErrorMSG", "");
                responseTextUpdated =
                    responseTextUpdated.toString().replaceAll(":", "");
                responseTextUpdated =
                    responseTextUpdated.toString().replaceAll("\"", "");
                responseTextUpdated =
                    responseTextUpdated.toString().replaceAll("{", "");
                responseTextUpdated =
                    responseTextUpdated.toString().replaceAll("}", "");
                print(responseTextUpdated.toString());
              }
              // print(responseText.toString().replaceAll("ErrorMSG", ""));
              // print(responseText.toString().replaceAll(":", ""));
              // print(responseText.toString().replaceAll("\"", ""));

              isValid = false;
            }
          }
        }

        setState(() {
          isSavingData = false;
          if (responseTextUpdated != "") errMsgText = responseTextUpdated;
        });
      }).catchError((onError) {
        setState(() {
          isSavingData = false;
        });
        print(onError);
      });
      return isValid;
    } catch (Exc) {
      print(Exc);
      return false;
    }
  }

  getDockQueueInfo(modeType) async {
    //return;

    if (isLoading) return;

    liveQueueStatusList = [];

    setState(() {
      isLoading = true;
      // selectAll = true;
      // dockOccupied = true;
      // vehicleEnroute = true;
      // dockAvailable = true;
      // dockUnavailable = true;
      // walkIn = true;
      // pickup = true;
      // dropoff = true;
    });

    var queryParams = {
      "OperationType": modeType.toString(),
      "strGHAId":
          selectedTerminalID.toString(), // loggedinUser.OrganizationBranchId,
    };
    await Global()
        .postData(
      Settings.SERVICES['LiveQueueStatus'],
      queryParams,
    )
        .then((response) {
      // print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      liveQueueStatusList = resp
          .map<QueueStatusLive>((json) => QueueStatusLive.fromJson(json))
          .toList();

      print("length liveQueueStatusList = " +
          liveQueueStatusList.length.toString());

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

  void runFilter(String enteredKeyword) {
    //ALL
    // D - occupied - D for export , P for import
    //A - available
    //B- unavailable
    //W- Walk in
    // Y -  enroute - - D for export , P for import
    // else walkin
    print("enteredKeyword == " + enteredKeyword.toLowerCase());
    print("modeselected 1 == " + modeSelected1.toString());
    print("modeselected == " + modeSelected.toString());

    if (enteredKeyword == "ALL") {
      setState(() {
        liveDockStatusListBind = liveDockStatusList;
      });
    } else {
      List<DockStatusLive> results = [];
      results.addAll(liveDockStatusList);

      print("results.length == " + results.length.toString());

      results.retainWhere((DockStatusLive element) =>
          element.DockStatus.toLowerCase()
              .contains(enteredKeyword.toLowerCase()));

      print("results.length after filter == " + results.length.toString());

      setState(() {
        liveDockStatusListBind = results;
      });
    }
  }

  void runFilterForAvlDocks() {
    //ALL
    // D - occupied - D for export , P for import
    //A - available
    //B- unavailable
    // Y -  enroute - - D for export , P for import
    // else walkin

    print("modeselected 1 == " + modeSelected1.toString());
    print("modeselected == " + modeSelected.toString());

    List<DockStatusLive> results = [];
    results.addAll(liveDockStatusList);

    print("results.length == " + results.length.toString());

    results.retainWhere((DockStatusLive element) =>
        element.DockStatus.toLowerCase().contains("a"));

    print("results.length after filter == " + results.length.toString());

    setState(() {
      avlDockList = results;
    });
  }
}

class UpdateDockDialog extends StatefulWidget {
  final bool isMobile;
  final bool isAssign;
  final String vtnum;
  final String dockname;
  final List<VehicleAndDocks> vehicleAndDocksList;

  UpdateDockDialog(
      {Key? key,
      required this.isMobile,
      required this.isAssign,
      required this.vtnum,
      required this.dockname,
      required this.vehicleAndDocksList})
      : super(key: key);

  @override
  State<UpdateDockDialog> createState() => _UpdateDockDialogState();
}

class _UpdateDockDialogState extends State<UpdateDockDialog> {
  String selectedSlot = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        scrollable: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.isMobile
                ? SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(widget.isAssign ? 'Assign Dock' : 'Update Dock',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11249F),
                        )),
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text(
                        widget.isAssign
                            ? 'Assign dock for VT# ' + widget.vtnum
                            : 'Update dock for VT# ' + widget.vtnum,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11249F),
                        )),
                  ),

            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.white,
                    ),
                    color: Colors.red,
                    shape: BoxShape.circle),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            // ),
          ],
        ), // To display the title it is optional
        content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isMobile)
                Text('VT # : ' + widget.vtnum,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF11249F),
                    )),
              if (!widget.isAssign)
                Row(
                  children: [
                    Text(
                      "Dock Currently Assigned",
                      style: TextStyle(
                        fontSize: widget.isMobile ? 16 : 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF11249F),
                      ),
                    ),
                    SizedBox(
                      width: widget.isMobile ? 15 : 30,
                    ),
                    Container(
                      height: widget.isMobile ? 40 : 70,
                      width: widget.isMobile ? 40 : 70,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade400,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                          width: 1,
                          color: Colors.orange, //Colors.blue,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.dockname,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF11249F),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.6,
                  color: Color(0xFF0461AA),
                ),
              ),
              if (widget.isMobile)
                if (widget.isMobile)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Available Docks',
                          style: TextStyle(
                            fontSize: widget.isMobile ? 16 : 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF11249F),
                          )),
                      SizedBox(
                        width: widget.isMobile ? 15 : 20,
                      ),
                      Text('(Click on dock to select)',
                          style: TextStyle(
                            fontSize: widget.isMobile ? 16 : 22,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF11249F),
                          )),
                    ],
                  ),

              if (!widget.isMobile)
                Row(
                  children: [
                    Text('Available Docks',
                        style: TextStyle(
                          fontSize: widget.isMobile ? 16 : 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11249F),
                        )),
                    SizedBox(
                      width: widget.isMobile ? 15 : 20,
                    ),
                    Text('(Click on dock to select)',
                        style: TextStyle(
                          fontSize: widget.isMobile ? 16 : 22,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF11249F),
                        )),
                  ],
                ),
              // Text('Available Docks (Click on dock to select)',
              //     style: TextStyle(
              //       fontSize: 22,
              //       fontWeight: FontWeight.bold,
              //       color: Color(0xFF11249F),
              //     )),

              // buildAvailableDocksMain(),
              SizedBox(height: widget.isMobile ? 10 : 30),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      List.generate(widget.vehicleAndDocksList.length, (index) {
                    return buildAvilDocksChildren(
                        widget.vehicleAndDocksList[index].strEmptySlots,
                        widget.vehicleAndDocksList[index].TruckTypeIds);
                  }),
                ),
              ),
            ]),
        // Message which will be pop up on the screen
        // Action widget which will provide the user to acknowledge the choice
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
            child: ElevatedButton(
              //textColor: Colors.black,
              onPressed: () {
                Navigator.of(context).pop(selectedSlot);
              },
              style: ElevatedButton.styleFrom(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)), //
                padding: const EdgeInsets.all(0.0),
              ),
              child: Container(
                height: 50,
                width: 150,
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
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.isAssign ? 'Assign' : 'Update',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildAvilDocksChildren(String strEmptyslots, String strTruckTypeIds) {
    List<String> docks = [];
    docks = strEmptyslots.split(",");

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isMobile)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.8,
                child: Container(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    children: List.generate(docks.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: Container(
                          height: widget.isMobile
                              ? selectedSlot == docks[index].toString().trim()
                                  ? 58
                                  : 48
                              : selectedSlot == docks[index].toString().trim()
                                  ? 70
                                  : 60, //60,
                          width: widget.isMobile
                              ? selectedSlot == docks[index].toString().trim()
                                  ? 58
                                  : 48
                              : selectedSlot == docks[index].toString().trim()
                                  ? 70
                                  : 60, //60,
                          decoration: BoxDecoration(
                              color:
                                  selectedSlot == docks[index].toString().trim()
                                      ? Colors.orange
                                      : Color(0xFF008000),
                              shape: BoxShape.circle),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSlot = docks[index].toString().trim();
                                  //  abc = docks[index].toString().trim();
                                  print("selectedSlot  ==" +
                                      selectedSlot.toString() +
                                      "a");
                                  print("abc  ==" +
                                      selectedSlot.toString() +
                                      "a");
                                });

                                //  print(docks[index].toString().trim());
                                // print("selectedSlot  == " +
                                //       selectedSlot.toString());
                                //   print("abc  == " + selectedSlot.toString());
                              },
                              child: Text(docks[index].toString().trim(),
                                  style: widget.isMobile
                                      ? mobileCircleLabelFontStyleWhite
                                      : iPADCircleLabelFontStyleWhite),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              buildVehicleList(strTruckTypeIds),
            ],
          ),
        if (!widget.isMobile)
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 4.5,
                child: Container(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    children: List.generate(docks.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: Container(
                          height: widget.isMobile
                              ? selectedSlot == docks[index].toString().trim()
                                  ? 58
                                  : 48
                              : selectedSlot == docks[index].toString().trim()
                                  ? 70
                                  : 60, //60,
                          width: widget.isMobile
                              ? selectedSlot == docks[index].toString().trim()
                                  ? 58
                                  : 48
                              : selectedSlot == docks[index].toString().trim()
                                  ? 70
                                  : 60, //60,
                          decoration: BoxDecoration(
                              color:
                                  selectedSlot == docks[index].toString().trim()
                                      ? Colors.orange
                                      : Color(0xFF008000),
                              shape: BoxShape.circle),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSlot = docks[index].toString().trim();
                                  //  abc = docks[index].toString().trim();
                                  print("selectedSlot  ==" +
                                      selectedSlot.toString() +
                                      "a");
                                  print("abc  ==" +
                                      selectedSlot.toString() +
                                      "a");
                                });

                                //  print(docks[index].toString().trim());
                                // print("selectedSlot  == " +
                                //       selectedSlot.toString());
                                //   print("abc  == " + selectedSlot.toString());
                              },
                              child: Text(docks[index].toString().trim(),
                                  style: widget.isMobile
                                      ? mobileCircleLabelFontStyleWhite
                                      : iPADCircleLabelFontStyleWhite),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              buildVehicleList(strTruckTypeIds),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 1,
            width: MediaQuery.of(context).size.width / 1.6,
            color: Color(0xFF0461AA),
          ),
        ),
      ],
    );
  }

  buildVehicleList(String strTruckTypeIds) {
    List<String> docks = [];
    docks = strTruckTypeIds.split(",");
    return SizedBox(
      width: widget.isMobile
          ? MediaQuery.of(context).size.width / 1.5
          : MediaQuery.of(context).size.width / 2.8,
      child: Container(
        child: Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: List.generate(vehicletypesList.length, (index) {
            if (docks
                .contains(vehicletypesList[index].TruckTypeId.toString())) {
              return Wrap(
                // mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //   (docks
                  // .contains(vehicletypesList[index].TruckTypeId.toString()))
                  // ?  Icon(Icons.check) : Icon(Icons.close),
                  Icon(
                    Icons.task_alt,
                    color: Colors.green.shade500,
                    size: widget.isMobile ? 28 : 32,
                  ),
                  SizedBox(
                    width: widget.isMobile ? 10 : 15,
                  ),
                  Text(vehicletypesList[index].TruckTypeName.toString(),
                      style: widget.isMobile
                          ? mobileTextFontStyleNormalBlue
                          : iPadTextFontStyleNormalBlue),
                  SizedBox(
                    width: widget.isMobile ? 10 : 30,
                  ),
                ],
              );
            } else
              return Text("");
          }),
        ),
      ),
    );
  }
}

class DockTileContainer extends StatelessWidget {
  final bool isMobile;
  final Color colorBorder;
  final Color colorBackground;
  final Color colorText;
  final String lblText1;
  final String lblText2;

  const DockTileContainer(
      {Key? key,
      required this.isMobile,
      required this.colorBorder,
      required this.colorBackground,
      required this.colorText,
      required this.lblText1,
      required this.lblText2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
      child: Container(
        height: isMobile ? 70 : 100,
        width: isMobile ? 70 : 100,
        decoration: BoxDecoration(
          color: colorBackground, //Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: 1,
            color: colorBorder, //Colors.blue,
          ),
        ),
        child: (lblText2.toLowerCase().contains("airport"))
            ? Stack(children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    //"P",
                    lblText1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF11249F),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    lblText2, //Pick-up from Airport",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 16,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF11249F),
                    ),
                  ),
                ),
              ])
            : (lblText2.toLowerCase().contains("unavailable"))
                ? Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            isMobile
                                ? lblText1 + " " + "not Available" // "All",
                                : lblText1 + " " + "Unavailable",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isMobile ? 14 : 16,
                              fontWeight: FontWeight.normal,
                              color: colorText, //Color(0xFF11249F),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            lblText1 + " " + lblText2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isMobile ? 14 : 16,
                              fontWeight: FontWeight.normal,
                              color: colorText, //Color(0xFF11249F),
                            ),
                          ),
                        ),

                        //             Align(
                        //               alignment:isMobile ? Alignment.topCenter : Alignment.center,
                        //               child: Text(
                        //                lblText1,// "Show",
                        //                 textAlign: TextAlign.center,
                        //                 style: TextStyle(
                        //                   fontSize:  isMobile ? 14:18,
                        //                   fontWeight: FontWeight.bold,
                        //                   color: colorText, //Color(0xFF11249F),
                        //                 ),
                        //               ),
                        //             ),
                        //  //if (isMobile)     SizedBox(height: 20),
                        //               //    SizedBox(height: 20),
                        //             Align(
                        //               alignment: Alignment.bottomCenter,
                        //               child: Text(
                        //                   lblText2,// "All",
                        //                 textAlign: TextAlign.center,
                        //                 style: TextStyle(
                        //                   fontSize:isMobile ? 14: 18,
                        //                   fontWeight: FontWeight.normal,
                        //                   color:  colorText,//Color(0xFF11249F),
                        //                 ),
                        //               ),
                        //             ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class DockstatusListWeidget extends StatelessWidget {
  const DockstatusListWeidget(
      this.circleColor,
      this.cardColor,
      this.circleText,
      this.lblText1,
      this.lblText2,
      this.lblText3,
      this.lblText4,
      this.lblText5,
      this.lblText6,
      this.isMobile,
      this.modeSelected);

  final Color circleColor;
  final Color cardColor;
  final String circleText;
  final String lblText1;
  final String lblText2;
  final String lblText3;
  final String lblText4;
  final String lblText5;
  final String lblText6;
  final bool isMobile;
  final int modeSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.02,
      child: isMobile
          ? Card(
              color: cardColor,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  children: [
                    ListTile(
                      trailing: Container(
                        height: isMobile ? 48 : 56, //60,
                        width: isMobile ? 48 : 56, //60,
                        decoration: BoxDecoration(
                            color: circleColor, shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            (circleText == "D" || circleText == "Y")
                                ? modeSelected == 1
                                    ? "P"
                                    : "D"
                                : circleText,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width / 17, //26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Text('Dock No.'),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 4.5,
                                    child: Text('Dock No.',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                26, //20,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF11249F))),
                                  ),
                                  Text(
                                    lblText1,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                26, //20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: Text('Check-in',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                26, //20,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF11249F))),
                                  ),
                                  Text(
                                    lblText2,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                26, //22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     SizedBox(
                              //       width:
                              //           MediaQuery.of(context).size.width / 2,
                              //       child: Text('Yard Check-in',
                              //           style: TextStyle(
                              //               fontSize: MediaQuery.of(context)
                              //                       .size
                              //                       .width /
                              //                   22, //20,
                              //               fontWeight: FontWeight.bold,
                              //               color: Color(0xFF11249F))),
                              //     ),
                              //     Text(
                              //       lblText2,
                              //       style: TextStyle(
                              //           fontSize:
                              //               MediaQuery.of(context).size.width /
                              //                   22, //22,
                              //           fontWeight: FontWeight.bold,
                              //           color: Colors.black),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(height: 5),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: Text('VT', //'VT No.',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                26, //20,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF11249F))),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    lblText4,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                26, //22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: Text('Trucking Company', //'VT No.',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                26, //20,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF11249F))),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    lblText5,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                26, //22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Text(
                                        'Time at Dock (Mins.)', //'VT No.',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                26, //20,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF11249F))),
                                  ),
                                  Text(
                                    lblText3, //'EVT2206020018',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                26, //22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Text('Driver' 's Mobile No.',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                26, //20,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF11249F))),
                                  ),
                                  Text(
                                    lblText6,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                26, //22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     height: 1,
                    //     width: MediaQuery.of(context).size.width - 80,
                    //     color: Color(0xFF0461AA),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 18.0),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           //Text('Dock No.'),
                    //           SizedBox(
                    //             width: MediaQuery.of(context).size.width / 3.5,
                    //             child: Text('VT No.',
                    //                 style: TextStyle(
                    //                     fontSize:
                    //                         MediaQuery.of(context).size.width /
                    //                             24, //20,
                    //                     fontWeight: FontWeight.bold,
                    //                     color: Color(0xFF11249F))),
                    //           ),
                    //           Text(
                    //             lblText4,
                    //             style: TextStyle(
                    //                 fontSize:
                    //                     MediaQuery.of(context).size.width /
                    //                         22, //20,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.black),
                    //           ),
                    //         ],
                    //       ),
                    //       SizedBox(height: 5),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           SizedBox(
                    //             width: MediaQuery.of(context).size.width / 3.5,
                    //             child: Text('Airline',
                    //                 style: TextStyle(
                    //                     fontSize:
                    //                         MediaQuery.of(context).size.width /
                    //                             22, //20,
                    //                     fontWeight: FontWeight.bold,
                    //                     color: Color(0xFF11249F))),
                    //           ),
                    //           Text(
                    //             lblText5,
                    //             style: TextStyle(
                    //                 fontSize:
                    //                     MediaQuery.of(context).size.width /
                    //                         22, //22,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.black),
                    //           ),
                    //         ],
                    //       ),
                    //       SizedBox(height: 5),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           SizedBox(
                    //             width: MediaQuery.of(context).size.width / 3.5,
                    //             child: Text('Driver' 's Mobile No.',
                    //                 style: TextStyle(
                    //                     fontSize:
                    //                         MediaQuery.of(context).size.width /
                    //                             22, //20,
                    //                     fontWeight: FontWeight.bold,
                    //                     color: Color(0xFF11249F))),
                    //           ),
                    //           Text(
                    //             lblText6, //'EVT2206020018',
                    //             style: TextStyle(
                    //                 fontSize:
                    //                     MediaQuery.of(context).size.width /
                    //                         22, //22,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.black),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          : Card(
              color: cardColor,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 8.0, right: 8.0),
                child: Column(
                  children: [
                    ListTile(
                      // trailing: Container(
                      //   height: 60,
                      //   width: 60,
                      //   decoration: BoxDecoration(
                      //       color: circleColor, shape: BoxShape.circle),
                      //   child: Center(
                      //     child: Text(
                      //       (circleText == "D" || circleText == "Y")
                      //           ? modeSelected == 1
                      //               ? "P"
                      //               : "D"
                      //           : circleText,
                      //       style: TextStyle(
                      //         fontSize: 26,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: circleColor, shape: BoxShape.circle),
                            child: Center(
                              child: Text(
                                (circleText == "D" || circleText == "Y")
                                    ? modeSelected == 1
                                        ? "P"
                                        : "D"
                                    : circleText,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 4.3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //Text('Dock No.'),
                                        Text('Dock No.',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF11249F))),
                                        Text(
                                          lblText1,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Yard Check-in',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF11249F))),
                                        Text(
                                          lblText2,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Time at Dock (Mins.)', //'VT No.',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF11249F))),
                                      Text(
                                        lblText3, //'EVT2206020018',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 1,
                                  width:
                                      MediaQuery.of(context).size.width - 180,
                                  color: Color(0xFF0461AA),
                                ),
                              ),
                              Wrap(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        4.3, // hard coding child width
                                    child: Text(
                                      'VT No.',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF11249F)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        3, // hard coding child width
                                    child: Text(
                                      'Trucking Company',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF11249F)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        4, // hard coding child width
                                    child: Text(
                                      'Driver' 's Mobile No.',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF11249F)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        4.3, // // hard coding child width
                                    child: Text(
                                      lblText4,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        3, // hard coding child width
                                    child: Text(
                                      lblText5,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        4, // hard coding child width
                                    child: Text(
                                      lblText6,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     height: 1,
                    //     width: MediaQuery.of(context).size.width - 80,
                    //     color: Color(0xFF0461AA),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       top: 5.0, bottom: 8.0, left: 18.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Column(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Wrap(
                    //             children: [
                    //               SizedBox(
                    //                 width: MediaQuery.of(context).size.width /
                    //                     4.3, // hard coding child width
                    //                 child: Text(
                    //                   'VT No.',
                    //                   style: TextStyle(
                    //                       fontSize: 20,
                    //                       fontWeight: FontWeight.bold,
                    //                       color: Color(0xFF11249F)),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 width: MediaQuery.of(context).size.width /
                    //                     3, // hard coding child width
                    //                 child: Text(
                    //                   'Trucking Company',
                    //                   style: TextStyle(
                    //                       fontSize: 20,
                    //                       fontWeight: FontWeight.bold,
                    //                       color: Color(0xFF11249F)),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 width: MediaQuery.of(context).size.width /
                    //                     4, // hard coding child width
                    //                 child: Text(
                    //                   'Driver' 's Mobile No.',
                    //                   style: TextStyle(
                    //                       fontSize: 20,
                    //                       fontWeight: FontWeight.bold,
                    //                       color: Color(0xFF11249F)),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               SizedBox(
                    //                 width: MediaQuery.of(context).size.width /
                    //                     4.3, // // hard coding child width
                    //                 child: Text(
                    //                   lblText4,
                    //                   style: TextStyle(
                    //                       fontSize: 20,
                    //                       fontWeight: FontWeight.bold,
                    //                       color: Colors.black),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 width: MediaQuery.of(context).size.width /
                    //                     3, // hard coding child width
                    //                 child: Text(
                    //                   lblText5,
                    //                   style: TextStyle(
                    //                       fontSize: 20,
                    //                       fontWeight: FontWeight.bold,
                    //                       color: Colors.black),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 width: MediaQuery.of(context).size.width /
                    //                     4, // hard coding child width
                    //                 child: Text(
                    //                   lblText6,
                    //                   style: TextStyle(
                    //                       fontSize: 20,
                    //                       fontWeight: FontWeight.bold,
                    //                       color: Colors.black),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}

// class QueueListWeidget extends StatefulWidget {
//   const QueueListWeidget(
//       //this.circleColor,
//       this.cardColor,
//       //  this.circleText,
//       this.lblText1,
//       this.lblText2,
//       this.lblText3,
//       this.lblText4,
//       this.lblText5,
//       this.lblText6,
//       this.lblText7,
//       this.isMobile,
//       this.modeSelected);

//   // final Color circleColor;
//   final Color cardColor;
//   // final String circleText;
//   final String lblText1;
//   final String lblText2;
//   final String lblText3;
//   final String lblText4;
//   final String lblText5;
//   final String lblText6;
//   final String lblText7;
//   final bool isMobile;
//   final int modeSelected;

//   @override
//   _QueueListWeidgetState createState() => _QueueListWeidgetState();
// }

// class _QueueListWeidgetState extends State<QueueListWeidget> {
//   String errMsgText = "", selectedSlot = "";
//   bool useMobileLayout = false, isLoading = false, isSavingData = false;
//   List<VehicleAndDocks> vehicleAndDocksList = [];
//   @override
//   Widget build(BuildContext context) {}

//   getDocksToUpdate(modeType) async {
//     if (isSavingData) return;

//     // liveDockStatusListBind = [];

//     setState(() {
//       isSavingData = true;
//     });

//     var queryParams = {
//       "OperationType": modeType.toString(), // "",
//       "strGHAId":
//           selectedTerminalID.toString(), // loggedinUser.OrganizationBranchId,
//     };

//     await Global()
//         .postData(
//       Settings.SERVICES['LiveQueuedockStatus'],
//       queryParams,
//     )
//         .then((response) {
//       // print("data received ");
//       print(json.decode(response.body)['d']);

//       var msg = json.decode(response.body)['d'];
//       var resp = json.decode(msg).cast<Map<String, dynamic>>();

//       vehicleAndDocksList = resp
//           .map<VehicleAndDocks>((json) => VehicleAndDocks.fromJson(json))
//           .toList();

//       print("length vehicleAndDocksList = " +
//           vehicleAndDocksList.length.toString());

//       setState(() {
//         isSavingData = false;
//       });
//     }).catchError((onError) {
//       setState(() {
//         isSavingData = false;
//       });
//       print(onError);
//     });
//   }

//   Future<bool> submitForDockUpdate(
//       operation, vehToken, operationType, newDockName, oldDockName) async {
//     try {
//       // return true;
//       errMsgText = "";
//       String responseTextUpdated = "";
//       bool isValid = false;

//       setState(() {
//         isSavingData = true;
//       });

//       var queryParams = {
//         "OperationType": operationType.toString(),
//         "TokenNo": vehToken,
//         "UpdateType": operation,
//         "AssignedDocks": oldDockName,
//         "comment": "",
//         "UnAssignedDocks": newDockName,
//       };
//       await Global()
//           .postData(
//         Settings.SERVICES['UpdateDocks'],
//         queryParams,
//       )
//           .then((response) {
//         print("data received ");
//         print(json.decode(response.body)['d']);
//         if (json.decode(response.body)['d'] == null) {
//           isValid = true;
//         } else {
//           if (json.decode(response.body)['d'] == "") {
//             isValid = true;
//           } else {
//             var responseText = json.decode(response.body)['d'].toString();

//             if (responseText.toLowerCase().contains("errormsg")) {
//               responseTextUpdated =
//                   responseText.toString().replaceAll("ErrorMSG", "");
//               responseTextUpdated =
//                   responseTextUpdated.toString().replaceAll(":", "");
//               responseTextUpdated =
//                   responseTextUpdated.toString().replaceAll("\"", "");
//               responseTextUpdated =
//                   responseTextUpdated.toString().replaceAll("{", "");
//               responseTextUpdated =
//                   responseTextUpdated.toString().replaceAll("}", "");
//               print(responseTextUpdated.toString());
//             }
//             // print(responseText.toString().replaceAll("ErrorMSG", ""));
//             // print(responseText.toString().replaceAll(":", ""));
//             // print(responseText.toString().replaceAll("\"", ""));

//             isValid = false;
//           }
//         }

//         setState(() {
//           isSavingData = false;
//           if (responseTextUpdated != "") errMsgText = responseTextUpdated;
//         });
//       }).catchError((onError) {
//         setState(() {
//           isSavingData = false;
//         });
//         print(onError);
//       });
//       return isValid;
//     } catch (Exc) {
//       print(Exc);
//       return false;
//     }
//   }
// }
