class ListingDetails {
  int awbid;
  String mawbNumber;
  dynamic hawbNumber;
  String flightDate;
  int piecesCount;
  double weight;
  String weightUnitId;
  int custodianId;
  String custodian;
  String airlinePrefix;
  dynamic asi;
  dynamic co;
  String origin;
  String originairportcode;
  String destination;
  String destinationairportcode;
  String truckerId;
  String truckerName;

  ListingDetails({
    required this.awbid,
    required this.mawbNumber,
    required this.hawbNumber,
    required this.flightDate,
    required this.piecesCount,
    required this.weight,
    required this.weightUnitId,
    required this.custodianId,
    required this.custodian,
    required this.airlinePrefix,
    required this.asi,
    required this.co,
    required this.origin,
    required this.originairportcode,
    required this.destination,
    required this.destinationairportcode,
    required this.truckerId,
    required this.truckerName,});


  factory ListingDetails.fromJson(Map<String, dynamic> json) {
    return ListingDetails(
      awbid: json["AWBID"] == null ? "" : json["AWBID"],
      mawbNumber: json["MAWBNumber"] == null ? "" : json["MAWBNumber"],
      hawbNumber:json["HAWBNumber"] == null ? "" : json["HAWBNumber"],
      flightDate: json["FlightDate"] == null ? "" : json["FlightDate"],
      piecesCount: json["PiecesCount"]== null ? "" : json["PiecesCount"],
      weight:json["Weight"] == null ? "" : json["Weight"],
      weightUnitId: json["WeightUnitID"]== null ? "" : json["WeightUnitID"],
      custodianId:json["CustodianID"] == null ? "" : json["CustodianID"],
      custodian:json["Custodian"] == null ? "" : json["Custodian"],
      airlinePrefix:json["AirlinePrefix"] == null ? "" : json["AirlinePrefix"],
      asi: json["ASI"]== null ? "" : json["ASI"],
      co:json["ORIGIN"] == null ? "" : json["CO"],
      origin: json["ORIGIN"] == null ? "" : json["ORIGIN"],
      originairportcode:json["ORIGINAIRPORTCODE"] == null ? "" : json["ORIGINAIRPORTCODE"],
      destination: json["DESTINATION"]== null ? "" : json["DESTINATION"],
      destinationairportcode: json["DESTINATIONAIRPORTCODE"] == null ? "" : json["DESTINATIONAIRPORTCODE"],
      truckerId: json["TruckerID"] == null ? "" : json["TruckerID"],
      truckerName: json["TruckerName"] == null ? "" : json["TruckerName"],
    );
  }

  Map<String, dynamic> toJson() => {
    "AWBID": awbid,
    "MAWBNumber": mawbNumber,
    "HAWBNumber": hawbNumber,
    "FlightDate": flightDate,
    "PiecesCount": piecesCount,
    "Weight": weight,
    "WeightUnitID": weightUnitId,
    "CustodianID": custodianId,
    "Custodian": custodian,
    "AirlinePrefix": airlinePrefix,
    "ASI": asi,
    "CO": co,
    "ORIGIN": origin,
    "ORIGINAIRPORTCODE": originairportcode,
    "DESTINATION": destination,
    "DESTINATIONAIRPORTCODE": destinationairportcode,
    "TruckerID": truckerId,
    "TruckerName" : truckerName,
  };
}



