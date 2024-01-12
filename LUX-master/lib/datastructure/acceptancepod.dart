class DamageType {
  final int DamageID;
  final String Damage;

  DamageType({
    required this.DamageID,
    required this.Damage,
  });

  factory DamageType.fromJson(Map<String, dynamic> json) {
    return DamageType(
      DamageID: json['DamageID'] == null ? 0 : json['DamageID'],
      Damage: json['Damage'] == null ? "" : json['Damage'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["DamageID"] = DamageID;
    map["Damage"] = Damage;
    return map;
  }
}

class AcceptanceType {
  final int ReasonID;
  final String Reason;

  AcceptanceType({
    required this.ReasonID,
    required this.Reason,
  });

  factory AcceptanceType.fromJson(Map<String, dynamic> json) {
    return AcceptanceType(
      ReasonID: json['ReasonID'] == null ? 0 : json['ReasonID'],
      Reason: json['Reason'] == null ? "" : json['Reason'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ReasonID"] = ReasonID;
    map["Reason"] = Reason;
    return map;
  }
}

class AwbDetails {
  final String Commodity;
  final String FlightNo;
  final String FlightDate;
  final String FittOffPoint;
  final String AWBDestination;
  final int TotalPKG;
  final double DecGrossWT;
  final double DecChargWT;
  final double DecVOLWT;
  final int CreatedById;
  final int UpdatedById;
  final int OrganizationBranchId;
  final int OrganizationId;
  final String AirlinePrefix;
  final String MAWBNumber;
  final String HAWBNumber;
  final String MobileNo;
  final String Email;
  final String DRIVERNAME;
  final int RcvdPKG;
  final double RcvdGrossWT;
  final String TOKENNO;
  final int ROWID;

  AwbDetails({
    required this.Commodity,
    required this.FlightNo,
    required this.FlightDate,
    required this.FittOffPoint,
    required this.AWBDestination,
    required this.TotalPKG,
    required this.DecGrossWT,
    required this.DecChargWT,
    required this.DecVOLWT,
    required this.CreatedById,
    required this.UpdatedById,
    required this.OrganizationBranchId,
    required this.OrganizationId,
    required this.AirlinePrefix,
    required this.MAWBNumber,
    required this.HAWBNumber,
    required this.MobileNo,
    required this.Email,
    required this.DRIVERNAME,
    required this.RcvdPKG,
    required this.RcvdGrossWT,
    required this.TOKENNO,
    required this.ROWID,
  });

  factory AwbDetails.fromJson(Map<String, dynamic> json) {
    return AwbDetails(
      // ReasonID: json['ReasonID'] == null ? 0 : json['ReasonID'],
      // Reason: json['Reason'] == null ? "" : json['Reason'],
      Commodity: json['Commodity'] == null ? "" : json['Commodity'],
      FlightNo: json['FlightNo'] == null ? "" : json['FlightNo'],
      FlightDate: json['FlightDate'] == null ? "" : json['FlightDate'],
      FittOffPoint: json['FittOffPoint'] == null ? "" : json['FittOffPoint'],
      AWBDestination:
          json['AWBDestination'] == null ? "" : json['AWBDestination'],
      TotalPKG: json['TotalPKG'] == null ? 0 : json['TotalPKG'],
      DecGrossWT: json['DecGrossWT'] == null ? 0 : json['DecGrossWT'],
      DecChargWT: json['DecChargWT'] == null ? 0 : json['DecChargWT'],
      DecVOLWT: json['DecVOLWT'] == null ? 0 : json['DecVOLWT'],
      CreatedById: json['CreatedById'] == null ? 0 : json['CreatedById'],
      UpdatedById: json['UpdatedById'] == null ? 0 : json['UpdatedById'],
      OrganizationBranchId: json['OrganizationBranchId'] == null
          ? 0
          : json['OrganizationBranchId'],
      OrganizationId:
          json['OrganizationId'] == null ? 0 : json['OrganizationId'],
      AirlinePrefix: json['AirlinePrefix'] == null ? "" : json['AirlinePrefix'],
      MAWBNumber: json['MAWBNumber'] == null ? "" : json['MAWBNumber'],
      HAWBNumber: json['HAWBNumber'] == null ? "" : json['HAWBNumber'],
      MobileNo: json['MobileNo'] == null ? "" : json['MobileNo'],
      Email: json['Email'] == null ? "" : json['Email'],
      DRIVERNAME: json['DRIVERNAME'] == null ? "" : json['DRIVERNAME'],
      RcvdPKG: json['RcvdPKG'] == null ? 0 : json['RcvdPKG'],
      RcvdGrossWT: json['RcvdGrossWT'] == null ? 0 : json['RcvdGrossWT'],
      TOKENNO: json['TOKENNO'] == null ? "" : json['TOKENNO'],
      ROWID: json['ROWID'] == null ? 0 : json['ROWID'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["Commodity"] = Commodity;
    map["FlightNo"] = FlightNo;
    map["FlightDate"] = FlightDate;
    map["FittOffPoint"] = FittOffPoint;
    map["AWBDestination"] = AWBDestination;
    map["TotalPKG"] = TotalPKG;
    map["DecGrossWT"] = DecGrossWT;
    map["DecChargWT"] = DecChargWT;
    map["DecVOLWT"] = DecVOLWT;
    map["CreatedById"] = CreatedById;
    map["UpdatedById"] = UpdatedById;
    map["OrganizationBranchId"] = OrganizationBranchId;
    map["OrganizationId"] = OrganizationId;
    map["AirlinePrefix"] = AirlinePrefix;
    map["MAWBNumber"] = MAWBNumber;
    map["HAWBNumber"] = HAWBNumber;
    map["MobileNo"] = MobileNo;
    map["Email"] = Email;
    map["DRIVERNAME"] = DRIVERNAME;
    map["RcvdPKG"] = RcvdPKG;
    map["RcvdGrossWT"] = RcvdGrossWT;
    map["TOKENNO"] = TOKENNO;
    map["ROWID"] = ROWID;
    return map;
  }
}

class AwbPod {
  final String Custom_Release_Status;
  final String Payment;
  final int DONoOfPackage;
  final double DOGrossWeight;
  final double DOChargableWeight;
  final String AirlinePrefix;
  final String MAWBNumber;
  final String HAWBNumber;
  final String MobileNo;
  final String Email;
  final String Commodity;
  final int CreatedById;
  final String FlightDate;
  final int UpdatedById;
  final int OrganizationBranchId;
  final int OrganizationId;
  final int DOId;
  final String DONo;
  final String TOKENNO;
  final int ROWID;
  final String ClearanceType;
  final int RcvdPKG;
  final double RcvdGrossWT;
  final String DRIVERNAME;
  final int VehicleTokenID;
  // final String PODID;
  // final int HAWBID;

  AwbPod({
    required this.Custom_Release_Status,
    required this.Payment,
    required this.DONoOfPackage,
    required this.DOGrossWeight,
    required this.DOChargableWeight,
    required this.AirlinePrefix,
    required this.MAWBNumber,
    required this.HAWBNumber,
    required this.MobileNo,
    required this.Email,
    required this.Commodity,
    required this.CreatedById,
    required this.FlightDate,
    required this.UpdatedById,
    required this.OrganizationBranchId,
    required this.OrganizationId,
    required this.DOId,
    required this.DONo,
    required this.TOKENNO,
    required this.ROWID,
    required this.ClearanceType,
    required this.RcvdPKG,
    required this.RcvdGrossWT,
    required this.DRIVERNAME,
    required this.VehicleTokenID,
    // required this.PODID,
    // required this.HAWBID,
  });

  factory AwbPod.fromJson(Map<String, dynamic> json) {
    return AwbPod(
      // ReasonID: json['ReasonID'] == null ? 0 : json['ReasonID'],
      // Reason: json['Reason'] == null ? "" : json['Reason'],

      Custom_Release_Status: json['Custom_Release_Status'] == null
          ? ""
          : json['Custom_Release_Status'],
      Payment: json['Payment'] == null ? "" : json['Payment'],
      DONoOfPackage: json['DONoOfPackage'] == null ? 0  : json['DONoOfPackage'],
      DOGrossWeight: json['DOGrossWeight']== null ? 0   :json['DOGrossWeight'],
      DOChargableWeight:
          json['DOChargableWeight'] == null ? 0   : json['DOChargableWeight'],
      AirlinePrefix: json['AirlinePrefix'] == null ? "" : json['AirlinePrefix'],
      MAWBNumber: json['MAWBNumber'] == null ? "" : json['MAWBNumber'],
      HAWBNumber: json['HAWBNumber'] == null ? "" : json['HAWBNumber'],
      MobileNo: json['MobileNo'] == null ? "" : json['MobileNo'],
      Email: json['Email'] == null ? "" : json['Email'],
      Commodity: json['Commodity'] == null ? "" : json['Commodity'],
      CreatedById: json['CreatedById'] == null ? 0 : json['CreatedById'],
      FlightDate: json['FlightDate'] == null ? "" : json['FlightDate'],
      UpdatedById: json['UpdatedById'] == null ? 0 : json['UpdatedById'],
      OrganizationBranchId: json['OrganizationBranchId'] == null
          ? 0
          : json['OrganizationBranchId'],
      OrganizationId:
          json['OrganizationId'] == null ? 0 : json['OrganizationId'],
      DOId: json['DOId'] == null ? 0 : json['DOId'],
      DONo: json['DONo'] == null ? "" : json['DONo'],
      TOKENNO: json['TOKENNO'] == null ? "" : json['TOKENNO'],
      ROWID: json['ROWID'] == null ? 0 : json['ROWID'],
      ClearanceType: json['ClearanceType'] == null ? "" : json['ClearanceType'],
      RcvdPKG: json['RcvdPKG'] == null ? 0   : json['RcvdPKG'],
      RcvdGrossWT: json['RcvdGrossWT']== null ? 0   : json['RcvdGrossWT'],
      DRIVERNAME: json['DRIVERNAME'] == null ? "" : json['DRIVERNAME'],
      VehicleTokenID:
          json['VehicleTokenID'] == null ? 0  : json['VehicleTokenID'],
      // PODID: json['PODID'] == null ? "" : json['PODID'],
      // HAWBID: json['HAWBID'] == null ? 0 : json['HAWBID'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["Custom_Release_Status"] = Custom_Release_Status;
    map["Payment"] = Payment;
    map["DONoOfPackage"] = DONoOfPackage;
    map["DOGrossWeight"] = DOGrossWeight;
    map["DOChargableWeight"] = DOChargableWeight;
    map["AirlinePrefix"] = AirlinePrefix;
    map["MAWBNumber"] = MAWBNumber;
    map["HAWBNumber"] = HAWBNumber;
    map["MobileNo"] = MobileNo;
    map["Email"] = Email;
    map["Commodity"] = Commodity;
    map["CreatedById"] = CreatedById;
    map["FlightDate"] = FlightDate;
    map["UpdatedById"] = UpdatedById;
    map["OrganizationBranchId"] = OrganizationBranchId;
    map["OrganizationId"] = OrganizationId;
    map["DOId"] = DOId;
    map["DONo"] = DONo;
    map["TOKENNO"] = TOKENNO;
    map["ROWID"] = ROWID;
    map["ClearanceType"] = ClearanceType;
    map["RcvdPKG"] = RcvdPKG;
    map["RcvdGrossWT"] = RcvdGrossWT;
    map["DRIVERNAME"] = DRIVERNAME;
    map["VehicleTokenID"] = VehicleTokenID;
    // map["PODID"] = PODID;
    // map["HAWBID"] = HAWBID;
    return map;
  }
}
