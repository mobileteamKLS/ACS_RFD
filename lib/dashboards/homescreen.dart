import 'dart:convert';

import 'package:luxair/dashboards/registeruser.dart';
import 'package:luxair/datastructure/vehicletoken.dart';
import 'package:luxair/otherpages/trackshipment.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:luxair/dashboards/login.dart';
import 'package:luxair/otherpages/yardcheckin.dart';
import 'package:luxair/widgets/headers.dart';

import '../constants.dart';
import '../global.dart';
import 'leaderboard.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:ani'
// import 'package:flutter_svg/flutter_svg.dart';

// import 'package:luxair/widgets/common.dart';
// import 'package:luxair/widgets/headers.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  double offset = 0;
  bool useMobileLayout = false, isLoadingMain = false, showLabel = false;
  static List<LableDisplay> lblDisplay = [];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
   // getLabelStatus();
    super.initState();
    controller.addListener(onScroll);
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  getLabelStatus() async {
    if (isLoadingMain) return;

    setState(() {
      isLoadingMain = true;
    });

    var queryParams = {};
    await Global()
        .postData(
      Settings.SERVICES['ShowTrackShipmentLabel'],
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['d']);

      var msg = json.decode(response.body)['d'];
      var resp = json.decode(msg).cast<Map<String, dynamic>>();

      lblDisplay = resp
          .map<LableDisplay>((json) => LableDisplay.fromJson(json))
          .toList();

      print("length lblDisplay = " + lblDisplay.length.toString());

      setState(() {
        showLabel = lblDisplay[0].showLable;
        isLoadingMain = false;
      });
    }).catchError((onError) {
      // setState(() {
      //   isLoading = false;
      // });
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = smallestDimension < 600;

    //double fontsizeWelcome = (MediaQuery.of(context).size.width / 20);//72,52,
    return Scaffold(
      floatingActionButton: // !useMobileLayout
          (kIsWeb)
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LeaderBoard()),
                    );
                  },
                  backgroundColor: Color(0xFF11249F), //Colors.green,
                  child: const Icon(Icons.leaderboard),
                )
              : Container(),
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Opacity(
                    //semi red clippath with more height and with 0.5 opacity
                    opacity: 0.5,
                    child: ClipPath(
                      clipper: WaveClipper(), //set our custom wave clipper
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xFF4364F7),
                              Color(0xFFa8c0ff),
                            ],
                          ),
                        ),
                        //color:Colors.deepOrangeAccent,
                        height: MediaQuery.of(context).size.height / 2.8, //200,
                      ),
                    ),
                  ),
                  ClipPath(
                    //upper clippath with less height
                    clipper: WaveClipper(), //set our custom wave clipper.
                    child: Container(
                      padding: EdgeInsets.only(bottom: 50),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xFF3383CD),
                            Color(0xFF11249F),
                          ],
                        ),
                      ),
                      height: MediaQuery.of(context).size.height / 3, //180,
                      alignment: Alignment.center,

                      child: DefaultTextStyle(
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width / 15, //52,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText('Welcome !!'),
                            TyperAnimatedText('Bonjour !!'),
                            // TyperAnimatedText('Bienvenida !!'),
                           // TyperAnimatedText('ਸੁਆਗਤ ਹੈ !!'),
                            TyperAnimatedText('नमस्ते !!'),
                            TyperAnimatedText('Bienvenida !!'),
                            TyperAnimatedText('Welcome !!'),
                          ],
                        ),
                      ),

                      // Text("Wave clipper", style: TextStyle(
                      //   fontSize:18, color:Colors.white,
                      // ),

                      // )
                    ),
                  ),

                  // ClipPath(
                  //   clipper: MyClippers(),
                  //   child: Container(
                  //     padding: EdgeInsets.only(left: 40, top: 50, right: 20),
                  //     // height: 480,
                  //     // width: double.infinity,
                  //      height: MediaQuery.of(context).size.height / 2,
                  // width: MediaQuery.of(context).size.width, //180,
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         begin: Alignment.topCenter,
                  //         end: Alignment.bottomLeft,
                  //         colors: [
                  //           Color(0xFF4364F7),
                  //           Color(0xFFa8c0ff),
                  //         ],
                  //       ),
                  //       // image: DecorationImage(
                  //       //   image: AssetImage("assets/images/virus.png"),
                  //       // ),
                  //     ),
                  //   ),
                  // ),
                  //     ClipPath(
                  //       clipper: MyClippers(),
                  //       child: Container(
                  //         padding: EdgeInsets.only(left: 40, top: 50, right: 20),
                  //           height: MediaQuery.of(context).size.height / 2.1,
                  //         // width: double.infinity,
                  //         //  height: MediaQuery.of(context).size.height / 5,
                  //     width: MediaQuery.of(context).size.width, //180,
                  //         decoration: BoxDecoration(
                  //           gradient: LinearGradient(
                  //             begin: Alignment.topRight,
                  //             end: Alignment.bottomLeft,
                  //             colors: [
                  //               Color(0xFF3383CD),
                  //               Color(0xFF11249F),
                  //             ],
                  //           ),
                  //           // image: DecorationImage(
                  //           //   image: AssetImage("assets/images/virus.png"),
                  //           // ),
                  //         ),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             SizedBox(height: 30),
                  //             Padding(
                  //               padding: const EdgeInsets.only(bottom: 150.0),
                  //               child: DefaultTextStyle(
                  //                 style:  TextStyle(
                  //                     fontSize: MediaQuery.of(context).size.width / 15,//52,
                  //                     fontFamily: 'Roboto',
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white),
                  //                 child: AnimatedTextKit(
                  //                   animatedTexts: [
                  //                     TyperAnimatedText('Welcome !!'),
                  //                     TyperAnimatedText('Bienvenida !!'),
                  //                     TyperAnimatedText('नमस्ते !!'),
                  //                     TyperAnimatedText('Welcome !!'),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //     //         //SizedBox(height: 100),
                  //     //         // Padding(
                  //     //         //   padding: const EdgeInsets.only(bottom: 150.0),
                  //     //         //   child: Container(
                  //     //         //     width: 200,
                  //     //         //     child: DropdownButtonFormField(
                  //     //         //       decoration: InputDecoration(
                  //     //         //         enabledBorder: OutlineInputBorder(
                  //     //         //           borderSide:
                  //     //         //               BorderSide(color: Colors.blue, width: 2),
                  //     //         //           borderRadius: BorderRadius.circular(20),
                  //     //         //         ),
                  //     //         //         border: OutlineInputBorder(
                  //     //         //           borderSide:
                  //     //         //               BorderSide(color: Colors.blue, width: 2),
                  //     //         //           borderRadius: BorderRadius.circular(20),
                  //     //         //         ),
                  //     //         //         filled: true,
                  //     //         //         fillColor: Colors.white,
                  //     //         //       ),
                  //     //         //       isDense: true,
                  //     //         //       isExpanded: true,
                  //     //         //       dropdownColor: Colors.white,
                  //     //         //       // isExpanded: true,
                  //     //         //       //underline: SizedBox(),
                  //     //         //       //icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                  //     //         //       value: "JFK-09",
                  //     //         //       items: [
                  //     //         //         'ABC Ground Handling Services',
                  //     //         //         'AdminGHA',
                  //     //         //         'Bldg_151',
                  //     //         //         'Bldg_76',
                  //     //         //         'Bldg_9',
                  //     //         //         'JFK-09',
                  //     //         //         'JFK-151'
                  //     //         //       ].map<DropdownMenuItem<String>>((String value) {
                  //     //         //         return DropdownMenuItem<String>(
                  //     //         //           value: value,
                  //     //         //           child: Text(value),
                  //     //         //         );
                  //     //         //       }).toList(),
                  //     //         //       onChanged: (value) {},
                  //     //         //     ),
                  //     //         //   ),
                  //     //         // ),
                  //     //       ],
                  //     //     ),
                  //     //   ),
                  //     // ),

                  //   ],
                  // ), //padding: const EdgeInsets.only(left: 40.0, top: 40.0),
                  //       ),
                  //     ),
                ],
              ),
              isLoadingMain
                  ? Center(
                      child: Container(
                          height: MediaQuery.of(context).size.height / 13,
                          width: MediaQuery.of(context).size.height / 13,
                          child: CircularProgressIndicator()))
                  : Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Center(
                        child: Wrap(
                          //]]mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            //        Padding(
                            //     padding: const EdgeInsets.only(left: 10.0),
                            //     child: ElevatedButton(
                            //       onPressed: () {
                            //          Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => SplashScreen()),
                            // );
                            //       },
                            //       style: ElevatedButton.styleFrom(
                            //         elevation: 4.0,
                            //         shape: RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.circular(10.0)), //
                            //         padding: const EdgeInsets.all(0.0),
                            //       ),
                            //       child: Container(
                            //         height: 50,
                            //         width: 150,
                            //         decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(10),
                            //           gradient: LinearGradient(
                            //             begin: Alignment.topRight,
                            //             end: Alignment.bottomLeft,
                            //             colors: [
                            //               Color(0xFF1220BC),
                            //               Color(0xFF3540E8),
                            //             ],
                            //           ),
                            //         ),
                            //         child: Padding(
                            //           padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            //           child: Align(
                            //             alignment: Alignment.center,
                            //             child: Text(
                            //               'Add MAWB',
                            //               style: TextStyle(
                            //                   fontSize: 20,
                            //                   fontWeight: FontWeight.normal,
                            //                   color: Colors.white),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       //Text('CONTAINED BUTTON'),
                            //     ),
                            //   ),
                            FadeInLeft(
                              child: HomeScreenMenuBlock(
                                  Color(0xFFff4b1f), // Color(0xFF1A2980),
                                  Color(0xFFff9068),
                                  Icons.check_circle,
                                  "Easy",
                                  "Yard",
                                  "Check-In",
                                  YardCheckIn(),
                                  useMobileLayout),
                            ),

                            FadeInRight(
                              child: HomeScreenMenuBlock(
                                  Color(0xFF0052D4),
                                  Color(0xFF9CECFB),
                                  Icons.login,
                                  "Ground",
                                  "Handler",
                                  "Login",
                                  LoginPage(),
                                  useMobileLayout),
                            ),

                            SizedBox(
                              width: kIsWeb
                                  ? MediaQuery.of(context).size.width / 3
                                  : MediaQuery.of(context).size.width / 1.1,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 40.0, bottom: 40.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TrackShipemnt()),
                                            );
                                          },
                                          child: Text(
                                            showLabel ? "Track Shipment" : "",
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF11249F),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterUser()),
                                        );
                                      },
                                      child: Text(
                                        showLabel ? "Register Now" : "",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF11249F),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )

                            //  HomeScreenMenuBlock(Color(0xFF0052D4), Color(0xFF9CECFB),
                            //                       Icons.login, "Ground", "Handler", "Login", QRImageorScan(),useMobileLayout),

                            // ElevatedButton(
                            //   onPressed: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => YardCheckIn()),
                            //     );
                            //   },
                            //   //padding: const EdgeInsets.all(0.0),
                            //   style: ElevatedButton.styleFrom(
                            //     elevation: 4.0,
                            //     // side: BorderSide(
                            //     //     color: Colors.yellow,
                            //     //     width: 2.0,
                            //     //     style: BorderStyle.solid), //set border for the button
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(10.0)), //
                            //     padding: const EdgeInsets.all(0.0),
                            //   ),
                            //   child: Container(
                            //     height: MediaQuery.of(context).size.width / 3,
                            //     width: MediaQuery.of(context).size.width / 3, //180,
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(10),
                            //       gradient: LinearGradient(
                            //         begin: Alignment.topRight,
                            //         end: Alignment.bottomLeft,
                            //         colors: [
                            //           Color(0xFFfd6607),
                            //           Color(0xFFfd7f07),
                            //         ],
                            //       ),
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Stack(
                            //         children: [
                            //           Align(
                            //             alignment: Alignment.topRight,
                            //             child: Icon(
                            //               Icons.check_circle,
                            //               size: 48,
                            //               color: Colors.white,
                            //             ),
                            //           ),
                            //           Column(
                            //               mainAxisAlignment: MainAxisAlignment.end,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   'Easy',
                            //                   style: TextStyle(
                            //                       fontSize: 28,
                            //                       fontWeight: FontWeight.normal,
                            //                       color: Colors.white),
                            //                 ),
                            //                 Text('Yard',
                            //                     style: TextStyle(
                            //                         fontSize: 28,
                            //                         fontWeight: FontWeight.normal,
                            //                         color: Colors.white)),
                            //                 Text('Check-in',
                            //                     style: TextStyle(
                            //                         fontSize: 28,
                            //                         fontWeight: FontWeight.normal,
                            //                         color: Colors.white))
                            //               ]),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            //   //Text('CONTAINED BUTTON'),
                            // ),

                            // Padding(
                            //   padding: const EdgeInsets.only(left: 40.0, right: 10.0),
                            //   child: ElevatedButton(
                            //     onPressed: () {
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => LoginPage()),
                            //       );
                            //     },
                            //     //padding: const EdgeInsets.all(0.0),
                            //     style: ElevatedButton.styleFrom(
                            //       elevation: 4.0,
                            //       // side: BorderSide(
                            //       //     color: Colors.yellow,
                            //       //     width: 2.0,
                            //       //     style: BorderStyle.solid), //set border for the button
                            //       shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(10.0)), //
                            //       padding: const EdgeInsets.all(0.0),
                            //     ),
                            //     child: Container(
                            //       height: MediaQuery.of(context).size.width / 3,
                            //       width: MediaQuery.of(context).size.width / 3, //180,
                            //       decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(10),
                            //         gradient: LinearGradient(
                            //           begin: Alignment.topRight,
                            //           end: Alignment.bottomLeft,
                            //           colors: [
                            //             Color(0xFF076cfd),
                            //             Color(0xFF0785fd),
                            //           ],
                            //         ),
                            //       ),
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: Stack(
                            //           // mainAxisAlignment: MainAxisAlignment.end,
                            //           // crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Align(
                            //               alignment: Alignment.topRight,
                            //               child: Icon(
                            //                 Icons.login,
                            //                 size: 48,
                            //                 color: Colors.white,
                            //               ),
                            //             ),
                            //             Column(
                            //                 mainAxisAlignment: MainAxisAlignment.end,
                            //                 crossAxisAlignment:
                            //                     CrossAxisAlignment.start,
                            //                 children: [
                            //                   Text(
                            //                     'Ground',
                            //                     style: TextStyle(
                            //                         fontSize: 28,
                            //                         fontWeight: FontWeight.normal,
                            //                         color: Colors.white),
                            //                   ),
                            //                   Text('Handler',
                            //                       style: TextStyle(
                            //                           fontSize: 28,
                            //                           fontWeight: FontWeight.normal,
                            //                           color: Colors.white)),
                            //                   Text('Login',
                            //                       style: TextStyle(
                            //                           fontSize: 28,
                            //                           fontWeight: FontWeight.normal,
                            //                           color: Colors.white))
                            //                 ]),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //     //Text('CONTAINED BUTTON'),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
            ]),
      ),
    );
  }
}

