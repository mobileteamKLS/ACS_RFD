import 'dart:convert';

import 'package:luxair/datastructure/slotbooking.dart';
import 'package:luxair/widgets/customdialogue.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../constants.dart';
import '../global.dart';

class BookedSlotsList extends StatefulWidget {
  const BookedSlotsList({Key? key}) : super(key: key);

  @override
  State<BookedSlotsList> createState() => _BookedSlotsListState();
}

class _BookedSlotsListState extends State<BookedSlotsList> {
  final _controllerModeType = ValueNotifier<bool>(false);
  List<BookedAWBDetail> bookedSlotsList = [];
  List<BookedAWBDetailImport> bookedSlotsListImport = [];
  bool isLoading = false, checked = false;
  String selectedMode = "Export";

  @override
  void initState() {
    getSlotsList();
    _controllerModeType.addListener(() {
      setState(() {
        if (_controllerModeType.value) {
          checked = true;
          print("value chnaged heere TO === IMPORT");
          selectedMode = "Import";
        } else {
          checked = false;
          print("value chnaged heere TO === EXPORT");
          selectedMode = "Export";
        }
        getSlotsList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderClipperWave(
                  color1: Color(0xFF3383CD),
                  color2: Color(0xFF11249F),
                  headerText: "Booked Slots List "),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Text("Mode", style: mobileHeaderFontStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: AdvancedSwitch(
                        activeColor: Color(0xFF11249F),
                        inactiveColor: Color(0xFF11249F),
                        activeChild:
                            Text('Import', style: mobileTextFontStyleWhite),
                        inactiveChild:
                            Text('Export', style: mobileTextFontStyleWhite),
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 35,
                        controller: _controllerModeType,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child:
                            Text("Search VT No.", style: mobileHeaderFontStyle),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width /
                            2.4, // hard coding child width
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2.4,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: TextField(
                              // onChanged: (value) => _runFilter(value),
                              // controller: txtVTNO,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search VT No.",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                isDense: true,
                              ),
                              style: mobileTextFontStyle),
                        ),
                      ),
                    ),
                  ]),
              Padding(
                padding:
                    const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.1,
                  color: Color(0xFF0461AA),
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
                        //scrollDirection: Axis.horizontal,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (selectedMode == "Export")
                              for (var i = 0; i < bookedSlotsList.length; i++)
                                buildBookedSlotsList(bookedSlotsList[i]),

                            if (selectedMode == "Import")
                              for (var i = 0;
                                  i < bookedSlotsListImport.length;
                                  i++)
                                buildBookedSlotsListImport(
                                    bookedSlotsListImport[i]),

                            // i == 0
                            //     ? Column(
                            //         children: [
                            //           Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.start,
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //             children: [
                            //               // Container(
                            //               //   width: 60,
                            //               //   height: 60,
                            //               //   color: Colors.yellow.shade300,
                            //               //   child: Padding(
                            //               //     padding: const EdgeInsets.only(
                            //               //         top: 16.0),
                            //               //     child: Text(
                            //               //       'Select',
                            //               //       style: mobileDetailsGridView,
                            //               //       textAlign: TextAlign.center,
                            //               //     ),
                            //               //   ),
                            //               // ),
                            //               // Container(
                            //               //   width: 140,
                            //               //   height: 60,
                            //               //   color: Colors.yellow.shade300,
                            //               //   child: Padding(
                            //               //     padding: const EdgeInsets.only(
                            //               //         top: 16.0),
                            //               //     child: Text(
                            //               //       'VT No.',
                            //               //       style: mobileDetailsGridView,
                            //               //       textAlign: TextAlign.center,
                            //               //     ),
                            //               //   ),
                            //               // ),
                            //               // // Container(
                            //               //   width: 150,
                            //               //   height: 60,
                            //               //   color: Colors.yellow.shade300,
                            //               //   child: Padding(
                            //               //     padding: const EdgeInsets.only(
                            //               //         top: 16.0),
                            //               //     child: Text(
                            //               //       'Handler/\nLocation',
                            //               //       style: mobileDetailsGridView,
                            //               //       textAlign: TextAlign.left,
                            //               //     ),
                            //               //   ),
                            //               // ),
                            //               // Container(
                            //               //   width: 150,
                            //               //   height: 60,
                            //               //   color: Colors.yellow.shade300,
                            //               //   child: Padding(
                            //               //     padding: const EdgeInsets.only(
                            //               //         top: 16.0),
                            //               //     child: Text(
                            //               //       'Freight\nForwarder',
                            //               //       style: mobileDetailsGridView,
                            //               //       textAlign: TextAlign.left,
                            //               //     ),
                            //               //   ),
                            //               // ),
                            //               //     Container(
                            //               //       width: 70,
                            //               //       height: 60,
                            //               //       color: Colors.yellow.shade300,
                            //               //       child: Padding(
                            //               //         padding: const EdgeInsets.only(
                            //               //             top: 16.0),
                            //               //         child: Text(
                            //               //           'NOP',
                            //               //           style: mobileDetailsGridView,
                            //               //           textAlign: TextAlign.center,
                            //               //         ),
                            //               //       ),
                            //               //     ),
                            //               //     Container(
                            //               //       width: 80,
                            //               //       height: 60,
                            //               //       color: Colors.yellow.shade300,
                            //               //       child: Padding(
                            //               //         padding: const EdgeInsets.only(
                            //               //             top: 16.0),
                            //               //         child: Text(
                            //               //           'Total Gr.Wt.',
                            //               //           style: mobileDetailsGridView,
                            //               //           textAlign: TextAlign.center,
                            //               //         ),
                            //               //       ),
                            //               //     ),
                            //               //     Container(
                            //               //       width: 70,
                            //               //       height: 60,
                            //               //       color: Colors.yellow.shade300,
                            //               //       child: Padding(
                            //               //         padding: const EdgeInsets.only(
                            //               //             top: 16.0),
                            //               //         child: Text(
                            //               //           'Unit',
                            //               //           style: mobileDetailsGridView,
                            //               //           textAlign: TextAlign.center,
                            //               //         ),
                            //               //       ),
                            //               //     ),
                            //             ],
                            //           ),
                            //           // SizedBox(height: 5),
                            //         ],
                            //       )
                            //     :
                          ],
                        ),
                      ),
                    ),
            ]),
      ),
    );
    // Expanded();
  }

  buildBookedSlotsList12(BookedAWBDetail bawbd) {
    // DateTime dateNow = bawbd.CreatedDate;
    // print("dateNow");
    // print(dateNow);

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      actions: <Widget>[
        IconSlideAction(
            caption: 'Edit',
            color: Colors.blue,
            icon: Icons.edit,
            onTap: () {}),
        IconSlideAction(
            caption: 'Cancel',
            color: Colors.red.shade400,
            icon: Icons.close,
            onTap: () {}),
      ],
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    // height: 70,
                    // color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        bawbd.tokenno,
                        style: mobilHeaderGridView,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    // height: 70,
                    // color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        bawbd.AllocatedPieces.toString() + " PCS",
                        style: mobileDetailsGridView,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    // height: 70,
                    // color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        bawbd.AllocatedGrosswt.toString() +
                            " " +
                            bawbd.WeightUnitID,
                        style: mobileDetailsGridView,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    // height: 70,
                    // color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        bawbd.SlotTime,
                        style: mobileDetailsGridView,
                        textAlign: TextAlign.left,
                        softWrap: true,
                        maxLines: 3,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    // height: 70,
                    // color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        bawbd.Custodian,
                        style: mobileDetailsGridView,
                        textAlign: TextAlign.left,
                        softWrap: true,
                        maxLines: 3,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    // height: 70,
                    // color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        bawbd.FreightForwarder,
                        style: mobileDetailsGridView,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildBookedSlotsListImport(BookedAWBDetailImport bawbd) {
    return Card(
      elevation: 3,
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
                    bawbd.VehicleTokenNo,
                    style: mobileGroupHeaderFontStyleBold,
                  ),
                ),
                SizedBox(
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 22,
                        color: Color(0xFF11249F),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomConfirmDialog(
                                    title: "Cancel Confirmation",
                                    description:
                                        "Are you sure you want to cancel \n" +
                                            "VT # " +
                                            bawbd.VehicleTokenNo +
                                            "\n Booked for " +
                                            bawbd.SlotTime,
                                    buttonText: "Okay",
                                    imagepath: 'assets/images/warn.gif',
                                    isMobile: true),
                          );
                        },
                        child: Icon(
                          Icons.cancel,
                          size: 22,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width / 3.5,
                //   // height: 70,
                //   // color: Colors.white,
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 16.0),
                //     child: Text(
                //       bawbd.AllocatedPieces.toString() + " PCS",
                //       style: mobileDetailsGridView,
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Icon(
                //               Icons.schedule,
                //               size: 16,
                //               color: Color(0xFF11249F),
                //             ),
                //              SizedBox(width: 10),
                Text(
                  bawbd.SlotTime,
                  style: VTlistTextFontStyle,
                ),
              ],
            ),
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
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bawbd.GHA,
                        style: VTlistTextFontStyle,
                        textAlign: TextAlign.left,
                        // softWrap: true,
                        // maxLines: 3,
                      ),
                      Text(
                        bawbd.FreightForwarder,
                        style: VTlistTextFontStyle,
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
                  height: 40,
                  width: 3,
                  color: Color(0xFF0461AA),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 5,
                    // height: 70,
                    // color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bawbd.AllocatedPieces.toString() + " PCS",
                          style: VTlistTextFontStylesmall,
                        ),
                        Text(
                          bawbd.RcvdGrWt.toStringAsFixed(2) +
                              " " +
                              bawbd.WeightUnitId,
                          style: VTlistTextFontStylesmall,
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

  buildBookedSlotsList(BookedAWBDetail bawbd) {
    return Card(
      elevation: 3,
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
                    bawbd.tokenno,
                    style: mobileGroupHeaderFontStyleBold,
                  ),
                ),
                SizedBox(
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 22,
                        color: Color(0xFF11249F),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomConfirmDialog(
                                    title: "Cancel Confirmation",
                                    description:
                                        "Are you sure you want to cancel \n" +
                                            "VT # " +
                                            bawbd.tokenno +
                                            "\n Booked for " +
                                            bawbd.SlotTime,
                                    buttonText: "Okay",
                                    imagepath: 'assets/images/warn.gif',
                                    isMobile: true),
                          );
                        },
                        child: Icon(
                          Icons.cancel,
                          size: 22,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width / 3.5,
                //   // height: 70,
                //   // color: Colors.white,
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 16.0),
                //     child: Text(
                //       bawbd.AllocatedPieces.toString() + " PCS",
                //       style: mobileDetailsGridView,
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Icon(
                //               Icons.schedule,
                //               size: 16,
                //               color: Color(0xFF11249F),
                //             ),
                //              SizedBox(width: 10),
                Text(
                  bawbd.SlotTime,
                  style: VTlistTextFontStyle,
                ),
              ],
            ),
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
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bawbd.GHA,
                        style: VTlistTextFontStyle,
                        textAlign: TextAlign.left,
                        // softWrap: true,
                        // maxLines: 3,
                      ),
                      Text(
                        bawbd.FreightForwarder,
                        style: VTlistTextFontStyle,
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
                  height: 40,
                  width: 3,
                  color: Color(0xFF0461AA),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 5,
                    // height: 70,
                    // color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bawbd.AllocatedPieces.toString() + " PCS",
                          style: VTlistTextFontStylesmall,
                        ),
                        Text(
                          bawbd.AllocatedGrosswt.toStringAsFixed(2) +
                              " " +
                              bawbd.WeightUnitID,
                          style: VTlistTextFontStylesmall,
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

  getSlotsList() async {
    if (isLoading) return;

    bookedSlotsList = [];
    bookedSlotsListImport = [];
    setState(() {
      isLoading = true;
    });

    var queryParams = {};
    selectedMode == "Import"
        ? queryParams = {
            "OrganisationID": loggedinUser.OrganizationId.toString(),
            "organizationBranchID":
                loggedinUser.OrganizationBranchId.toString(),
            "createdByID": loggedinUser.CreatedByUserId,
            "isWFSIntegrated": "0",
          }
        : queryParams = {
            "OrganisationID": loggedinUser.OrganizationId.toString(),
            "organizationBranchID":
                loggedinUser.OrganizationBranchId.toString(),
            "createdByID": loggedinUser.CreatedByUserId,
            "isWFSIntegrated": "0",
          };
    await Global()
        .postData(
      selectedMode == "Import"
          ? Settings.SERVICES['BookedSlotsListImport']
          : Settings.SERVICES['BookedSlotsListExport'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      if (selectedMode == "Import") {
        bookedSlotsListImport = resp
            .map<BookedAWBDetailImport>(
                (json) => BookedAWBDetailImport.fromJson(json))
            .toList();
        print("length BookedAWBDetailImport = " +
            bookedSlotsListImport.length.toString());
      } else {
        bookedSlotsList = resp
            .map<BookedAWBDetail>((json) => BookedAWBDetail.fromJson(json))
            .toList();

        print("length bookedSlotsList = " + bookedSlotsList.length.toString());
      }

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
}
