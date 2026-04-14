import 'dart:math' as math;
import 'dart:math';

import 'package:bd_stock_trend/common/model/time_series.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineChartSample4 extends StatefulWidget {
  final List<TimeSeries> data1;
  final List<TimeSeries> data2;

  const LineChartSample4({super.key, required this.data1, required this.data2});

  @override
  State<LineChartSample4> createState() => _LineChartSample4State();
}

class _LineChartSample4State extends State<LineChartSample4> {
  List<Color> gradientColors1 = [
    Colors.greenAccent,
    Colors.green,
  ];

  List<Color> gradientColors2 = [
    Colors.redAccent,
    Colors.red,
  ];

  final int _divider = 25;
  final int _leftLabelsCount = 5;

  List<FlSpot> _values1 = const [];
  List<FlSpot> _values2 = const [];

  double _minX = 0;
  double _maxX = 0;
  double _minY = 0;
  double _maxY = 0;
  double _leftTitlesInterval = 0;

  @override
  void initState() {
    super.initState();
    _prepareStockData();
  }

  @override
  void didUpdateWidget(covariant LineChartSample4 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.data1, widget.data1) ||
        !identical(oldWidget.data2, widget.data2)) {
      _prepareStockData();
    }
  }

  void _prepareStockData() {
    if (widget.data1.isEmpty || widget.data2.isEmpty) {
      _values1 = const [];
      _values2 = const [];
      _minX = 0;
      _maxX = 1;
      _minY = 0;
      _maxY = 1;
      _leftTitlesInterval = 1;
      setState(() {});
      return;
    }

    double minY = double.maxFinite;
    double maxY = double.minPositive;

    _values1 = widget.data1.map((datum) {
      if (minY > datum.value) minY = datum.value;
      if (maxY < datum.value) maxY = datum.value;
      return FlSpot(
        datum.time.millisecondsSinceEpoch.toDouble(),
        datum.value,
      );
    }).toList();

    _values2 = widget.data2.map((datum) {
      if (minY > datum.value) minY = datum.value;
      if (maxY < datum.value) maxY = datum.value;
      return FlSpot(
        datum.time.millisecondsSinceEpoch.toDouble(),
        datum.value,
      );
    }).toList();

    print(
        '[CHART_DEBUG] Historical data (data1): ${widget.data1.length} points, range: ${widget.data1.map((d) => d.value).reduce((a, b) => a < b ? a : b).toStringAsFixed(2)} - ${widget.data1.map((d) => d.value).reduce((a, b) => a > b ? a : b).toStringAsFixed(2)}');
    print(
        '[CHART_DEBUG] Forecast data (data2): ${widget.data2.length} points, range: ${widget.data2.map((d) => d.value).reduce((a, b) => a < b ? a : b).toStringAsFixed(2)} - ${widget.data2.map((d) => d.value).reduce((a, b) => a > b ? a : b).toStringAsFixed(2)}');
    print(
        '[CHART_DEBUG] data1 values: ${widget.data1.map((d) => d.value.toStringAsFixed(2)).join(', ')}');
    print(
        '[CHART_DEBUG] data2 values: ${widget.data2.map((d) => d.value.toStringAsFixed(2)).join(', ')}');

    _values2.insert(0, _values1.last);

    _minX = min(_values1.first.x, _values2.first.x);
    _maxX = max(_values1.last.x, _values2.last.x);
    _minY = (minY / _divider).floorToDouble() * _divider;
    _maxY = (maxY / _divider).ceilToDouble() * _divider;
    _leftTitlesInterval =
        ((_maxY - _minY) / (_leftLabelsCount - 1)).floorToDouble();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
              duration: const Duration(milliseconds: 200),
              curve: Curves.linearToEaseOut,
            ),
          ),
        ),
      ],
    );
  }

  SideTitles bottomTitles() {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        final DateTime date =
            DateTime.fromMillisecondsSinceEpoch(value.toInt());
        final time = DateFormat('dd/MM').format(date);

        if (value == meta.max || value == meta.min) {
          return Container();
        }

        return SideTitleWidget(
          meta: meta,
          space: 6,
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
      reservedSize: 40,
      interval: 3600000 * 24 * 15,
    );
  }

  SideTitles leftTitles() {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        if (value == meta.max || value == meta.min) {
          return Container();
        }

        return Text(
          value.floor().toString(),
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
        );
      },
      reservedSize: 40,
      interval: _leftTitlesInterval,
    );
  }

  FlGridData gridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return const FlLine(
          color: Colors.white24,
          strokeWidth: 1,
        );
      },
      /*getDrawingVerticalLine: (value) {
        return const FlLine(
          color: Colors.white24,
          strokeWidth: 1,
        );
      },*/
      horizontalInterval: _leftTitlesInterval,
      /*checkToShowHorizontalLine: (value) {
        return (value.floor()) % _leftTitlesInterval.floor() == 0;
      },*/
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: gridData(),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(sideTitles: bottomTitles()),
        leftTitles: AxisTitles(sideTitles: leftTitles()),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      lineTouchData: LineTouchData(
        touchSpotThreshold: 30,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          final strokeColor = (barData.gradient?.colors.isNotEmpty ?? false)
              ? barData.gradient!.colors.last
              : Colors.white;

          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              const FlLine(
                color: Colors.white24,
                strokeWidth: 1,
              ),
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, spotIndex) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: strokeColor,
                  );
                },
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          tooltipPadding: const EdgeInsets.all(8),
          tooltipMargin: 8,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final time = DateTime.fromMillisecondsSinceEpoch(
                touchedSpot.x.toInt(),
              );
              final value = touchedSpot.y;
              return LineTooltipItem(
                '${DateFormat('EEE MMM dd').format(time)}\nPrice: ${value.toStringAsFixed(2)}',
                const TextStyle(color: Colors.white),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY,
      lineBarsData: [
        LineChartBarData(
          spots: _values1,
          //isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors1,
          ),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors1
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
        LineChartBarData(
          spots: _values2,
          //isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors2,
          ),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors2
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
