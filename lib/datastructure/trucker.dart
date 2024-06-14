import 'package:camera/camera.dart';

class ListingAssignTruckingDetails {
  String mawbNumber;
  String prefix;
  // int nop;
  // double grwt;
  // String unit;
  // String ffName;
  // String hawbNo;
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
    // required this.nop,
    // required this.grwt,
    // required this.unit,
    // required this.ffName,
    // required this.hawbNo,
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
      // nop: json["SBNOP"]== null ? "" :json["SBNOP"],
      // grwt: json["SBNGrWt"]== null ? "" :json["SBNGrWt"],
      // unit: json["SBUnit"]== null ? "" :json["SBUnit"],
      // ffName: json["FFName"]== null ? "" :json["FFName"],
      // hawbNo: json["HAWBNo"]== null ? "" :json["HAWBNo"],
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
    // "SBNOP": nop,
    // "SBNGrWt" : grwt,
    // "SBUnit": unit,
    // "FFName" : ffName,
    // "HAWBNo": hawbNo,
    "TruckingCompany": truckingCompany,
    "ITN No" : ITNNo,
    "ITN Date" : ITNDate,
    "AWBID": awbId,
    "HAWBID":hawbID,
    "OrganizationBranchID" : OrganizationBranchID,
    "CreatedBy" : CreatedBy,


  };
}


