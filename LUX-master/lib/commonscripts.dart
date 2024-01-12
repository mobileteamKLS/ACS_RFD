//  import '../constants.dart';
// import '../global.dart';
//  import 'package:flutter/material.dart';
 
//  getTerminalsList() async {
//     if (isLoading) return;

//     // vehicleToeknListExport = [];
//     // vehicleToeknListImport = [];
//     // vehicleToeknListToBind = [];

//     setState(() {
//       isLoading = true;
//     });

//     var queryParams = {};
//     await Global()
//         .postData(
//       Settings.SERVICES['TerminalsList'],
//       queryParams,
//     )
//         .then((response) {
//       print("data received ");
//       print(json.decode(response.body)['d']);

//       var msg = json.decode(response.body)['d'];
//       var resp = json.decode(msg).cast<Map<String, dynamic>>();

//       terminalsList = resp
//           .map<WarehouseTerminals>((json) => WarehouseTerminals.fromJson(json))
//           .toList();

//       print("length terminalsList = " + terminalsList.length.toString());

//       setState(() {
//         isLoading = false;
//       });
//     }).catchError((onError) {
//       // setState(() {
//       //   isLoading = false;
//       // });
//       print(onError);
//     });
//   }
