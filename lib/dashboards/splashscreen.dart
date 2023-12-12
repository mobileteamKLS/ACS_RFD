import 'dart:async';
import 'dart:convert';

import 'package:luxair/datastructure/slotbooking.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:luxair/dashboards/dashboard.dart';
import 'package:luxair/dashboards/login.dart';
import 'package:luxair/datastructure/acceptancepod.dart';
import 'package:luxair/datastructure/userdetails.dart';
import 'package:luxair/datastructure/vehicletoken.dart';
import 'package:luxair/widgets/common.dart';
import 'package:luxair/widgets/customdialogue.dart';

import '../constants.dart';
import '../global.dart';
import 'homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool useMobileLayout = false;
  bool isLoading = false;
  static List<UserDetails> userDetails = [];
  static List<UserOrganizationDetails> userOrganizationsList = [];
  static List<WarehouseTerminals> userTerminallist = [];

  static final savedUserCred = {
    'UserID': 0,
    "OrganizationId": 0,
    "OrganizationTypeId": 0
  };

  @override
  void initState() {
    checkLocation();

    // getDeviceType();
    // sendToNextPage();
    //  getUserLocation();
    super.initState();
  }

  checkLocation() async {
    try {
      var abc = await determinePosition1();
      print(abc);
      if (abc.toLowerCase().contains("disabled")) {
        showDialog(
          context: context,
          builder: (BuildContext context) => customAlertMessageDialog(
              title: "Location Disabled",
              description: abc.toString(),
              buttonText: "Okay",
              imagepath: 'assets/images/warn.gif',
              isMobile: useMobileLayout),
        );
        return;
      }

      if (abc.toLowerCase().contains("denied")) {
        showDialog(
          context: context,
          builder: (BuildContext context) => customAlertMessageDialog(
              title: "Location Access Denied",
              description: abc.toString(),
              buttonText: "Okay",
              imagepath: 'assets/images/warn.gif',
              isMobile: useMobileLayout),
        );
        return;
      }

      if (abc.toLowerCase().contains("ok")) {
        getDeviceType();
        sendToNextPage();
      }
    } catch (Exc) {
      print(Exc);
    } finally {
      print("this is finally");
    }
  }

  Future<String> determinePosition1() async {
    bool serviceEnabled;
    // LocationPermission permission;
    String locationMsg = "";
    //  await Geolocator.requestPermission();
    //   // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      locationMsg =
          'Location services are disabled. Kindly enable from Phone settings.';
      // return Future.error('Location services are disabled.');
    } else {
      LocationPermission permission = await Geolocator.requestPermission();

      permission = await Geolocator.checkPermission();
      // LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationMsg =
              'Location permissions are denied. Restart app and select "While using" or "Always" when asked for location ';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        //permission = await Geolocator.requestPermission();
        // Permissions are denied forever, handle appropriately.
        locationMsg =
            'Location permissions are permanently denied, we cannot request permissions.Kindly allow from Phone settings.';
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        locationMsg = 'OK';
      }
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    //return await Geolocator.getCurrentPosition();
    return locationMsg;
  }

  void getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    if (data.size.shortestSide < 600) {
      setState(() {
        useMobileLayout = true;
      });
    }

    // return data.size.shortestSide < 600 ? DeviceType.Phone : DeviceType.Tablet;
  }

  Future<bool> getStoredPreferences() async {
    bool isDetsStored = false;
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//             prefs.clear();
    await SharedPreferences.getInstance().then((value) {
      if (value.getBool("isLoggedIn_WFS") != null) {
        print("isDetsStored = true");
        savedUserCred["UserID"] = value.getInt("UserId_WFS_LUX")!;
        savedUserCred["OrganizationId"] = value.getInt("OrganizationId_WFS_LUX")!;
        savedUserCred["OrganizationTypeId"] =
            value.getInt("OrganizationTypeId_WFS")!;
        isDetsStored = true;
      }

      print(value.getInt("UserId_WFS_LUX"));
    });

    return isDetsStored;
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

  void sendToNextPage() async {
    bool retVal = await getStoredPreferences();
    if (retVal == true) {
      print("saved use received");
      // load other values and transfer to Dashboard
      var abc = await loginUser(context, savedUserCred["UserID"]);
      if (abc == true) {
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
        print("All loading completed here");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Dashboards()));
      }
    } else {
      await getTerminalsList();
      await getUserBranchList();
      await getVehicleTypesList();
      await getVehicleNoList();
      await getDriversList();
      await getDamageTypeList();
      await getAcceptanceResonList();
      await getRejectionReasonList();

      print(" *******  saved use NOT received");
      if (useMobileLayout) {
        Timer(
            Duration(seconds: 4),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginPage())));
      } else {
        Timer(
            Duration(seconds: 4),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen())));
      }
    }
  }

  Future<bool> loginUser(BuildContext context, userID) async {
    try {
      bool isValid = false;
      print("This is new function");

      setState(() {
        isLoading = true;
      });
      //showLoadingDialog(context, true);
      await Global()
          .postData(
        Settings.SERVICES['ExistingUserLogin'],
        savedUserCred,
      )
          .then((response) {
        setState(() {
          isLoading = false;
        });
        //  showLoadingDialog(context, false);
        // print(response);
        //https://yvruatsrv.kalelogistics.com/srvmobile.asmx?op=AUTGetLoginUserDetailByUserId
        var inValidMsg = "Please enter valid credentials.";
        if (json.decode(response.body)['d'].toString().toLowerCase() ==
            inValidMsg.toLowerCase()) {
          print('Provided Username and Password is incorrect');
          isValid = false;
        } else {
          isGHA = false;
          isTrucker = false;
          isTruckerFF = false;
          isTPS = false;

          // showLoadingDialog(context, true);
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

                // setPreferences(userDetails[1]);
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

                // setPreferences(userDetails[0]);
              }
            });
          isValid = true;
          // showLoadingDialog(context, false);
        }

        // print("parsed " + table.toString());
      }).catchError((onError) {
        //isValid=false;
        //showLoadingDialog(context, false);
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

  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = smallestDimension < 600;
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: useMobileLayout
            ? Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.asset("assets/images/kls.jpg",
                            fit: BoxFit.fitHeight)),
                    SizedBox(width: 40), //YVRLogo_CMYK
                    // ClipRRect(
                    //     borderRadius: BorderRadius.circular(5),
                    //     child: Image.asset("assets/images/WFS_logo.png",
                    //         fit: BoxFit.scaleDown)),
                    // ClipRRect(
                    //     borderRadius: BorderRadius.circular(5),
                    //     child: Image.asset("assets/images/YVRLogo_CMYK.jpg",
                    //         fit: BoxFit.scaleDown)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset("assets/images/splash1.gif",
                          fit: BoxFit.fitHeight),
                    ),
                  ],
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 180.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.asset("assets/images/kls.jpg",
                              fit: BoxFit.fitHeight)),
                      SizedBox(height: 40),
                      // ClipRRect(
                      //     borderRadius: BorderRadius.circular(5),
                      //     child: Image.asset("assets/images/WFS_logo.png",
                      //         fit: BoxFit.scaleDown)),
                      // ClipRRect(
                      //     borderRadius: BorderRadius.circular(5),
                      //     child: Image.asset("assets/images/YVRLogo_CMYK.jpg",
                      //         fit: BoxFit.scaleDown)),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset("assets/images/splash1.gif",
                            fit: BoxFit.fitHeight),
                      ),
                    ],
                  ),
                ),
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
}
