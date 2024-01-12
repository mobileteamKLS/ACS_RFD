import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';

class QRImageorScan extends StatefulWidget {
  const QRImageorScan({Key? key}) : super(key: key);

  @override
  State<QRImageorScan> createState() => _QRImageorScanState();
}

class _QRImageorScanState extends State<QRImageorScan> {
  var imageFile;
  var qrcode;
  // var _image;
  // var imagePicker;
  // var type;

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Image Picker"),
        ),
        body: Container(
            child: imageFile == null
                ? Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          // color: Colors.greenAccent,
                          onPressed: () {
                            _getFromGallery();
                          },
                          child: Text("PICK FROM GALLERY"),
                        ),
                        Container(
                          height: 40.0,
                        ),

                        // RaisedButton(
                        //   color: Colors.lightGreenAccent,
                        //   onPressed: () {
                        //     _getFromCamera();
                        //   },
                        //   child: Text("PICK FROM CAMERA"),
                        // )
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Text("QR CODE SCANNED IS = " + qrcode.toString()),
                      SizedBox(height: 30),
                      Container(
                        child: Image.file(
                          imageFile,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  )));
  }

  /// Get from gallery
  _getFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(image!.path);
      if (imageFile != null) getQRcode();
    });
  }

  getQRcode() async {
    String? str = await Scan.parse(imageFile.path);
    if (str != null) {
      setState(() {
        qrcode = str;
      });
    }
  }

  // final picker = ImagePicker();
  // PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);
  // imageFile = File(pickedFile!.path);

  // var image = await ImagePicker().pickImage(source: ImageSource.gallery);

  // if (image != null) {
  //   setState(() {
  //     imageFile = File(image!.path);
  //     //selectedImage = File(image!.path); // won't have any error now
  //   });
  // }

  // PickedFile pickedFile = await ImagePicker().getImage(
  //   source: ImageSource.gallery,
  //   maxWidth: 1800,
  //   maxHeight: 1800,
  // );
  // if (pickedFile != null) {
  //   setState(() {
  //     imageFile = Image.file(File(imageFile.path), width: 400, height: 400);//File(pickedFile.path);
  //   });
  // }
}

  /// Get from Camera
  // _getFromCamera() async {
  //   PickedFile pickedFile = await ImagePicker().getImage(
  //     source: ImageSource.camera,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile = Image.file(File(imageFile.path), width: 400, height: 400);//File(pickedFile.path);
  //     });
  //   }
  // }

