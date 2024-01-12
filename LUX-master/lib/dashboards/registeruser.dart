import 'dart:convert';

import 'package:luxair/widgets/customdialogue.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../global.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  bool useMobileLayout = false, isLoading = false,
      isValidusername = true,
      isValidfirstname = true,
      isValidlastname = true,
      isValidemail = true;

  String errMsgText = "";

  TextEditingController txtUserName = new TextEditingController();
  TextEditingController txtFirstName = new TextEditingController();
  TextEditingController txtLastName = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();

  @override
  Widget build(BuildContext context) {
      var smallestDimension = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = smallestDimension < 600;

    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderClipperWave(
                color1: Color(0xFF3383CD),
                color2: Color(0xFF11249F),
                headerText: "Register User"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 15.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                                // hard coding child width
                                child: Text(
                                  "Username",
                                  style: useMobileLayout
                                ? mobileHeaderFontStyle
                                : TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF11249F),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    1.6, // hard coding child width
                                child: Container(
                                   height: useMobileLayout ? 40 : 65,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isValidusername
                                          ? Colors.grey.withOpacity(0.5)
                                          : Colors.red,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: TextField(
                                    controller: txtUserName,
                                    maxLength: 15,
                                    readOnly: false,
                                    //onChanged: (value) => runFilter(value),
                                    // textCapitalization:
                                    //     TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter preferred Username",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      counterText: "",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      isDense: true,
                                    ),
                                    style: useMobileLayout
                                  ? mobileTextFontStyle
                                  : TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 15.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                                // hard coding child width
                                child: Text(
                                  "First Name",
                                  style: useMobileLayout
                                ? mobileHeaderFontStyle
                                : TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF11249F),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    1.6, // hard coding child width
                                child: Container(
                                   height: useMobileLayout ? 40 : 65,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isValidfirstname
                                          ? Colors.grey.withOpacity(0.5)
                                          : Colors.red,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: TextField(
                                    controller: txtFirstName,
                                    maxLength: 30,
                                    readOnly: false,
                                    //onChanged: (value) => runFilter(value),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter your first name",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      counterText: "",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      isDense: true,
                                    ),
                                    style: useMobileLayout
                                  ? mobileTextFontStyle
                                  : TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 15.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                                // hard coding child width
                                child: Text(
                                  "Last Name",
                                  style: useMobileLayout
                                ? mobileHeaderFontStyle
                                : TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF11249F),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    1.6, // hard coding child width
                                child: Container(
                                   height: useMobileLayout ? 40 : 65,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isValidlastname
                                          ? Colors.grey.withOpacity(0.5)
                                          : Colors.red,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: TextField(
                                    controller: txtLastName,
                                    maxLength: 30,
                                    readOnly: false,
                                    //onChanged: (value) => runFilter(value),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter your last name",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      counterText: "",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      isDense: true,
                                    ),
                                   style: useMobileLayout
                                  ? mobileTextFontStyle
                                  : TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 15.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                                // hard coding child width
                                child: Text(
                                  "Email ID",
                                  style: useMobileLayout
                                ? mobileHeaderFontStyle
                                : TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF11249F),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    1.6, // hard coding child width
                                child: Container(
                                   height: useMobileLayout ? 40 : 65,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isValidemail
                                          ? Colors.grey.withOpacity(0.5)
                                          : Colors.red,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: TextField(
                                    controller: txtEmail,
                                    maxLength: 50,
                                    readOnly: false,
                                    //onChanged: (value) => runFilter(value),
                                    // textCapitalization:
                                    //     TextCapitalization.characters,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter your email id",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      counterText: "",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      isDense: true,
                                    ),
 style: useMobileLayout
                                  ? mobileTextFontStyle
                                  : TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (isLoading) return;

                              setState(() {
                                isValidusername = true;
                                isValidfirstname = true;
                                isValidlastname = true;
                                isValidemail = true;
                              });

                              if (txtUserName.text.toString().trim().length ==
                                  0)
                                setState(() {
                                  isValidusername = false;
                                  return;
                                });

                              if (txtFirstName.text.toString().trim().length ==
                                  0)
                                setState(() {
                                  isValidfirstname = false;
                                  return;
                                });

                              if (txtLastName.text.toString().trim().length ==
                                  0)
                                setState(() {
                                  isValidlastname = false;
                                  return;
                                });

                              if (txtEmail.text.toString().trim().length == 0)
                                setState(() {
                                  isValidemail = false;
                                  return;
                                });

                              if (isValidusername &&
                                  isValidfirstname &&
                                  isValidlastname &&
                                  isValidemail) {
                                // showSuccessMessage();
                                var submitCheckin = await registerNewUser();
                                if (submitCheckin == true) {
                                  var dlgstatus = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomDialog(
                                      title: txtUserName.text,
                                      description:
                                          "New user register request for " +
                                              txtFirstName.text +
                                              " " +
                                              txtLastName.text +
                                              " has been sent successfully. \n You will receive email for login details on " +
                                              txtEmail.text.toString(),

                                      buttonText: "Okay",
                                      imagepath: 'assets/images/successchk.gif',
                                      isMobile: useMobileLayout,
                                    ),
                                  );

                                  if (dlgstatus == true) {
                                    Navigator.of(context)
                                        .pop(true); // To close the form
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        customAlertMessageDialog(
                                            title: errMsgText == ""
                                                ? "Error Occured"
                                                : "Register User Failed",
                                            description: errMsgText == ""
                                                ? "Error occured while sending new user registration request, Please try again after some time"
                                                : errMsgText,
                                            buttonText: "Okay",
                                            imagepath: 'assets/images/warn.gif',
                                            isMobile: useMobileLayout),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)), //
                              padding: const EdgeInsets.all(0.0),
                            ),
                            child: Container(
       height: useMobileLayout ? 70 : 90,
                                width: useMobileLayout ? 250 : 350,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    isLoading ? Colors.grey : Color(0xFF1220BC),
                                    isLoading ? Colors.grey : Color(0xFF3540E8),
                                  ],
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                      fontSize: useMobileLayout
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  22
                                              : 28,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            //Text('CONTAINED BUTTON'),
                          ),
                          if (isLoading) SizedBox(width: 10),
                          if (isLoading)
                            Center(
                                child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 13,
                                    width:
                                        MediaQuery.of(context).size.height / 13,
                                    child: CircularProgressIndicator()))
                        ],
                      )
                    ]),
                  ],
                ),
              ),
            ),
          ]),
    );
  }

  Future<bool> registerNewUser() async {
    try {
      bool isValid = false;
      errMsgText = "";
      String responseTextUpdated = "";

      setState(() {
        isLoading = true;
      });

      var queryParams = {
        "LoginID": txtUserName.text.toString(),
        "FirstName": txtFirstName.text.toString(),
        "LastName": txtLastName.text.toString(),
        "Email": txtEmail.text.toString(),
      };
      await Global()
          .postData(
        Settings.SERVICES['Register'],
        queryParams,
      )
          .then((response) {
        print("data received ");
        print(json.decode(response.body)['d']);
        // isValid = true;

        if (json.decode(response.body)['d'] == null) {
          isValid = true;
        } else {
          if (json.decode(response.body)['d'] == "null") {
            isValid = true;
          } else {
            if (json.decode(response.body)['d'] == "") {
              isValid = true;
            } else {
              var responseText = json.decode(response.body)['d'].toString();

              if (responseText.toLowerCase().contains("errormsg")) {
                responseTextUpdated =
                    responseText.toString().toLowerCase().replaceAll("errormsg", "");
                responseTextUpdated =
                    responseTextUpdated.toString().replaceAll(":", "");
                responseTextUpdated =
                    responseTextUpdated.toString().replaceAll("\"", "");
                responseTextUpdated =
                    responseTextUpdated.toString().replaceAll("{", "");
                responseTextUpdated =
                    responseTextUpdated.toString().replaceAll("}", "");
                       responseTextUpdated =
                    responseTextUpdated.toString().replaceAll("[", "");
                responseTextUpdated =
                    responseTextUpdated.toString().replaceAll("]", "");
                print(responseTextUpdated.toString());
              }

              isValid = false;
            }
          }
        }

        setState(() {
          isLoading = false;
          if (responseTextUpdated != "") errMsgText = responseTextUpdated;
        });
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        print(onError);
      });
      return isValid;
    } catch (Exc) {
      print(Exc);
      return false;
    }
  }
}
