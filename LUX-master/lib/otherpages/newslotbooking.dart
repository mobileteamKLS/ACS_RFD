import 'dart:convert';

import 'package:luxair/constants.dart';
import 'package:luxair/dashboards/dashboard.dart';
import 'package:luxair/datastructure/acceptancepod.dart';
import 'package:luxair/datastructure/slotbooking.dart';
import 'package:luxair/datastructure/vehicletoken.dart';
import 'package:luxair/global.dart';
import 'package:luxair/otherpages/slotlist.dart';
import 'package:luxair/otherpages/slotslistadditional.dart';
import 'package:luxair/widgets/common.dart';
import 'package:luxair/widgets/customdialogue.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:luxair/widgets/headers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class NewSlotBooking extends StatefulWidget {
  final List<AWBDetail> selectedShipments;
  final List<AWBDetailImport> selectedShipmentsImport;
  final String shipmentMode;
  final int GHA;
  final String GHAname;
  const NewSlotBooking(
      {Key? key,
      required this.selectedShipments,
      required this.selectedShipmentsImport,
      required this.shipmentMode,
      required this.GHA,
      required this.GHAname})
      : super(key: key);

  @override
  State<NewSlotBooking> createState() => _NewSlotBookingState();
}

class _NewSlotBookingState extends State<NewSlotBooking> {
  int selectedVehicleID = 0, selectedGHA = 0;
  int _currentStep = 0;
  bool isLoading = false, isSavingData = false, isErrorSave = false;
  String selectedGHAText = "",
      totalNOPText = "",
      totalGRWTText = "",
      selectedSlotDate = "",
      errMsgText = "";
  String selectedVehicleText = ""; //10 "Flat-bed/Box Truck(10-12 ft)";
  TextEditingController dateInput = TextEditingController();
  String preferredTimeText = "View All", preferredTimeVal = "ALL";
  String selectedSlot = "";
  StepperType stepperType = StepperType.vertical;
  bool isOnLastStep = false;
  TextEditingController txtDriverName = TextEditingController();
  TextEditingController txtVehicleNo = TextEditingController();
  TextEditingController txtMobileNo = TextEditingController();
  TextEditingController txtLicNo = TextEditingController();
  TextEditingController txtSTA = TextEditingController();

  TextEditingController txtAllocatedNOP = TextEditingController();
  TextEditingController txtAllocatedGRWT = TextEditingController();

  List<DriverDetails> driverNamesListFilter = [];
  List<SlotDetail> slotsList = [];

  List<AWBDetail> allocatedShipment = [];
  List<AWBDetailImport> allocatedShipmentImport = [];

  bool validGHA = true,
      validVehicleT = true,
      validDate = true,
      validVehicleNo = true,
      validDname = true,
      validDMobN = true,
      validDLic = true;

