import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  final String title;
  final bool isWeb;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
    required this.title,required this.isWeb
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isWeb 
                                        ? MediaQuery.of(context).size.width /
                                           4.5 : MediaQuery.of(context).size.width / 2.5,
      child: Container(
        color: Color(0xfff5f4f9),
        height: 35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
                  color:color,/// Colors.transparent,
                  border: Border(
                    top: BorderSide(width: 3.0, color: color),
                    bottom: BorderSide(width: 2.0, color: color),
                    left: BorderSide(width: 2.0, color: color),
                    right: BorderSide(width: 2.0, color: color),
                  ),
                ),
              ),
            ),
            // const SizedBox(
            //   width: 4,
            // ),
            SizedBox(
              width: isWeb 
                                        ? MediaQuery.of(context).size.width /
                                            8 :MediaQuery.of(context).size.width / 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // const SizedBox(
          //   height: 18,
          // ),
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 70,
                      sections: showingSections(
                          Color(0xff3887fe),
                          Color(0xffee984d),
                          Color(0xffab4eba),
                          Color(0xff26af61))),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Daily",
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.normal,
                                color: Colors.black)),
                                 Text("Traffic",
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.normal,
                                color: Colors.black)),
                        Text("90%",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ],
                    )),
              ],
            ),
          ),
             // const SizedBox(
              //   width: 28,
              // ),
            ],
          ),
    );
  }

  List<PieChartSectionData> showingSections(Color graphColor, Color graphColor1,
      Color graphColor2, Color graphColor3) {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 70.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: graphColor, //const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: graphColor1, //const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: graphColor2, //const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: graphColor3, //const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}
