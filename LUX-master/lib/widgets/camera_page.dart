import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:luxair/widgets/preview_page.dart';

import 'headerclipper.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription>? cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = false;
  XFile picture = XFile('');

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![1]);
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture1 = await _cameraController.takePicture();

      setState(() {
        picture = picture1;
        // print(picture.path);
      });

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => PreviewPage(
      //               picture: picture,
      //             )));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
        cameraDescription, ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.bgra8888);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(title: const Text('Camera Page')),


        
        body: Stack(children: [
          (_cameraController.value.isInitialized)
              ? picture.path == ""
                  ? Column(
                    children: [
                       HeaderClipperWave(
          color1: Color(0xFF3383CD),
          color2: Color(0xFF11249F),
          headerText: "Click your Picture"),
                      Container(height:MediaQuery.of(context).size.height /1.5 ,
                      width: MediaQuery.of(context).size.width ,
                      child: Center(child: CameraPreview(_cameraController))),
                    ],
                  )
                  : Column(
                    children: [
                       HeaderClipperWave(
          color1: Color(0xFF3383CD),
          color2: Color(0xFF11249F),
          headerText: "Click your Picture"),
                       Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top:18.0, right: 18.0),
                child: IconButton(
                          onPressed: () { 
                          setState(() {
                         picture = XFile('');
                          });},
                          iconSize: 28,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.close, color: Colors.black),
                        ),
              ),),
                      SizedBox(height: 10),
                      Center(
                          child: Image.file(File(picture.path),
                              fit: BoxFit.fitHeight,height:MediaQuery.of(context).size.height /1.5 ,
                      width: MediaQuery.of(context).size.width),
                        ),
                    ],
                  )
              : Container(
                  color: Colors.black,
                  child: const Center(child: CircularProgressIndicator())),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.10,
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                    color: Colors.black),
                child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 40,
                        icon: Icon(
                            _isRearCameraSelected
                                ? CupertinoIcons.switch_camera
                                : CupertinoIcons.switch_camera_solid,
                            color: Colors.white),
                        onPressed: () {
                          //picture = XFile('');
                          setState(() {
                            _isRearCameraSelected = !_isRearCameraSelected;
                          });
                          // setState(() {
                          // picture.path == "";
                          //     _isRearCameraSelected = !_isRearCameraSelected});
                          initCamera(
                              widget.cameras![_isRearCameraSelected ? 0 : 1]);
                        },
                      ),
                      IconButton(
                        onPressed: takePicture,
                        iconSize: 50,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.circle, color: Colors.white),
                      ),

                      if (picture.path !="")IconButton(
                        onPressed: () {
                          print("closing noew " + picture.path );
                            Navigator.of(context).pop(picture);
                        },
                        iconSize: 50,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.done, color: Colors.white),
                      ),
                      //const Spacer(),
                    ]),
              )),
        ]));
  }
}
