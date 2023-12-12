import 'dart:convert';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:luxair/datastructure/vehicletoken.dart';
import 'package:luxair/widgets/headerclipper.dart';

import '../constants.dart';
import '../global.dart';

// bool useMobileLayout = false;

// ignore: must_be_immutable
class VehicleTokenDetails extends StatefulWidget {
  bool isExport = false;
  final VehicleToken selectedVtDetails;

  VehicleTokenDetails(
      {Key? key, required this.selectedVtDetails, required this.isExport})
      : super(key: key);

  @override
  _VehicleTokenDetailsState createState() => _VehicleTokenDetailsState();
}

class _VehicleTokenDetailsState extends State<VehicleTokenDetails> {
  bool useMobileLayout = false;
  bool isLoading = false;
  List<vehicleSMS> vehicleSMSToBind1 = [
    vehicleSMS(
        SMSMessage:
            "To learn about all of the Flutter video series, see our videos page.",
        SMSDate: "10 Oct 2022 08:00-09:00",
        MobileNo: "9890323584909"),
    vehicleSMS(
        SMSMessage:
            "The documentation on this site reflects the latest stable release of Flutter.",
        SMSDate: "18 Sep 2022 16:00-17:00",
        MobileNo: "9890323584909"),
  ];
  List<vehicleSMS> vehicleSMSToBind = [];

