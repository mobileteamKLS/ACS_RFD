class ITNDetails {
  dynamic hawbNumber;
  String mawbNumber;
  String origin;
  String originairportcode;
  String destination;
  String destinationairportcode;
  int awbid;
  String flightDate;
  int piecesCount;
  String custodian;
  double weight;
  String unit;
  dynamic asi;
  String truckerId;
  String truckerName;


  ITNDetails({
    required this.hawbNumber,
    required this.mawbNumber,
    required this.origin,
    required this.originairportcode,
    required this.destination,
    required this.destinationairportcode,
    required this.awbid,
    required this.flightDate,
    required this.piecesCount,
    required this.custodian,
    required this.weight,
    required this.unit,
    required this.asi,
    required this.truckerId,
    required this.truckerName,
 });


  factory ITNDetails.fromJson(Map<String, dynamic> json) {
    return ITNDetails(
      hawbNumber: json["HAWBNumber"]== null ? "" :json["HAWBNumber"],
      mawbNumber: json["MAWBNumber"]== null ? "" :json["MAWBNumber"],
      origin: json["ORIGIN"]== null ? "" :json["ORIGIN"],
      originairportcode: json["ORIGINAIRPORTCODE"]== null ? "" :json["ORIGINAIRPORTCODE"],
      destination: json["DESTINATION"]== null ? "" :json["DESTINATION"],
      destinationairportcode: json["DESTINATIONAIRPORTCODE"]== null ? "" : json["DESTINATIONAIRPORTCODE"],
      awbid: json["AWBID"]== null ? "" :json["AWBID"],
      flightDate: json["FlightDate"]== null ? "" :json["FlightDate"],
      piecesCount: json["PiecesCount"]== null ? "" :json["PiecesCount"],
      custodian: json["Custodian"]== null ? "" :json["Custodian"],
      weight: json["Weight"]== null ? "" :json["Weight"],
      unit: json["Unit"]== null ? "" :json["Unit"],
      asi: json["ASI"]== null ? "" :json["ASI"],
      truckerId: json["TruckerID"]== null ? "" :json["TruckerID"],
      truckerName: json["TruckerName"]== null ? "" :json["TruckerName"],
    );
  }

  Map<String, dynamic> toJson() => {
    "HAWBNumber": hawbNumber,
    "MAWBNumber": mawbNumber,
    "ORIGIN": origin,
    "ORIGINAIRPORTCODE": originairportcode,
    "DESTINATION": destination,
    "DESTINATIONAIRPORTCODE": destinationairportcode,
    "AWBID": awbid,
    "FlightDate": flightDate,
    "PiecesCount": piecesCount,
    "Custodian": custodian,
    "Weight": weight,
    "Unit": unit,
    "ASI": asi,
    "TruckerID": truckerId,
    "TruckerName": truckerName,
  };
}



