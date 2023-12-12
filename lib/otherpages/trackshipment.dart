import 'dart:async';

import 'package:luxair/widgets/headerclipper.dart';
import 'package:luxair/widgets/timeline.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class TrackShipemnt extends StatefulWidget {
  const TrackShipemnt({Key? key}) : super(key: key);

  @override
  State<TrackShipemnt> createState() => _TrackShipemntState();
}

class TokenList {
  String tokenno;
  String placefrom;
  String placeto;
  String lastupdate;
  String partnerimgpath;
  String partner;

  TokenList(
      {required this.tokenno,
      required this.placefrom,
      required this.placeto,
      required this.lastupdate,
      required this.partnerimgpath,
      required this.partner});
}

class TokenListDetails {
  String tokenno;
  String statusdate;
  String statusinfo;
  int sortorder;

  TokenListDetails(
      {required this.tokenno,
      required this.statusdate,
      required this.statusinfo,
      required this.sortorder});
}

class _TrackShipemntState extends State<TrackShipemnt> {
  bool useMobileLayout = false,
      isLoading = false,
      isSerached = false,
      isValid = true;
  TextEditingController txtVTNO = new TextEditingController();
  // List<DockInOutVTDetails> dockInOutDets = [];
  List<TokenList> tokenListBind = [];
  List<TokenListDetails> tokenListDetsBind = [];

  List<TokenList> tokenListRandom = [
    TokenList(
        tokenno: "596712769074",
        placefrom: "Greenwood, Nova Scotia",
        placeto: "Winnipeg,Manitoba",
        lastupdate: "03 Dec 2022 16:23",
        partnerimgpath: "assets/images/cpost.png",
        partner: "Canada Post"),
    TokenList(
        tokenno: "458233331239",
        placefrom: "Red Deer, Alberta",
        placeto: "Portland,Oregon",
        lastupdate: "28 Nov 2022 19:23",
        partnerimgpath: "assets/images/dhlex.png",
        partner: "DHL Express"),
    TokenList(
        tokenno: "965327592629",
        placefrom: "Vancouver, British Columbia",
        placeto: "Maple Leaf,Seattle",
        lastupdate: "05 Dec 2022 02:23",
        partnerimgpath: "assets/images/ups.png",
        partner: "UPS"),
    TokenList(
        tokenno: "23789525941",
        placefrom: "Calgary, Alberta",
        placeto: "Edmonton,Alberta",
        lastupdate: "05 Dec 2022 09:23",
        partnerimgpath: "assets/images/cpost.png",
        partner: "Canada Post")
  ];

  List<TokenListDetails> tokenListDetsRandom = [
    TokenListDetails(
        tokenno: "458233331239",
        statusdate: "25 Nov 2022 10:23",
        statusinfo: "Received Shipment",
        sortorder: 0),
    TokenListDetails(
        tokenno: "458233331239",
        statusdate: "25 Nov 2022 18:23",
        statusinfo: "Arrived at DHL Express shipping facility",
        sortorder: 1),
    TokenListDetails(
        tokenno: "458233331239",
        statusdate: "26 Nov 2022 13:03",
        statusinfo: "Left from DHL Express shipping facility",
        sortorder: 2),
    TokenListDetails(
        tokenno: "458233331239",
        statusdate: "28 Nov 2022 00:44",
        statusinfo: "Accepted at destination DHL Express shipping facility",
        sortorder: 3),
    TokenListDetails(
        tokenno: "458233331239",
        statusdate: "28 Nov 2022 10:23",
        statusinfo: "Out for Delivery",
        sortorder: 4),
    TokenListDetails(
        tokenno: "458233331239",
        statusdate: "28 Nov 2022 19:23",
        statusinfo: "Shipment Delivered",
        sortorder: 5),
    TokenListDetails(
        tokenno: "23789525941",
        statusdate: "03 Dec 2022 11:44",
        statusinfo: "Received Shipment at Canada Post",
        sortorder: 0),
    TokenListDetails(
        tokenno: "23789525941",
        statusdate: "03 Dec 2022 13:03",
        statusinfo: "Left from post office",
        sortorder: 2),
    TokenListDetails(
        tokenno: "23789525941",
        statusdate: "04 Dec 2022 16:12",
        statusinfo: "Accepted at destination post",
        sortorder: 3),
    TokenListDetails(
        tokenno: "23789525941",
        statusdate: "04 Dec 2022 18:55",
        statusinfo: "Out for Delivery",
        sortorder: 4),
    TokenListDetails(
        tokenno: "965327592629",
        statusdate: "01 Dec 2022 13:55",
        statusinfo: "Received Shipment",
        sortorder: 0),
    TokenListDetails(
        tokenno: "965327592629",
        statusdate: "01 Dec 2022 19:49",
        statusinfo: "Arrived at UPS shipping facility",
        sortorder: 1),
    TokenListDetails(
        tokenno: "965327592629",
        statusdate: "03 Dec 2022 06:39",
        statusinfo: "Left from UPS shipping facility",
        sortorder: 2),
    TokenListDetails(
        tokenno: "965327592629",
        statusdate: "05 Dec 2022 02:23",
        statusinfo: "Accepted at destination UPS shipping facility",
        sortorder: 3),
    TokenListDetails(
        tokenno: "596712769074",
        statusdate: "30 Nov 2022 10:10",
        statusinfo: "Received Shipment at Canada Post",
        sortorder: 1),
    TokenListDetails(
        tokenno: "596712769074",
        statusdate: "01 Dec 2022 22:07",
        statusinfo: "Left from post office",
        sortorder: 2),
    TokenListDetails(
        tokenno: "596712769074",
        statusdate: "02 Dec 2022 11:07",
        statusinfo: "Accepted at destination Canada Post",
        sortorder: 3),
    TokenListDetails(
        tokenno: "596712769074",
        statusdate: "03 Dec 2022 09:07",
        statusinfo: "Out for Delivery",
        sortorder: 4),
    TokenListDetails(
        tokenno: "596712769074",
        statusdate: "03 Dec 2022 16:23",
        statusinfo: "Shipment Delivered",
        sortorder: 5),
  ];

