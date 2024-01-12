import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'headerclipper.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar:
      
      //  AppBar(
      //   //leading: Container(),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(right: 8.0),
      //       child: GestureDetector(
      //         child: Icon(
      //           // Icons.menu,
      //           Icons.close,
      //           size: 22,
      //           color: const Color(0xFFF4F7FB),
      //         ),
      //         onTap: () {
      //           Navigator.of(context).pop("");
      //         },
      //       ),
      //     ),
      //   ],
      //   backgroundColor: Color(0xFF0461AA),
      //   title: Center(
      //     child: Text(
      //       "Scan QR Code",
      //       style: TextStyle(
      //         fontFamily: 'Roboto',
      //         fontSize: 14,
      //         color: const Color(0xffffffff),
      //       ),
      //       textAlign: TextAlign.center,
      //     ),
      //   ),
      // ),
      body: Column(
        children: <Widget>[
          HeaderClipperWave(
                color1: Color(0xFF3383CD),
                color2: Color(0xFF11249F),
                headerText:  "Scan QR Code"),
 SizedBox(height:  30),
          Container(
              height: MediaQuery.of(context).size.height - 300,
              width: MediaQuery.of(context).size.width,
              child: _buildQrView(context)),
          result != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Container(
                      height: 30,
                      child: Text('Data: ${result!.code}',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: const Color(0xff0461aa),
                          ))),
                )
              :
              //Container(height: 30, child: Text('Scan a code')),
              Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Container(
                      height: 30,
                      child: Text('Scan a code',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: const Color(0xff0461aa),
                          ))),
                ),

          result != null
              ? ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF0461AA)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: Color(0xFF0461AA))))),
                  onPressed: () {
                    Navigator.of(context).pop(result!.code);
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    child: Center(
                      child: Text(
                        "Done",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,

      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      //print('resilut state here');
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
