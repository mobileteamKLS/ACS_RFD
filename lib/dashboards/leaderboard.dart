import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:luxair/widgets/piechart.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE7E5E5),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HeaderClipperWave(
              //     color1: Color(0xFF3383CD),
              //     color2: Color(0xFF11249F),
              //     headerText: "Dashboard"),
              // SizedBox(width: 10),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, bottom: 8.0),
                          child: Container(
                            // height: 170,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                GraphCards(Color(0xFF24c6dc), Color(0xFF514a9d),
                                    "Trucks", "16", "Booked", "20", "Arrived"),
                                GraphCards(
                                    Color(0xFFf2709c),
                                    Color(0xFFff9472),
                                    "Shipments",
                                    "4",
                                    "Processed",
                                    "20",
                                    "Booked"),
                                GraphCards(
                                    Color(0xFFff4b1f),
                                    Color(0xFFff9068),
                                    "Shipments",
                                    "5",
                                    "Accepted",
                                    "1",
                                    "Rejected"),
                                GraphCards(Color(0xFF134e5e), Color(0xFF71b280),
                                    "Docks", "4", "Occupied", "9", "Total"),
                             Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 170,
                                    width: 250,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Color(0xFF4364F7),
                                          Color(0xFFa8c0ff),
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Processed",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "16",
                                                  style: TextStyle(
                                                      fontSize: 48,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(height: 16),
                                                Text(
                                                  "at verification counter", // 'QR code',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                               
                              ]),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, bottom: 8.0, top: 16.0),
                              child: Container(
                                //  height: 220,
                                width: kIsWeb
                                    ? MediaQuery.of(context).size.width / 1.58
                                    : MediaQuery.of(context).size.width / 1.65,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Vehicle Timings (Hourly)",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22,
                                            child: Text(
                                              "",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          SizedBox(
                                            width: kIsWeb
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.5
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4,
                                            child: Text(
                                              "Vehicle Type",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
                                            child: Text(
                                              "Wait Time",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
                                            child: Text(
                                              "Dwell Time",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      VehicleTimingRow(
                                          Colors.red,
                                          Icons.arrow_drop_up,
                                          "Crane",
                                          "122",
                                          "127"),
                                      VehicleTimingRow(
                                          Colors.green,
                                          Icons.arrow_drop_down,
                                          "Lowboy",
                                          "125",
                                          "127"),
                                      VehicleTimingRow(
                                          Colors.red,
                                          Icons.arrow_drop_up,
                                          "40-53 ft Trailer",
                                          "64",
                                          "66"),
                                      VehicleTimingRow(
                                          Colors.green,
                                          Icons.arrow_drop_down,
                                          "Flat-bed/Box Truck(10-12 ft)",
                                          "50",
                                          "45"),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, bottom: 8.0),
                              child: Container(
                                  height: 330,
                                  width: kIsWeb
                                      ? MediaQuery.of(context).size.width / 1.58
                                      : MediaQuery.of(context).size.width /
                                          1.65,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Commodities Handled (Weekly)",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "General Cargo",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              new LinearPercentIndicator(
                                                width: kIsWeb
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2.5
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2.5,
                                                lineHeight: 12.0,
                                                percent: 0.5,
                                                progressColor: Colors.blue,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "50%",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Perishables",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              new LinearPercentIndicator(
                                                width: kIsWeb
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2.5
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2.5,
                                                lineHeight: 12.0,
                                                percent: 0.7,
                                                progressColor: Colors.orange,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "60%",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Hazardous",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              new LinearPercentIndicator(
                                                width: kIsWeb
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2.5
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2.5,
                                                lineHeight: 12.0,
                                                percent: 0.3,
                                                progressColor: Colors.red,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "30%",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Medicines",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              new LinearPercentIndicator(
                                                width: kIsWeb
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2.5
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2.5,
                                                lineHeight: 12.0,
                                                percent: 0.9,
                                                progressColor: Colors.green,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "80%",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ))),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 330,
                                    width: kIsWeb
                                        ? MediaQuery.of(context).size.width / 5
                                        : 240,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                         Text(
                                          "Total",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          "Walk-in (Weekly)",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        CircularPercentIndicator(
                                          radius: 100.0,
                                          animation: true,
                                          animationDuration: 1200,
                                          lineWidth: 15.0,
                                          percent: 0.4,
                                          center: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      color: Color(0xFF22c5f8),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  new Text(
                                                    "10 Import",
                                                    style: new TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      color: Color(0xFF5746f9),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  new Text(
                                                    "40 Export",
                                                    style: new TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          circularStrokeCap:
                                              CircularStrokeCap.butt,
                                          backgroundColor: Color(0xFF5746f9),
                                          progressColor: Color(
                                              0xFF22c5f8), //Color(#FF#22c5f8),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  height: 330,
                                  width: kIsWeb
                                      ? MediaQuery.of(context).size.width / 5
                                      : 250,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                         Text(
                                          "Total",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      Text(
                                        "Web (Weekly)",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CircularPercentIndicator(
                                        radius: 100.0,
                                        animation: true,
                                        animationDuration: 1200,
                                        lineWidth: 15.0,
                                        percent: 0.5,
                                        center: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    color: Color(0xFF22c5f8),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                new Text(
                                                  "20 Import",
                                                  style: new TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    color: Color(0xFF5746f9),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                new Text(
                                                  "20 Export",
                                                  style: new TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.butt,
                                        backgroundColor: Color(0xFF5746f9),
                                        progressColor: Color(
                                            0xFF22c5f8), //Color(#FF#22c5f8),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  height: 330,
                                  width: kIsWeb
                                      ? MediaQuery.of(context).size.width / 5
                                      : 250,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                         Text(
                                          "Total",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      Text(
                                        "Mobiles (Weekly)",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CircularPercentIndicator(
                                        radius: 100.0,
                                        animation: true,
                                        animationDuration: 1200,
                                        lineWidth: 15.0,
                                        percent: 1.0,
                                        center: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    color: Color(0xFF22c5f8),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                new Text(
                                                  "20 Import",
                                                  style: new TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0),
                                                ),
                                              ],
                                            ),
                                            // SizedBox(height: 10),
                                            // Row(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.center,
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.center,
                                            //   children: [
                                            //     Container(
                                            //       height: 20,
                                            //       width:20,
                                            //       decoration: BoxDecoration(
                                            //         borderRadius:
                                            //             BorderRadius.all(
                                            //                 Radius.circular(
                                            //                     20)),
                                            //         color: Color(0xFF5746f9),
                                            //       ),
                                            //     ),
                                            //     SizedBox(width: 10),
                                            //     new Text(
                                            //       "20 Export",
                                            //       style: new TextStyle(
                                            //           fontWeight:
                                            //               FontWeight.bold,
                                            //           fontSize: 20.0),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.butt,
                                        backgroundColor: Color(0xFF5746f9),
                                        progressColor: Color(
                                            0xFF22c5f8), //Color(#FF#22c5f8),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

//ontainer(child: PieChartSample2()),
                          ],
                        ),
                      ]),
                  // SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 300,
                          // width: 250,
                          width: kIsWeb
                              ? MediaQuery.of(context).size.width / 2
                              : 800,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              PieChartSample2(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const <Widget>[
                                  Indicator(
                                    color: Color(0xff3887fe),
                                    text: 'Lowboy',
                                    isSquare: true,
                                    title: "40%",
                                    isWeb: kIsWeb,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Indicator(
                                    color: Color(0xffee984d),
                                    text: 'Crane',
                                    isSquare: true,
                                    title: "30%",
                                    isWeb: kIsWeb,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Indicator(
                                    color: Color(0xffab4eba),
                                    text: 'Flat-bed',
                                    isSquare: true,
                                    title: "15%",
                                    isWeb: kIsWeb,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Indicator(
                                    color: Color(0xff26af61),
                                    text: '40-53ft Trailer',
                                    isSquare: true,
                                    title: "15%",
                                    isWeb: kIsWeb,
                                  ),
                                  // SizedBox(
                                  //   height: 18,
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Container(
                      //   height: 300,
                      //   // width: 250,
                      //   width: kIsWeb
                      //       ? MediaQuery.of(context).size.width / 1.5
                      //       : 300,
                      //   decoration: BoxDecoration(
                      //     borderRadius:
                      //         BorderRadius.all(Radius.circular(20)),
                      //     color: Colors.white,
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: const <Widget>[
                      //       Indicator(
                      //         color: Color(0xff3887fe),
                      //         text: 'Lowboy',
                      //         isSquare: true,
                      //         title: "40%",
                      //       ),
                      //       SizedBox(
                      //         height: 8,
                      //       ),
                      //       Indicator(
                      //         color: Color(0xffee984d),
                      //         text: 'Crane',
                      //         isSquare: true,
                      //         title: "30%",
                      //       ),
                      //       SizedBox(
                      //         height: 8,
                      //       ),
                      //       Indicator(
                      //         color: Color(0xffab4eba),
                      //         text: 'Flat-bed',
                      //         isSquare: true,
                      //         title: "15%",
                      //       ),
                      //       SizedBox(
                      //         height: 8,
                      //       ),
                      //       Indicator(
                      //         color: Color(0xff26af61),
                      //         text: '40-53ft Trailer',
                      //         isSquare: true,
                      //         title: "15%",
                      //       ),
                      //       // SizedBox(
                      //       //   height: 18,
                      //       // ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}

List<VBarChartModel> bardata = [
  VBarChartModel(
    index: 0,
    label: "Medicines",
    colors: [Colors.orange, Colors.deepOrange],
    jumlah: 55,
    tooltip: "55%",
    description: Text(
      "Most handled good last week",
      style: TextStyle(fontSize: 10),
    ),
  ),
  VBarChartModel(
    index: 1,
    label: "General Cargo",
    colors: [Colors.blue, Colors.blueAccent],
    jumlah: 20,
    tooltip: "20%",
    // description: Text(
    //   "",
    //   style: TextStyle(fontSize: 10),
    // ),
  ),
  VBarChartModel(
    index: 2,
    label: "Electronics",
    colors: [Colors.teal, Colors.indigo],
    jumlah: 12,
    tooltip: "12%",
  ),
  VBarChartModel(
    index: 5,
    label: "Food",
    colors: [Colors.purple, Colors.deepPurple],
    jumlah: 30,
    tooltip: "30 %",
    description: Text(
      "Favorites vegetables",
      style: TextStyle(fontSize: 10),
    ),
  ),
];

class GraphCards extends StatelessWidget {
  // const GraphCards({
  //   Key? key,
  // }) : super(key: key);

  GraphCards(this.color1, this.color2, this.btnText1, this.btnText2,
      this.btnText3, this.btnText4, this.btnText5);

  final Color color1;
  final Color color2;
  final String btnText1;
  final String btnText2;
  final String btnText3;
  final String btnText4;
  final String btnText5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 170,
        width: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topCenter,
            colors: [
              color1, // Color(0xFF24c6dc),
              color2, //Color(0xFF514a9d),
            ],
          ),
        ),
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                btnText1,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            // SizedBox(
            //   height: 16,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: kIsWeb ? 100 : 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        btnText2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        btnText3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  width: 2,
                  color: Colors.white, //Color(0xFF3540E8),
                ),
                SizedBox(
                  width: kIsWeb ? 100 : 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        btnText4,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        btnText5,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //                       SizedBox(
            //                         height: 16,
            //                       ),
            //  Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //      SizedBox( width: kIsWeb
            //                   ? 100
            //                   : 80,
            //        child: Text(
            //             btnText3,
            //             textAlign: TextAlign.center,
            //             style: TextStyle(
            //                 fontSize: 20,
            //                 fontWeight: FontWeight.normal,
            //                 color: Colors.white),
            //           ),
            //      ),
            //      SizedBox(
            //                         width: 16,
            //                       ),
            //     SizedBox( width: kIsWeb
            //                   ? 100
            //                   : 80,
            //       child: Text(
            //         btnText5,
            //             textAlign: TextAlign.center,
            //         style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.normal,
            //             color: Colors.white),
            //       ),
            //     ),
            //   ],
            // ),
            // // Row(
            // //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // //   crossAxisAlignment: CrossAxisAlignment.center,
            // //   children: [
            // //     Column(
            // //       mainAxisAlignment: MainAxisAlignment.center,
            // //       crossAxisAlignment: CrossAxisAlignment.center,
            // //       children: [
            // //         Text(
            // //           btnText2,
            // //           style: TextStyle(
            // //               fontSize: 48,
            // //               fontWeight: FontWeight.bold,
            // //               color: Colors.white),
            // //         ),
            // //         SizedBox(height: 5),
            // //         Text(
            // //           btnText3,
            // //           style: TextStyle(
            // //               fontSize: 20,
            // //               fontWeight: FontWeight.normal,
            // //               color: Colors.white),
            // //         ),
            // //       ],
            // //     ),
            // //     Column(
            // //       mainAxisAlignment: MainAxisAlignment.center,
            // //       crossAxisAlignment: CrossAxisAlignment.center,
            // //       children: [
            // //         Text(
            // //           btnText4,
            // //           style: TextStyle(
            // //               fontSize: 48,
            // //               fontWeight: FontWeight.bold,
            // //               color: Colors.white),
            // //         ),
            // //         SizedBox(height: 5),
            // //         // Text(
            // //         //   "Trucks", // 'QR code',
            // //         //   style: TextStyle(
            // //         //       fontSize: 20,
            // //         //       fontWeight: FontWeight.normal,
            // //         //       color: Colors.white),
            // //         // ),
            // //         Text(
            // //           btnText5,
            // //           style: TextStyle(
            // //               fontSize: 20,
            // //               fontWeight: FontWeight.normal,
            // //               color: Colors.white),
            // //         ),
            // //       ],
            // //     ),
            // //   ],
            // // ),
          ],
        ),
      ),
    );
  }
}

class VehicleTimingRow extends StatelessWidget {
  VehicleTimingRow(
      this.color1, this.lblicon, this.btnText1, this.btnText2, this.btnText3);

  final Color color1;
  final IconData lblicon;
  final String btnText1;
  final String btnText2;
  final String btnText3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 35,
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Color(0xFFE7E5E5),
              ),
              child: Icon(
                lblicon, // Icons.qr_code,
                size: 36, color: color1,
              ),

              //     Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Icon(
              //       lblicon, // Icons.qr_code,
              //       size: 36, color: color1,

              //     ),
              //   ],
              // ),
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: kIsWeb
                ? MediaQuery.of(context).size.width / 3.5
                : MediaQuery.of(context).size.width / 4,
            child: Text(
              btnText1,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 8,
            child: Text(
              btnText2,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 8,
            child: Text(
              btnText3,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
