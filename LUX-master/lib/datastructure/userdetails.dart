

class UserOrganizationDetails {
  final String UserId;
  final int OrganizationId;
  final String OrgName;
  final int OrganizationBranchId;
  final String OrgBranchName;
  final int OrganizationTypeId;

  UserOrganizationDetails({
    required this.UserId,
    required this.OrganizationId,
    required this.OrgName,
    required this.OrganizationBranchId,
    required this.OrgBranchName,
    required this.OrganizationTypeId,
  });
  factory UserOrganizationDetails.fromJson(Map<String, dynamic> json) {
    return UserOrganizationDetails(
      UserId: json['UserId'] == null ? "" : json['UserId'],
      OrganizationId:
          json['OrganizationId'] == null ? 0 : json['OrganizationId'],
      OrgName: json['OrgName'] == null ? "" : json['OrgName'],
      OrganizationBranchId: json['OrganizationBranchId'] == null
          ? 0
          : json['OrganizationBranchId'],
      OrgBranchName: json['OrgBranchName'] == null ? "" : json['OrgBranchName'],
      OrganizationTypeId:
          json['OrganizationTypeId'] == null ? 0 : json['OrganizationTypeId'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["UserId"] = UserId;
    map["OrganizationId"] = OrganizationId;
    map["OrgName"] = OrgName;
    map["OrganizationBranchId"] = OrganizationBranchId;
    map["OrgBranchName"] = OrgBranchName;
    map["OrganizationTypeId"] = OrganizationTypeId;
    return map;
  }
}

class UserDetails {
  final String UserId;
  final String OrgName;
  final String Name;
  final String EmailId;
  final String MobileNo;
  final int OrganizationBranchId;
  final int OrganizationId;
  final int CreatedByUserId;
  final int OrganizationTypeId;
  final String IsWFSIntegration;
  String OrganizationBranchIdString;
  String OrganizationtypeIdString;

  UserDetails({
    required this.UserId,
    required this.OrgName,
    required this.Name,
    required this.EmailId,
    required this.MobileNo,
    required this.OrganizationBranchId,
    required this.OrganizationId,
    required this.CreatedByUserId,
    required this.OrganizationTypeId,
    required this.IsWFSIntegration,
    required this.OrganizationBranchIdString,
    required this.OrganizationtypeIdString,
  });
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      UserId: json['UserId'] == null ? "" : json['UserId'],
      OrgName: json['OrgName'] == null ? "" : json['OrgName'],
      Name: json['Name'] == null ? "" : json['Name'],
      EmailId: json['EmailId'] == null ? "" : json['EmailId'],
      MobileNo: json['MobileNo'] == null ? "" : json['MobileNo'],
      OrganizationBranchId: json['OrganizationBranchId'] == null
          ? 0
          : json['OrganizationBranchId'],
      OrganizationId:
          json['OrganizationId'] == null ? 0 : json['OrganizationId'],
      CreatedByUserId:
          json['CreatedByUserId'] == null ? 0 : json['CreatedByUserId'],
      OrganizationTypeId:
          json['OrganizationTypeId'] == null ? 0 : json['OrganizationTypeId'],
      IsWFSIntegration:
          json['IsWFSIntegration'] == null ? "" : json['IsWFSIntegration'],
      OrganizationBranchIdString: "",
      OrganizationtypeIdString: "",
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["UserId"] = UserId;
    map["OrgName"] = OrgName;
    map["Name"] = Name;
    map["EmailId"] = EmailId;
    map["MobileNo"] = MobileNo;
    map["OrganizationBranchId"] = OrganizationBranchId;
    map["OrganizationId"] = OrganizationId;
    map["CreatedByUserId"] = CreatedByUserId;
    map["OrganizationTypeId"] = OrganizationTypeId;
    map["IsWFSIntegration"] = IsWFSIntegration;
    map["OrganizationBranchIdString"] = OrganizationBranchIdString;
    map["OrganizationtypeIdString"] = OrganizationtypeIdString;
    return map;
  }
}

//[{"Latitude":"19.46626366","Longitude":"72.81160143","IsActive":true,"RadiousinMeter":50}]
class LocationDetails {
  final String Latitude;
  final String Longitude;
  final bool IsActive;
  final double RadiousinMeter;

  LocationDetails({
    required this.Latitude,
    required this.Longitude,
    required this.IsActive,
    required this.RadiousinMeter,
  });

  factory LocationDetails.fromJson(Map<String, dynamic> json) {
    return LocationDetails(
      Latitude: json['Latitude'] == null ? "" : json['Latitude'],
      Longitude: json['Longitude'] == null ? "" : json['Longitude'],
      IsActive: json['IsActive'] == null ? false : json['IsActive'],
      RadiousinMeter:
          json['RadiousinMeter'] == null ? 0 : json['RadiousinMeter'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["Latitude"] = Latitude;
    map["Longitude"] = Longitude;
    map["IsActive"] = IsActive;
    map["RadiousinMeter"] = RadiousinMeter;
    return map;
  }
}
