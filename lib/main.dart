import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Load JSON data in Flutter',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const JsonData(),
    );
  }
}

class JsonData extends StatefulWidget {
  const JsonData({super.key});

  @override
  JsonDataState createState() => JsonDataState();
}

class JsonDataState extends State<JsonData> {
  JsonDataState();

  final List<_ChartData> _chartData = <_ChartData>[];

  Future<String> _loadSalesDataAsset() async {
    return await rootBundle.loadString('assets/data.json');
  }

  Future _loadSalesData() async {
    final String jsonString = await _loadSalesDataAsset();
    final dynamic jsonResponse = json.decode(jsonString);
    setState(() {
      for (final Map<dynamic, dynamic> i in jsonResponse) {
        _chartData.add(_ChartData.fromJson(i));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSalesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildDefaultLineChart(),
    );
  }

  SfCartesianChart _buildDefaultLineChart() {
    return SfCartesianChart(
      key: GlobalKey(),
      plotAreaBorderWidth: 0,
      title: const ChartTitle(text: 'Load JSON Data In Flutter Chart'),
      legend: const Legend(isVisible: true),
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        intervalType: DateTimeIntervalType.years,
        dateFormat: DateFormat.y(),
        name: 'Years',
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        rangePadding: ChartRangePadding.none,
        name: 'Price',
        minimum: 70,
        maximum: 100,
        interval: 10,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.transparent),
      ),
      series: _getDefaultFastLineSeries(),
    );
  }

  /// The method returns line series to chart.
  List<FastLineSeries<_ChartData, DateTime>> _getDefaultFastLineSeries() {
    return <FastLineSeries<_ChartData, DateTime>>[
      FastLineSeries<_ChartData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.y1,
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class _ChartData {
  _ChartData(this.x, this.y1, this.y2);

  DateTime x;
  num y1;
  num y2;

  factory _ChartData.fromJson(Map<dynamic, dynamic> parsedJson) {
    return _ChartData(
      DateTime.parse(parsedJson['x']),
      parsedJson['y1'],
      parsedJson['y2'],
    );
  }
}