class MyClippers extends CustomClipper<Path> {
  // @override
  // Path getClip(Size size) {
  //   var path = Path();
  //   path.lineTo(0, size.height - 80);
  //   path.quadraticBezierTo(
  //       size.width / 2, size.height, size.width, size.height - 80);
  //   path.lineTo(size.width, 0);
  //   path.close();
  //   return path;
  // }
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    var firstControlPoint = Offset(55, size.height / 1.4);
    var firstEndPoint = Offset(size.width / 1.7, size.height / 1.3);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width - (35), size.height - 95);
    var secondEndPoint = Offset(size.width, size.height / 2);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class HomeScreenMenuBlock extends StatelessWidget {
  HomeScreenMenuBlock(this.color1, this.color2, this.lblicon, this.btnText1,
      this.btnText2, this.btnText3, this.pageroute, this.isMobile);

  final Color color1;
  final Color color2;
  final IconData lblicon;
  final String btnText1;
  final String btnText2;
  final String btnText3;
  final pageroute;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kIsWeb ? 400 : MediaQuery.of(context).size.height / 2.8,
      width: kIsWeb ? 400 : MediaQuery.of(context).size.width / 2.2, //180,
      color: Colors.transparent,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pageroute),
                );

//  Navigator.of(context).push(PageRouteBuilder(
//                       pageBuilder: (context, animation, anotherAnimation) {
//                         return pageroute;
//                       },
//                       transitionDuration: Duration(milliseconds: 1000),
//                       transitionsBuilder:
//                           (context, animation, anotherAnimation, child) {
//                         animation = CurvedAnimation(
//                             curve:  Curves.easeOutCubic, parent: animation);
//                         return FadeTransition(
//                           opacity:animation,
//                           child: child,
//                         );
//                       }));
              },
              //padding: const EdgeInsets.all(0.0),
              style: ElevatedButton.styleFrom(
                elevation: 1.0,
                // side: BorderSide(
                //     color: Colors.yellow,
                //     width: 2.0,
                //     style: BorderStyle.solid), //set border for the button
                shape: RoundedRectangleBorder(
                  //borderRadius: BorderRadius.circular(10.0)

                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(180),
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ), //
                padding: const EdgeInsets.all(0.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                // height: MediaQuery.of(context).size.height / 4.2,
                // width: MediaQuery.of(context).size.width / 3, //180,
                height: kIsWeb ? 300 : MediaQuery.of(context).size.height / 3.8,
                width: kIsWeb
                    ? 300
                    : MediaQuery.of(context).size.width / 2.8, //180,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(10),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(180),
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topCenter,
                    colors: [
                      // Color(0xFFdd5e89),
                      // Color(0xFFF7BB97),
                      color1, color2
                      // Colors.blue.shade700,
                      // Colors.blue,
                      //Color(0xFF0AA1FA),
                      //Color(0xFF0A92DF),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      btnText1, // 'Scan',
                      style: TextStyle(
                          fontSize: kIsWeb
                              ? 30
                              : isMobile
                                  ? MediaQuery.of(context).size.width / 18
                                  : MediaQuery.of(context).size.width /
                                      25, //30,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                    Text(
                      btnText2, // 'Scan',
                      style: TextStyle(
                          fontSize: kIsWeb
                              ? 30
                              : isMobile
                                  ? MediaQuery.of(context).size.width / 18
                                  : MediaQuery.of(context).size.width /
                                      25, //30, MediaQuery.of(context).size.width / 25, //30,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                    Text(
                      btnText3, // 'QR code',
                      style: TextStyle(
                          fontSize: kIsWeb
                              ? 30
                              : isMobile
                                  ? MediaQuery.of(context).size.width / 18
                                  : MediaQuery.of(context).size.width /
                                      25, //30,   MediaQuery.of(context).size.width / 25, //30,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              //Text('CONTAINED BUTTON'),
            ),
          ),
          // Positioned(
          //   // top: -30,
          //   right: 30,
          //   child: CircleAvatar(
          //     radius: 36.0,
          //   ),
          // ),

          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: MediaQuery.of(context).size.height / 8, // 108.0,
              width: MediaQuery.of(context).size.width / 8, // 108.0,
              decoration: BoxDecoration(
                  // border: Border.all(
                  //   width: 2,
                  //   color: Colors.white,
                  // ),
                  // color: Color(0xFF008000),
                  color: Colors.white,
                  //Colors.blue.withOpacity(0.5),
                  shape: BoxShape.circle),
              child:

                  // Image(
                  //   // height: 50.0,
                  //   // width: 50.0,
                  //   // fit: BoxFit.scaleDown,
                  //   image: AssetImage(
                  //       'assets/icons/qr-code-3.png'),
                  // )

                  Icon(lblicon, // Icons.qr_code,
                      size: kIsWeb
                          ? 72
                          : MediaQuery.of(context).size.width / 11, //72,
                      color: color1
                      //  Color(0xFFdd5e89), //Colors.blue.shade700, //Colors.white,
                      ),
            ),
          )
        ],
      ),
    );
  }
}
