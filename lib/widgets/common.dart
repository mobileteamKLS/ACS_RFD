import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

// Colors
const kBackgroundColor = Color(0xFFFEFEFE);
const kTitleTextColor = Color(0xFF303030);
const kBodyTextColor = Color(0xFF4B4B4B);
const kTextLightColor = Color(0xFF959595);
const kInfectedColor = Color(0xFFFF8748);
const kDeathColor = Color(0xFFFF4848);
const kRecovercolor = Color(0xFF36C12C);
const kPrimaryColor = Color(0xFF3382CC);
final kShadowColor = Color(0xFFB7B7B7).withOpacity(.16);
final kActiveShadowColor = Color(0xFF4056C6).withOpacity(.15);

const kHeadingTextStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w600,
);

const kSubTextStyle = TextStyle(fontSize: 16, color: kTextLightColor);

const kTitleTextstyle = TextStyle(
  fontSize: 18,
  color: kTitleTextColor,
  fontWeight: FontWeight.bold,
);

class ScanContainerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 9.5, // 65.0,
      width: MediaQuery.of(context).size.width / 9.5, //65.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF1220BC),
            Color(0xFF3540E8),
          ],
        ),
      ),
      child: Icon(
        Icons.scanner,
        color: Colors.white,
        size: MediaQuery.of(context).size.width / 16, //32,
      ),
    );
  }
}

class GalleryScanContainerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 9.5, // 65.0,
      width: MediaQuery.of(context).size.width / 9.5, //65.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF1220BC),
            Color(0xFF3540E8),
          ],
        ),
      ),
      child: Icon(
        Icons.collections,
        color: Colors.white,
        size: MediaQuery.of(context).size.width / 16, //32,
      ),
    );
  }
}
class SearchContainerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 9.5, // 65.0,
      width: MediaQuery.of(context).size.width / 9.5, //65.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF1220BC),
            Color(0xFF3540E8),
          ],
        ),
      ),
      child: Icon(
        Icons.search,
        color: Colors.white,
        size: MediaQuery.of(context).size.width / 16, //32,
      ),
    );
  }
}
class DeleteScanContainerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 9.5, // 65.0,
      width: MediaQuery.of(context).size.width / 9.5, //65.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF1220BC),
            Color(0xFF3540E8),
          ],
        ),
      ),
      child: Icon(
        Icons.delete,
        color: Colors.white,
        size: MediaQuery.of(context).size.width / 16, //32,
      ),
    );
  }
}
class DatePickerContainerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 9.5, // 65.0,
      width: MediaQuery.of(context).size.width / 9.5, //65.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF1220BC),
            Color(0xFF3540E8),
          ],
        ),
      ),
      child: Icon(
        Icons.calendar_month_rounded,
        color: Colors.white,
        size: MediaQuery.of(context).size.width / 16, //32,
      ),
    );
  }
}
class SearchContainerButtonIpad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 14, // 65.0,
      width: MediaQuery.of(context).size.width / 14, //65.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF1220BC),
            Color(0xFF3540E8),
          ],
        ),
      ),
      child: Icon(
        Icons.search,
        color: Colors.white,
        size: MediaQuery.of(context).size.width / 18, //32,
      ),
    );
  }
}
class DeleteScanContainerButtonIpad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 14, // 65.0,
      width: MediaQuery.of(context).size.width / 14, //65.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF1220BC),
            Color(0xFF3540E8),
          ],
        ),
      ),
      child: Icon(
        Icons.delete,
        color: Colors.white,
        size: MediaQuery.of(context).size.width / 18, //32,
      ),
    );
  }
}
class DatePickerContainerButtonIpad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 14, // 65.0,
      width: MediaQuery.of(context).size.width / 14, //65.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF1220BC),
            Color(0xFF3540E8),
          ],
        ),
      ),
      child: Icon(
        Icons.calendar_month_rounded,
        color: Colors.white,
        size: MediaQuery.of(context).size.width / 18, //32,
      ),
    );
  }
}

class ScanContainerButtonIpad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 14, // 65.0,
      width: MediaQuery.of(context).size.width / 14, //65.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF1220BC),
            Color(0xFF3540E8),
          ],
        ),
      ),
      child: Icon(
        Icons.scanner,
        color: Colors.white,
        size: MediaQuery.of(context).size.width / 18, //32,
      ),
    );
  }
}

class GallaryScanContainerButtonIpad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 14, // 65.0,
      width: MediaQuery.of(context).size.width / 14, //65.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF1220BC),
            Color(0xFF3540E8),
          ],
        ),
      ),
      child: Icon(
        Icons.collections,
        color: Colors.white,
        size: MediaQuery.of(context).size.width / 18, //32,
      ),
    );
  }
}

