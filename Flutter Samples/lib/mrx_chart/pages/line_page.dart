import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_samples/logger.dart';
import 'package:intl/intl.dart';
import 'package:mrx_charts/mrx_charts.dart';

class XY {
  int x;
  double y;
  XY({required this.x, required this.y});
}

class LinePage extends StatefulWidget {
  const LinePage({Key? key}) : super(key: key);

  @override
  State<LinePage> createState() => _LinePageState();
}

class _LinePageState extends State<LinePage> {
  late List<XY> charts;
  int numbMonths = 6;
  final from = DateTime(2021, 4);
  late DateTime to;
  @override
  void initState() {
    super.initState();
    to = from.add(Duration(days: 30 * numbMonths));
    charts = List.generate(
      numbMonths,
      (index) => XY(
        x: index,
        y: Random().nextDouble() * 50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
            ),
            child: GestureDetector(
              onTap: () => setState(() {}),
              child: const Icon(
                Icons.refresh,
                size: 26.0,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text('Line'),
      ),
      backgroundColor: const Color(0xFF1B0E41),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 400.0,
            maxWidth: 600.0,
          ),
          padding: const EdgeInsets.all(24.0),
          child: Chart(
            layers: layers(),
            padding: const EdgeInsets.symmetric(horizontal: 30.0).copyWith(
              bottom: 12.0,
            ),
          ),
        ),
      ),
    );
  }

  List<double> getMinMax(List<XY> list) {
    var map = list.map((e) => e.y).toList();
    map.sort();
    double mn = map.first;
    consoleLog(mn);
    double mx = map.last;
    consoleLog(mx);
    /* var lstRtrn = [
      mn - 0.1 * (mx - mn),
      max(mx + 0.1 * (mx - mn), mn + 20),
    ]; */
    return [mn, mx];
  }

  List<ChartLayer> layers() {
    final frequency = (to.millisecondsSinceEpoch - from.millisecondsSinceEpoch) / 3.0;
    return [
      ChartHighlightLayer(
        shape: () => ChartHighlightLineShape<ChartLineDataItem>(
          backgroundColor: const Color(0xFF331B6D),
          currentPos: (item) => item.currentValuePos,
          radius: const BorderRadius.all(Radius.circular(8.0)),
          width: 60.0,
        ),
      ),
      ChartAxisLayer(
        settings: ChartAxisSettings(
          x: ChartAxisSettingsAxis(
            frequency: frequency,
            max: to.millisecondsSinceEpoch.toDouble(),
            min: from.millisecondsSinceEpoch.toDouble(),
            textStyle: const TextStyle(fontSize: 10.0),
          ),
          y: ChartAxisSettingsAxis(
            frequency: 50.0,
            max: getMinMax(charts)[1],
            min: getMinMax(charts)[0],
            textStyle: const TextStyle(fontSize: 10.0),
          ),
        ),
        labelX: (value) => DateFormat('MMM').format(
          DateTime.fromMillisecondsSinceEpoch(
            value.toInt(),
          ),
        ),
        labelY: (value) => value.toInt().toString(),
      ),
      ChartLineLayer(
        items: charts
            .map(
              (e) => ChartLineDataItem(
                x: (e.x * frequency) + from.millisecondsSinceEpoch,
                value: Random().nextInt(38) + 20,
              ),
            )
            .toList(),
        settings: const ChartLineSettings(
          color: Color(0xFF8043F9),
          thickness: 4.0,
        ),
      ),
      ChartTooltipLayer(
        shape: () => ChartTooltipLineShape<ChartLineDataItem>(
          backgroundColor: Colors.white,
          circleBackgroundColor: Colors.white,
          circleBorderColor: const Color(0xFF331B6D),
          circleSize: 4.0,
          circleBorderThickness: 2.0,
          currentPos: (item) => item.currentValuePos,
          onTextValue: (item) => '€${item.value.toString()}',
          marginBottom: 6.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          radius: 6.0,
          textStyle: const TextStyle(
            color: Color(0xFF8043F9),
            letterSpacing: 0.2,
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ];
  }
}
