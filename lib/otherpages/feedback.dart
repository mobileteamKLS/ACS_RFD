import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:luxair/otherpages/yardcheckin.dart';
import 'package:luxair/widgets/customdialogue.dart';
import 'package:luxair/widgets/headerclipper.dart';
import 'package:luxair/widgets/headers.dart';

class AppFeedback extends StatefulWidget {
  AppFeedback({Key? key}) : super(key: key);

  @override
  State<AppFeedback> createState() => _AppFeedbackState();
}

class _AppFeedbackState extends State<AppFeedback> {
    bool useMobileLayout = false;
  @override
  Widget build(BuildContext context) {
     var smallestDimension = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = smallestDimension < 600;
    print("useMobileLayout");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ClipPath(
            //   clipper: MyClippers1(),
            //   child: Container(
            //     padding: EdgeInsets.only(left: 40, top: 50, right: 20),
            // height: MediaQuery.of(context).size.height / 5.2,
            //   width: MediaQuery.of(context).size.width, //180,
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         begin: Alignment.topRight,
            //         end: Alignment.bottomLeft,
            //         colors: [
            //           Color(0xFF3383CD),
            //           Color(0xFF11249F),
            //         ],
            //       ),
            //     ),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.only(top: 20.0),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               GestureDetector(
            //                 onTap: () {
            //                   Navigator.of(context).pop();
            //                 },
            //                 child: Center(
            //                   child: Icon(
            //                     Icons.chevron_left,
            //                     size: MediaQuery.of(context).size.width / 18,//56,
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //               ),
            //               SizedBox(width: 20),
            //               Text(
            //                 "App Feedback",
            //                 style: TextStyle(
            //                     fontSize: MediaQuery.of(context).size.width / 18,//48,
            //                     fontWeight: FontWeight.normal,
            //                     color: Colors.white),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          
            HeaderClipperWave(color1:Color(0xFF3383CD),
                  color2:Color(0xFF11249F),headerText:       "App Feedback"),
          
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [



                      Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/feedback.gif",
                              height: useMobileLayout ? 250:300, width: useMobileLayout ? 270: 320, fit: BoxFit.scaleDown),
                        ],
                      ),
                      SizedBox(
                        height:  useMobileLayout ? 20: 30,
                      ),
                      Center(
                        child: Text(
                          "   Give us Rating",
                          style: TextStyle(
                            fontSize: useMobileLayout ? 18 : 20,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF11249F),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: useMobileLayout ? 10 : 20,
                      ),
                      Center(
                        child: RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 8.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ),
                      SizedBox(
                            height: useMobileLayout ? 10 : 20,
                      ),
                      Center(
                        child: Text(
                          "   Tell us more",
                          style: TextStyle(
                              fontSize: useMobileLayout ? 18 : 20,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF11249F),
                          ),
                        ),
                      ),
                      SizedBox(
                    height: useMobileLayout ? 10 : 20,
                      ),
                      Center(
                        child: SizedBox(
                          width:  useMobileLayout ?
                          MediaQuery.of(context).size.width / 1.2:
                           MediaQuery.of(context).size.width / 2.5,
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextField(
                              //  expands: true,
                              // minLines: 1,
                              minLines: 1,
                              maxLines:
                                  5, // allow user to enter 5 line in textfield
                              keyboardType: TextInputType
                                  .multiline, // user keyboard will have a button to move cursor to next line
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your feedback here",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                isDense: true,
                              ),
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                      title: "Feedback received",
                      description: "Dear user we have noted your feedback",
                      buttonText: "Okay",
                      imagepath: 'assets/images/thanks.gif',
                                            isMobile: useMobileLayout,
                    ),
                  );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)), //
                            padding: const EdgeInsets.all(0.0),
                          ),
                          child: Container(
                            height: 70,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0xFF1220BC),
                                  Color(0xFF3540E8),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 18.0, bottom: 18.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          //Text('CONTAINED BUTTON'),
                        ),
                      ),
                    ]),
              ),
            ),
            // Expanded
            // Expa
          ]),
    );
  }
}
