import 'package:camera/camera.dart';

class ListingDetails {
  dynamic hawbNumber;
  String mawbNumber;
  String origin;
  String originAirportCode;
  String destination;
  String destinationAirportCode;
  String sbNumber;
  int awbId;
  int sbId;
  String tspSetting;
  String flightDate;
  int piecesCount;
  String custodian;
  double weight;
  String unit;
  String truckerId;
  dynamic truckerName;

  ListingDetails({
    required this.hawbNumber,
    required this.mawbNumber,
    required this.origin,
    required this.originAirportCode,
    required this.destination,
    required this.destinationAirportCode,
    required this.sbNumber,
    required this.awbId,
    required this.sbId,
    required this.tspSetting,
    required this.flightDate,
    required this.piecesCount,
    required this.custodian,
    required this.weight,
    required this.unit,
    required this.truckerId,
    required this.truckerName,
  });

  factory ListingDetails.fromJson(Map<String, dynamic> json) => ListingDetails(
        hawbNumber: json["HAWBNumber"] == null ? "" : json["HAWBNumber"],
        mawbNumber: json["MAWBNumber"]== null ? "" :json["MAWBNumber"],
        origin: json["ORIGIN"]== null ? "" :json["ORIGIN"],
        originAirportCode: json["ORIGINAIRPORTCODE"]== null ? "" :json["ORIGINAIRPORTCODE"],
        destination: json["DESTINATION"]== null ? "" :json["DESTINATION"],
        destinationAirportCode: json["DESTINATIONAIRPORTCODE"]== null ? "" : json["DESTINATIONAIRPORTCODE"],
        sbNumber: json["SBNumber"] == null ? "" : json["SBNumber"],
        awbId: json["AWBID"]== null ? 0 :json["AWBID"],
        sbId: json["SBID"] == null ? 0 : json["SBID"],
        tspSetting: json["TSPSetting"]== null ? "" :json["TSPSetting"],
        flightDate: json["FlightDate"] == null ? "" : json["FlightDate"],
        piecesCount: json["PiecesCount"]== null ? 0 : json["PiecesCount"],
        custodian: json["Custodian"]==null?"":json["Custodian"],
        weight: json["Weight"]== null ? 0 : json["Weight"],
        unit: json["Unit"]== null ? "" :json["Unit"],
        truckerId: json["TruckerID"]== null ? "" :json["TruckerID"],
        truckerName: json["truckerName"] == null ? "" : json["truckerName"],
      );

  Map<String, dynamic> toMap() => {
        "HAWBNumber": hawbNumber,
        "MAWBNumber": mawbNumber,
        "ORIGIN": origin,
        "ORIGINAIRPORTCODE": originAirportCode,
        "DESTINATION": destination,
        "DESTINATIONAIRPORTCODE": destinationAirportCode,
        "SBNumber": sbNumber,
        "AWBID": awbId,
        "SBID": sbId,
        "TSPSetting": tspSetting,
        "FlightDate": flightDate,
        "PiecesCount": piecesCount,
        "Custodian": custodian,
        "Weight": weight,
        "Unit": unit,
        "TruckerID": truckerId,
        "truckerName": truckerName,
      };
}



class ListingAssignTruckingDetails {
  String mawbNumber;
  String prefix;
  int nop;
  double grwt;
  String unit;
  String ffName;
  String hawbNo;
  String truckingCompany;
  String ITNNo;
  String ITNDate;
  int awbId;
  int hawbID;
  int OrganizationBranchID;
  int CreatedBy;

  bool? isSelected;

  ListingAssignTruckingDetails({
    required this.mawbNumber,
    required this.prefix,
    required this.nop,
    required this.grwt,
    required this.unit,
    required this.ffName,
    required this.hawbNo,
    required this.truckingCompany,
    required this.ITNNo,
    required this.ITNDate,
    required this.awbId,
    required this.hawbID,
    required this.OrganizationBranchID,
    required this.CreatedBy,
    this.isSelected = false});


  factory ListingAssignTruckingDetails.fromJson(Map<String, dynamic> json) {
    return ListingAssignTruckingDetails(
      mawbNumber: json["MAWBNumber"]== null ? "" :json["MAWBNumber"],
      prefix: json["AirlinePrefix"]== null ? "" :json["AirlinePrefix"],
      nop: json["SBNOP"]== null ? "" :json["SBNOP"],
      grwt: json["SBNGrWt"]== null ? "" :json["SBNGrWt"],
      unit: json["SBUnit"]== null ? "" :json["SBUnit"],
      ffName: json["FFName"]== null ? "" :json["FFName"],
      hawbNo: json["HAWBNo"]== null ? "" :json["HAWBNo"],
      truckingCompany: json["TruckingCompany"]== "" ? "" :json["TruckingCompany"],
      ITNNo: json["ITN No"]== null ? "" :json["ITN No"],
      ITNDate: json["ITN Date"]== null ? "" :json["ITN Date"],
      awbId: json["AWBID"]== "" ? "" :json["AWBID"],
      hawbID: json["HAWBID"]== "" ? "" :json["HAWBID"],
      OrganizationBranchID: json["OrganizationBranchID"]== null ? "" :json["OrganizationBranchID"],
      CreatedBy: json["CreatedBy"]== null ? "" :json["CreatedBy"],


    );
  }

  Map<String, dynamic> toMap() => {
    "MAWBNumber": mawbNumber,
    "AirlinePrefix" : prefix,
    "SBNOP": nop,
    "SBNGrWt" : grwt,
    "SBUnit": unit,
    "FFName" : ffName,
    "HAWBNo": hawbNo,
    "TruckingCompany": truckingCompany,
    "ITN No" : ITNNo,
    "ITN Date" : ITNDate,
    "AWBID": awbId,
    "HAWBID":hawbID,
    "OrganizationBranchID" : OrganizationBranchID,
    "CreatedBy" : CreatedBy,


  };
}


