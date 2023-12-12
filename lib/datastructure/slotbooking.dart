import 'package:flutter/widgets.dart';

class VehicleNos {
  final String VH_NUMBER;

  VehicleNos({
    required this.VH_NUMBER,
  });

  factory VehicleNos.fromJson(Map<String, dynamic> json) {
    return VehicleNos(
      VH_NUMBER: json['VH_NUMBER'] == null ? "" : json['VH_NUMBER'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["VH_NUMBER"] = VH_NUMBER;
    return map;
  }
}

class DriverDetails {
  final String DR_FIRSTNAME;
  final String DR_MOBILE;
  final String DR_LICENSENO;
  final String DR_STA;
  final String VehicleNo;

  DriverDetails({
    required this.DR_FIRSTNAME,
    required this.DR_MOBILE,
    required this.DR_LICENSENO,
    required this.DR_STA,
    required this.VehicleNo,
  });

  factory DriverDetails.fromJson(Map<String, dynamic> json) {
    return DriverDetails(
      DR_FIRSTNAME: json['DR_FIRSTNAME'],
      DR_MOBILE: json['DR_MOBILE'],
      DR_LICENSENO: json['DR_LICENSENO'],
      DR_STA: json['DR_STA'],
      VehicleNo: json['VehicleNo'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["DR_FIRSTNAME"] = DR_FIRSTNAME;
    map["DR_MOBILE"] = DR_MOBILE;
    map["DR_LICENSENO"] = DR_LICENSENO;
    map["DR_STA"] = DR_STA;
    map["VehicleNo"] = VehicleNo;
    return map;
  }
}

class SlotDetail {
  final String SlotDate;
  final String FromTime;
  final String ToTime;
  final int AllocatedDocks;
  final int BookedSlots;
  final int Custodian;
  final String SlotAvailability;
  final String Terminal;
  final String SlotType;

  SlotDetail({
    required this.SlotDate,
    required this.FromTime,
    required this.ToTime,
    required this.AllocatedDocks,
    required this.BookedSlots,
    required this.Custodian,
    required this.SlotAvailability,
    required this.Terminal,
    required this.SlotType,
  });

  factory SlotDetail.fromJson(Map<String, dynamic> json) {
    return SlotDetail(
      SlotDate: json['SlotDate'] == null ? "" : json['SlotDate'],
      FromTime: json['FromTime'] == null ? "" : json['FromTime'],
      ToTime: json['ToTime'] == null ? "" : json['ToTime'],
      AllocatedDocks:
          json['AllocatedDocks'] == null ? 0 : json['AllocatedDocks'],
      BookedSlots: json['BookedSlots'] == null ? 0 : json['BookedSlots'],
      Custodian: json['Custodian'] == null ? 0 : json['Custodian'],
      SlotAvailability:
          json['SlotAvailability'] == null ? "" : json['SlotAvailability'],
      Terminal: json['Terminal'] == null ? "" : json['Terminal'],
      SlotType: json['SlotType'] == null ? "" : json['SlotType'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["SlotDate"] = SlotDate;
    map["FromTime"] = FromTime;
    map["ToTime"] = ToTime;
    map["AllocatedDocks"] = AllocatedDocks;
    map["BookedSlots"] = BookedSlots;
    map["Custodian"] = Custodian;
    map["SlotAvailability"] = SlotAvailability;
    map["Terminal"] = Terminal;
    map["SlotType"] = SlotType;
    return map;
  }
}

class AWBDetail {
  final int RecordNumber;
  final String tokenno;
  final int NOP;
  final int AWBID;
  final String HAWBNumber;
  final String AirlinePrefix;
  final String MAWBNumber;
  final String ExecutionOn;
  final String CreatedDate;
  final int OrganizationId;
  final int PiecesCount;
  final String Custodian;
  final double Weight;
  final String WeightUnitID;
  final String OrgName;
  final int ORIGINAirportId;
  final String ORIGINAIRPORTNAME;
  final String ORIGINAIRPORTCODE;
  final int DESTINATIONAIRPORTID;
  final String DESTINATIONAIRPORTNAME;
  final String DESTINATIONAIRPORTCODE;
  final int CustodianID;
  final bool IsConsol;
  final String TruckerID;
  final String TruckerName;
  final String GHA;
  final String FreightForwarder;
  final double ChargableWeight;
  final String FlightNo;
  final String FlightDate;
  final String SlotBookingStatus;
  final double GrossWeight;
  final String orgType;
  final int AllocatedPieces;
  final double AllocatedGrosswt;
  final String SlotStatus;
  bool selected;
  bool enabled;
  TextEditingController txtAllotedPCS;
  TextEditingController txtAllocatedWt;

  AWBDetail({
    required this.RecordNumber,
    required this.tokenno,
    required this.NOP,
    required this.AWBID,
    required this.HAWBNumber,
    required this.AirlinePrefix,
    required this.MAWBNumber,
    required this.ExecutionOn,
    required this.CreatedDate,
    required this.OrganizationId,
    required this.PiecesCount,
    required this.Custodian,
    required this.Weight,
    required this.WeightUnitID,
    required this.OrgName,
    required this.ORIGINAirportId,
    required this.ORIGINAIRPORTNAME,
    required this.ORIGINAIRPORTCODE,
    required this.DESTINATIONAIRPORTID,
    required this.DESTINATIONAIRPORTNAME,
    required this.DESTINATIONAIRPORTCODE,
    required this.CustodianID,
    required this.IsConsol,
    required this.TruckerID,
    required this.TruckerName,
    required this.GHA,
    required this.FreightForwarder,
    required this.ChargableWeight,
    required this.FlightNo,
    required this.FlightDate,
    required this.SlotBookingStatus,
    required this.GrossWeight,
    required this.orgType,
    required this.AllocatedPieces,
    required this.AllocatedGrosswt,
    required this.SlotStatus,
    required this.selected,
    required this.enabled,
    required this.txtAllotedPCS,
    required this.txtAllocatedWt,
  });

  factory AWBDetail.fromJson(Map<String, dynamic> json) {
    return AWBDetail(
      RecordNumber: json['RecordNumber'] == null ? 0 : json['RecordNumber'],
      tokenno: json['tokenno'] == null ? "" : json['tokenno'],
      NOP: json['NOP'] == null ? 0 : json['NOP'],
      AWBID: json['AWBID'] == null ? 0 : json['AWBID'],
      HAWBNumber: json['HAWBNumber'] == null ? "" : json['HAWBNumber'],
      AirlinePrefix: json['AirlinePrefix'] == null ? "" : json['AirlinePrefix'],
      MAWBNumber: json['MAWBNumber'] == null ? "" : json['MAWBNumber'],
      ExecutionOn: json['ExecutionOn'] == null ? "" : json['ExecutionOn'],
      CreatedDate: json['CreatedDate'] == null ? "" : json['CreatedDate'],
      OrganizationId:
          json['OrganizationId'] == null ? 0 : json['OrganizationId'],
      PiecesCount: json['PiecesCount'] == null ? 0 : json['PiecesCount'],
      Custodian: json['Custodian'] == null ? "" : json['Custodian'],
      Weight: json['Weight'] == null ? 0 : json['Weight'],
      WeightUnitID: json['WeightUnitID'] == null ? "" : json['WeightUnitID'],
      OrgName: json['OrgName'] == null ? "" : json['OrgName'],
      ORIGINAirportId:
          json['ORIGINAirportId'] == null ? 0 : json['ORIGINAirportId'],
      ORIGINAIRPORTNAME:
          json['ORIGINAIRPORTNAME'] == null ? "" : json['ORIGINAIRPORTNAME'],
      ORIGINAIRPORTCODE:
          json['ORIGINAIRPORTCODE'] == null ? "" : json['ORIGINAIRPORTCODE'],
      DESTINATIONAIRPORTID: json['DESTINATIONAIRPORTID'] == null
          ? 0
          : json['DESTINATIONAIRPORTID'],
      DESTINATIONAIRPORTNAME: json['DESTINATIONAIRPORTNAME'] == null
          ? ""
          : json['DESTINATIONAIRPORTNAME'],
      DESTINATIONAIRPORTCODE: json['DESTINATIONAIRPORTCODE'] == null
          ? ""
          : json['DESTINATIONAIRPORTCODE'],
      CustodianID: json['CustodianID'] == null ? 0 : json['CustodianID'],
      IsConsol: json['IsConsol'] == null
          ? false
          : json['IsConsol'].toString() == "true"
              ? true
              : false,
      TruckerID: json['TruckerID'] == null ? "" : json['TruckerID'],
      TruckerName: json['TruckerName'] == null ? "" : json['TruckerName'],
      GHA: json['GHA'] == null ? "" : json['GHA'],
      FreightForwarder:
          json['FreightForwarder'] == null ? "" : json['FreightForwarder'],
      ChargableWeight:
          json['ChargableWeight'] == null ? 0 : json['ChargableWeight'],
      FlightNo: json['FlightNo'] == null ? "" : json['FlightNo'],
      FlightDate: json['FlightDate'] == null ? "" : json['FlightDate'],
      SlotBookingStatus:
          json['SlotBookingStatus'] == null ? "" : json['SlotBookingStatus'],
      GrossWeight: json['GrossWeight'] == null ? 0 : json['GrossWeight'],
      orgType: json['orgType'] == null ? "" : json['orgType'],
      AllocatedPieces:
          json['AllocatedPieces'] == null ? 0 : json['AllocatedPieces'],
      AllocatedGrosswt:
          json['AllocatedGrosswt'] == null ? 0 : json['AllocatedGrosswt'],
      SlotStatus: json['SlotStatus'] == null ? "" : json['SlotStatus'],
      selected: false,
      enabled: true,
      txtAllotedPCS: new TextEditingController(),
      txtAllocatedWt: new TextEditingController(),
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["RecordNumber"] = RecordNumber;
    map["tokenno"] = tokenno;
    map["NOP"] = NOP;
    map["AWBID"] = AWBID;
    map["HAWBNumber"] = HAWBNumber;
    map["AirlinePrefix"] = AirlinePrefix;
    map["MAWBNumber"] = MAWBNumber;
    map["ExecutionOn"] = ExecutionOn;
    map["CreatedDate"] = CreatedDate;
    map["OrganizationId"] = OrganizationId;
    map["PiecesCount"] = PiecesCount;
    map["Custodian"] = Custodian;
    map["Weight"] = Weight;
    map["WeightUnitID"] = WeightUnitID;
    map["OrgName"] = OrgName;
    map["ORIGINAirportId"] = ORIGINAirportId;
    map["ORIGINAIRPORTNAME"] = ORIGINAIRPORTNAME;
    map["ORIGINAIRPORTCODE"] = ORIGINAIRPORTCODE;
    map["DESTINATIONAIRPORTID"] = DESTINATIONAIRPORTID;
    map["DESTINATIONAIRPORTNAME"] = DESTINATIONAIRPORTNAME;
    map["DESTINATIONAIRPORTCODE"] = DESTINATIONAIRPORTCODE;
    map["CustodianID"] = CustodianID;
    map["IsConsol"] = IsConsol;
    map["TruckerID"] = TruckerID;
    map["TruckerName"] = TruckerName;
    map["GHA"] = GHA;
    map["FreightForwarder"] = FreightForwarder;
    map["ChargableWeight"] = ChargableWeight;
    map["FlightNo"] = FlightNo;
    map["FlightDate"] = FlightDate;
    map["SlotBookingStatus"] = SlotBookingStatus;
    map["GrossWeight"] = GrossWeight;
    map["orgType"] = orgType;
    map["AllocatedPieces"] = AllocatedPieces;
    map["AllocatedGrosswt"] = AllocatedGrosswt;
    map["SlotStatus"] = SlotStatus;
    map["selected"] = selected;
    map["enabled"] = enabled;
    txtAllotedPCS = txtAllotedPCS;
    txtAllocatedWt = txtAllocatedWt;
    return map;
  }
}

class AWBDetailImport {
  final String Id;
  final String MAWBNumber;
  final String HAWBNumber;
  final String GHA;
  final String FreightForwarder;
  final int AWBPcs;
  final double GrWt;
  final int Rcvdpcs;
  final double RcvdGrWt;
  final double RcvdChrgWt;
  final String VehicleTokenNo1;
  final String VehicleTokenNo;
  final int DOID;
  final int HAWBId;
  final String AIRLINE_MAWB;
  final String TruckerName;
  final int TruckerBranchId;
  final String AirlinePrefix;
  final String ShipmentType;
  final String BookSlotStatus;
  final String SlotStatus;
  final String CreatedDate;
  final int CustodianID;
  final String WeightUnitId;
  final String VTNO;
  final int AllocatedPieces;
  final int VTIndex;
  final String BreakDownStatus;
  final String PaymentStatus;
  final String DocAcceptanceStatus;
  final String ErrorCodeStatus;
  final String RequestID;
  final String CrossLevel;
  bool selected;
  bool enabled;
  TextEditingController txtAllotedPCS;
  TextEditingController txtAllocatedWt;

  AWBDetailImport({
    required this.Id,
    required this.MAWBNumber,
    required this.HAWBNumber,
    required this.GHA,
    required this.FreightForwarder,
    required this.AWBPcs,
    required this.GrWt,
    required this.Rcvdpcs,
    required this.RcvdGrWt,
    required this.RcvdChrgWt,
    required this.VehicleTokenNo1,
    required this.VehicleTokenNo,
    required this.DOID,
    required this.HAWBId,
    required this.AIRLINE_MAWB,
    required this.TruckerName,
    required this.TruckerBranchId,
    required this.AirlinePrefix,
    required this.ShipmentType,
    required this.BookSlotStatus,
    required this.SlotStatus,
    required this.CreatedDate,
    required this.CustodianID,
    required this.WeightUnitId,
    required this.VTNO,
    required this.AllocatedPieces,
    required this.VTIndex,
    required this.BreakDownStatus,
    required this.PaymentStatus,
    required this.DocAcceptanceStatus,
    required this.ErrorCodeStatus,
    required this.RequestID,
    required this.CrossLevel,
    required this.selected,
    required this.enabled,
    required this.txtAllotedPCS,
    required this.txtAllocatedWt,
  });

  factory AWBDetailImport.fromJson(Map<String, dynamic> json) {
    return AWBDetailImport(
      Id: json['Id'] == null ? "" : json['Id'],
      MAWBNumber: json['MAWBNumber'] == null ? "" : json['MAWBNumber'],
      HAWBNumber: json['HAWBNumber'] == null ? "" : json['HAWBNumber'],
      GHA: json['GHA'] == null ? "" : json['GHA'],
      FreightForwarder:
          json['FreightForwarder'] == null ? "" : json['FreightForwarder'],
      AWBPcs: json['AWBPcs'] == null ? 0 : json['AWBPcs'],
      GrWt: json['GrWt'] == null ? 0 : json['GrWt'],
      Rcvdpcs: json['Rcvdpcs'] == null ? 0 : json['Rcvdpcs'],
      RcvdGrWt: json['RcvdGrWt'] == null ? 0 : json['RcvdGrWt'],
      RcvdChrgWt: json['RcvdChrgWt'] == null ? 0 : json['RcvdChrgWt'],
      VehicleTokenNo1:
          json['VehicleTokenNo1'] == null ? "" : json['VehicleTokenNo1'],
      VehicleTokenNo:
          json['VehicleTokenNo'] == null ? "" : json['VehicleTokenNo'],
      DOID: json['DOID'] == null ? 0 : json['DOID'],
      HAWBId: json['HAWBId'] == null ? 0 : json['HAWBId'],
      AIRLINE_MAWB: json['AIRLINE_MAWB'] == null ? "" : json['AIRLINE_MAWB'],
      TruckerName: json['TruckerName'] == null ? "" : json['TruckerName'],
      TruckerBranchId:
          json['TruckerBranchId'] == null ? 0 : json['TruckerBranchId'],
      AirlinePrefix: json['AirlinePrefix'] == null ? "" : json['AirlinePrefix'],
      ShipmentType: json['ShipmentType'] == null ? "" : json['ShipmentType'],
      BookSlotStatus:
          json['BookSlotStatus'] == null ? "" : json['BookSlotStatus'],
      SlotStatus: json['SlotStatus'] == null ? "" : json['SlotStatus'],
      CreatedDate: json['CreatedDate'] == null ? "" : json['CreatedDate'],
      CustodianID: json['CustodianID'] == null ? 0 : json['CustodianID'],
      WeightUnitId: json['WeightUnitId'] == null ? "" : json['WeightUnitId'],
      VTNO: json['VTNO'] == null ? "" : json['VTNO'],
      AllocatedPieces:
          json['AllocatedPieces'] == null ? 0 : json['AllocatedPieces'],
      VTIndex: json['VTIndex'] == null ? 0 : json['VTIndex'],
      BreakDownStatus:
          json['BreakDownStatus'] == null ? "" : json['BreakDownStatus'],
      PaymentStatus: json['PaymentStatus'] == null ? "" : json['PaymentStatus'],
      DocAcceptanceStatus: json['DocAcceptanceStatus'] == null
          ? ""
          : json['DocAcceptanceStatus'],
      ErrorCodeStatus:
          json['ErrorCodeStatus'] == null ? "" : json['ErrorCodeStatus'],
      RequestID: json['RequestID'] == null ? "" : json['RequestID'],
      CrossLevel: json['CrossLevel'] == null ? "" : json['CrossLevel'],
      selected: false,
      enabled: true,
      txtAllotedPCS: new TextEditingController(),
      txtAllocatedWt: new TextEditingController(),
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["Id"] = Id;
    map["MAWBNumber"] = MAWBNumber;
    map["HAWBNumber"] = HAWBNumber;
    map["GHA"] = GHA;
    map["FreightForwarder"] = FreightForwarder;
    map["AWBPcs"] = AWBPcs;
    map["GrWt"] = GrWt;
    map["Rcvdpcs"] = Rcvdpcs;
    map["RcvdGrWt"] = RcvdGrWt;
    map["RcvdChrgWt"] = RcvdChrgWt;
    map["VehicleTokenNo1"] = VehicleTokenNo1;
    map["VehicleTokenNo"] = VehicleTokenNo;
    map["DOID"] = DOID;
    map["HAWBId"] = HAWBId;
    map["AIRLINE_MAWB"] = AIRLINE_MAWB;
    map["TruckerName"] = TruckerName;
    map["TruckerBranchId"] = TruckerBranchId;
    map["AirlinePrefix"] = AirlinePrefix;
    map["ShipmentType"] = ShipmentType;
    map["BookSlotStatus"] = BookSlotStatus;
    map["SlotStatus"] = SlotStatus;
    map["CreatedDate"] = CreatedDate;
    map["CustodianID"] = CustodianID;
    map["WeightUnitId"] = WeightUnitId;
    map["VTNO"] = VTNO;
    map["AllocatedPieces"] = AllocatedPieces;
    map["VTIndex"] = VTIndex;
    map["BreakDownStatus"] = BreakDownStatus;
    map["PaymentStatus"] = PaymentStatus;
    map["DocAcceptanceStatus"] = DocAcceptanceStatus;
    map["ErrorCodeStatus"] = ErrorCodeStatus;
    map["RequestID"] = RequestID;
    map["CrossLevel"] = CrossLevel;
    map["selected"] = selected;
    map["enabled"] = enabled;
    txtAllotedPCS = txtAllotedPCS;
    txtAllocatedWt = txtAllocatedWt;

    return map;
  }
}

class BookedAWBDetail {
  final int RecordNumber;
  final String tokenno;
  final int NOP;
  final int AWBID;
  final String AirlinePrefix;
  final String MAWBNumber;
  final int OrganizationId;
  final String Custodian;
  final double Weight;
  final String WeightUnitID;
  final String OrgName;
  final int CustodianID;
  final String TruckerID;
  final String TruckerName;
  final String GHA;
  final String FreightForwarder;
  final double GrossWeight;
  final int AllocatedPieces;
  final double AllocatedGrosswt;
  final String SlotStatus;
  final DateTime CreatedDate;
  final String SlotTime;

  BookedAWBDetail({
    required this.RecordNumber,
    required this.tokenno,
    required this.NOP,
    required this.AWBID,
    required this.AirlinePrefix,
    required this.MAWBNumber,
    required this.OrganizationId,
    required this.Custodian,
    required this.Weight,
    required this.WeightUnitID,
    required this.OrgName,
    required this.CustodianID,
    required this.TruckerID,
    required this.TruckerName,
    required this.GHA,
    required this.FreightForwarder,
    required this.GrossWeight,
    required this.AllocatedPieces,
    required this.AllocatedGrosswt,
    required this.SlotStatus,
    required this.CreatedDate,
    required this.SlotTime,
  });

  factory BookedAWBDetail.fromJson(Map<String, dynamic> json) {
    return BookedAWBDetail(
      RecordNumber: json['RecordNumber'] == null ? "" : json['RecordNumber'],
      tokenno: json['tokenno'] == null ? "" : json['tokenno'],
      NOP: json['NOP'] == null ? "" : json['NOP'],
      AWBID: json['AWBID'] == null ? "" : json['AWBID'],
      AirlinePrefix: json['AirlinePrefix'] == null ? "" : json['AirlinePrefix'],
      MAWBNumber: json['MAWBNumber'] == null ? "" : json['MAWBNumber'],
      OrganizationId:
          json['OrganizationId'] == null ? "" : json['OrganizationId'],
      Custodian: json['Custodian'] == null ? "" : json['Custodian'],
      Weight: json['Weight'] == null ? "" : json['Weight'],
      WeightUnitID: json['WeightUnitID'] == null ? "" : json['WeightUnitID'],
      OrgName: json['OrgName'] == null ? "" : json['OrgName'],
      CustodianID: json['CustodianID'] == null ? "" : json['CustodianID'],
      TruckerID: json['TruckerID'] == null ? "" : json['TruckerID'],
      TruckerName: json['TruckerName'] == null ? "" : json['TruckerName'],
      GHA: json['GHA'] == null ? "" : json['GHA'],
      FreightForwarder:
          json['FreightForwarder'] == null ? "" : json['FreightForwarder'],
      GrossWeight: json['GrossWeight'] == null ? "" : json['GrossWeight'],
      AllocatedPieces:
          json['AllocatedPieces'] == null ? "" : json['AllocatedPieces'],
      AllocatedGrosswt:
          json['AllocatedGrosswt'] == null ? "" : json['AllocatedGrosswt'],
      SlotStatus: json['SlotStatus'] == null ? "" : json['SlotStatus'],
      CreatedDate: json['CreatedDate'] == null
          ? DateTime.now()
          : DateTime.parse(json['CreatedDate']),
      SlotTime: json['SlotTime'] == null ? "" : json['SlotTime'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["RecordNumber"] = RecordNumber;
    map["tokenno"] = tokenno;
    map["NOP"] = NOP;
    map["AWBID"] = AWBID;
    map["AirlinePrefix"] = AirlinePrefix;
    map["MAWBNumber"] = MAWBNumber;
    map["OrganizationId"] = OrganizationId;
    map["Custodian"] = Custodian;
    map["Weight"] = Weight;
    map["WeightUnitID"] = WeightUnitID;
    map["OrgName"] = OrgName;
    map["CustodianID"] = CustodianID;
    map["TruckerID"] = TruckerID;
    map["TruckerName"] = TruckerName;
    map["GHA"] = GHA;
    map["FreightForwarder"] = FreightForwarder;
    map["GrossWeight"] = GrossWeight;
    map["AllocatedPieces"] = AllocatedPieces;
    map["AllocatedGrosswt"] = AllocatedGrosswt;
    map["SlotStatus"] = SlotStatus;
    map["CreatedDate"] = CreatedDate;
    map["SlotTime"] = SlotTime;

    return map;
  }
}

class BookedAWBDetailImport {
  final String Id;
  final String FlightNo;
  final String FlightDate;
  final String MAWBNumber;
  final String HAWBNumber;
  final String GHA;
  final String FreightForwarder;
  final int AWBPcs;
  final double GrWt;
  final int Rcvdpcs;
  final double RcvdGrWt;
  final double RcvdChrgWt;
  final String DONoCreate;
  final String CustomReleaseNo;
  final String Payment;
  final String Commodity;
  final String VehicleTokenNo1;
  final String VehicleTokenNo;
  final int DOID;
  final int HAWBId;
  final String AIRLINE_MAWB;
  final String TruckerName;
  final int TruckerBranchId;
  final String AirlinePrefix;
  final String ShipmentType;
  final String BookSlotStatus;
  final String SlotStatus;
  final String CreatedDate;
  final int CustodianID;
  final String WeightUnitId;
  final bool IsDeleted;
  final String OriginAirportCode;
  final String VTNO;
  final int AllocatedPieces;
  final int VTIndex;
  final String Remarks;
  final String BreakDownStatus;
  final String PaymentStatus;
  final String PAYMENTREMARKS;
  final String DocAcceptanceStatus;
  final String ErrorCodeStatus;
  final String RequestID;
  final String CrossLevel;
  final String SlotTime;

  BookedAWBDetailImport({
    required this.Id,
    required this.FlightNo,
    required this.FlightDate,
    required this.MAWBNumber,
    required this.HAWBNumber,
    required this.GHA,
    required this.FreightForwarder,
    required this.AWBPcs,
    required this.GrWt,
    required this.Rcvdpcs,
    required this.RcvdGrWt,
    required this.RcvdChrgWt,
    required this.DONoCreate,
    required this.CustomReleaseNo,
    required this.Payment,
    required this.Commodity,
    required this.VehicleTokenNo1,
    required this.VehicleTokenNo,
    required this.DOID,
    required this.HAWBId,
    required this.AIRLINE_MAWB,
    required this.TruckerName,
    required this.TruckerBranchId,
    required this.AirlinePrefix,
    required this.ShipmentType,
    required this.BookSlotStatus,
    required this.SlotStatus,
    required this.CreatedDate,
    required this.CustodianID,
    required this.WeightUnitId,
    required this.IsDeleted,
    required this.OriginAirportCode,
    required this.VTNO,
    required this.AllocatedPieces,
    required this.VTIndex,
    required this.Remarks,
    required this.BreakDownStatus,
    required this.PaymentStatus,
    required this.PAYMENTREMARKS,
    required this.DocAcceptanceStatus,
    required this.ErrorCodeStatus,
    required this.RequestID,
    required this.CrossLevel,
    required this.SlotTime,
  });

  // Rcvdpcs: json['Rcvdpcs'] == null ? 0 : json['Rcvdpcs'],
  //   RcvdGrWt: json['RcvdGrWt'] == null ? 0 : json['RcvdGrWt'],

  factory BookedAWBDetailImport.fromJson(Map<String, dynamic> json) {
    return BookedAWBDetailImport(
        Id: json['Id'] == null ? "" : json['Id'],
        FlightNo: json['FlightNo'] == null ? "" : json['FlightNo'],
        FlightDate: json['FlightDate'] == null ? "" : json['FlightDate'],
        MAWBNumber: json['MAWBNumber'] == null ? "" : json['MAWBNumber'],
        HAWBNumber: json['HAWBNumber'] == null ? "" : json['HAWBNumber'],
        GHA: json['GHA'] == null ? "" : json['GHA'],
        FreightForwarder:
            json['FreightForwarder'] == null ? "" : json['FreightForwarder'],
        AWBPcs: json['AWBPcs'] == null ? 0 : json['AWBPcs'],
        GrWt: json['GrWt'] == null ? 0 : json['GrWt'],
        Rcvdpcs: json['Rcvdpcs'] == null ? 0 : json['Rcvdpcs'],
        RcvdGrWt: json['RcvdGrWt'] == null ? 0 : json['RcvdGrWt'],
        RcvdChrgWt: json['RcvdChrgWt'] == null ? 0 : json['RcvdChrgWt'],
        DONoCreate: json['DONoCreate'] == null ? "" : json['DONoCreate'],
        CustomReleaseNo:
            json['CustomReleaseNo'] == null ? "" : json['CustomReleaseNo'],
        Payment: json['Payment'] == null ? "" : json['Payment'],
        Commodity: json['Commodity'] == null ? "" : json['Commodity'],
        VehicleTokenNo1:
            json['VehicleTokenNo1'] == null ? "" : json['VehicleTokenNo1'],
        VehicleTokenNo:
            json['VehicleTokenNo'] == null ? "" : json['VehicleTokenNo'],
        DOID: json['DOID'] == null ? 0 : json['DOID'],
        HAWBId: json['HAWBId'] == null ? 0 : json['HAWBId'],
        AIRLINE_MAWB: json['AIRLINE_MAWB'] == null ? "" : json['AIRLINE_MAWB'],
        TruckerName: json['TruckerName'] == null ? "" : json['TruckerName'],
        TruckerBranchId:
            json['TruckerBranchId'] == null ? "" : json['TruckerBranchId'],
        AirlinePrefix:
            json['AirlinePrefix'] == null ? "" : json['AirlinePrefix'],
        ShipmentType: json['ShipmentType'] == null ? "" : json['ShipmentType'],
        BookSlotStatus:
            json['BookSlotStatus'] == null ? "" : json['BookSlotStatus'],
        SlotStatus: json['SlotStatus'] == null ? "" : json['SlotStatus'],
        CreatedDate: json['CreatedDate'] == null ? "" : json['CreatedDate'],
        CustodianID: json['CustodianID'] == null ? "" : json['CustodianID'],
        WeightUnitId: json['WeightUnitId'] == null ? "" : json['WeightUnitId'],
        IsDeleted: json['IsDeleted'] == null
            ? false
            : json['IsDeleted'].toString() == "true"
                ? true
                : false,
        OriginAirportCode:
            json['OriginAirportCode'] == null ? "" : json['OriginAirportCode'],
        VTNO: json['VTNO'] == null ? "" : json['VTNO'],
        AllocatedPieces:
            json['AllocatedPieces'] == null ? 0 : json['AllocatedPieces'],
        VTIndex: json['VTIndex'] == null ? 0 : json['VTIndex'],
        Remarks: json['Remarks'] == null ? "" : json['Remarks'],
        BreakDownStatus:
            json['BreakDownStatus'] == null ? "" : json['BreakDownStatus'],
        PaymentStatus:
            json['PaymentStatus'] == null ? "" : json['PaymentStatus'],
        PAYMENTREMARKS:
            json['PAYMENTREMARKS'] == null ? "" : json['PAYMENTREMARKS'],
        DocAcceptanceStatus: json['DocAcceptanceStatus'] == null
            ? ""
            : json['DocAcceptanceStatus'],
        ErrorCodeStatus:
            json['ErrorCodeStatus'] == null ? "" : json['ErrorCodeStatus'],
        RequestID: json['RequestID'] == null ? "" : json['RequestID'],
        CrossLevel: json['CrossLevel'] == null ? "" : json['CrossLevel'],
        SlotTime: json['SlotTime'] == null ? "" : json['SlotTime']);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["Id"] = Id;
    map["FlightNo"] = FlightNo;
    map["FlightDate"] = FlightDate;
    map["MAWBNumber"] = MAWBNumber;
    map["HAWBNumber"] = HAWBNumber;
    map["GHA"] = GHA;
    map["FreightForwarder"] = FreightForwarder;
    map["AWBPcs"] = AWBPcs;
    map["GrWt"] = GrWt;
    map["Rcvdpcs"] = Rcvdpcs;
    map["RcvdGrWt"] = RcvdGrWt;
    map["RcvdChrgWt"] = RcvdChrgWt;
    map["DONoCreate"] = DONoCreate;
    map["CustomReleaseNo"] = CustomReleaseNo;
    map["Payment"] = Payment;
    map["Commodity"] = Commodity;
    map["VehicleTokenNo1"] = VehicleTokenNo1;
    map["VehicleTokenNo"] = VehicleTokenNo;
    map["DOID"] = DOID;
    map["HAWBId"] = HAWBId;
    map["AIRLINE_MAWB"] = AIRLINE_MAWB;
    map["TruckerName"] = TruckerName;
    map["TruckerBranchId"] = TruckerBranchId;
    map["AirlinePrefix"] = AirlinePrefix;
    map["ShipmentType"] = ShipmentType;
    map["BookSlotStatus"] = BookSlotStatus;
    map["SlotStatus"] = SlotStatus;
    map["CreatedDate"] = CreatedDate;
    map["CustodianID"] = CustodianID;
    map["WeightUnitId"] = WeightUnitId;
    map["IsDeleted"] = IsDeleted;
    map["OriginAirportCode"] = OriginAirportCode;
    map["VTNO"] = VTNO;
    map["AllocatedPieces"] = AllocatedPieces;
    map["VTIndex"] = VTIndex;
    map["Remarks"] = Remarks;
    map["BreakDownStatus"] = BreakDownStatus;
    map["PaymentStatus"] = PaymentStatus;
    map["PAYMENTREMARKS"] = PAYMENTREMARKS;
    map["DocAcceptanceStatus"] = DocAcceptanceStatus;
    map["ErrorCodeStatus"] = ErrorCodeStatus;
    map["RequestID"] = RequestID;
    map["CrossLevel"] = CrossLevel;
    map["SlotTime"] = SlotTime;
    return map;
  }
}

// [{"Status":"S","StrMessage
class ResponseMsg {
  final String Status;
  final String StrMessage;

  ResponseMsg({
    required this.Status,
    required this.StrMessage,
  });

  factory ResponseMsg.fromJson(Map<String, dynamic> json) {
    return ResponseMsg(
      Status: json['Status'] == null ? "" : json['Status'],
      StrMessage: json['StrMessage'] == null ? "" : json['StrMessage'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["Status"] = Status;
    map["StrMessage"] = StrMessage;
    return map;
  }
}
