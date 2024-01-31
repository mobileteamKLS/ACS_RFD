class ASIList{
  final int BoEID;
  final int BoENumber;
  final int GHAID;
  final String GHANAME;
  final int HAWBID;
  final String HAWBNumber;
  final double HAWB_Total_ChargeWt;
  final double HAWB_Total_GrossWt;
  final int HAWB_Total_Nop;
  final int MAWBID;
  final String MAWBNumber;
  final int OOCID;
  final String Unit;

  ASIList({
    required this.BoEID,
    required this.BoENumber,
    required this.GHAID,
    required this.GHANAME,
    required this.HAWBID,
    required this.HAWBNumber,
    required this.HAWB_Total_ChargeWt,
    required this.HAWB_Total_GrossWt,
    required this.HAWB_Total_Nop,
    required this.MAWBID,
    required this.MAWBNumber,
    required this.OOCID,
    required this.Unit,
  });

  factory ASIList.fromJson(Map<String, dynamic> json) {
    return ASIList(
      BoEID: json['BoEID'] == null ? "" : json['BoEID'],
      BoENumber: json['BoENumber'] == null ? "" : json['BoENumber'],
      GHAID: json['GHAID'] == null ? "" : json['GHAID'],
      GHANAME: json['GHANAME'] == null ? "" : json['GHANAME'],
      HAWBID: json['HAWBID'] == null ? "" : json['HAWBID'],
      HAWBNumber: json['HAWBNumber'] == null ? "" : json['HAWBNumber'],
      HAWB_Total_ChargeWt: json['HAWB_Total_ChargeWt'] == null ? "" : json['HAWB_Total_ChargeWt'],
      HAWB_Total_GrossWt: json['HAWB_Total_GrossWt'] == null ? "" : json['HAWB_Total_GrossWt'],
      HAWB_Total_Nop: json['HAWB_Total_Nop'] == null ? "" : json['HAWB_Total_Nop'],
      MAWBID: json['MAWBID'] == null ? "" : json['MAWBID'],
      MAWBNumber: json['MAWBNumber'] == null ? "" : json['MAWBNumber'],
      OOCID: json['OOCID'] == null ? "" : json['OOCID'],
      Unit: json['Unit'] == null ? "" : json['Unit'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["BoEID"] = BoEID;
    map["BoENumber"] = BoENumber;
    map["GHAID"] = GHAID;
    map["GHANAME"] = GHANAME;
    map["HAWBID"] = HAWBID;
    map["HAWBNumber"] = HAWBNumber;
    map["HAWB_Total_ChargeWt"] = HAWB_Total_ChargeWt;
    map["HAWB_Total_GrossWt"] = HAWB_Total_GrossWt;
    map["HAWB_Total_Nop"] = HAWB_Total_Nop;
    map["MAWBID"] = MAWBID;
    map["MAWBNumber"] = MAWBNumber;
    map["OOCID"] = OOCID;
    map["Unit"] = Unit;
    return map;
  }
}