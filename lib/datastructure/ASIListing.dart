class ASIDetails {
  final String MAWBNumber;
  bool? isSelected;

  ASIDetails({
    required this.MAWBNumber,
    this.isSelected = false});


  factory ASIDetails.fromJson(Map<String, dynamic> json) {
    return ASIDetails(
      MAWBNumber: json['MAWBNumber'] == null ? "" : json['MAWBNumber'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["MAWBNumber"] = MAWBNumber;
    return map;
  }
}