  @override
  void initState() {
    if (widget.isExport)
      getVehicleTokenSMSList(3);
    else
      getVehicleTokenSMSList(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = smallestDimension < 600;
    // print("useMobileLayout");
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              "https://static.vecteezy.com/system/resources/previews/005/658/973/non_2x/abstract-background-illustration-wallpaper-with-blue-light-color-blue-grid-mosaic-background-creative-design-templates-free-vector.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderClipperWave(
                  color1: Color(0xFF3383CD),
                  color2: Color(0xFF11249F),
                  headerText: "Vehicle Token Details"), //VTNo
              isLoading
                  ? Center(
                      child: Container(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator()))
                  : Center(
                      child: Container(
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: SCticketShape(
                                vtDetails: widget.selectedVtDetails,
                                isMobile: useMobileLayout,
                                vehicleSMSToBind: vehicleSMSToBind,
                              ),
                            ),
                            Positioned(
                              left: Consts.padding,
                              right: Consts.padding,
                              child: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                radius: 44, //Consts.avatarRadius,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: Consts.avatarRadius, //26,
                                  child: Center(
                                    child: Text(
                                        widget.selectedVtDetails.DOCKNAME,
                                        style: yardGateInText),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
            ]),
      ),
    ));
  }

  getVehicleTokenSMSList(modeType) async {
    if (isLoading) return;

    vehicleSMSToBind = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "OperationType": modeType.toString(), // "",
      "VTNo": widget.selectedVtDetails.VTNo,
    };
    await Global()
        .postData(
      Settings.SERVICES['MessageListTrucker'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      setState(() {
        vehicleSMSToBind =
            resp.map<vehicleSMS>((json) => vehicleSMS.fromJson(json)).toList();

        print(
            "length vehicleSMSToBind = " + vehicleSMSToBind.length.toString());
        isLoading = false;
//vehicleSMSToBind=[];
       // if (vehicleSMSToBind.length == 0) vehicleSMSToBind = vehicleSMSToBind1;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0; // 24.0 ;
  static const double avatarRadius = 40; //48.0;
}

class SCticketShape extends StatelessWidget {
  final VehicleToken vtDetails;
  final bool isMobile;
  final List<vehicleSMS> vehicleSMSToBind;

  List<vehicleSMS> vehicleSMSToBind1 = [
    vehicleSMS(
        SMSMessage:
            "To learn about all of the Flutter video series, see our videos page.",
        SMSDate: "10 Oct 2022 08:00-09:00",
        MobileNo: "9890323584909"),
    vehicleSMS(
        SMSMessage:
            "The documentation on this site reflects the latest stable release of Flutter.",
        SMSDate: "18 Sep 2022 16:00-17:00",
        MobileNo: "9890323584909"),
  ];

  //List<vehicleSMS> vehicleSMSToBind1 = [];

  SCticketShape(
      {Key? key,
      required this.vtDetails,
      required this.isMobile,
      required this.vehicleSMSToBind})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("vehicleSMSToBind1 length = " + vehicleSMSToBind.length.toString());
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ClipPath(
            clipper: CustomTicketShape(isMobile: isMobile),
            // isMobile: isMobile, listLength: vehicleSMSToBind.length),
            child: Container(
              color: Colors.white,
              // height: isMobile
              //     ? MediaQuery.of(context).size.height / 1.01
              //     : MediaQuery.of(context).size.height / 1.57,
              width: isMobile
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 1.55,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 52.0, left: 8.0, right: 8.0, bottom: 16.0),
                child: Column(
                  children: [
                    if (vtDetails.DOCKNAME != "--")
                      Text(
                          "Kindly proceed to assigned dock " +
                              vtDetails.DOCKNAME +
                              " with below QR code.",
                          style: yardGateInHeaderText,
                          textAlign: TextAlign.center),
                    SizedBox(height: 20),
                    BarcodeWidget(
                      barcode: Barcode.qrCode(),
                      data: vtDetails.VTNo,
                      color: Color(0xFF11249F),
                    ),
                   SizedBox(height: isMobile ? 16 : 18),
                    // Container(
                    //   height: 1.7,
                    //   width: isMobile
                    //       ? MediaQuery.of(context).size.width / 1.8
                    //       : MediaQuery.of(context).size.width / 1.8,
                    //   color: Color(0xFF11249F),
                    // ),
                  
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Container(
             width: isMobile
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
               color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
           
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: isMobile
                            ? MediaQuery.of(context).size.width / 2.6
                            : MediaQuery.of(context).size.width / 2.6,
                        child: Container(
                          height: isMobile ? 40 : 50,
                          color: Colors.yellow.shade300,
                          child: Center(
                            child: Text('Vehicle No.',
                                style: isMobile
                                    ? mobileYellowTextFontStyleBold
                                    : iPadYellowTextFontStyleBold),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: isMobile
                            ? MediaQuery.of(context).size.width / 2.1
                            : MediaQuery.of(context).size.width /2.6,
                        child: Container(
                          height: isMobile ? 40 : 50,
                          color: Colors.yellow.shade300,
                          child: Center(
                            child: Text('Driver Name',
                                style: isMobile
                                    ? mobileYellowTextFontStyleBold
                                    : iPadYellowTextFontStyleBold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: isMobile
                            ? MediaQuery.of(context).size.width / 2.6
                            : MediaQuery.of(context).size.width / 2.6,
                        child: Container(
                          height: isMobile ? 40 : 50,
                          color: Colors.yellow.shade100,
                          child: Center(
                            child: Text(vtDetails.VEHICLENO,
                                style: isMobile
                                    ? mobileDetailsYellowBold
                                    : iPadDetailsYellowBold),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: isMobile
                            ? MediaQuery.of(context).size.width / 2.1
                            : MediaQuery.of(context).size.width / 2.6,
                        child: Container(
                          height: isMobile ? 40 : 50,
                          color: Colors.yellow.shade100,
                          child: Center(
                            child: Text(vtDetails.DRIVERNAME,
                                style: isMobile
                                    ? mobileDetailsYellowBold
                                    : iPadDetailsYellowBold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: isMobile
                            ? MediaQuery.of(context).size.width / 2.6
                            : MediaQuery.of(context).size.width / 2.6,
                        // ? MediaQuery.of(context).size.width / 1.16
                        // : MediaQuery.of(context).size.width / 1.6,
                        child: Container(
                          height: isMobile ? 40 : 50,
                          color: Colors.yellow.shade300,
                          child: Center(
                            child: Text('Mobile No.',
                                style: isMobile
                                    ? mobileYellowTextFontStyleBold
                                    : iPadYellowTextFontStyleBold),
                          ),
                        ),
                      ),
                      // SizedBox(width: isMobile ? 5 :10),
                      SizedBox(
                        width: isMobile
                            // ? MediaQuery.of(context).size.width / 2.5
                            // : MediaQuery.of(context).size.width / 2.5,
                            ? MediaQuery.of(context).size.width / 2.1
                            : MediaQuery.of(context).size.width / 2.6,
                        child: Container(
                          height: isMobile ? 40 : 50,
                          color: Colors.yellow.shade300,
                          child: Center(
                            child: Text('Slot/ Dock Details',
                                style: isMobile
                                    ? mobileYellowTextFontStyleBold
                                    : iPadYellowTextFontStyleBold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: isMobile
                            ? MediaQuery.of(context).size.width / 2.6
                            : MediaQuery.of(context).size.width / 2.6,
                        // ? MediaQuery.of(context).size.width / 1.16
                        // : MediaQuery.of(context).size.width / 1.6,
                        child: Container(
                          height: isMobile ? 40 : 50,
                          color: Colors.yellow.shade100,
                          child: Center(
                            child: Text(vtDetails.DRIVERMOBILENO,
                                style: isMobile
                                    ? mobileDetailsYellowBold
                                    : iPadDetailsYellowBold),
                          ),
                        ),
                      ),
                      //  SizedBox(width: isMobile ? 5 :10),
                      SizedBox(
                        width: isMobile
                            ? MediaQuery.of(context).size.width / 2.1
                            : MediaQuery.of(context).size.width / 2.6,
                        // ? MediaQuery.of(context).size.width / 2.5
                        // : MediaQuery.of(context).size.width / 2.5,
                        child: Container(
                          height: isMobile ? 40 : 50,
                          color: Colors.yellow.shade100,
                          child: Center(
                            child: Text(vtDetails.SLOTTIME,
                                textAlign: TextAlign.center,
                                style: isMobile
                                    ? mobileDetailsYellowBold
                                    : iPadDetailsYellowBold),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //  SizedBox(height: 8),
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       SizedBox(
                  //         width: isMobile
                  //             ? MediaQuery.of(context).size.width / 1.16
                  //             : MediaQuery.of(context).size.width / 1.6,
                  //         child: Container(
                  //           height: isMobile ? 40 : 50,
                  //           color: Colors.yellow.shade300,
                  //           child: Center(
                  //             child: Text('Slot/ Dock Details',
                  //                 style: isMobile
                  //                     ? mobileYellowTextFontStyleBold
                  //                     : iPadYellowTextFontStyleBold),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       SizedBox(
                  //         width: isMobile
                  //             ? MediaQuery.of(context).size.width / 1.16
                  //             : MediaQuery.of(context).size.width / 1.6,
                  //         child: Container(
                  //           height: isMobile ? 40 : 50,
                  //           color: Colors.yellow.shade100,
                  //           child: Center(
                  //             child: Text(vtDetails.SLOTTIME,
                  //                 style: isMobile
                  //                     ? mobileDetailsYellowBold
                  //                     : iPadDetailsYellowBold),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  SizedBox(height: 8),
                 if (vehicleSMSToBind.isNotEmpty)
                  Text(
                    "Event Details",
                    style: isMobile
                        ? mobileHeaderFontStyle
                        : TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF11249F),
                          ),
                  ),
                     if (vehicleSMSToBind.isNotEmpty) SizedBox(height: 8),
                      if (vehicleSMSToBind.isNotEmpty)
                  for (vehicleSMS _sms in vehicleSMSToBind)
                    Padding(
                      padding:isMobile ?const EdgeInsets.only(bottom: 8.0)
                      : const EdgeInsets.only(bottom: 8.0 , left: 8.0,right: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: isMobile
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.width/1.2,
                            child: Container(
                              height: isMobile ? 40 : 50,
                              color: Colors.yellow.shade300,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: Text(_sms.SMSDate,
                                    textAlign: TextAlign.start,
                                    style: isMobile
                                        ? mobileDetailsYellowBold
                                        : iPadDetailsYellowBold),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: isMobile
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.width,
                            child: Container(
                              //  height: isMobile ? 100 : 50,
                              color: Colors.yellow.shade100,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 8.0, bottom: 8.0),
                                child: Text(_sms.SMSMessage,
                                    textAlign: TextAlign.left,
                                    style: isMobile
                                        ? mobileYellowTextFontStyleBold
                                        : iPadYellowTextFontStyleBold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
class CustomTicketShape extends CustomClipper<Path> {
  final bool isMobile;

  CustomTicketShape({required this.isMobile});

  @override
  Path getClip(Size size) {
    // print("listLength = " + listLength.toString());

    // final path = Path();
    // path.addRRect(RRect.fromRectAndRadius(
    //     Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(24)));
    // path.addOval(Rect.fromCircle(
    //     center: isMobile
    //         ?  Offset(0, (size.height/3.8 ) * 1.8)
    //         : Offset(0, (size.height / 3.3) * 1.8),
    //     radius: 20));
    // path.addOval(Rect.fromCircle(
    //     center: isMobile
    //         ?
    //              Offset(0, (size.height/3.8) * 1.8)
    //         : Offset(size.width, (size.height / 3.3) * 1.8),
    //     radius: 20));
    // path.fillType = PathFillType.evenOdd;

    // return path;
    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(24)));
    path.addOval(Rect.fromCircle(
        center: Offset(0, (size.height / 3) * 1.8), radius: 32));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, (size.height / 3) * 1.8), radius: 32));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
