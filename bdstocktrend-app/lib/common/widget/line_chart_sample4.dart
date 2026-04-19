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

  final int _leftLabelsCount = 5;

  List<FlSpot> _values1 = const [];
  List<FlSpot> _values2 = const [];

  double _minX = 0;
  double _maxX = 0;
  double _minY = 0;
  double _maxY = 0;
  double _leftTitlesInterval = 0;
  int _leftTitlesDecimals = 0;

  late final TransformationController _transformationController;

  double _niceInterval(double rawInterval) {
    if (rawInterval <= 0 || rawInterval.isNaN || rawInterval.isInfinite) {
      return 1;
    }

    final exponent = (log(rawInterval) / ln10).floor();
    final pow10 = pow(10, exponent).toDouble();
    final fraction = rawInterval / pow10;

    double niceFraction;
    if (fraction <= 1) {
      niceFraction = 1;
    } else if (fraction <= 2) {
      niceFraction = 2;
    } else if (fraction <= 5) {
      niceFraction = 5;
    } else {
      niceFraction = 10;
    }

    return niceFraction * pow10;
  }

  void _applyYAxisBounds({required double dataMinY, required double dataMaxY}) {
    final safeMin = dataMinY.isFinite ? dataMinY : 0;
    final safeMax = dataMaxY.isFinite ? dataMaxY : 0;
    final base = max(max(safeMin.abs(), safeMax.abs()), 1.0);
    final range = (safeMax - safeMin).abs();

    final padding =
        range == 0 ? base * 0.05 : max(max(range * 0.10, base * 0.005), 0.01);

    var minY = safeMin - padding;
    var maxY = safeMax + padding;

    final rawInterval = (maxY - minY) / (_leftLabelsCount - 1);
    final interval = _niceInterval(rawInterval);

    minY = (minY / interval).floorToDouble() * interval;
    maxY = (maxY / interval).ceilToDouble() * interval;

    if (minY == maxY) {
      maxY = minY + interval;
    }

    int decimals = 0;
    var tmp = interval;
    while (tmp < 1 && decimals < 4) {
      tmp *= 10;
      decimals++;
    }

    _minY = minY;
    _maxY = maxY;
    _leftTitlesInterval = interval;
    _leftTitlesDecimals = decimals;
  }

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController(
      Matrix4.identity()..scale(0.9),
    );
    _prepareStockData();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
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
      _leftTitlesDecimals = 0;
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

    _values2.insert(0, _values1.last);

    _minX = min(_values1.first.x, _values2.first.x);
    _maxX = max(_values1.last.x, _values2.last.x);
    _applyYAxisBounds(dataMinY: minY, dataMaxY: maxY);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final labelColor =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.65);
    final gridColor = Theme.of(context).dividerColor.withOpacity(0.35);

    return LayoutBuilder(
      builder: (context, constraints) {
        final pointsCount = max(_values1.length, _values2.length);
        final desiredWidth = math.max(constraints.maxWidth, pointsCount * 28.0);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: desiredWidth,
            height: constraints.maxHeight,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: InteractiveViewer(
                panEnabled: false,
                scaleEnabled: true,
                transformationController: _transformationController,
                minScale: 0.85,
                maxScale: 3,
                child: LineChart(
                  mainData(labelColor: labelColor, gridColor: gridColor),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linearToEaseOut,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SideTitles bottomTitles({required Color labelColor}) {
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
              style: TextStyle(color: labelColor, fontSize: 12),
            ),
          ),
        );
      },
      reservedSize: 40,
      interval: 3600000 * 24 * 15,
    );
  }

  SideTitles leftTitles({required Color labelColor}) {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        return Text(
          value.toStringAsFixed(_leftTitlesDecimals),
          style: TextStyle(color: labelColor, fontSize: 12),
        );
      },
      reservedSize: 44,
      interval: _leftTitlesInterval,
    );
  }

  FlGridData gridData({required Color gridColor}) {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(color: gridColor, strokeWidth: 1);
      },
      getDrawingVerticalLine: (value) {
        return FlLine(color: gridColor, strokeWidth: 1);
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

  LineChartData mainData(
      {required Color labelColor, required Color gridColor}) {
    return LineChartData(
      clipData: const FlClipData.all(),
      gridData: gridData(gridColor: gridColor),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles:
            AxisTitles(sideTitles: bottomTitles(labelColor: labelColor)),
        leftTitles: AxisTitles(sideTitles: leftTitles(labelColor: labelColor)),
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
              FlLine(color: gridColor, strokeWidth: 1),
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
          maxContentWidth: 120,
          tooltipPadding: const EdgeInsets.all(6),
          tooltipMargin: 4,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            if (touchedSpots.isEmpty) return const [];

            final time = DateTime.fromMillisecondsSinceEpoch(
              touchedSpots.first.x.toInt(),
            );

            double? historical;
            double? forecast;
            for (final spot in touchedSpots) {
              if (spot.barIndex == 0) {
                historical = spot.y;
              } else if (spot.barIndex == 1) {
                forecast = spot.y;
              }
            }

            final buffer = StringBuffer()
              ..write(DateFormat('dd MMM').format(time));
            if (historical != null) {
              buffer.write('\nH: ${historical.toStringAsFixed(2)}');
            }
            if (forecast != null) {
              buffer.write('\nF: ${forecast.toStringAsFixed(2)}');
            }

            return [
              LineTooltipItem(
                buffer.toString(),
                const TextStyle(color: Colors.white),
              ),
            ];
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
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) {
              if (_values1.isEmpty) return false;
              final index = _values1.indexOf(spot);
              return index == 0 || index == _values1.length - 1;
            },
            getDotPainter: (spot, percent, bar, spotIndex) {
              return FlDotCirclePainter(
                radius: 2.2,
                color: Theme.of(context).colorScheme.surface,
                strokeWidth: 1.6,
                strokeColor: gradientColors1.last,
              );
            },
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
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) {
              if (_values2.isEmpty) return false;
              final index = _values2.indexOf(spot);
              // Show first point (join) and last forecast point.
              return index == 0 || index == _values2.length - 1;
            },
            getDotPainter: (spot, percent, bar, spotIndex) {
              return FlDotCirclePainter(
                radius: 2.2,
                color: Theme.of(context).colorScheme.surface,
                strokeWidth: 1.6,
                strokeColor: gradientColors2.last,
              );
            },
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
