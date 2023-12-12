class DockStatusLive {
  final String DockName;
  final String Terminal;
  final String DockStatus;
  final String CheckIn;
  final String Airline;
  final String TruckCompany;
  final String DRIVERMOBILENO;
  final String VTNo;
  final String TimeAtDock;
  final bool IsWalkin;
  final bool IsDockAssigned;
  final String Dockin;
  final String DockOut;
  final String TPSCheckIn;
  final String TPSCheckOut;
  final String strEmptySlots;
  final int GHABranchID;
  final int DockID;
  final String Mode;
  final String DockinTimestamp;
  final bool Isblock;
  final String Remarks;

  DockStatusLive({
    required this.DockName,
    required this.Terminal,
    required this.DockStatus,
    required this.CheckIn,
    required this.Airline,
    required this.TruckCompany,
    required this.DRIVERMOBILENO,
    required this.VTNo,
    required this.TimeAtDock,
    required this.IsWalkin,
    required this.IsDockAssigned,
    required this.Dockin,
    required this.DockOut,
    required this.TPSCheckIn,
    required this.TPSCheckOut,
    required this.strEmptySlots,
    required this.GHABranchID,
    required this.DockID,
    required this.Mode,
    required this.DockinTimestamp,
    required this.Isblock,
    required this.Remarks,
  });

  factory DockStatusLive.fromJson(Map<String, dynamic> json) {
    return DockStatusLive(
      // custodianName: json['CustodianName'] == null ? "" : json['CustodianName'],
      // custudian: json['CUSTODIAN'] == null ? 0 : json['CUSTODIAN'],

      DockName: json['DockName'] == null ? "" : json['DockName'],
      Terminal: json['Terminal'] == null ? "" : json['Terminal'],
      DockStatus: json['DockStatus'] == null ? "" : json['DockStatus'],
      CheckIn: json['CheckIn'] == null ? "" : json['CheckIn'],
      Airline: json['Airline'] == null ? "" : json['Airline'],
      TruckCompany: json['TruckCompany'] == null ? "" : json['TruckCompany'],
      DRIVERMOBILENO:
          json['DRIVERMOBILENO'] == null ? "" : json['DRIVERMOBILENO'],
      VTNo: json['VTNo'] == null ? "" : json['VTNo'],
      TimeAtDock: json['TimeAtDock'] == null ? "" : json['TimeAtDock'],
      IsWalkin: json['IsWalkin'] == null
          ? false
          : json['IsWalkin'].toString() == "true"
              ? true
              : false,
      //json['IsWalkin'] == null ? "" : json['IsWalkin'],
      IsDockAssigned: json['IsDockAssigned'] == null
          ? false
          : json['IsDockAssigned'].toString() == "true"
              ? true
              : false,
      //json['IsDockAssigned'] == null ? "" : json['IsDockAssigned'],
      Dockin: json['Dockin'] == null ? "" : json['Dockin'],
      DockOut: json['DockOut'] == null ? "" : json['DockOut'],
      TPSCheckIn: json['TPSCheckIn'] == null ? "" : json['TPSCheckIn'],
      TPSCheckOut: json['TPSCheckOut'] == null ? "" : json['TPSCheckOut'],
      strEmptySlots: json['strEmptySlots'] == null ? "" : json['strEmptySlots'],
      GHABranchID: json['GHABranchID'] == null ? 0 : json['GHABranchID'],
      DockID: json['DockID'] == null ? 0 : json['DockID'],
      Mode: json['Mode'] == null ? "" : json['Mode'],
      DockinTimestamp:
          json['DockinTimestamp'] == null ? "" : json['DockinTimestamp'],
      Isblock: json['Isblock'] == null
          ? false
          : json['Isblock'].toString() == "true"
              ? true
              : false,
      //json['Isblock'] == null ? "" :json['Isblock'],
      Remarks: json['Remarks'] == null ? "" : json['Remarks'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["DockName"] = DockName;
    map["Terminal"] = Terminal;
    map["DockStatus"] = DockStatus;
    map["CheckIn"] = CheckIn;
    map["Airline"] = Airline;
    map["TruckCompany"] = TruckCompany;
    map["DRIVERMOBILENO"] = DRIVERMOBILENO;
    map["VTNo"] = VTNo;
    map["TimeAtDock"] = TimeAtDock;
    map["IsWalkin"] = IsWalkin;
    map["IsDockAssigned"] = IsDockAssigned;
    map["Dockin"] = Dockin;
    map["DockOut"] = DockOut;
    map["TPSCheckIn"] = TPSCheckIn;
    map["TPSCheckOut"] = TPSCheckOut;
    map["strEmptySlots"] = strEmptySlots;
    map["GHABranchID"] = GHABranchID;
    map["DockID"] = DockID;
    map["Mode"] = Mode;
    map["DockinTimestamp"] = DockinTimestamp;
    map["Isblock"] = Isblock;
    map["Remarks"] = Remarks;
    return map;
  }
}

class QueueStatusLive {
  final String TOKENNO;
  final String DockStatus;
  final String SLOTTIME;
  final String ServiceTime;
  final String VEHICLENO;
  final String DRIVERNAME;
  final String DRIVERMOBILENO;
  final String YardCheckin;
  final String tpscheckInTimestamp;
  final String VEHICLETYPE;
  final int VEHICLETYPEId;
  final String strEmptySlots;
  final String Terminal;

  QueueStatusLive({
    required this.TOKENNO,
    required this.DockStatus,
    required this.SLOTTIME,
    required this.ServiceTime,
    required this.VEHICLENO,
    required this.DRIVERNAME,
    required this.DRIVERMOBILENO,
    required this.YardCheckin,
    required this.tpscheckInTimestamp,
    required this.VEHICLETYPE,
    required this.VEHICLETYPEId,
    required this.strEmptySlots,
    required this.Terminal,
  });

  factory QueueStatusLive.fromJson(Map<String, dynamic> json) {
    return QueueStatusLive(
      // custodianName: json['CustodianName'] == null ? "" : json['CustodianName'],
      // custudian: json['CUSTODIAN'] == null ? 0 : json['CUSTODIAN'],

      TOKENNO: json['TOKENNO'] == null ? "" : json['TOKENNO'],
      DockStatus: json['DockStatus'] == null ? "" : json['DockStatus'],
      SLOTTIME: json['SLOTTIME'] == null ? "" : json['SLOTTIME'],
      ServiceTime: json['ServiceTime'] == null ? "" : json['ServiceTime'],
      VEHICLENO: json['VEHICLENO'] == null ? "" : json['VEHICLENO'],
      DRIVERNAME: json['DRIVERNAME'] == null ? "" : json['DRIVERNAME'],
      DRIVERMOBILENO:
          json['DRIVERMOBILENO'] == null ? "" : json['DRIVERMOBILENO'],
      YardCheckin: json['YardCheckin'] == null ? "" : json['YardCheckin'],
      tpscheckInTimestamp: json['tpscheckInTimestamp'] == null
          ? ""
          : json['tpscheckInTimestamp'],
      VEHICLETYPE: json['VEHICLETYPE'] == null ? "" : json['VEHICLETYPE'],
      VEHICLETYPEId: json['VEHICLETYPEId'] == null ? 0 : json['VEHICLETYPEId'],
      strEmptySlots: json['strEmptySlots'] == null ? "" : json['strEmptySlots'],
      Terminal: json['Terminal'] == null ? "" : json['Terminal'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["TOKENNO"] = TOKENNO;
    map["DockStatus"] = DockStatus;
    map["SLOTTIME"] = SLOTTIME;
    map["ServiceTime"] = ServiceTime;
    map["VEHICLENO"] = VEHICLENO;
    map["DRIVERNAME"] = DRIVERNAME;
    map["DRIVERMOBILENO"] = DRIVERMOBILENO;
    map["YardCheckin"] = YardCheckin;
    map["tpscheckInTimestamp"] = tpscheckInTimestamp;
    map["VEHICLETYPE"] = VEHICLETYPE;
    map["VEHICLETYPEId"] = VEHICLETYPEId;
    map["strEmptySlots"] = strEmptySlots;
    map["Terminal"] = Terminal;
    return map;
  }
}

class VehicleAndDocks {
  final int id;
  final String TruckTypeIds;
  final String TruckTypeNames;
  final String strEmptySlots;

  VehicleAndDocks({
    required this.id,
    required this.TruckTypeIds,
    required this.TruckTypeNames,
    required this.strEmptySlots,
  });

  factory VehicleAndDocks.fromJson(Map<String, dynamic> json) {
    return VehicleAndDocks(
      // custodianName: json['CustodianName'] == null ? "" : json['CustodianName'],
      // custudian: json['CUSTODIAN'] == null ? 0 : json['CUSTODIAN'],
      id: json['id'] == null ? 0 : json['id'],
      TruckTypeIds: json['TruckTypeIds'] == null ? "" : json['TruckTypeIds'],
      TruckTypeNames:
          json['TruckTypeNames'] == null ? "" : json['TruckTypeNames'],
      strEmptySlots: json['strEmptySlots'] == null ? "" : json['strEmptySlots'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["TruckTypeIds"] = TruckTypeIds;
    map["TruckTypeNames"] = TruckTypeNames;
    map["strEmptySlots"] = strEmptySlots;
    return map;
  }
}