  @override
  Widget build(BuildContext context) {
       var smallestDimension = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = smallestDimension < 600;

    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderClipperWave(
                color1: Color(0xFF3383CD),
                color2: Color(0xFF11249F),
                headerText: "Track Shipemnt"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 15.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 5,
                                // hard coding child width
                                child: Text(
                                  "VT No.",
                               style: useMobileLayout
                                ? mobileHeaderFontStyle
                                : TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF11249F),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    2, // hard coding child width
                                child: Container(
                                   height: useMobileLayout ? 40 : 65,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isValid
                                          ? Colors.grey.withOpacity(0.5)
                                          : Colors.red,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: TextField(
                                    controller: txtVTNO,
                                    maxLength: 15,
                                    readOnly: false,
                                    onChanged: (value) => runFilter(value),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter Tracking No.",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      counterText: "",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      isDense: true,
                                    ),
                                     style: useMobileLayout
                                  ? mobileTextFontStyle
                                  : TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSerached = true;
                                    runFilter(txtVTNO.text);
                                  });
                                },
                                child: Container(
                                  height: useMobileLayout ? MediaQuery.of(context).size.width /
                                      9.5 : MediaQuery.of(context).size.width / 14, // 65.0,
                                  width:  useMobileLayout ? MediaQuery.of(context).size.width /
                                      9.5 : MediaQuery.of(context).size.width / 14, 
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      begin: Alignment.center,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Color(0xFF1220BC),
                                        Color(0xFF3540E8),
                                      ],
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: MediaQuery.of(context).size.width /
                                        16, //32,
                                  ),
                                ),
                              )
                            ]),
                      ),
                    ]),
                    isLoading
                        ? Center(
                            child: Container(
                                height: 100,
                                width: 100,
                                child: CircularProgressIndicator()))
                        : (tokenListBind.length == 0 && isSerached)
                            ? Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          // hard coding child width
                                          child: Text(
                                            "No record found",
                                            style: useMobileLayout
                                ? mobileHeaderFontStyle
                                : TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF11249F),
                                  ),
                                          ),
                                        ),
                                      ]),
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (tokenListBind.length > 0)
                                    SizedBox(height: 10),
                                  if (tokenListBind.length > 0)
                                    Container(
                                      height: 1,
                                      width: MediaQuery.of(context).size.width /
                                          1.1,
                                      color: Color(0xFF11249F),
                                    ),
                                  if (tokenListBind.length > 0)
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 8.0, bottom: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  child: Text('From',
                                                      style: useMobileLayout
                                ? mobileHeaderFontStyle
                                : TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF11249F),
                                  )),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  child: Text(
                                                      tokenListBind[0]
                                                          .placefrom,
                                                      style:
                                                        useMobileLayout ?
                                                          mobileYellowTextFontStyleBold
                                                          : iPadYellowTextFontStyleBold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  child: Text('to',
                                                       style: useMobileLayout
                                ? mobileHeaderFontStyle
                                : TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF11249F),
                                  ),),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  child: Text(
                                                      tokenListBind[0].placeto,
                                                      style:
                                                            useMobileLayout ?
                                                          mobileYellowTextFontStyleBold
                                                          : iPadYellowTextFontStyleBold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  child: Text('Last update on',
                                                  style: useMobileLayout
                                ? mobileHeaderFontStyle
                                : TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF11249F),
                                  ),
                                                          ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  child: Text(
                                                      tokenListBind[0]
                                                          .lastupdate,
                                                      style:useMobileLayout ?
                                                          mobileYellowTextFontStyleBold
                                                          : iPadYellowTextFontStyleBold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (tokenListBind.length > 0)
                                    SizedBox(height: 5),
                                  if (tokenListBind.length > 0)
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            // hard coding child width
                                            child: Text(
                                              "Shipping Partner",
                                               style: useMobileLayout
                                ? mobileHeaderFontStyle
                                : TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF11249F),
                                  ),
                                            ),
                                          ),
                                          Image.asset(
                                              tokenListBind[0].partnerimgpath,
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.scaleDown),
                                        ]),
                                      ),
                                    ),
                                  if (tokenListBind.length > 0)
                                    SizedBox(height: 5),
                                  if (tokenListBind.length > 0)
                                    Card(
                                      child: Timeline(
                                        children: <Widget>[
                                          for (int i = 0;
                                              i < tokenListDetsBind.length;
                                              i++)
                                            Container(
                                              height: 100,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 12.0, left: 18),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        tokenListDetsBind[i]
                                                            .statusdate,
                                                        style: useMobileLayout ?
                                                        pendingGreyText :iPadpendingGreyText),
                                                    SizedBox(height: 5),
                                                    Text(
                                                        tokenListDetsBind[i]
                                                            .statusinfo,
                                                        style: useMobileLayout ?
                                                            completedBlackText :
                                                            iPadcompletedBlackText),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                        indicators: <Widget>[
                                          for (int i = 0;
                                              i < tokenListDetsBind.length;
                                              i++)
                                            Container(
                                              child: Icon(
                                                tokenListDetsBind[i]
                                                        .statusinfo
                                                        .toLowerCase()
                                                        .contains("out")
                                                    ? Icons.unarchive
                                                    : tokenListDetsBind[i]
                                                            .statusinfo
                                                            .toLowerCase()
                                                            .contains(
                                                                "delivered")
                                                        ? Icons
                                                            .check_circle_outline
                                                        : Icons.local_shipping,
                                                size: 32,
                                                color: tokenListDetsBind[i]
                                                        .statusinfo
                                                        .toLowerCase()
                                                        .contains("out")
                                                    ? Colors.orange.shade600
                                                    : tokenListDetsBind[i]
                                                            .statusinfo
                                                            .toLowerCase()
                                                            .contains(
                                                                "delivered")
                                                        ? Colors.green.shade400
                                                        : Colors.blue.shade400,

                                                ///Colors.blue.shade400,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                ],
                              )
                  ],
                ),
              ),
            ),
          ]),
    );
  }

  void runFilter(String enteredKeyword) {
    List<TokenList> results = [];
    List<TokenListDetails> results1 = [];

    tokenListBind = [];
    tokenListDetsBind = [];

    if (enteredKeyword.isEmpty) {
      setState(() {
        isValid = false;
      });
    } else {
      print("enteredKeyword length== " + enteredKeyword.length.toString());
      if (enteredKeyword.length < 12) {
        setState(() {
          tokenListBind = [];
          tokenListDetsBind = [];
         // isSerached = false;
          return;
        });
      } else {
        if (!isSerached) return;

        setState(() {
          isLoading = true;
        });

        Timer(Duration(seconds: 2), () {
          print("Yeah, this line is printed after 3 seconds");
          setState(() {
            isLoading = false;
          });
        });

        print("enteredKeyword == " + enteredKeyword.toLowerCase());

        results.addAll(tokenListRandom);
        results1.addAll(tokenListDetsRandom);

        print("results.length == " + results.length.toString());

        results.retainWhere((TokenList element) => element.tokenno
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()));

        results1.retainWhere((TokenListDetails element) => element.tokenno
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()));

        // print("results.length after filter == " + results.length.toString());
        results1.sort((a, b) => b.sortorder.compareTo(a.sortorder));
        setState(() {
          tokenListBind = results;
          tokenListDetsBind = results1;
        });
      }
    }
    // Refresh the UI
  }
}
