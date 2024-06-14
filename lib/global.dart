import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:luxair/datastructure/acceptancepod.dart';

import 'constants.dart';
import 'datastructure/slotbooking.dart';
import 'datastructure/userdetails.dart';
import 'datastructure/vehicletoken.dart';

// import 'constants/constants.dart';
// import 'datastructures/shipmentdetails.dart';

bool isTrucker = false;
bool isTruckerFF = false;
bool isGHA = false;
bool isTPS = false;
bool isFF = false;
bool isAirline = false;
bool isExport = true;

int currUserId = 0;
int orgId = 0;
UserDetails loggedinUser = new UserDetails(
    UserId: "",
    OrgName: "",
    Name: "",
    EmailId: "",
    MobileNo: "",
    OrganizationBranchId: 0,
    OrganizationId: 0,
    CreatedByUserId: 0,
    OrganizationTypeId: 0,
    IsWFSIntegration: "",
    OrganizationBranchIdString: "",
    OrganizationtypeIdString: "");
String displayName = "un";
String selectedTerminal = "";
int selectedTerminalID = 0;
List suspendedBY = [];
List<WarehouseTerminals> terminalsList = [];
List<Vehicletypes> vehicletypesList = [];
List<DamageType> damageTypeList = [];
List<AcceptanceType> rejectionReasonsList = [];

List<Airport> airportList = [];
List<AirlinesPrefix> airlinesPrefixList = [];

List<AcceptanceType> acceptanceTypeList = [];
List<LocationDetails> locationDetailsSaved = [];

List<VehicleNos> vehicleNosList = [];
List<DriverDetails> driverNamesList = [];
List<AssignTrucker> trucker = [];

double latitude = 0, longitude = 0;

class Global {
  // static List<TerminalDetails> termDets = [];
  // static List<PortDetails> portDets = [];
  // static List<ContainerMaster> containerMstDets = [];
  // static List<VesselMaster> vesselMaster = [];

  Future<Post> postData(service, payload) async {
   print("payload " + payload.toString());
    print("encoded payload " + json.encode(payload));

    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.none) {
    //   this.showToast("No internet Connection Available !");
    // } else {
    return fetchData(service, payload);
    //}
  }

  Future<Post> fetchData(apiname, payload) async {
    var newURL = Settings.ACSServiceURL + apiname;
    print("fetch data for API = " + newURL);
    if (payload == "") {
      print("payload blank");
      return await http.post(
        Uri.parse(newURL),
        body: json.encode({}),
        headers: {
          'Content-Type': 'application/json',
        },
      ).then((http.Response response) {
        print(response.body);
        print(response.statusCode);

        final int statusCode = response.statusCode;
        if (statusCode == 401) {
          return Post.fromJson(response.body, statusCode);
        }
        //  if (statusCode == 404) {
        //   return Post.fromJson(response.body, statusCode);
        // }
        if (statusCode < 200 || statusCode > 400) {
          throw new Exception("Error while fetching data");
        }
        print("sending data to post");
        return Post.fromJson(response.body, statusCode);
      });
    } else {
      return await http.post(
        Uri.parse(newURL),
        body: json.encode(payload),
        headers: {
          'Content-Type': 'application/json',
        },
      ).then((http.Response response) {
        print(response.body);
        print(response.statusCode);

        final int statusCode = response.statusCode;
        if (statusCode == 401) {
          return Post.fromJson(response.body, statusCode);
        }
        if (statusCode < 200 || statusCode > 400) {
          return Post.fromJson(response.body, statusCode);
        }
        print("sending data to post");
        return Post.fromJson(response.body, statusCode);
      });
    }
    //return http.get(Uri.parse('http://113.193.225.56:8080/POCMobile/api/DOAPILogin'));
  }

  Future<Post> setData(apiname, payload) async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.none) {
    //   this.showToast("No internet Connection Available !");
    // } else {
    return saveData(apiname, payload);
    //}
  }

  Future<Post> saveData(apiname, payload) async {
    var newURL = Settings.ACSServiceURL + apiname;
    print("save data for API = " + newURL);
    // print(newURL);
    print("payload " + json.encode(payload));
    return await http
        .post(
          Uri.parse(newURL),
          body: json.encode(payload),
          headers: {
            'Content-Type': 'application/json',
          },
        )
        .then((http.Response response) {
          print("response received");
          print(response.body);

          final int statusCode = response.statusCode;
          if (statusCode == 401) {
            return Post.fromJson(response.body, statusCode);
          }
          if (statusCode < 200 || statusCode > 400 || json == null) {
            throw new Exception("Error while fetching data");
          }
          return Post.fromJson(response.body, statusCode);
        })
        .catchError((onError) {})
        .whenComplete(() {
          print("completed");
        })
        .catchError((onError) => print(onError));
  }

  Future<Post> fetchDataLoadUnload(payload) async {
    print("fetchDataLoadUnload payload " + payload.toString());
        print("fetchDataLoadUnload encoded payload " + json.encode(payload));
    var newURL =
        "https://atlacssrv.kalelogistics.com/ACS_ML/api/DockTime/Predict22";
    print("fetch data for API = " + newURL);

    return await http.post(
      Uri.parse(newURL),
      body: json.encode(payload),
      headers: {
        'Content-Type': 'application/json',
      },
    ).then((http.Response response) {
      print(response.body);
      print(response.statusCode);

      final int statusCode = response.statusCode;
      if (statusCode == 401) {
        return Post.fromJson(response.body, statusCode);
      }
      if (statusCode < 200 || statusCode > 400) {
        return Post.fromJson(response.body, statusCode);
      }
      print("sending data to post");
      return Post.fromJson(response.body, statusCode);
    });
  }
}

class Post {
  final int statusCode;
  final String body;

  Post({required this.statusCode, required this.body});

  factory Post.fromJson(String json, int statusCode) {
    return Post(
      statusCode: statusCode,
      body: json,
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["statusCode"] = statusCode;
    map["body"] = body;
    return map;
  }
}
