// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class ChartExample extends StatefulWidget {
//   const ChartExample({ Key? key }) : super(key: key);

//   @override
//   State<ChartExample> createState() => _ChartExampleState();
// }

// class _ChartExampleState extends State<ChartExample> {
// int _currentPage = 0;

//   final _controller = PageController(initialPage: 0);
//   final _duration = const Duration(milliseconds: 300);
//   final _curve = Curves.easeInOutCubic;
//   final _pages = const [
    
//     PieChartPage(),
   
//   ];

//   bool  isDesktopOrWeb = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(() {
//       setState(() {
//         _currentPage = _controller.page!.round();
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: PageView(
//           physics: isDesktopOrWeb
//               ? const NeverScrollableScrollPhysics()
//               : const AlwaysScrollableScrollPhysics(),
//           controller: _controller,
//           children: _pages,
//         ),
//       ),
//       bottomNavigationBar: isDesktopOrWeb
//           ? Container(
//               padding: const EdgeInsets.all(16),
//               color: Colors.transparent,
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Visibility(
//                     visible: _currentPage != 0,
//                     child: FloatingActionButton(
//                       onPressed: () => _controller.previousPage(
//                           duration: _duration, curve: _curve),
//                       child: const Icon(Icons.chevron_left_rounded),
//                     ),
//                   ),
//                   const Spacer(),
//                   Visibility(
//                     visible: _currentPage != _pages.length - 1,
//                     child: FloatingActionButton(
//                       onPressed: () => _controller.nextPage(
//                           duration: _duration, curve: _curve),
//                       child: const Icon(Icons.chevron_right_rounded),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : null,
//     );
//   }
// }


// class PieChartPage extends StatelessWidget {
//   final Color barColor = Colors.white;
//   final Color barBackgroundColor = const Color(0xff72d8bf);
//   final double width = 22;

//   const PieChartPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color(0xffeceaeb),
//       child: Padding(
//         padding: const EdgeInsets.all(28.0),
//         child: ListView(
//           children: const <Widget>[
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: EdgeInsets.only(left: 8.0),
//                 child: Text(
//                   'Pie Chart',
//                   style: TextStyle(
//                       color: Color(
//                         0xff333333,
//                       ),
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             PieChartSample1(),
//             SizedBox(
//               height: 12,
//             ),
//             PieChartSample2(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PieChartSample1 extends StatefulWidget {
//   const PieChartSample1({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => PieChartSample1State();
// }


// class Indicator extends StatelessWidget {
//   final Color color;
//   final String text;
//   final bool isSquare;
//   final double size;
//   final Color textColor;

//   const Indicator({
//     Key? key,
//     required this.color,
//     required this.text,
//     required this.isSquare,
//     this.size = 16,
//     this.textColor = const Color(0xff505050),
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         Container(
//           width: size,
//           height: size,
//           decoration: BoxDecoration(
//             shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
//             color: color,
//           ),
//         ),
//         const SizedBox(
//           width: 4,
//         ),
//         Text(
//           text,
//           style: TextStyle(
//               fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
//         )
//       ],
//     );
//   }
// }

// class PieChartSample1State extends State {
//   int touchedIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.3,
//       child: Card(
//         color: Colors.white,
//         child: Column(
//           children: <Widget>[
//             const SizedBox(
//               height: 28,
//             ),
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 Indicator(
//                   color: const Color(0xff0293ee),
//                   text: 'One',
//                   isSquare: false,
//                   size: touchedIndex == 0 ? 18 : 16,
//                   textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
//                 ),
//                 Indicator(
//                   color: const Color(0xfff8b250),
//                   text: 'Two',
//                   isSquare: false,
//                   size: touchedIndex == 1 ? 18 : 16,
//                   textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
//                 ),
//                 Indicator(
//                   color: const Color(0xff845bef),
//                   text: 'Three',
//                   isSquare: false,
//                   size: touchedIndex == 2 ? 18 : 16,
//                   textColor: touchedIndex == 2 ? Colors.black : Colors.grey,
//                 ),
//                 Indicator(
//                   color: const Color(0xff13d38e),
//                   text: 'Four',
//                   isSquare: false,
//                   size: touchedIndex == 3 ? 18 : 16,
//                   textColor: touchedIndex == 3 ? Colors.black : Colors.grey,
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 18,
//             ),
//             Expanded(
//               child: AspectRatio(
//                 aspectRatio: 1,
//                 child: PieChart(
//                   PieChartData(
//                       pieTouchData: PieTouchData(touchCallback:
//                           (FlTouchEvent event, pieTouchResponse) {
//                         setState(() {
//                           if (!event.isInterestedForInteractions ||
//                               pieTouchResponse == null ||
//                               pieTouchResponse.touchedSection == null) {
//                             touchedIndex = -1;
//                             return;
//                           }
//                           touchedIndex = pieTouchResponse
//                               .touchedSection!.touchedSectionIndex;
//                         });
//                       }),
//                       startDegreeOffset: 180,
//                       borderData: FlBorderData(
//                         show: false,
//                       ),
//                       sectionsSpace: 1,
//                       centerSpaceRadius: 0,
//                       sections: showingSections()),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<PieChartSectionData> showingSections() {
//     return List.generate(
//       4,
//       (i) {
//         final isTouched = i == touchedIndex;
//         final opacity = isTouched ? 1.0 : 0.6;

//         const color0 = Color(0xff0293ee);
//         const color1 = Color(0xfff8b250);
//         const color2 = Color(0xff845bef);
//         const color3 = Color(0xff13d38e);

//         switch (i) {
//           case 0:
//             return PieChartSectionData(
//               color: color0.withOpacity(opacity),
//               value: 25,
//               title: '',
//               radius: 80,
//               titleStyle: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff044d7c)),
//               titlePositionPercentageOffset: 0.55,
//               borderSide: isTouched
//                   ? BorderSide(color: color0.darken(40), width: 6)
//                   : BorderSide(color: color0.withOpacity(0)),
//             );
//           case 1:
//             return PieChartSectionData(
//               color: color1.withOpacity(opacity),
//               value: 25,
//               title: '',
//               radius: 65,
//               titleStyle: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff90672d)),
//               titlePositionPercentageOffset: 0.55,
//               borderSide: isTouched
//                   ? BorderSide(color: color1.darken(40), width: 6)
//                   : BorderSide(color: color2.withOpacity(0)),
//             );
//           case 2:
//             return PieChartSectionData(
//               color: color2.withOpacity(opacity),
//               value: 25,
//               title: '',
//               radius: 60,
//               titleStyle: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff4c3788)),
//               titlePositionPercentageOffset: 0.6,
//               borderSide: isTouched
//                   ? BorderSide(color: color2.darken(40), width: 6)
//                   : BorderSide(color: color2.withOpacity(0)),
//             );
//           case 3:
//             return PieChartSectionData(
//               color: color3.withOpacity(opacity),
//               value: 25,
//               title: '',
//               radius: 70,
//               titleStyle: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff0c7f55)),
//               titlePositionPercentageOffset: 0.55,
//               borderSide: isTouched
//                   ? BorderSide(color: color3.darken(40), width: 6)
//                   : BorderSide(color: color2.withOpacity(0)),
//             );
//           default:
//             throw Error();
//         }
//       },
//     );
//   }
// }

// extension ColorExtension on Color {
//   /// Convert the color to a darken color based on the [percent]
//   Color darken([int percent = 40]) {
//     assert(1 <= percent && percent <= 100);
//     final value = 1 - percent / 100;
//     return Color.fromARGB(alpha, (red * value).round(), (green * value).round(),
//         (blue * value).round());
//   }
// }

// class PieChartSample2 extends StatefulWidget {
//   const PieChartSample2({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => PieChart2State();
// }

// class PieChart2State extends State {
//   int touchedIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.3,
//       child: Card(
//         color: Colors.white,
//         child: Row(
//           children: <Widget>[
//             const SizedBox(
//               height: 18,
//             ),
//             Expanded(
//               child: AspectRatio(
//                 aspectRatio: 1,
//                 child: PieChart(
//                   PieChartData(
//                       pieTouchData: PieTouchData(touchCallback:
//                           (FlTouchEvent event, pieTouchResponse) {
//                         setState(() {
//                           if (!event.isInterestedForInteractions ||
//                               pieTouchResponse == null ||
//                               pieTouchResponse.touchedSection == null) {
//                             touchedIndex = -1;
//                             return;
//                           }
//                           touchedIndex = pieTouchResponse
//                               .touchedSection!.touchedSectionIndex;
//                         });
//                       }),
//                       borderData: FlBorderData(
//                         show: false,
//                       ),
//                       sectionsSpace: 0,
//                       centerSpaceRadius: 40,
//                       sections: showingSections()),
//                 ),
//               ),
//             ),
//             Column(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const <Widget>[
//                 Indicator(
//                   color: Color(0xff0293ee),
//                   text: 'First',
//                   isSquare: true,
//                 ),
//                 SizedBox(
//                   height: 4,
//                 ),
//                 Indicator(
//                   color: Color(0xfff8b250),
//                   text: 'Second',
//                   isSquare: true,
//                 ),
//                 SizedBox(
//                   height: 4,
//                 ),
//                 Indicator(
//                   color: Color(0xff845bef),
//                   text: 'Third',
//                   isSquare: true,
//                 ),
//                 SizedBox(
//                   height: 4,
//                 ),
//                 Indicator(
//                   color: Color(0xff13d38e),
//                   text: 'Fourth',
//                   isSquare: true,
//                 ),
//                 SizedBox(
//                   height: 18,
//                 ),
//               ],
//             ),
//             const SizedBox(
//               width: 28,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<PieChartSectionData> showingSections() {
//     return List.generate(4, (i) {
//       final isTouched = i == touchedIndex;
//       final fontSize = isTouched ? 25.0 : 16.0;
//       final radius = isTouched ? 60.0 : 50.0;
//       switch (i) {
//         case 0:
//           return PieChartSectionData(
//             color: const Color(0xff0293ee),
//             value: 40,
//             title: '40%',
//             radius: radius,
//             titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xffffffff)),
//           );
//         case 1:
//           return PieChartSectionData(
//             color: const Color(0xfff8b250),
//             value: 30,
//             title: '30%',
//             radius: radius,
//             titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xffffffff)),
//           );
//         case 2:
//           return PieChartSectionData(
//             color: const Color(0xff845bef),
//             value: 15,
//             title: '15%',
//             radius: radius,
//             titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xffffffff)),
//           );
//         case 3:
//           return PieChartSectionData(
//             color: const Color(0xff13d38e),
//             value: 15,
//             title: '15%',
//             radius: radius,
//             titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xffffffff)),
//           );
//         default:
//           throw Error();
//       }
//     });
//   }
// }