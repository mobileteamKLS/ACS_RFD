import 'package:luxair/dashboards/registeruser.dart';
import 'package:luxair/datastructure/slotbooking.dart';
import 'package:luxair/otherpages/trackshipment.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:luxair/dashboards/dashboard.dart';
import 'package:luxair/dashboards/homescreen.dart';
import 'package:luxair/datastructure/acceptancepod.dart';
import 'package:luxair/datastructure/userdetails.dart';
import 'package:luxair/datastructure/vehicletoken.dart';
import 'package:luxair/widgets/common.dart';
import 'package:luxair/widgets/customdialogue.dart';
import 'package:luxair/widgets/headers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../constants.dart';
import '../global.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = false;
  bool useMobileLayout = false;
  static List<UserDetails> userDetails = [];
  static final userCred = {'pUserID': "", "pPassword": ""};
  static List<UserOrganizationDetails> userOrganizationsList = [];
  static List<WarehouseTerminals> userTerminallist = [];
  static List<LableDisplay> lblDisplay = [];

  final userNameController = TextEditingController();
  final passWordController = TextEditingController();

  bool isUserNameEntered = true;
  bool isPasswordEntered = true;
  bool isLoading = false, isLoadingMain = false, showLabel = false;

  @override
  void initState() {
    //getLabelStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = smallestDimension < 600;
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          Stack(children: [
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
                  height: MediaQuery.of(context).size.height / 2.8, //200,
                ),
              ),
            ),
            ClipPath(
              //upper clippath with less height
              clipper: WaveClipper(), //set our custom wave clipper.
              child: Container(
                padding: EdgeInsets.only(bottom: 50),
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
                height: MediaQuery.of(context).size.height / 3,
                //180,
                alignment: Alignment.center,

                child: Container(
                  height: MediaQuery.of(context).size.height / 7, // 100,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset("assets/images/ACSLogo1.png",
                          fit: BoxFit.fill)),
                ),
              ),
            ),
          ]),
          isLoadingMain
              ? Center(
                  child: Container(
                      height: MediaQuery.of(context).size.height / 13,
                      width: MediaQuery.of(context).size.height / 13,
                      child: CircularProgressIndicator()))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Log in to your account ",
                      style: TextStyle(
                        fontSize: useMobileLayout
                            ? MediaQuery.of(context).size.width / 20
                            : 30,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF11249F),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      color: Colors.grey[200],
                      width: kIsWeb
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.width / 1.3,
                      child: Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height /
                                    15, //60,
                                decoration: BoxDecoration(
                                  border: isUserNameEntered
                                      ? Border(
                                          bottom: BorderSide(
                                              width: 0.0,
                                              color: Colors.transparent),
                                        )
                                      : Border(
                                          bottom: BorderSide(
                                              width: 1.0,
                                              color: Colors.red.shade800),
                                        ),
                                ),
                                child: TextField(
                                  onSubmitted: (value) async {
                                    if (value != null) if (value
                                            .toString()
                                            .trim() !=
                                        "") {
                                      print(value);
                                      await peformLogin();
                                    }
                                    // or do whatever you want when you are done editing
                                    // call your method/print values etc
                                  },
                                  readOnly: isLoading ? true : false,
                                  controller: userNameController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Username",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    isDense: true,
                                  ),
                                  style: useMobileLayout
                                      ? TextStyle(
                                          decoration: TextDecoration.none,
                                          color: // Colors.red,
                                              isUserNameEntered
                                                  ? const Color(0xff3a3a3a)
                                                  : Colors.red.shade800,
                                        )
                                      : TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 22.0,
                                          color: // Colors.red,
                                              isUserNameEntered
                                                  ? const Color(0xff3a3a3a)
                                                  : Colors.red.shade800,
                                          // color: Colors.black,
                                        ),
                                ),
                              ),
                              Container(
                                height: 2,
                                color: Colors.grey[200],
                                width: MediaQuery.of(context).size.width - 40,
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height /
                                    15, //60,
                                decoration: BoxDecoration(
                                  border: isPasswordEntered
                                      ? Border(
                                          bottom: BorderSide(
                                              width: 0.0,
                                              color: Colors.transparent),
                                        )
                                      : Border(
                                          bottom: BorderSide(
                                              width: 1.0,
                                              color: Colors.red.shade800),
                                        ),
                                ),
                                child: TextField(
                                  onSubmitted: (value) async {
                                    if (value != null) if (value
                                            .toString()
                                            .trim() !=
                                        "") {
                                      print(value);
                                      await peformLogin();
                                    }
                                    // or do whatever you want when you are done editing
                                    // call your method/print values etc
                                  },
                                  controller: passWordController,
                                  keyboardType: TextInputType.text,
                                  obscureText: showPassword ? false : true,
                                  readOnly: isLoading ? true : false,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          showPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: const Color(0xFF0461AA)),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          showPassword = !showPassword;
                                        });
                                      },
                                    ),
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    isDense: true,
                                  ),
                                  style: useMobileLayout
                                      ? TextStyle(
                                          decoration: TextDecoration.none,
                                          color: isPasswordEntered
                                              ? const Color(0xff3a3a3a)
                                              : Colors.red.shade800)
                                      : TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 22.0,
                                          color: isPasswordEntered
                                              ? const Color(0xff3a3a3a)
                                              : Colors.red.shade800),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // ElevatedButton(
                    //     onPressed: () async {
                    //       var isSent = await sendSMS(
                    //           "919890323584", "VT1234567890", "Shruti Thakur");
                    //       if (isSent == true) print("SMS sent");
                    //     },
                    //     child: Text("send")),
                    isLoading
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (isLoading) return;

                                  if (userNameController.text.isEmpty) {
                                    print("userNameController blank");
                                    setState(() {
                                      isUserNameEntered = false;
                                    });
                                    // return;
                                  } else {
                                    setState(() {
                                      isUserNameEntered = true;
                                    });
                                  }

                                  if (passWordController.text.isEmpty) {
                                    print("passWordController blank");
                                    setState(() {
                                      isPasswordEntered = false;
                                    });
                                    // return;
                                  } else {
                                    setState(() {
                                      isPasswordEntered = true;
                                    });
                                  }

                                  if (isUserNameEntered && isPasswordEntered) {
                                    var abc = await loginUser(context);
                                    if (abc == false)
                                      showAlertDialog(context, "OK", "Alert",
                                          "Username or Password is incorrect");
                                    else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Dashboards()),
                                      );

                                      print(abc.toString());
                                    }
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
                                  height: MediaQuery.of(context).size.height /
                                      13, //60,
                                  width: kIsWeb
                                      ? MediaQuery.of(context).size.width / 3
                                      : MediaQuery.of(context).size.width /
                                          1.8, //1.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        isLoading
                                            ? Colors.grey
                                            : Color(0xFF1220BC),
                                        isLoading
                                            ? Colors.grey
                                            : Color(0xFF3540E8),
                                      ],
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: useMobileLayout
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  22
                                              : 24,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                //Text('CONTAINED BUTTON'),
                              ),
                              SizedBox(width: 10),
                              Center(
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              13,
                                      width:
                                          MediaQuery.of(context).size.height /
                                              13,
                                      child: CircularProgressIndicator()))
                            ],
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              if (isLoading) return;

                              if (userNameController.text.isEmpty) {
                                print("userNameController blank");
                                setState(() {
                                  isUserNameEntered = false;
                                });
                                // return;
                              } else {
                                setState(() {
                                  isUserNameEntered = true;
                                });
                              }

                              if (passWordController.text.isEmpty) {
                                print("passWordController blank");
                                setState(() {
                                  isPasswordEntered = false;
                                });
                                // return;
                              } else {
                                setState(() {
                                  isPasswordEntered = true;
                                });
                              }

                              if (isUserNameEntered && isPasswordEntered) {
                                var abc = await loginUser(context);
                                if (abc == false)
                                  // showAlertDialog(context, "OK", "Alert",
                                  //     "Username or Password is incorrect");

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        customAlertMessageDialog(
                                            title: "Invalid Details",
                                            description:
                                                "Username or Password is incorrect",
                                            buttonText: "Okay",
                                            imagepath: 'assets/images/warn.gif',
                                            isMobile: useMobileLayout),
                                  );
                                else {
                                  if (kIsWeb && !isGHA) {
                                    // showAlertDialog(context, "OK", "Alert",
                                    //     "Your are not authorized to use this Application");

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          customAlertMessageDialog(
                                              title: "Invalid User",
                                              description:
                                                  "Your are not authorized to use this Application ",
                                              buttonText: "Okay",
                                              imagepath:
                                                  'assets/images/warn.gif',
                                              isMobile: useMobileLayout),
                                    );
                                  } else if (!useMobileLayout && !isTrucker) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          customAlertMessageDialog(
                                              title: "Invalid User",
                                              description:
                                                  "Your are not authorized to use this Application ",
                                              buttonText: "Okay",
                                              imagepath:
                                                  'assets/images/warn.gif',
                                              isMobile: useMobileLayout),
                                    );
                                  } else {
                                    print("isTrucker  =  " +
                                        isTrucker.toString());
                                    print("isGHA  =  " + isGHA.toString());
                                    print("isTPS  =  " + isTPS.toString());
                                    print("isTruckerFF  =  " +
                                        isTruckerFF.toString());
                                    await getUserLocation();
                                    await getTerminalsList();
                                    await getUserBranchList();
                                    await getVehicleTypesList();
                                    await getVehicleNoList();
                                    await getDriversList();

                                    if (isGHA) {
                                      await getDamageTypeList();
                                      await getAcceptanceResonList();
                                      await getRejectionReasonList();
                                      if (vehicletypesList.isEmpty)
                                        await getVehicleTypesList();
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Dashboards()),
                                    );

                                    print(abc.toString());
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)), //
                              padding: const EdgeInsets.all(0.0),
                            ),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height / 13, //60,
                              width: kIsWeb
                                  ? MediaQuery.of(context).size.width / 3
                                  : MediaQuery.of(context).size.width / 1.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    isLoading ? Colors.grey : Color(0xFF1220BC),
                                    isLoading ? Colors.grey : Color(0xFF3540E8),
                                  ],
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: useMobileLayout
                                          ? MediaQuery.of(context).size.width /
                                              22
                                          : 24,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            //Text('CONTAINED BUTTON'),
                          ),
                  ],
                ),
          if (!isLoadingMain)
            useMobileLayout
                ? SizedBox(
                    width: kIsWeb
                        ? MediaQuery.of(context).size.width / 3
                        : MediaQuery.of(context).size.width / 1.1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => TrackShipemnt()),
                                  );
                                },
                                child: Text(
                                  showLabel ? "Track Shipment" : "",
                                  style: TextStyle(
                                    fontSize: useMobileLayout
                                        ? MediaQuery.of(context).size.width / 23
                                        : 24,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF11249F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => RegisterUser()),
                              );
                            },
                            child: Text(
                              showLabel ? "Register Now" : "",
                              style: TextStyle(
                                fontSize: useMobileLayout
                                    ? MediaQuery.of(context).size.width / 23
                                    : 24,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF11249F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    width: kIsWeb
                        ? MediaQuery.of(context).size.width / 3
                        : MediaQuery.of(context).size.width / 1.1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.start,

                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          GestureDetector(
                            onTap: () {
                              if (!isLoading)
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                );
                            },
                            child: Text(
                              "Back to Dashboard",
                              style: TextStyle(
                                fontSize: useMobileLayout
                                    ? MediaQuery.of(context).size.width / 23
                                    : 24,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF11249F),
                              ),
                            ),
                          ),
                          // Text(
                          //   " ",
                          //   style: TextStyle(
                          //     fontSize: useMobileLayout
                          //         ? MediaQuery.of(context).size.width / 23
                          //         : 24,
                          //     fontWeight: FontWeight.normal,
                          //     color: Color(0xFF11249F),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
        ])));
  }

  getUserLocation() async {
    if (isLoading) return;

    // userOrganizationsList = [];
    // userTerminallist = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "OperationType": "1",
    };
    await Global()
        .postData(
      Settings.SERVICES['GetLocation'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);
      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      setState(() {
        locationDetailsSaved = resp
            .map<LocationDetails>((json) => LocationDetails.fromJson(json))
            .toList();

        print("length locationDetailsSaved = " +
            locationDetailsSaved.length.toString());
        isLoading = false;
      });
    }).catchError((onError) {
      // setState(() {
      //   isLoading = false;
      // });
      print(onError);
    });
  }

  peformLogin() async {
    print(" performing login");

    if (isLoading) return;

    if (userNameController.text.isEmpty) {
      print("userNameController blank");
      setState(() {
        isUserNameEntered = false;
      });
      // return;
    } else {
      setState(() {
        isUserNameEntered = true;
      });
    }

    if (passWordController.text.isEmpty) {
      print("passWordController blank");
      setState(() {
        isPasswordEntered = false;
      });
      // return;
    } else {
      setState(() {
        isPasswordEntered = true;
      });
    }

    if (isUserNameEntered && isPasswordEntered) {
      var abc = await loginUser(context);
      if (abc == false)
        // showAlertDialog(context, "OK", "Alert",
        //     "Username or Password is incorrect");

        showDialog(
          context: context,
          builder: (BuildContext context) => customAlertMessageDialog(
              title: "Invalid Details",
              description: "Username or Password is incorrect",
              buttonText: "Okay",
              imagepath: 'assets/images/warn.gif',
              isMobile: useMobileLayout),
        );
      else {
        if (kIsWeb && !isGHA) {
          // showAlertDialog(context, "OK", "Alert",
          //     "Your are not authorized to use this Application");

          showDialog(
            context: context,
            builder: (BuildContext context) => customAlertMessageDialog(
                title: "Invalid User",
                description: "Your are not authorized to use this Application ",
                buttonText: "Okay",
                imagepath: 'assets/images/warn.gif',
                isMobile: useMobileLayout),
          );
        } else if (!useMobileLayout && !isTrucker) {
          showDialog(
            context: context,
            builder: (BuildContext context) => customAlertMessageDialog(
                title: "Invalid User",
                description: "Your are not authorized to use this Application ",
                buttonText: "Okay",
                imagepath: 'assets/images/warn.gif',
                isMobile: useMobileLayout),
          );
        } else {
          print("isTrucker  =  " + isTrucker.toString());
          print("isGHA  =  " + isGHA.toString());
          print("isTPS  =  " + isTPS.toString());
          print("isTruckerFF  =  " + isTruckerFF.toString());
          await getUserLocation();
          await getTerminalsList();
          await getUserBranchList();
          await getVehicleTypesList();
          await getVehicleNoList();
          await getDriversList();
          if (isGHA) {
            await getDamageTypeList();
            await getAcceptanceResonList();
            await getRejectionReasonList();
            if (vehicletypesList.isEmpty) await getVehicleTypesList();
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Dashboards()),
          );

          print(abc.toString());
        }
      }
    }
  }

  Future<bool> loginUser(BuildContext context) async {
    try {
      bool isValid = false;
      print("This is new function");
      userCred['pUserID'] = userNameController.text;
      userCred['pPassword'] = passWordController.text;

      setState(() {
        isLoading = true;
      });
      //showLoadingDialog(context, true);
      await Global()
          .postData(
        Settings.SERVICES['Login'],
        userCred,
      )
          .then((response) {
        setState(() {
          isLoading = false;
        });
        //  showLoadingDialog(context, false);
        // print(response);
        var inValidMsg = "Please enter valid credentials.";
        if (json.decode(response.body)['d'].toString().toLowerCase() ==
            inValidMsg.toLowerCase()) {
          print('Provided Username and Password is incorrect');
          isValid = false;

          // return;
        } else {
          isGHA = false;
          isTrucker = false;
          isTruckerFF = false;
          isTPS = false;
          // isCB = false;
          // isAirline = false;

          showLoadingDialog(context, true);
          // print(json.decode(response.body)['d']);
          // var msg = json.decode(response.body)['d'];

          var msg = json.decode(response.body)['d'];
          // var parsed = json.decode(msg)['StatusMessage'];
          // var table = json.decode(parsed)['Table'];

          var resp = json.decode(msg).cast<Map<String, dynamic>>();
          var resp1 = json.decode(msg).cast<Map<String, dynamic>>();
          userDetails = resp
              .map<UserDetails>((json) => UserDetails.fromJson(json))
              .toList();

          final List<dynamic> namesList =
              resp.map((e) => e["OrganizationBranchId"]).toSet().toList();
          print(namesList.length);

          var organizationsAccess = namesList.join(', ');
          print(organizationsAccess.toString());

          final List<dynamic> namesList1 =
              resp1.map((e1) => e1["OrganizationTypeId"]).toSet().toList();
          print(namesList1.length);

          if (namesList1.contains(10)) isGHA = true;

          if (namesList1.contains(3) && namesList1.contains(5))
            isTruckerFF = true;

          if (namesList1.contains(3)) isTruckerFF = true;

          if (namesList1.contains(25)) isTPS = true;

          if (namesList1.contains(5) && !namesList1.contains(3))
            isTrucker = true;

          // if (namesList1.contains(4)) isAirline = true;

          var organizationTypes = namesList1.join(', ');
          print(organizationTypes.toString());

          print(userDetails.length);

          if (userDetails.length > 0) if (userDetails.length > 0)
            setState(() {
              if (isTruckerFF && userDetails.length > 1) {
                loggedinUser = new UserDetails(
                    UserId: userDetails[1].UserId,
                    OrgName: userDetails[1].OrgName,
                    Name: userDetails[1].Name,
                    EmailId: userDetails[1].EmailId,
                    MobileNo: userDetails[1].MobileNo,
                    OrganizationBranchId: userDetails[1].OrganizationBranchId,
                    OrganizationId: userDetails[1].OrganizationId,
                    CreatedByUserId: userDetails[1].CreatedByUserId,
                    OrganizationTypeId: userDetails[1].OrganizationTypeId,
                    IsWFSIntegration: userDetails[1].IsWFSIntegration,
                    OrganizationBranchIdString: organizationsAccess,
                    OrganizationtypeIdString: organizationTypes);

                setPreferences(userDetails[1]);
              } else {
                loggedinUser = new UserDetails(
                    UserId: userDetails[0].UserId,
                    OrgName: userDetails[0].OrgName,
                    Name: userDetails[0].Name,
                    EmailId: userDetails[0].EmailId,
                    MobileNo: userDetails[0].MobileNo,
                    OrganizationBranchId: userDetails[0].OrganizationBranchId,
                    OrganizationId: userDetails[0].OrganizationId,
                    CreatedByUserId: userDetails[0].CreatedByUserId,
                    OrganizationTypeId: userDetails[0].OrganizationTypeId,
                    IsWFSIntegration: userDetails[0].IsWFSIntegration,
                    OrganizationBranchIdString: organizationsAccess,
                    OrganizationtypeIdString: organizationTypes);

                setPreferences(userDetails[0]);
              }
            });
          isValid = true;
          showLoadingDialog(context, false);
        }

        // print("parsed " + table.toString());
      }).catchError((onError) {
        //isValid=false;
        showLoadingDialog(context, false);
        setState(() {
          isLoading = false;
        });
        print(onError);
        //return false;
      });
      return isValid;
    } catch (Exc) {
      print(Exc);
      return false;
    }
  }

  getLabelStatus() async {
    if (isLoadingMain) return;

    setState(() {
      isLoadingMain = true;
    });

    var queryParams = {};
    await Global()
        .postData(
      Settings.SERVICES['ShowTrackShipmentLabel'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      lblDisplay = resp
          .map<LableDisplay>((json) => LableDisplay.fromJson(json))
          .toList();

      print("length lblDisplay = " + lblDisplay.length.toString());

      setState(() {
        showLabel = lblDisplay[0].showLable;
        isLoadingMain = false;
      });
    }).catchError((onError) {
      // setState(() {
      //   isLoading = false;
      // });
      print(onError);
    });
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

      WarehouseTerminals wt =
          new WarehouseTerminals(custudian: 0, custodianName: "Select");
      terminalsList.add(wt);
      terminalsList.sort((a, b) => a.custudian.compareTo(b.custudian));

      print("length terminalsList = " + terminalsList.length.toString());

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

  getUserBranchList() async {
    if (isLoading) return;

    userOrganizationsList = [];
    userTerminallist = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "UserId": loggedinUser.CreatedByUserId,
    };
    await Global()
        .postData(
      Settings.SERVICES['UsersBranchList'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      userOrganizationsList = resp
          .map<UserOrganizationDetails>(
              (json) => UserOrganizationDetails.fromJson(json))
          .toList();

      print("length userOrganizationsList = " +
          userOrganizationsList.length.toString());

      for (UserOrganizationDetails uod in userOrganizationsList) {
        for (WarehouseTerminals wtml in terminalsList) {
          {
            print(wtml.custudian.toString() +
                " - " +
                wtml.custodianName.toString());
            if (uod.OrganizationBranchId == wtml.custudian)
              userTerminallist.add(wtml);
          }
        }
      }
      print("length userTerminallist = " + userTerminallist.length.toString());

      if (userTerminallist.length > 0) {
        terminalsList = userTerminallist;

        selectedTerminal = terminalsList[0].custodianName;
        selectedTerminalID = int.parse(terminalsList[0].custudian.toString());
      } else {
        selectedTerminalID = loggedinUser.OrganizationBranchId;
      }

      print("length terminalsList = " + terminalsList.length.toString());
      print("selectedTerminal = " + selectedTerminal.toString());
      print("selectedTerminalID = " + selectedTerminalID.toString());

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

  getDamageTypeList() async {
    if (isLoading) return;

    damageTypeList = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "OperationType": "1",
    };
    await Global()
        .postData(
      Settings.SERVICES['Get_ReasonAndDamageList'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);
      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      setState(() {
        damageTypeList =
            resp.map<DamageType>((json) => DamageType.fromJson(json)).toList();

        DamageType dt = new DamageType(DamageID: 0, Damage: "Select");
        damageTypeList.add(dt);
        damageTypeList.sort((a, b) => a.DamageID.compareTo(b.DamageID));

        print("length damageTypeList = " + damageTypeList.length.toString());
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
  }

  getAcceptanceResonList() async {
    if (isLoading) return;

    acceptanceTypeList = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "OperationType": "3",
    };
    await Global()
        .postData(
      Settings.SERVICES['Get_ReasonAndDamageList'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      setState(() {
        acceptanceTypeList = resp
            .map<AcceptanceType>((json) => AcceptanceType.fromJson(json))
            .toList();

        AcceptanceType at = new AcceptanceType(ReasonID: 0, Reason: "Select");
        acceptanceTypeList.add(at);
        acceptanceTypeList.sort((a, b) => a.ReasonID.compareTo(b.ReasonID));

        print("length acceptanceTypeList = " +
            acceptanceTypeList.length.toString());
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
  }

  getRejectionReasonList() async {
    if (isLoading) return;

    rejectionReasonsList = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "OperationType": "2",
    };
    await Global()
        .postData(
      Settings.SERVICES['Get_ReasonAndDamageList'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);
      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      setState(() {
        rejectionReasonsList = resp
            .map<AcceptanceType>((json) => AcceptanceType.fromJson(json))
            .toList();

        AcceptanceType dt = new AcceptanceType(ReasonID: 0, Reason: "Select");
        rejectionReasonsList.add(dt);
        rejectionReasonsList.sort((a, b) => a.ReasonID.compareTo(b.ReasonID));

        print("length rejectionReasonsList = " +
            rejectionReasonsList.length.toString());
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
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

      Vehicletypes vt =
          new Vehicletypes(TruckTypeId: 0, TruckTypeName: "Select");
      vehicletypesList.add(vt);
      vehicletypesList.sort((a, b) => a.TruckTypeId.compareTo(b.TruckTypeId));

      print("length vehicletypesList = " + vehicletypesList.length.toString());

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

  getDriversList() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "OrganisationBranchID": selectedTerminalID,
    };
    await Global()
        .postData(
      Settings.SERVICES['GetDriversList'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      // print(response.body);

      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      driverNamesList = resp
          .map<DriverDetails>((json) => DriverDetails.fromJson(json))
          .toList();

      print("length driverNamesList = " + driverNamesList.length.toString());

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

  getVehicleNoList() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "OrganisationBranchID": selectedTerminalID,
    };
    await Global()
        .postData(
      Settings.SERVICES['GetVehicleNoList'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      //print(response.body);

      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      vehicleNosList =
          resp.map<VehicleNos>((json) => VehicleNos.fromJson(json)).toList();

      print("length vehicleNosList = " + vehicleNosList.length.toString());

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

  void setPreferences(UserDetails _userDets) async {
    //print(_userDets);
    print(" *******  saving user details");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn_WFS_LUX", true);
    prefs.setString("logindate_WFS_LUX", DateTime.now().toString());
    prefs.setString("OrgName_WFS_LUX", _userDets.OrgName);

    prefs.setInt("UserId_WFS_LUX", _userDets.CreatedByUserId);
    prefs.setInt("OrganizationId_WFS_LUX", _userDets.OrganizationId);
    prefs.setInt(
        "OrganizationBranchId_WFS_LUX", _userDets.OrganizationBranchId);
    prefs.setInt("OrganizationTypeId_WFS_LUX", _userDets.OrganizationTypeId);
  }

// showAlertDialog(context, buttonText, titleText, msgText) {
//   // set up the button
//   Widget okButton = TextButton(
//     child: Text(buttonText),
//     onPressed: () {
//       Navigator.of(context).pop();
//     },
//   );

//   // set up the AlertDialog
//   AlertDialog alert = AlertDialog(
//     title: Text(
//       titleText,
//       style: TextStyle(
//           fontFamily: 'Roboto', fontSize: 16, color: Colors.red.shade800),
//     ),
//     content: Text(
//       msgText,
//       style: TextStyle(fontFamily: 'Roboto', fontSize: 12),
//     ),
//     actions: [
//       okButton,
//     ],
//   );

//   // show the dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }
}
