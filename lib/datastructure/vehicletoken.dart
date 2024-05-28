class VehicleToken {
  final String SLOTTIME;
  final String VTNo;
  final bool tpscheckInstatus;
  final String DOCKNAME;
  final String DRIVERNAME;
  final String VEHICLENO;

  final String Mode;
  final String VTDate;
  final String TruckTypeName;
  final String EMAILID;
  final String DRIVERMOBILENO;
  final String HandlerBranchId;
  final String Column1;
  final int isHHT;
  final String TruckingCompanyName;
  final String tpscheckInTimestamp;
  final bool DockInstatus;
  final String DockInTimestamp;
  final bool Dockoutstatus;
  final String DockoutTimestamp;
  final bool tpscheckoutstatus;
  final String tpscheckoutTimestamp;

  VehicleToken({
    required this.SLOTTIME,
    required this.VTNo,
    required this.tpscheckInstatus,
    required this.DOCKNAME,
    required this.DRIVERNAME,
    required this.VEHICLENO,
    required this.Mode,
    required this.VTDate,
    required this.TruckTypeName,
    required this.EMAILID,
    required this.DRIVERMOBILENO,
    required this.HandlerBranchId,
    required this.Column1,
    required this.isHHT,
    required this.TruckingCompanyName,
    required this.tpscheckInTimestamp,
    required this.DockInstatus,
    required this.DockInTimestamp,
    required this.Dockoutstatus,
    required this.DockoutTimestamp,
    required this.tpscheckoutstatus,
    required this.tpscheckoutTimestamp,
  });

  factory VehicleToken.fromJson(Map<String, dynamic> json) {
    return VehicleToken(
      SLOTTIME: json['SLOTTIME'] == null ? "" : json['SLOTTIME'],
      VTNo: json['VTNo'] == null ? "" : json['VTNo'],
      tpscheckInstatus: json['tpscheckInstatus'] == null
          ? false
          : json['tpscheckInstatus'] == "true"
              ? true
              : false,
      // json['tpscheckInstatus'] == null ? "" : json['tpscheckInstatus'],
      DOCKNAME: json['DOCKNAME'] == null ? "--" : json['DOCKNAME'],
      DRIVERNAME: json['DRIVERNAME'] == null ? "" : json['DRIVERNAME'],
      VEHICLENO: json['VEHICLENO'] == null ? "" : json['VEHICLENO'],
      Mode: json['Mode'] == null ? "" : json['Mode'],
      VTDate: json['VTDate'] == null ? "" : json['VTDate'],
      TruckTypeName: json['TruckTypeName'] == null ? "" : json['TruckTypeName'],
      EMAILID: json['EMAILID'] == null ? "" : json['EMAILID'],
      DRIVERMOBILENO:
          json['DRIVERMOBILENO'] == null ? "" : json['DRIVERMOBILENO'],
      HandlerBranchId:
          json['HandlerBranchId'] == null ? "" : json['HandlerBranchId'],
      Column1: json['Column1'] == null ? "" : json['Column1'],
      isHHT: json['isHHT'] == null ? 0 : json['isHHT'],
      TruckingCompanyName: json['TruckingCompanyName'] == null
          ? ""
          : json['TruckingCompanyName'],
      tpscheckInTimestamp: json['tpscheckInTimestamp'] == null
          ? ""
          : json['tpscheckInTimestamp'],
      DockInstatus: json['DockInstatus'] == null
          ? false
          : json['DockInstatus'] == "true"
              ? true
              : false,
      DockInTimestamp:
          json['DockInTimestamp'] == null ? "" : json['DockInTimestamp'],
      Dockoutstatus: json['Dockoutstatus'] == null
          ? false
          : json['Dockoutstatus'] == "true"
              ? true
              : false,
      DockoutTimestamp:
          json['DockoutTimestamp'] == null ? "" : json['DockoutTimestamp'],
      tpscheckoutstatus: json['tpscheckoutstatus'] == null
          ? false
          : json['tpscheckoutstatus'] == "true"
              ? true
              : false,
      tpscheckoutTimestamp: json['tpscheckoutTimestamp'] == null
          ? ""
          : json['tpscheckoutTimestamp'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["SLOTTIME"] = SLOTTIME;
    map["VTNo"] = VTNo;
    map["tpscheckInstatus"] = tpscheckInstatus;
    map["DOCKNAME"] = DOCKNAME;
    map["DRIVERNAME"] = DRIVERNAME;
    map["VEHICLENO"] = VEHICLENO;

    map["Mode"] = Mode;
    map["VTDate"] = VTDate;
    map["TruckTypeName"] = TruckTypeName;
    map["EMAILID"] = EMAILID;
    map["DRIVERMOBILENO"] = DRIVERMOBILENO;
    map["HandlerBranchId"] = HandlerBranchId;
    map["Column1"] = Column1;
    map["isHHT"] = isHHT;
    map["TruckingCompanyName"] = TruckingCompanyName;
    map["tpscheckInTimestamp"] = tpscheckInTimestamp;
    map["DockInstatus"] = DockInstatus;
    map["DockInTimestamp"] = DockInTimestamp;
    map["Dockoutstatus"] = Dockoutstatus;
    map["DockoutTimestamp"] = DockoutTimestamp;
    map["tpscheckoutstatus"] = tpscheckoutstatus;
    map["tpscheckoutTimestamp"] = tpscheckoutTimestamp;
    return map;
  }
}

class vehicleSMS {
  final String SMSDate;
  final String SMSMessage;
  final String MobileNo;
  vehicleSMS({
    required this.SMSDate,
    required this.SMSMessage,
    required this.MobileNo,
  });

  factory vehicleSMS.fromJson(Map<String, dynamic> json) {
    return vehicleSMS(
      SMSDate: json['SMSDate'] == null ? "" : json['SMSDate'],
      SMSMessage: json['SMSMessage'] == null ? "" : json['SMSMessage'],
      MobileNo: json['MobileNo'] == null ? "" : json['MobileNo'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["SMSDate"] = SMSDate;
    map["SMSMessage"] = SMSMessage;
    map["MobileNo"] = MobileNo;
    return map;
  }
}

class VehicleShipmentDetails {
  final String AWBNo;
  final String TokenNo;
  final String Status;
  final String Reason;
  VehicleShipmentDetails({
    required this.AWBNo,
    required this.TokenNo,
    required this.Status,
    required this.Reason,
  });

  factory VehicleShipmentDetails.fromJson(Map<String, dynamic> json) {
    return VehicleShipmentDetails(
      AWBNo: json['AWBNo'] == null ? "" : json['AWBNo'],
      TokenNo: json['TokenNo'] == null ? "" : json['TokenNo'],
      Status: json['Status'] == null ? "" : json['Status'],
      Reason: json['Reason'] == null ? "" : json['Reason'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["AWBNo"] = AWBNo;
    map["TokenNo"] = TokenNo;
    map["Status"] = Status;
    map["Reason"] = Reason;
    return map;
  }
}

class VehicleTrackingDetails {
  final String Name;
  final String Status;
  final String VehicleDateTime;
  VehicleTrackingDetails({
    required this.Name,
    required this.Status,
    required this.VehicleDateTime,
  });

  factory VehicleTrackingDetails.fromJson(Map<String, dynamic> json) {
    return VehicleTrackingDetails(
      Name: json['Name'] == null ? "" : json['Name'],
      Status: json['Status'] == null ? "" : json['Status'],
      VehicleDateTime:
          json['VehicleDateTime'] == null ? "" : json['VehicleDateTime'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["Name"] = Name;
    map["Status"] = Status;
    map["VehicleDateTime"] = VehicleDateTime;
    return map;
  }
}

class DockInOutVT {
  final String Mode;
  final String VTNo;
  final String VTDate;
  final String VEHICLENO;
  final String TruckTypeName;
  final String DRIVERNAME;
  final String EMAILID;
  final String DRIVERMOBILENO;
  final int HandlerBranchId;
  final int isHHT;
  final String TruckingCompanyName;
  final bool tpscheckInstatus;
  final String tpscheckInTimestamp;
  final bool DockInstatus;
  final String DockInTimestamp;
  final bool Dockoutstatus;
  final String DockoutTimestamp;
  final bool tpscheckoutstatus;
  final String tpscheckoutTimestamp;
  final String SLOTTIME;
  final String DOCKNAME;
  final String DRIVERLICENSE;
  final String STA;

  DockInOutVT({
    required this.Mode,
    required this.VTNo,
    required this.VTDate,
    required this.VEHICLENO,
    required this.TruckTypeName,
    required this.DRIVERNAME,
    required this.EMAILID,
    required this.DRIVERMOBILENO,
    required this.HandlerBranchId,
    required this.isHHT,
    required this.TruckingCompanyName,
    required this.tpscheckInstatus,
    required this.tpscheckInTimestamp,
    required this.DockInstatus,
    required this.DockInTimestamp,
    required this.Dockoutstatus,
    required this.DockoutTimestamp,
    required this.tpscheckoutstatus,
    required this.tpscheckoutTimestamp,
    required this.SLOTTIME,
    required this.DOCKNAME,
    required this.DRIVERLICENSE,
    required this.STA,
  });

  factory DockInOutVT.fromJson(Map<String, dynamic> json) {
    return DockInOutVT(
      Mode: json['Mode'] == null ? "" : json['Mode'],
      VTNo: json['VTNo'] == null ? "" : json['VTNo'],
      VTDate: json['VTDate'] == null ? "" : json['VTDate'],
      VEHICLENO: json['VEHICLENO'] == null ? "" : json['VEHICLENO'],
      TruckTypeName: json['TruckTypeName'] == null ? "" : json['TruckTypeName'],
      DRIVERNAME: json['DRIVERNAME'] == null ? "" : json['DRIVERNAME'],
      EMAILID: json['EMAILID'] == null ? "" : json['EMAILID'],
      DRIVERMOBILENO:
          json['DRIVERMOBILENO'] == null ? "" : json['DRIVERMOBILENO'],
      HandlerBranchId:
          json['HandlerBranchId'] == null ? 0 : json['HandlerBranchId'],
      isHHT: json['isHHT'] == null ? 0 : json['isHHT'],
      TruckingCompanyName: json['TruckingCompanyName'] == null
          ? ""
          : json['TruckingCompanyName'],
      tpscheckInstatus: json['tpscheckInstatus'] == null
          ? false
          : json['tpscheckInstatus'] == "true"
              ? true
              : false,
      tpscheckInTimestamp: json['tpscheckInTimestamp'] == null
          ? ""
          : json['tpscheckInTimestamp'],
      DockInstatus: json['DockInstatus'] == null
          ? false
          : json['DockInstatus'].toString() == "true"
              ? true
              : false,
      DockInTimestamp:
          json['DockInTimestamp'] == null ? "" : json['DockInTimestamp'],
      Dockoutstatus: json['Dockoutstatus'] == null
          ? false
          : json['Dockoutstatus'].toString() == "true"
              ? true
              : false,
      DockoutTimestamp:
          json['DockoutTimestamp'] == null ? "" : json['DockoutTimestamp'],
      tpscheckoutstatus: json['tpscheckoutstatus'] == null
          ? false
          : json['tpscheckoutstatus'].toString() == "true"
              ? true
              : false,
      tpscheckoutTimestamp: json['tpscheckoutTimestamp'] == null
          ? ""
          : json['tpscheckoutTimestamp'],
      SLOTTIME: json['SLOTTIME'] == null ? "" : json['SLOTTIME'],
      DOCKNAME: json['DOCKNAME'] == null ? "" : json['DOCKNAME'],
      DRIVERLICENSE: json['DRIVERLICENSE'] == null ? "" : json['DRIVERLICENSE'],
      STA: json['STA'] == null ? "" : json['STA'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["Mode"] = Mode;
    map["VTNo"] = VTNo;
    map["VTDate"] = VTDate;
    map["VEHICLENO"] = VEHICLENO;
    map["TruckTypeName"] = TruckTypeName;
    map["DRIVERNAME"] = DRIVERNAME;
    map["EMAILID"] = EMAILID;
    map["DRIVERMOBILENO"] = DRIVERMOBILENO;
    map["HandlerBranchId"] = HandlerBranchId;
    map["isHHT"] = isHHT;
    map["TruckingCompanyName"] = TruckingCompanyName;
    map["tpscheckInstatus"] = tpscheckInstatus;
    map["tpscheckInTimestamp"] = tpscheckInTimestamp;
    map["DockInstatus"] = DockInstatus;
    map["DockInTimestamp"] = DockInTimestamp;
    map["Dockoutstatus"] = Dockoutstatus;
    map["DockoutTimestamp"] = DockoutTimestamp;
    map["tpscheckoutstatus"] = tpscheckoutstatus;
    map["tpscheckoutTimestamp"] = tpscheckoutTimestamp;
    map["SLOTTIME"] = SLOTTIME;
    map["DOCKNAME"] = DOCKNAME;
    map["DRIVERLICENSE"] = DRIVERLICENSE;
    map["STA"] = STA;
    return map;
  }
}

class DockInOutVTDetails {
  final String AirlinePrefix;
  final String MAWBNumber;
  final String HAWBNumber;
  final String FlightArrivalStatus;
  final String STA;
  final String ATA;
  final String CustomReleaseNumber;
  final String Payment;
  final int OrganizationBranchId;
  final int OrganizationId;
  final String MobileNo;
  final String Email;
  final String Latitude;
  final String Longitude;
  final String AssignedDockName;
  final String TOKENNO;
  final int ROWID;

  DockInOutVTDetails({
    required this.AirlinePrefix,
    required this.MAWBNumber,
    required this.HAWBNumber,
    required this.FlightArrivalStatus,
    required this.STA,
    required this.ATA,
    required this.CustomReleaseNumber,
    required this.Payment,
    required this.OrganizationBranchId,
    required this.OrganizationId,
    required this.MobileNo,
    required this.Email,
    required this.Latitude,
    required this.Longitude,
    required this.AssignedDockName,
    required this.TOKENNO,
    required this.ROWID,
  });

  factory DockInOutVTDetails.fromJson(Map<String, dynamic> json) {
    return DockInOutVTDetails(
      // Mode: json['Mode'] == null ? "" : json['Mode'],
      AirlinePrefix: json['AirlinePrefix'] == null ? "" : json['AirlinePrefix'],
      MAWBNumber: json['MAWBNumber'] == null ? "" : json['MAWBNumber'],
      HAWBNumber: json['HAWBNumber'] == null ? "" : json['HAWBNumber'],
      FlightArrivalStatus: json['FlightArrivalStatus'] == null
          ? ""
          : json['FlightArrivalStatus'],
      STA: json['STA'] == null ? "" : json['STA'],
      ATA: json['ATA'] == null ? "" : json['ATA'],
      CustomReleaseNumber: json['CustomReleaseNumber'] == null
          ? ""
          : json['CustomReleaseNumber'],
      Payment: json['Payment'] == null ? "" : json['Payment'],
      OrganizationBranchId: json['OrganizationBranchId'] == null
          ? ""
          : json['OrganizationBranchId'],
      OrganizationId:
          json['OrganizationId'] == null ? "" : json['OrganizationId'],
      MobileNo: json['MobileNo'] == null ? "" : json['MobileNo'],
      Email: json['Email'] == null ? "" : json['Email'],
      Latitude: json['Latitude'] == null ? "" : json['Latitude'],
      Longitude: json['Longitude'] == null ? "" : json['Longitude'],
      AssignedDockName:
          json['AssignedDockName'] == null ? "" : json['AssignedDockName'],
      TOKENNO: json['TOKENNO'] == null ? "" : json['TOKENNO'],
      ROWID: json['ROWID'] == null ? "" : json['ROWID'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["AirlinePrefix"] = AirlinePrefix;
    map["MAWBNumber"] = MAWBNumber;
    map["HAWBNumber"] = HAWBNumber;
    map["FlightArrivalStatus"] = FlightArrivalStatus;
    map["STA"] = STA;
    map["ATA"] = ATA;
    map["CustomReleaseNumber"] = CustomReleaseNumber;
    map["Payment"] = Payment;
    map["OrganizationBranchId"] = OrganizationBranchId;
    map["OrganizationId"] = OrganizationId;
    map["MobileNo"] = MobileNo;
    map["Email"] = Email;
    map["Latitude"] = Latitude;
    map["Longitude"] = Longitude;
    map["AssignedDockName"] = AssignedDockName;
    map["TOKENNO"] = TOKENNO;
    map["ROWID"] = ROWID;
    return map;
  }
}

class WarehouseAcceptanceAWB {
  final String AirlinePrefix;
  final String MAWBNumber;
  final String MawbDate;
  final String SLOTTIME;
  final String DOCKNAME;
  final dynamic WHAID;

  WarehouseAcceptanceAWB({
    required this.AirlinePrefix,
    required this.MAWBNumber,
    required this.MawbDate,
    required this.SLOTTIME,
    required this.DOCKNAME,
    required this.WHAID,
  });

  factory WarehouseAcceptanceAWB.fromJson(Map<String, dynamic> json) {
    return WarehouseAcceptanceAWB(
      AirlinePrefix: json['AirlinePrefix'] == null ? "" : json['AirlinePrefix'],
      MAWBNumber: json['MAWBNumber'] == null ? "" : json['MAWBNumber'],
      MawbDate: json['MawbDate'] == null ? "" : json['MawbDate'],
      SLOTTIME: json['SLOTTIME'] == null ? "" : json['SLOTTIME'],
      DOCKNAME: json['DOCKNAME'] == null ? "" : json['DOCKNAME'],
      WHAID: json['MAWBNumber'] == null ? 0 : json['WHAID'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["AirlinePrefix"] = AirlinePrefix;
    map["MAWBNumber"] = MAWBNumber;
    map["MawbDate"] = MawbDate;
    map["SLOTTIME"] = SLOTTIME;
    map["DOCKNAME"] = DOCKNAME;
    map["WHAID"] = WHAID;
    return map;
  }
}

class PODAWB {
  final String AirlinePrefix;
  final String MAWBNumber;
  final String HAWBNumber;
  final String MawbDate;
  final String SLOTTIME;
  final String DOCKNAME;

  PODAWB({
    required this.AirlinePrefix,
    required this.MAWBNumber,
    required this.HAWBNumber,
    required this.MawbDate,
    required this.SLOTTIME,
    required this.DOCKNAME,
  });

  factory PODAWB.fromJson(Map<String, dynamic> json) {
    return PODAWB(
      AirlinePrefix: json['AirlinePrefix'] == null ? "" : json['AirlinePrefix'],
      MAWBNumber: json['MAWBNumber'] == null ? "" : json['MAWBNumber'],
      HAWBNumber: json['HAWBNumber'] == null ? "" : json['HAWBNumber'],
      MawbDate: json['MawbDate'] == null ? "" : json['MawbDate'],
      SLOTTIME: json['SLOTTIME'] == null ? "" : json['SLOTTIME'],
      DOCKNAME: json['DOCKNAME'] == null ? "" : json['DOCKNAME'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["AirlinePrefix"] = AirlinePrefix;
    map["MAWBNumber"] = MAWBNumber;
    map["HAWBNumber"] = HAWBNumber;
    map["MawbDate"] = MawbDate;
    map["SLOTTIME"] = SLOTTIME;
    map["DOCKNAME"] = DOCKNAME;
    return map;
  }
}

class WarehouseTerminals {
  final int custudian;
  final String custodianName;

  WarehouseTerminals({
    required this.custudian,
    required this.custodianName,
  });

  factory WarehouseTerminals.fromJson(Map<String, dynamic> json) {
    return WarehouseTerminals(
      custodianName: json['CustodianName'] == null ? "" : json['CustodianName'],
      custudian: json['CUSTODIAN'] == null ? 0 : json['CUSTODIAN'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["CUSTODIAN"] = custudian;
    map["CustodianName"] = custodianName;
    return map;
  }
}

class WalInTokenDetails {
  final String Mode;
  final String SlotDate;
  final String TimeStart;
  final String TimeEnd;
  final String TokenNo;
  final String VehicleRegNo;
  final String DriverName;
  final String DriverNumber;
  bool isChecked = false;

  WalInTokenDetails({
    required this.Mode,
    required this.SlotDate,
    required this.TimeStart,
    required this.TimeEnd,
    required this.TokenNo,
    required this.VehicleRegNo,
    required this.DriverName,
    required this.DriverNumber,
  });

  factory WalInTokenDetails.fromJson(Map<String, dynamic> json) {
    return WalInTokenDetails(
      Mode: json['Mode'] == null ? "" : json['Mode'],
      SlotDate: json['SlotDate'] == null ? "" : json['SlotDate'],
      TimeStart: json['TimeStart'] == null ? "" : json['TimeStart'],
      TimeEnd: json['TimeEnd'] == null ? "" : json['TimeEnd'],
      TokenNo: json['TokenNo'] == null ? "" : json['TokenNo'],
      VehicleRegNo: json['VehicleRegNo'] == null ? "" : json['VehicleRegNo'],
      DriverName: json['DriverName'] == null ? "" : json['DriverName'],
      DriverNumber: json['DriverNumber'] == null ? "" : json['DriverNumber'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["Mode"] = Mode;
    map["SlotDate"] = SlotDate;
    map["TimeStart"] = TimeStart;
    map["TimeEnd"] = TimeEnd;
    map["TokenNo"] = TokenNo;
    map["VehicleRegNo"] = VehicleRegNo;
    map["DriverName"] = DriverName;
    map["DriverNumber"] = DriverNumber;
    map["isChecked"] = isChecked;
    return map;
  }
}

class Vehicletypes {
  final int TruckTypeId;
  final String TruckTypeName;

  Vehicletypes({
    required this.TruckTypeId,
    required this.TruckTypeName,
  });

  factory Vehicletypes.fromJson(Map<String, dynamic> json) {
    return Vehicletypes(
      TruckTypeName: json['TruckTypeName'] == null ? "" : json['TruckTypeName'],
      TruckTypeId: json['TruckTypeId'] == null ? 0 : json['TruckTypeId'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["TruckTypeId"] = TruckTypeId;
    map["TruckTypeName"] = TruckTypeName;
    return map;
  }
}

class Airport {
  final int CityId;
  final String CityCode;
  final String CityName;

  Airport({
    required this.CityId,
    required this.CityCode,
    required this.CityName,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      CityId: json['CityId'] == null ? 0 : json['CityId'],
      CityCode: json['CityCode'] == null ? "" : json['CityCode'],
      CityName: json['CityName'] == null ? "" : json['CityName'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["CityId"] = CityId;
    map["CityCode"] = CityCode;
    map["CityName"] = CityName;
    return map;
  }
}

class AirlinesPrefix {
  final String AirlinePrefix;

  AirlinesPrefix({
    required this.AirlinePrefix,
  });

  factory AirlinesPrefix.fromJson(Map<String, dynamic> json) {
    return AirlinesPrefix(
      AirlinePrefix: json['AirlinePrefix'] == null ? "" : json['AirlinePrefix'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["AirlinePrefix"] = AirlinePrefix;
    return map;
  }
}

class WalkinMain {
  String driName;
  String driSTA;
  String email;
  String lisNo;
  String mobNo;
  String mobNoPrefix;
  String terminal;
  String truckCompany;
  String vehNo;
  String vehType;

  WalkinMain(
      {required this.driName,
      required this.driSTA,
      required this.email,
      required this.lisNo,
      required this.mobNo,
      required this.mobNoPrefix,
      required this.terminal,
      required this.truckCompany,
      required this.vehNo,
      required this.vehType});
}

//showLable

class LableDisplay {
  final bool showLable;

  LableDisplay({
    required this.showLable,
  });

  factory LableDisplay.fromJson(Map<String, dynamic> json) {
    return LableDisplay(
      showLable: json['showLable'] == null
          ? false
          : json['showLable'].toString().toLowerCase() == "true"
              ? true
              : false,
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["showLable"] = showLable;
    return map;
  }
}

class AssignTrucker {
  final int branchId;
  final String name;

  AssignTrucker({
    required this.branchId,
    required this.name,
  });

  factory AssignTrucker.fromJson(Map<String, dynamic> json) {
    return AssignTrucker(
      branchId: json['OrganizationBranchId'] == null ? "" : json['OrganizationBranchId'],
      name: json['Name'] == null ? 0 : json['Name'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["OrganizationBranchId"] = branchId;
    map["Name"] = name;
    return map;
  }
}