showLoadingDialog(BuildContext context, isLoad) {
  isLoad
      ? showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
                backgroundColor: Colors.white,
                children: <Widget>[
                  Center(
                    child: Column(children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please Wait....",
                        style: TextStyle(
                          color: Color(0xFF0461AA),
                        ),
                      )
                    ]),
                  )
                ]);
          })
      : Navigator.pop(context);
}

showSavingDialog(BuildContext context, isLoad) {
  isLoad
      ? showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
                backgroundColor: Colors.white,
                children: <Widget>[
                  Center(
                    child: Column(children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Saving Data\n Please Wait....",
                        style: TextStyle(
                          color: Color(0xFF0461AA),
                        ),
                      )
                    ]),
                  )
                ]);
          })
      : Navigator.pop(context);
}

showAlertDialog(context, buttonText, titleText, msgText) {
  // set up the button
  Widget okButton = TextButton(
    child: Text(buttonText),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      titleText,
      style: TextStyle(
          fontFamily: 'Roboto', fontSize: 16, color: Colors.red.shade800),
    ),
    content: Text(
      msgText,
      style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<bool> sendSMS(mobileNumber, vtNo, driverName) async {
  bool isSent = false;
  //https://platform.clickatell.com/messages/http/send?apiKey=gS7BfRrtS2yMXtOHkRLAAg==&to=
  //+919890323584+
  //&content=Hello'

  var messageContent = " VT No " +
      vtNo.toString() +
      " Updated for Tucker. " +
      driverName.toString().toUpperCase() +
      "";

  var requestString =
      "https://platform.clickatell.com/messages/http/send?apiKey=gS7BfRrtS2yMXtOHkRLAAg==&to=";
  requestString = requestString + "+" + mobileNumber + "+&content=";
  requestString = requestString + messageContent;

  print("messageContent");
  print(messageContent);
  print("requestString");
  print(requestString);

  var request = http.Request('GET', Uri.parse(requestString));

  http.StreamedResponse response = await request.send();
  print(response);
  if (response.statusCode == 202) {
    isSent = true;
    print(response);
  } else {
    print(response.reasonPhrase);
  }
  return isSent;
}

Future<bool> sendSmsAccDel(
    mobileNumber, driverName, mAWBNumber, hAWBNumber) async {
  bool isSent = false;
  //https://platform.clickatell.com/messages/http/send?apiKey=gS7BfRrtS2yMXtOHkRLAAg==&to=
  //+919890323584+
  //&content=Hello'

  var messageContent = "Shipment for MAWB No. " +
      mAWBNumber.toString() +
      " & HAWB No(s). " +
      hAWBNumber.toString() +
      " has been delivered to " +
      driverName.toString().toUpperCase() +
      "";

  var requestString =
      "https://platform.clickatell.com/messages/http/send?apiKey=gS7BfRrtS2yMXtOHkRLAAg==&to=";
  requestString = requestString + "+" + mobileNumber + "+&content=";
  requestString = requestString + messageContent;

  print("messageContent");
  print(messageContent);
  print("requestString");
  print(requestString);

  var request = http.Request('GET', Uri.parse(requestString));

  http.StreamedResponse response = await request.send();
  print(response);
  if (response.statusCode == 202) {
    isSent = true;
    print(response);
  } else {
    print(response.reasonPhrase);
  }
  return isSent;
}

Future<String> determinePosition() async {
  bool serviceEnabled;
  // LocationPermission permission;
  String locationMsg = "OK";
  //  await Geolocator.requestPermission();
  //   // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.

    locationMsg =
        'Location services are disabled. Kindly enable from Phone settings.';
    // return Future.error('Location services are disabled.');
  } else {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locationMsg =
            'Location permissions are denied. Restart app and select "While using" or "Always" when asked for location ';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      //permission = await Geolocator.requestPermission();
      // Permissions are denied forever, handle appropriately.
      locationMsg =
          'Location permissions are permanently denied, we cannot request permissions.Kindly allow from Phone settings.';
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      locationMsg = 'OK';
    }
  }
  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  //return await Geolocator.getCurrentPosition();
  return locationMsg;
}

void showSnackBar(BuildContext context,msg,screenWidth) {
  final snackBar = SnackBar(
    content: Text(msg),
    backgroundColor: Color(0xFF1220BC),
    behavior: SnackBarBehavior.floating,
    width: screenWidth,
    action: SnackBarAction(
      label: 'Dismiss',
      disabledTextColor:Colors.white,
      textColor: Colors.yellow,
      onPressed: () {
        //Do whatever you want
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