  Future<List<DriverDetails>> getSuggestionsDD(String query) async {
    //txtMobileNo.text="";
    //  driverNamesListFilter = [];
    List<DriverDetails> matches = [];
    matches.addAll(driverNamesListFilter);
    matches.retainWhere((DriverDetails s) =>
        s.DR_FIRSTNAME.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  Future<List<VehicleNos>> getSuggestionsVN(String query) async {
    driverNamesListFilter = [];
    List<VehicleNos> matches = [];
    matches.addAll(vehicleNosList);
    matches.retainWhere((VehicleNos s) =>
        s.VH_NUMBER.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    allocatedShipment = widget.selectedShipments;
    allocatedShipmentImport = widget.selectedShipmentsImport;
    selectedGHA = widget.GHA;
    selectedGHAText = widget.GHAname;
    driverNamesListFilter = driverNamesList;
    if (allocatedShipment.length > 0) calculateNopWt();
    if (allocatedShipmentImport.length > 0) calculateNopWt();

    super.initState();
    // getDriversList();
    // getVehicleNoList();
    // txtDriverName.addListener(_printLatestValueDD);
    // txtVehicleNo.addListener(_printLatestValueVH);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    txtDriverName.dispose();
    txtVehicleNo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderClipperWaveThisForm(
                color1: Color(0xFF3383CD),
                color2: Color(0xFF11249F),
                headerText: "New Slot Booking "),
            Expanded(
              child: isSavingData
                  ? Center(
                      child: Container(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator()))
                  : Stepper(
                      controlsBuilder:
                          (BuildContext context, ControlsDetails controls) {
                        return Row(
                          children: <Widget>[
                            // TextButton(
                            //   onPressed: onStepContinue,
                            //   child: _currentStep == 2
                            //       ? const Text('SUBMIT')
                            //       : const Text('NEXT'),
                            // ),

                            if (_currentStep > 0)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: buildbutton("PREV", controls.onStepCancel),
                              ),
                            buildbutton(_currentStep == 2 ? "SUBMIT" : "NEXT",
                                controls.onStepContinue),
                            // TextButton(
                            //   onPressed: onStepCancel,
                            //   child: const Text('PREV'),
                            // ),
                          ],
                        );
                      },
                      type: stepperType,
                      physics: ScrollPhysics(),
                      currentStep: _currentStep,
                      onStepTapped: (step) => tapped(step),
                      onStepContinue: continued,
                      onStepCancel: cancel,
                      steps: <Step>[
                        Step(
                          title: new Text('Select Slot'),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select GHA",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF11249F),
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    // filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: validGHA
                                              ? Colors.grey.withOpacity(0.5)
                                              : Colors.red,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  dropdownColor: Colors.white,
                                  hint: Text("---- Select ----",
                                      style: mobileYellowTextFontStyleBold),
                                  value: selectedGHA,
                                  items: terminalsList.map((term) {
                                    return DropdownMenuItem(
                                      child: Text(
                                          term.custodianName.toUpperCase(),
                                          style:
                                              mobileTextFontStyle), //label of item
                                      value: term.custudian, //value of item
                                    );
                                  }).toList(),

                                  //                    onChanged: awbDT.enabled == false
                                  // ? null
                                  // : (bool? value) {
                                  //     setState(() {
                                  //       awbDT.selected = value!;
                                  //     });
                                  //   },
                                  onChanged: widget.GHA > 0
                                      ? null
                                      : (value) {
                                          setState(() {
                                            // selectedGHAText = value.toString();
                                            selectedGHA =
                                                int.parse(value.toString());

                                            List<WarehouseTerminals> matches =
                                                [];
                                            matches.addAll(terminalsList);
                                            matches.retainWhere(
                                                (WarehouseTerminals s) =>
                                                    s.custudian == value);
                                            selectedGHAText =
                                                matches[0].custodianName;

                                            getSlotsList();
                                          });
                                        },
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Select Vehicle Type",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF11249F),
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    // filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: validVehicleT
                                              ? Colors.grey.withOpacity(0.5)
                                              : Colors.red,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  dropdownColor: Colors.white,
                                  hint: Text("---- Select ----",
                                      style: mobileYellowTextFontStyleBold),
                                  value: selectedVehicleID,
                                  items: vehicletypesList.map((vehicle) {
                                    return DropdownMenuItem(
                                      child: Text(
                                          vehicle.TruckTypeName.toUpperCase(),
                                          style:
                                              mobileTextFontStyle), //label of item
                                      value:
                                          vehicle.TruckTypeId, //value of item
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      //selectedVehicleText = value.toString();
                                      selectedVehicleID =
                                          int.parse(value.toString());

                                      List<Vehicletypes> matches = [];
                                      matches.addAll(vehicletypesList);
                                      matches.retainWhere((Vehicletypes s) =>
                                          s.TruckTypeId == value);
                                      selectedVehicleText =
                                          matches[0].TruckTypeName;

                                      getSlotsList();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Select Date",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF11249F),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.1, // hard coding child width
                                      child: Container(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.1,

                                        //     borderSide: BorderSide(
                                        //     color: Colors.grey.withOpacity(0.5), width: 1),
                                        // borderRadius: BorderRadius.circular(4.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: validDate
                                                ? Colors.grey.withOpacity(0.5)
                                                : Colors.red,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: TextField(
                                            // onChanged: (value) => _runFilter(value),
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime(2100));

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

                                                  getSlotsList(); // refesh slots
                                                });
                                              }
                                            },
                                            controller: dateInput,
                                            //keyboardType: TextInputType.text,
                                            readOnly: true,
                                            // textCapitalization:
                                            //     TextCapitalization.characters,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Select Date",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
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
                                ],
                              ),
                              SizedBox(height: 5),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width / 1.1,
                                color: Color(0xFF11249F),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Select Preferred Time",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF11249F),
                                ),
                              ),
                              SizedBox(height: 5),
                              Wrap(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  timingWidget(
                                      Colors.grey.shade200,
                                      Color(0xFF3540E8),
                                      "View All",
                                      "ALL",
                                      "assets/icons/all2.png"),
                                  timingWidget(
                                      Colors.grey.shade200,
                                      Color(0xFF3540E8),
                                      "Morning",
                                      "MOR",
                                      "assets/icons/sunrise.png"),
                                  timingWidget(
                                      Colors.grey.shade200,
                                      Color(0xFF3540E8),
                                      "Mid Day",
                                      "MID",
                                      "assets/icons/midday.png"),
                                  timingWidget(
                                      Colors.grey.shade200,
                                      Color(0xFF3540E8),
                                      "Evening",
                                      "EVE",
                                      "assets/icons/sunset.png"),
                                  timingWidget(
                                      Colors.grey.shade200,
                                      Color(0xFF3540E8),
                                      "Night",
                                      "NGT",
                                      "assets/icons/moon.png"),
                                ],
                              ),
                              SizedBox(height: 5),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width / 1.1,
                                color: Color(0xFF11249F),
                              ),
                              SizedBox(height: 5),
                              if (selectedGHA == 0 ||
                                  selectedVehicleID == 0 ||
                                  selectedSlotDate == "")
                                if (slotsList.isNotEmpty)
                                  Text(
                                    "Select Slot",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF11249F),
                                    ),
                                  ),

                              if (selectedGHA != 0 &&
                                  selectedVehicleID != 0 &&
                                  selectedSlotDate != "")
                                if (slotsList.isEmpty)
                                  Text(
                                    "No slots available",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF11249F),
                                    ),
                                  ),
                              SizedBox(height: 10),
                              isLoading
                                  ? Center(
                                      child: Container(
                                          height: 100,
                                          width: 100,
                                          child: CircularProgressIndicator()))
                                  : Wrap(
                                      children: [
                                        for (var i = 0;
                                            i < slotsList.length;
                                            i++)
                                          if (slotsList[i]
                                                  .SlotAvailability
                                                  .toString()
                                                  .trim() ==
                                              "A")
                                            (preferredTimeVal == "ALL")
                                                ? slotWidget(
                                                    (slotsList[i]
                                                                .AllocatedDocks -
                                                            slotsList[i]
                                                                .BookedSlots)
                                                        .toString(),
                                                    Color(0xFF1220BC),
                                                    //  "  " +
                                                    slotsList[i]
                                                        .FromTime
                                                        .toString()
                                                        .trim(),
                                                    slotsList[i]
                                                        .ToTime
                                                        .toString()
                                                        .trim())
                                                : (slotsList[i]
                                                            .SlotType
                                                            .toUpperCase() ==
                                                        preferredTimeVal)
                                                    ? slotWidget(
                                                        (slotsList[i]
                                                                    .AllocatedDocks -
                                                                slotsList[i]
                                                                    .BookedSlots)
                                                            .toString(),
                                                        Color(0xFF1220BC),
                                                        // "  " +
                                                        slotsList[i]
                                                            .FromTime
                                                            .toString()
                                                            .trim(),
                                                        slotsList[i]
                                                            .ToTime
                                                            .toString()
                                                            .trim())
                                                    : Container(),
                                      ],
                                    ),
                              SizedBox(height: 15),
                              // Padding(
                              //   padding: const EdgeInsets.only(bottom: 8.0),
                              //   child: Center(
                              //     child: ElevatedButton(
                              //       onPressed: () {
                              //         Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     NewSlotBooking()));
                              //       },

                              //       style: ElevatedButton.styleFrom(
                              //         elevation: 4.0,
                              //         shape: RoundedRectangleBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(10.0)), //
                              //         padding: const EdgeInsets.all(0.0),
                              //       ),
                              //       child: Container(
                              //         height: 50,
                              //         width: 150,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(10),
                              //           gradient: LinearGradient(
                              //             begin: Alignment.topRight,
                              //             end: Alignment.bottomLeft,
                              //             colors: [
                              //               Color(0xFF3540E8),
                              //               Color(0xFF3540E8),
                              //             ],
                              //           ),
                              //         ),
                              //         child: Padding(
                              //           padding: const EdgeInsets.only(
                              //               top: 8.0, bottom: 8.0),
                              //           child: Align(
                              //             alignment: Alignment.center,
                              //             child: Text(
                              //               'Next',
                              //               style: TextStyle(
                              //                   fontSize: MediaQuery.of(context)
                              //                           .size
                              //                           .width /
                              //                       22,
                              //                   fontWeight: FontWeight.bold,
                              //                   color: Colors.white),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //       //Text('CONTAINED BUTTON'),
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(height: 35),
                            ],
                          ),
                          isActive: _currentStep >= 0,
                          state: _currentStep >= 0
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        Step(
                          title: new Text('Driver Details'),
                          content: Column(
                            children: <Widget>[
                              buildInfoWidget(),
                              SizedBox(height: 10),
                              Card(
                                child: ExpansionTile(
                                  initiallyExpanded: true,
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Driver Details",
                                        style: mobileHeaderFontStyle,
                                      ),
                                      // GestureDetector(
                                      //     onTap: () {
                                      //       print("delete clicked");
                                      //     },
                                      //     child: Icon(
                                      //       Icons.delete_forever,
                                      //       color: Colors.red,
                                      //     )),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            child: Text('Vehicle No.',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF11249F))),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.3,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3, // hard coding child width
                                              child: Container(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.3,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: validVehicleNo
                                                        ? Colors.grey
                                                            .withOpacity(0.5)
                                                        : Colors.red,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: TypeAheadField(
                                                  //he

                                                  textFieldConfiguration:
                                                      TextFieldConfiguration(
                                                          autocorrect: false,
                                                          style:
                                                              mobileTextFontStyle,
                                                          keyboardType:
                                                              TextInputType
                                                                  .streetAddress,
                                                          //  maxLength: ,
                                                          controller:
                                                              txtVehicleNo,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            counterText: "",
                                                            isDense: true,
                                                            hintText:
                                                                "Select/Enter vehicle",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            8,
                                                                        horizontal:
                                                                            8),
                                                          ),

                                                          // enabled: false,
                                                          onChanged: (txt) {
                                                            // print('Vehicle No: ${txtVehicleNo.text.toString()}');
                                                            // print('Second text field: ${txt.toString()}');

                                                            txtDriverName.text =
                                                                "";
                                                            txtMobileNo.text =
                                                                "";
                                                            txtLicNo.text = "";
                                                            txtSTA.text = "";
                                                          }),
                                                  suggestionsCallback:
                                                      (pattern) async {
                                                    return getSuggestionsVN(
                                                        pattern);
                                                  },
                                                  transitionBuilder: (context,
                                                      suggestionsBox,
                                                      controller) {
                                                    return suggestionsBox;
                                                  },
                                                  itemBuilder: (context,
                                                      VehicleNos suggestion) {
                                                    return ListTile(
                                                      title: Text(suggestion
                                                          .VH_NUMBER
                                                          .toString()),
                                                    );
                                                  },
                                                  onSuggestionSelected:
                                                      (VehicleNos suggestion) {
                                                    // print(suggestion);
                                                    this.txtVehicleNo.text =
                                                        suggestion.VH_NUMBER
                                                            .toString();

                                                    print(suggestion.VH_NUMBER
                                                        .toString());

                                                    driverNamesListFilter = [];
                                                    driverNamesListFilter
                                                        .addAll(
                                                            driverNamesList);
                                                    driverNamesListFilter
                                                        .retainWhere((DriverDetails
                                                                s) =>
                                                            s.VehicleNo
                                                                .toLowerCase() ==
                                                            (suggestion
                                                                .VH_NUMBER
                                                                .toLowerCase()));
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.start,
                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                    //     children: [
                                    //       SizedBox(
                                    //         width:
                                    //             MediaQuery.of(context).size.width / 4,
                                    //         child: Text('Name',
                                    //             style: TextStyle(
                                    //                 fontSize: 16,
                                    //                 fontWeight: FontWeight.bold,
                                    //                 color: Color(0xFF11249F))),
                                    //       ),
                                    //       SizedBox(
                                    //         width: MediaQuery.of(context).size.width /
                                    //             2.3,
                                    //         child: SizedBox(
                                    //           width:
                                    //               MediaQuery.of(context).size.width /
                                    //                   2.3, // hard coding child width
                                    //           child: Container(
                                    //             height: 80,
                                    //             width: MediaQuery.of(context)
                                    //                     .size
                                    //                     .width /
                                    //                 2.3,
                                    //             decoration: BoxDecoration(
                                    //               border: Border.all(
                                    //                 color:
                                    //                     Colors.grey.withOpacity(0.5),
                                    //                 width: 1.0,
                                    //               ),
                                    //               borderRadius:
                                    //                   BorderRadius.circular(4.0),
                                    //             ),
                                    //             child: TextField(
                                    //                 // onChanged: (value) => _runFilter(value),
                                    //                 // controller: txtVTNO,
                                    //                 keyboardType:
                                    //                     TextInputType.multiline,
                                    //                 maxLines: 3,
                                    //                 minLines: 2,
                                    //                 textCapitalization:
                                    //                     TextCapitalization.characters,
                                    //                 decoration: InputDecoration(
                                    //                   border: InputBorder.none,
                                    //                   hintText: "Enter driver name",
                                    //                   hintStyle: TextStyle(
                                    //                       color: Colors.grey),
                                    //                   contentPadding:
                                    //                       EdgeInsets.symmetric(
                                    //                           vertical: 8,
                                    //                           horizontal: 8),
                                    //                   isDense: true,
                                    //                 ),
                                    //                 style: mobileTextFontStyle),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            child: Text('Name',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF11249F))),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.3,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3, // hard coding child width
                                              child: Container(
                                                height: 80,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.3,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: validDname
                                                        ? Colors.grey
                                                            .withOpacity(0.5)
                                                        : Colors.red,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: TypeAheadField(
                                                    //he
                                                    textFieldConfiguration:
                                                        TextFieldConfiguration(
                                                            autocorrect: false,
                                                            style:
                                                                mobileTextFontStyle,
                                                            keyboardType:
                                                                TextInputType
                                                                    .name,
                                                            //  maxLength: ,
                                                            controller:
                                                                txtDriverName,
                                                            decoration:
                                                                InputDecoration(
                                                              isDense: true,
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              counterText: "",
                                                              hintText:
                                                                  "Select/Enter name",
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          8),
                                                            ),

                                                            // enabled: false,
                                                            onChanged:
                                                                (txt) {}),
                                                    suggestionsCallback:
                                                        (pattern) async {
                                                      // txtMobileNo.text = "";
                                                      // txtLicNo.text = "";
                                                      // txtSTA.text = "";
                                                      return getSuggestionsDD(
                                                          pattern);
                                                    },
                                                    transitionBuilder: (context,
                                                        suggestionsBox,
                                                        controller) {
                                                      return suggestionsBox;
                                                    },
                                                    itemBuilder: (context,
                                                        DriverDetails
                                                            suggestion) {
                                                      return ListTile(
                                                        title: Text(suggestion
                                                            .DR_FIRSTNAME
                                                            .toString()),
                                                      );
                                                    },
                                                    // noItemsFoundBuilder: (value) {
                                                    //   print(value);
                                                    //   // setState(() {
                                                    //   //   this.txtMobileNo.text = "";

                                                    //   //   this.txtLicNo.text = "";

                                                    //   //   this.txtSTA.text = "";
                                                    //   // });
                                                    //   //  print("no record found");
                                                    //   return Text(
                                                    //       "No record found !!");
                                                    // },

                                                    //suggestionsBoxDecoration: ,
                                                    onSuggestionSelected:
                                                        (DriverDetails
                                                            suggestion) {
                                                      // print(suggestion);
                                                      this.txtDriverName.text =
                                                          suggestion
                                                              .DR_FIRSTNAME
                                                              .toString();

                                                      this.txtMobileNo.text =
                                                          suggestion.DR_MOBILE
                                                              .toString();

                                                      this.txtLicNo.text =
                                                          suggestion
                                                              .DR_LICENSENO
                                                              .toString();

                                                      this.txtSTA.text =
                                                          suggestion.DR_STA
                                                              .toString();

                                                      // print(suggestion.DR_FIRSTNAME
                                                      //     .toString());

                                                      // bookingDetailsSave['Mode'] = suggestion.toString();
                                                    }),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            child: Text('Mobile No.',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF11249F))),
                                          ),
                                          SizedBox(
                                            width: 55,
                                            child: SizedBox(
                                              width:
                                                  55, // hard coding child width
                                              child: Container(
                                                height: 40,
                                                width: 55,
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
                                                    readOnly: true,
                                                    // onChanged: (value) => _runFilter(value),
                                                    //  controller: txtMobileNo,
                                                    // keyboardType: TextInputType.text,
                                                    // textCapitalization:
                                                    //     TextCapitalization.characters,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "+352",
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
                                          SizedBox(width: 5),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.66,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.66, // hard coding child width
                                              child: Container(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.66,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: validDMobN
                                                        ? Colors.grey
                                                            .withOpacity(0.5)
                                                        : Colors.red,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: TextField(
                                                    // onChanged: (value) => _runFilter(value),
                                                    controller: txtMobileNo,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText:
                                                          "Enter mobile no",
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
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            child: Text('License No.',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF11249F))),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.3,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3, // hard coding child width
                                              child: Container(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.3,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: validDLic
                                                        ? Colors.grey
                                                            .withOpacity(0.5)
                                                        : Colors.red,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: TextField(
                                                    // onChanged: (value) => _runFilter(value),
                                                    controller: txtLicNo,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText:
                                                          "Enter license no",
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
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            child: Text('STA(Opt.)',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF11249F))),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.3,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3, // hard coding child width
                                              child: Container(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.3,
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
                                                    // onChanged: (value) => _runFilter(value),
                                                    controller: txtSTA,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "Enter sta",
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                          isActive: _currentStep >= 0,
                          state: _currentStep >= 1
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        Step(
                          title: new Text('Shipment Details'),
                          content: Column(
                            children: <Widget>[
                              buildInfoWidget(),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Click to add more shipments -->  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF11249F)),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      print("selectedGHAText = " +
                                          selectedGHAText);
                                      print("selectedGHAID = " +
                                          selectedGHA.toString());

                                      if (widget.shipmentMode == "Import") {
                                        List<AWBDetailImport> newAwbsImport =
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SlotsListAdditional(
                                                          selectedShipments: [],
                                                          selectedShipmentsImports:
                                                              widget
                                                                  .selectedShipmentsImport,
                                                          custodianID:
                                                              selectedGHAText,
                                                          mode: widget
                                                              .shipmentMode,
                                                        )));

                                        if (newAwbsImport.isNotEmpty) {
                                          print("newAwbs selected");
                                          for (int i = 0;
                                              i < newAwbsImport.length;
                                              i++) {
                                            widget.selectedShipmentsImport
                                                .add(newAwbsImport[i]);
                                          }
                                          setState(() {
                                            calculateNopWt();
                                          });
                                        }
                                      } else {
                                        List<AWBDetail> newAwbs =
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SlotsListAdditional(
                                                          selectedShipments: widget
                                                              .selectedShipments,
                                                          selectedShipmentsImports: [],
                                                          custodianID:
                                                              selectedGHAText,
                                                          mode: widget
                                                              .shipmentMode,
                                                        )));

                                        if (newAwbs.isNotEmpty) {
                                          print("newAwbs selected");
                                          for (int i = 0;
                                              i < newAwbs.length;
                                              i++) {
                                            widget.selectedShipments
                                                .add(newAwbs[i]);
                                          }
                                          setState(() {
                                            calculateNopWt();
                                          });
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Colors.green,
                                              Colors.green,
                                            ],
                                          ),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            ' + ',
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (widget.shipmentMode == "Import")
                                for (int i = 0;
                                    i < allocatedShipmentImport.length;
                                    i++)
                                  buildAllocatedShipmentWidgetImport(
                                      allocatedShipmentImport[i]),
                              if (widget.shipmentMode == "Export")
                                for (int i = 0;
                                    i < allocatedShipment.length;
                                    i++)
                                  buildAllocatedShipmentWidget(
                                      allocatedShipment[i]),
                              SizedBox(height: 35),
                            ],
                          ),
                          isActive: _currentStep >= 0,
                          state: _currentStep >= 2
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  calculateNopWt() {
    print("***************** calculateNopWt called here *****************");
    int totPCS = 0;
    double grWT = 0;

    if (widget.shipmentMode == "Import") {
      for (int i = 0; i < allocatedShipmentImport.length; i++) {
        totPCS = totPCS + allocatedShipmentImport[i].AWBPcs;
        grWT = grWT + allocatedShipmentImport[i].GrWt;
      }
    } else {
      for (int i = 0; i < allocatedShipment.length; i++) {
        totPCS = totPCS + allocatedShipment[i].PiecesCount;
        grWT = grWT + allocatedShipment[i].GrossWeight;
      }
    }

    setState(() {
      totalNOPText = totPCS.toString();
      totalGRWTText = grWT.toString();
    });
  }

  getSlotsList() async {
    if (isLoading) return;

    if (selectedGHA == 0 || selectedVehicleID == 0 || selectedSlotDate == "")
      return;

    slotsList = [];
    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "Organizationid": loggedinUser.OrganizationId.toString(),
      "SlotBookDate": selectedSlotDate.toString(),
      "terminal": selectedGHA.toString(),
      "dropdownvehiclevalue": selectedVehicleID.toString(),
      "CommodityTypeIds": "2",
    };
    await Global()
        .postData(
      Settings.SERVICES['GetSlotsList'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      slotsList =
          resp.map<SlotDetail>((json) => SlotDetail.fromJson(json)).toList();

      print("length slotsList = " + slotsList.length.toString());

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

  tapped(int step) {
    print(step);
    setState(() => _currentStep = step);
  }

  continued() async {
    print(_currentStep);

    //  if (_currentStep == 2) {
    //   print("object");
    // }

    if (_currentStep == 2) {
      setState(() {
        validGHA = true;
        validVehicleT = true;
        validDate = true;
        validVehicleNo = true;
        validDname = true;
        validDMobN = true;
        validDLic = true;
      });

      if (selectedGHA == 0) {
        showAlertDialog(context, "OK", "Validation Failed", "Select GHA");
        setState(() {
          validGHA = false;
          _currentStep = 0;
        });
        return;
      }
      if (selectedVehicleID == 0) {
        showAlertDialog(
            context, "OK", "Validation Failed", "Select Vehicle Type");
        setState(() {
          validVehicleT = false;
          _currentStep = 0;
        });
        return;
      }
      if (selectedSlotDate == "") {
        showAlertDialog(context, "OK", "Validation Failed", "Select Date");
        setState(() {
          validDate = false;
          _currentStep = 0;
        });
        return;
      }
      if (selectedSlot == "") {
        showAlertDialog(context, "OK", "Validation Failed", "Select Slot");
        setState(() {
          _currentStep = 0;
        });
        return;
      }
      if (txtVehicleNo.text.isEmpty) {
        showAlertDialog(
            context, "OK", "Validation Failed", "Enter or Select Vehicle No.");
        setState(() {
          validVehicleNo = false;
          _currentStep = 1;
        });
        return;
      }
      if (txtDriverName.text.isEmpty) {
        showAlertDialog(
            context, "OK", "Validation Failed", "Enter or Select Driver Name");
        setState(() {
          validDname = false;
          _currentStep = 1;
        });
        return;
      }
      if (txtMobileNo.text.isEmpty) {
        showAlertDialog(context, "OK", "Validation Failed", "Enter Mobile No.");
        setState(() {
          validDMobN = false;
          _currentStep = 1;
        });
        return;
      }

      if (txtMobileNo.text.length < 10) {
        showAlertDialog(
            context, "OK", "Validation Failed", "Invalid Mobile No.");
        setState(() {
          validDMobN = false;
          _currentStep = 1;
        });
        return;
      }

      if (txtLicNo.text.isEmpty) {
        showAlertDialog(
            context, "OK", "Validation Failed", "Enter License No.");
        setState(() {
          validDLic = false;
          _currentStep = 1;
        });
        return;
      }

      if (txtLicNo.text.isEmpty) {
        showAlertDialog(
            context, "OK", "Validation Failed", "Enter License No.");
        setState(() {
          validDLic = false;
          _currentStep = 1;
        });
        return;
      }

      if (widget.shipmentMode == "Import") {
        if (allocatedShipmentImport.isEmpty) {
          showAlertDialog(context, "OK", "Validation Failed",
              "Select at-least one shipment to book a slot");
          return;
        }
      } else {
        if (allocatedShipment.isEmpty) {
          showAlertDialog(context, "OK", "Validation Failed",
              "Select at-least one shipment to book a slot");
          return;
        }
      }

      if (widget.shipmentMode == "Import") {
        for (var u in allocatedShipmentImport) {
          if (u.txtAllotedPCS.text.isEmpty) {
            showAlertDialog(
                context,
                "OK",
                "Validation Failed",
                "Enter Allocated NoP for " +
                    u.AirlinePrefix +
                    "-" +
                    u.MAWBNumber);
            return;
          }
        }
      } else {
        for (var u in allocatedShipment) {
          if (u.txtAllotedPCS.text.isEmpty) {
            showAlertDialog(
                context,
                "OK",
                "Validation Failed",
                "Enter Allocated NoP for " +
                    u.AirlinePrefix +
                    "-" +
                    u.MAWBNumber);
            return;
          }
        }
      }

      if (widget.shipmentMode == "Import") {
        for (var u in allocatedShipmentImport) {
          if (u.txtAllocatedWt.text.isEmpty) {
            showAlertDialog(
                context,
                "OK",
                "Validation Failed",
                "Enter Allocated GR. WT. for " +
                    u.AirlinePrefix +
                    "-" +
                    u.MAWBNumber);
            return;
          }
        }
      } else {
        for (var u in allocatedShipment) {
          if (u.txtAllocatedWt.text.isEmpty) {
            showAlertDialog(
                context,
                "OK",
                "Validation Failed",
                "Enter Allocated GR. WT. for " +
                    u.AirlinePrefix +
                    "-" +
                    u.MAWBNumber);
            return;
          }
        }
      }

      if (!isSavingData) {
        var submitCheckin = false;
        submitCheckin = widget.shipmentMode == "Import"
            ? await createBookingImport()
            : await createBooking();
        if (submitCheckin == true) {
          var dlgstatus = await showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(
              title: isErrorSave ? "Error Occured" : "Slot Booked",
              description: errMsgText.toString(),
              buttonText: "Okay",
              imagepath: isErrorSave
                  ? 'assets/images/warn.gif'
                  : 'assets/images/successchk.gif',
              isMobile: true,
            ),
          );

          if (dlgstatus == true) {
            if (isErrorSave == false)
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => Dashboards()));
          }
        }
      }
    }
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }
  //getTimeLoadUnload();

  cancel() {
    print(_currentStep);
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  buildInfoWidget() {
    return Card(
      elevation: 2,
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
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text('Selected Date',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11249F))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(dateInput.text, style: VTlistTextFontStyle),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text('Selected Slot',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11249F))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(selectedSlot, style: VTlistTextFontStyle),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text('Vehicle Type',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11249F))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(selectedVehicleText, style: VTlistTextFontStyle),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                      widget.shipmentMode == "Export"
                          ? 'Time to Unload (Approx)'
                          : 'Time to load (Approx)',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11249F))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text('80 Mins', style: VTlistTextFontStyle),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width / 1.2,
              color: Color(0xFF11249F),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text('NoP',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11249F))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text('GR. WT.',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11249F))),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(totalNOPText, //'100',
                      style: VTlistTextFontStyle),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(totalGRWTText, // '235.000 KGS',
                      style: VTlistTextFontStyle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildbutton(btnText, eventtoPerform) {
    return ElevatedButton(
      onPressed: eventtoPerform,

      style: ElevatedButton.styleFrom(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)), //
        padding: const EdgeInsets.all(0.0),
      ),
      child: Container(
        height: 50,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF3540E8),
              Color(0xFF3540E8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              btnText,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
          ),
        ),
      ),
      //Text('CONTAINED BUTTON'),
    );
  }

  timingWidget(Color colorBorder, Color colorText, String lblText1,
      String lblTextVal, String iconPath) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            preferredTimeText = lblText1;
            preferredTimeVal = lblTextVal;
            //getGetSlotsList();
          });
        },
        child: Column(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  width: 1,
                  color: preferredTimeText == lblText1
                      ? colorText
                      : colorBorder, //Colors.blue,
                ),
              ),
              child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(iconPath, fit: BoxFit.fill)),
            ),
            SizedBox(height: 5),
            Text(
              lblText1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: colorText, //Color(0xFF11249F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  slotWidget(String slotAvailable, Color circleColor, String lblText1,
      String lblText2) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSlot = lblText1 + "-" + lblText2;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 0.0, bottom: 4.0, right: 4.0),
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width / 2.8, //180
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selectedSlot == lblText1 + "-" + lblText2
                ? Colors.green.shade200
                : Colors.transparent,
            border: Border.all(
              width: 1,
              color: Color(0xFF1220BC),
            ),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                lblText1 + "-" + lblText2,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
              SizedBox(width: 5),
              Container(
                height: 32,
                width: 32,
                decoration:
                    BoxDecoration(color: circleColor, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    slotAvailable,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // ListTile(
              //   dense: true,
              //   contentPadding: EdgeInsets.all(0.0),
              //   trailing: Container(
              //     height: 32,
              //     width: 32,
              //     decoration:
              //         BoxDecoration(color: circleColor, shape: BoxShape.circle),
              //     child: Center(
              //       child: Text(
              //         slotAvailable,
              //         style: TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              //   title: Text(
              //     lblText1 + "-" + lblText2,
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.normal,
              //         color: Colors.black),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  buildAllocatedShipmentWidget(AWBDetail _awb) {
    //var strName = "txtEdit" + _awb.AWBID.toString();

    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _awb.AirlinePrefix + "-" + _awb.MAWBNumber,
              style: mobileHeaderFontStyle,
            ),
            GestureDetector(
                onTap: () async {
                  var userSelection = await showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomConfirmDialog(
                        title: "Removal Confirmation",
                        description:
                            "Are you sure you want to remove this Shipment? ",
                        buttonText: "Okay",
                        imagepath: 'assets/images/warn.gif',
                        isMobile: true),
                  );

                  if (userSelection == true) {
                    print("delete clicked for " +
                        _awb.AirlinePrefix +
                        " - " +
                        _awb.MAWBNumber);

                    widget.selectedShipments
                        .removeWhere((item) => item.AWBID == _awb.AWBID);

                    setState(() {
                      calculateNopWt();
                    });
                  }
                },
                child: Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                )),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Text('Allocate Nop',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11249F))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width /
                        5, // hard coding child width
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextField(
                          // onChanged: (value) => _runFilter(value),
                          controller: _awb.txtAllotedPCS,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: false, signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter allocate NoP",
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            isDense: true,
                          ),
                          style: mobileTextFontStyle),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width /
                        5, // hard coding child width
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextField(
                          // onChanged: (value) => _runFilter(value),
                          //controller: txtAllocatedGRWT,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: _awb.PiecesCount.toString(),
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            isDense: true,
                          ),
                          style: mobileTextFontStyle),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Text('Allocate GR. WT.',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11249F))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width /
                        5, // hard coding child width
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextField(
                          controller: _awb.txtAllocatedWt,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[0-9.]")),
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              try {
                                final text = newValue.text;
                                if (text.isNotEmpty) double.parse(text);
                                return newValue;
                              } catch (e) {}
                              return oldValue;
                            }),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Allocate GR. WT.",
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            isDense: true,
                          ),
                          style: mobileTextFontStyle),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width /
                        5, // hard coding child width
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: _awb.GrossWeight.toStringAsFixed(2),
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            isDense: true,
                          ),
                          style: mobileTextFontStyle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildAllocatedShipmentWidgetImport(AWBDetailImport _awb) {
    //var strName = "txtEdit" + _awb.AWBID.toString();

    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _awb.AirlinePrefix + "-" + _awb.MAWBNumber,
              style: mobileHeaderFontStyle,
            ),
            GestureDetector(
                onTap: () async {
                  var userSelection = await showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomConfirmDialog(
                        title: "Removal Confirmation",
                        description:
                            "Are you sure you want to remove this Shipment? ",
                        buttonText: "Okay",
                        imagepath: 'assets/images/warn.gif',
                        isMobile: true),
                  );

                  if (userSelection == true) {
                    print("delete clicked for " +
                        _awb.AirlinePrefix +
                        " - " +
                        _awb.MAWBNumber);

                    widget.selectedShipmentsImport
                        .removeWhere((item) => item.DOID == _awb.DOID);

                    setState(() {
                      calculateNopWt();
                    });
                  }
                },
                child: Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                )),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Text('Allocate Nop',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11249F))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width /
                        5, // hard coding child width
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextField(
                          // onChanged: (value) => _runFilter(value),
                          controller: _awb.txtAllotedPCS,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: false, signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter allocate NoP",
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            isDense: true,
                          ),
                          style: mobileTextFontStyle),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width /
                        5, // hard coding child width
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextField(
                          // onChanged: (value) => _runFilter(value),
                          //controller: txtAllocatedGRWT,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: _awb.AWBPcs.toString(),
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            isDense: true,
                          ),
                          style: mobileTextFontStyle),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Text('Allocate GR. WT.',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11249F))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width /
                        5, // hard coding child width
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextField(
                          controller: _awb.txtAllocatedWt,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[0-9.]")),
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              try {
                                final text = newValue.text;
                                if (text.isNotEmpty) double.parse(text);
                                return newValue;
                              } catch (e) {}
                              return oldValue;
                            }),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Allocate GR. WT.",
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            isDense: true,
                          ),
                          style: mobileTextFontStyle),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width /
                        5, // hard coding child width
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: _awb.GrWt.toStringAsFixed(2),
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            isDense: true,
                          ),
                          style: mobileTextFontStyle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> createBooking() async {
    try {
      // return true;
      errMsgText = "";
      String responseTextUpdated = "";
      bool isValid = false;
       isErrorSave = false;
       

      setState(() {
        isSavingData = true;
      });

      String slotDet =
          selectedSlotDate + " " + selectedSlot.toString().replaceAll(" ", "");
      String finalStringVD = "", finalStringAWB = "";
      int iVD = 0;
      for (var u in allocatedShipment) {
        String a = "{" +
            "\"SlotDetails\":\"${slotDet.toString()}\"," +
            "\"VehicleNo\":\"${txtVehicleNo.text}\"," +
            "\"DriverName\":\"${txtDriverName.text}\"," +
            "\"DriverMobileNo\":\"${txtMobileNo.text}\"," +
            "\"DriverLicense\":\"${txtLicNo.text}\"," +
            "\"TSA\":\"${txtSTA.text}\"," +
            "\"VehicleType\":\"${selectedVehicleText.toString()}\"," +
            "\"NoOfPieces\":\"${u.PiecesCount}\"," +
            "\"GrossWeight\":\"${u.GrossWeight}\"," +
            "\"UnitId\":\" \"," +
            "\"Unit\":\"${u.WeightUnitID}\"," +
            "\"RowIndex\":\"2\"," +
            "\"CustodianID\":\"${u.CustodianID}\"," +
            "\"DriverCountryCode\":\"1\"," +
            "\"MLValue\":\"87  minutes\"," +
            "\"isAdvanceSlot\":\"0\"}";

// lstAssignedAwbData:[{"GHAID":"136220","rowIndex":"2","AWBid":"14302",
// "AllocateNOP":"50","AllocateGrWt":"500.000"}]
        String b = "{" +
            "\"GHAID\":\"${selectedGHA.toString()}\"," +
            "\"RowIndex\":\"2\"," +
            "\"AWBid\":\"${u.AWBID}\"," +
            "\"AllocateNOP\":\"${u.txtAllotedPCS.text}\"," +
            "\"AllocateGrWt\":\"${u.txtAllocatedWt.text}\"}";

        if (iVD == 0) {
          finalStringVD = finalStringVD + a;
          finalStringAWB = finalStringAWB + b;
        } else {
          finalStringVD = finalStringVD + "," + a;
          finalStringAWB = finalStringAWB + "," + b;
        }

        iVD++;
      }
      String bvd = "[" + finalStringVD + "]";
      String bAWB = "[" + finalStringAWB + "]";

      var queryParams = {
        "dateButtonValue": selectedSlotDate.toString(),
        "strNoOfVehicle": 1.toString(),
        "BaseStation": "YVR",
        "strVehicleType": selectedVehicleText,
        "strVehicleTypeID": selectedVehicleID.toString(),
        "strCommodityIDs": "2",
        "isWFSIntegrated": "0",
        "createdByID": loggedinUser.CreatedByUserId,
        "VehicleDetails": json.decode(bvd),
        "lstAssignedAwbData": json.decode(bAWB),
        "OrganizationID": loggedinUser.OrganizationId.toString(),
        "OrganizationBranchID": loggedinUser.OrganizationBranchId.toString(),
        "isTruckFlight": "false"
      };

//OrganizationID, long OrganizationBranchID, "isTruckFlight":"false"
      // print(json.encode(queryParams));
      // return true;

      await Global()
          .postData(
        Settings.SERVICES['Bookslot'],
        queryParams,
      )
          .then((response) {
        print("data received ");
        print(json.decode(response.body)['d']);

        if (json.decode(response.body)['d'] == null) {
          isValid = true;
          responseTextUpdated =
              "Unable to book slot, Please try again after some time.";
          isErrorSave = true;
        } else {
          var outMsg = json.decode(response.body)['d'];
 print(json.decode(response.body)['d']);
          print(outMsg.replaceAll("\"", ""));
          outMsg = outMsg.replaceAll("\"", "");
          outMsg = outMsg.replaceAll("{", "");
          outMsg = outMsg.replaceAll("}", "");
          outMsg = outMsg.replaceAll(",", "");

          outMsg = outMsg.replaceAll("message:", "");
          outMsg = outMsg.replaceAll(":", "");

          var abc1 = outMsg.split("description");
          print(abc1[1]); // description
          print(abc1[0]); // message

          // responseTextUpdated = abc1[0].toString();
          if (abc1[1].toString().trim() == "") {
            isValid = true;
            isErrorSave = true;
            responseTextUpdated = abc1[0].toString();
          } else {
            isValid = true;
            responseTextUpdated =
                abc1[0].toString() + " VT # generated is " + abc1[1];
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

  Future<bool> createBookingImport() async {
    try {
      // return true;
      errMsgText = "";
      String responseTextUpdated = "";
      bool isValid = false;
isErrorSave =false;
      setState(() {
        isSavingData = true;
      });

      String slotDet =
          selectedSlotDate + " " + selectedSlot.toString().replaceAll(" ", "");
      String finalStringVD = "", finalStringAWB = "";
      int iVD = 0;
      for (var u in allocatedShipmentImport) {
        String a = "{" +
            "\"SlotDetails\":\"${slotDet.toString()}\"," +
            "\"VehicleNo\":\"${txtVehicleNo.text}\"," +
            "\"DriverName\":\"${txtDriverName.text}\"," +
            "\"DriverMobileNo\":\"${txtMobileNo.text}\"," +
            "\"DriverLicense\":\"${txtLicNo.text}\"," +
            "\"TSA\":\"${txtSTA.text}\"," +
            "\"VehicleType\":\"${selectedVehicleText.toString()}\"," +
            "\"NoOfPieces\":\"${u.AWBPcs}\"," +
            "\"GrossWeight\":\"${u.GrWt}\"," +
            "\"UnitId\":\" \"," +
            "\"Unit\":\"${u.WeightUnitId}\"," +
            "\"RowIndex\":\"2\"," +
            "\"CustodianID\":\"${u.CustodianID}\"," +
            "\"DriverCountryCode\":\"1\"," +
            "\"MLValue\":\"87  minutes\"," +
            "\"isAdvanceSlot\":\"0\"}";

        String b = "{" +
            "\"GHAID\":\"${selectedGHA.toString()}\"," +
            "\"RowIndex\":\"2\"," +
            "\"AWBid\":\"0\"," +
            "\"DOId\":\"${u.DOID}\"," +
            "\"HAWBID\":\"${u.HAWBId}\"," +
            "\"AllocateNOP\":\"${u.txtAllotedPCS.text}\"," +
            "\"AllocateGrWt\":\"${u.txtAllocatedWt.text}\"}";

        if (iVD == 0) {
          finalStringVD = finalStringVD + a;
          finalStringAWB = finalStringAWB + b;
        } else {
          finalStringVD = finalStringVD + "," + a;
          finalStringAWB = finalStringAWB + "," + b;
        }

        iVD++;
      }
      String bvd = "[" + finalStringVD + "]";
      String bAWB = "[" + finalStringAWB + "]";

      var queryParams = {
        "dateButtonValue": selectedSlotDate.toString(),
        "strNoOfVehicle": 1,
        "BaseStation": "YVR",
        "strVehicleType": selectedVehicleID,
        "strVehicleTypeID": selectedVehicleText,
        "strCommodityIDs": "2",
        "isWFSIntegrated": "0",
        "createdByID": loggedinUser.CreatedByUserId.toString(),
        "OrganizationID": loggedinUser.OrganizationId.toString(),
        "OrganizationBranchID": loggedinUser.OrganizationBranchId.toString(),
        "VehicleDetails": json.decode(bvd),
        "lstAssignedAwbData": json.decode(bAWB),
      };

      // print(json.encode(queryParams));
      // return true;

      await Global()
          .postData(
        Settings.SERVICES['BookslotImport'],
        queryParams,
      )
          .then((response) {
        print("data received ");
        print(json.decode(response.body)['d']);

        if (json.decode(response.body)['d'] == null) {
          isValid = true;
          responseTextUpdated =
              "Unable to book slot, Please try again after some time.";
          isErrorSave = true;
        } else {
          var outMsg = json.decode(response.body)['d'];
          print(json.decode(response.body)['d']);
          print(outMsg.replaceAll("\"", ""));
          outMsg = outMsg.replaceAll("\"", "");
          outMsg = outMsg.replaceAll("{", "");
          outMsg = outMsg.replaceAll("}", "");
          outMsg = outMsg.replaceAll(",", "");

          outMsg = outMsg.replaceAll("message:", "");
          outMsg = outMsg.replaceAll(":", "");
          print(outMsg);

          var abc1 = outMsg.split("description");
          print(abc1[1]); // description
          print(abc1[0]); // message

          print("abc1[1] =" + abc1[1] + "end");
          print("abc1[1] =" + abc1[1].toString().trim() + "end");
          //print(abc1[1].toString().trim());

          if (abc1[1].toString().trim() == "") {
            print("blank here");
            isValid = true;
            isErrorSave = true;
            responseTextUpdated = abc1[0].toString();
          } else {
            print("NOT blank here");
            isValid = true;
            responseTextUpdated =
                abc1[0].toString() + " VT # generated is " + abc1[1];
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

  getTimeLoadUnload() async {
    var modepass = widget.shipmentMode.toString().substring(0, 1);

    var queryParams = "{" +
        "\"SHC\":\"GEN\"," +
        "\"Mode\":\"${modepass.toString()}\"," +
        "\"Pieces\":${int.parse(totalNOPText.toString())}," +
        "\"GrossWt\":${double.parse(totalGRWTText.toString())}," +
        "\"TruckType\":\"${selectedVehicleText.toString()}\"," +
        "\"Duration\":\"10\"}";

    await Global()
        .fetchDataLoadUnload(
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body));
    }).catchError((onError) {
      print(onError);
    });
  }
}

class HeaderClipperWaveThisForm extends StatelessWidget {
  final Color color1;
  final Color color2;
  final String headerText;

  const HeaderClipperWaveThisForm(
      {Key? key,
      required this.color1,
      required this.color2,
      required this.headerText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool useMobileLayout = false;

    if (kIsWeb) {
      // running on the web!
      print("running on the web!");
      useMobileLayout = false;
    } else {
      var smallestDimension = MediaQuery.of(context).size.shortestSide;
      useMobileLayout = smallestDimension < 600;
    }
    return ClipPath(
      //upper clippath with less height
      clipper: kIsWeb
          ? WaveClipper()
          : useMobileLayout
              ? WaveClipperNew()
              : WaveClipper(), //set our custom wave clipper.
      child: Container(
        padding: EdgeInsets.only(
            bottom: kIsWeb
                ? 0
                : useMobileLayout
                    ? 40
                    : 60),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            colors: [
              color1, //  Color(0xFF3383CD),
              color2, //   Color(0xFF11249F),
            ],
          ),
        ),
        height: MediaQuery.of(context).size.height / 6, //180,
        alignment: Alignment.center,

        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => Dashboards()));
                        //Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Icon(
                          Icons.chevron_left,
                          size: useMobileLayout
                              ? 40
                              : MediaQuery.of(context).size.width / 18, //56,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: useMobileLayout ? 10 : 20),
                    Text(
                      headerText, // "Walk-in Details ",
                      style: TextStyle(
                          fontSize: kIsWeb
                              ? 48
                              : MediaQuery.of(context).size.width / 18, //48,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              if (headerText.contains("multiline"))
                Text(
                  " Mode : Export",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 18, //48,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
            ]),
      ),
    );
  }
}
