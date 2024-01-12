import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
// import 'package:intro_slider/slide_object.dart';
import 'package:luxair/dashboards/homescreen.dart';

class Carousel extends StatefulWidget {
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();
    slides.add(
      Slide(
        backgroundImage: "assets/images/slider1.png",
        backgroundImageFit: BoxFit.fitWidth,
        backgroundBlendMode: BlendMode.lighten,
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      Slide(
        backgroundImage: "assets/images/slider2.png",
        backgroundImageFit: BoxFit.fitWidth,
        backgroundBlendMode: BlendMode.lighten,
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      Slide(
        backgroundImage: "assets/images/slider3.png",
        backgroundImageFit: BoxFit.fitWidth,
        backgroundBlendMode: BlendMode.lighten,
        backgroundColor: Colors.white,
      ),
    );
  }

  void onDonePress() {
    // Do what you want
    print("End of slides");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFF11249F)),
      overlayColor: MaterialStateProperty.all<Color>(const Color(0xFF11249F)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      backgroundColorAllSlides: Colors.white,
      nextButtonStyle: myButtonStyle(),
      prevButtonStyle: myButtonStyle(),
      skipButtonStyle: myButtonStyle(),
      doneButtonStyle: myButtonStyle(),
      slides: slides,
      onDonePress: onDonePress,
    );
  }
}
