// /// Bar chart example
// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

// class OrdinalSales {
//   String year;
//   int sales;

//   OrdinalSales({required this.year, required this.sales});
// }

// class StackedBarChart extends StatelessWidget {
//   final List<charts.Series> seriesList;
//   final bool animate;

//   StackedBarChart(List<charts.Series<OrdinalSales, String>> createSampleData, {required this.seriesList, required this.animate});

//   /// Creates a stacked [BarChart] with sample data and no transition.
//   factory StackedBarChart.withSampleData() {
//     return new StackedBarChart(
//       _createSampleData(),
//       // Disable animations for image tests.
//       animate: false,
//     );
//   }


//   @override
//   Widget build(BuildContext context) {
//     return new charts.BarChart(
//       seriesList,
//       animate: animate,
//       barGroupingType: charts.BarGroupingType.stacked,
//     );
//   }

//   static List<charts.Series<OrdinalSales, String>> _createSampleData() {
//     final desktopSalesData = [
//       new OrdinalSales(year: '2014', sales: 5),
//       new OrdinalSales(year: '2015', sales: 25),
//       new OrdinalSales(year: '2016', sales: 100),
//       new OrdinalSales(year: '2017', sales: 75),
//     ];

//     final tableSalesData = [
//       new OrdinalSales(year: '2014', sales: 25),
//       new OrdinalSales(year: '2015', sales: 50),
//       new OrdinalSales(year: '2016', sales: 10),
//       new OrdinalSales(year: '2017', sales: 20),
//     ];

//     return [
//       new charts.Series<OrdinalSales, String>(
//         id: 'Desktop',
//         domainFn: (OrdinalSales sales, _) => sales.year,
//         measureFn: (OrdinalSales sales, _) => sales.sales,
//         data: desktopSalesData,
//       ),
//       new charts.Series<OrdinalSales, String>(
//         id: 'Tablet',
//         domainFn: (OrdinalSales sales, _) => sales.year,
//         measureFn: (OrdinalSales sales, _) => sales.sales,
//         data: tableSalesData,
//       ),
//     ];
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return new charts.BarChart(
//   //     seriesList,
//   //     animate: true,
//   //     barGroupingType: charts.BarGroupingType.stacked,
//   //   );
//   // }
// }
