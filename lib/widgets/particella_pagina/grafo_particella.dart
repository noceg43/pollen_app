import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key, required this.p, required this.listVal});
  final Particella p;
  final Map<DateTime, num> listVal;

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    List<double> valori =
        (widget.p.limite.length == 1 && widget.p.limite.first > 100)
            ? widget.listVal.values.map((e) => (e / 10).toDouble()).toList()
            : widget.listVal.values.map((e) => e.toDouble()).toList();
    // calcolo valore massimo y
    num maxVal = 0;
    for (num i in valori) {
      if (i > maxVal) maxVal = i;
    }
    num max = 0;
    if (widget.p.limite.length > 1) {
      max = (widget.p.limite.last > maxVal) ? widget.p.limite.last : maxVal;
    } else {
      max = (widget.p.limite.first > maxVal) ? widget.p.limite.first : maxVal;
      if (max > 100) max = max / 10;
    }
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
              color: Color(0xFFF1F1F1),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                mainData(valori, max),
              ),
            ),
          ),
        ),
        /*
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 10),
            ),
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'media',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          ),
        ),
        */
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    //                                                              asse x nomi
    Widget text;
    if (value == value.toInt()) {
      text = Text(
        "${widget.listVal.keys.elementAt(value.toInt()).day}/${widget.listVal.keys.elementAt(value.toInt()).month}",
        style: style,
      );
    } else {
      text = const Text("");
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(
    double value,
    TitleMeta meta,
  ) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    //                                                              asse y nomi
    String text;
    Color colore = Colors.grey;

    if (widget.p.limite.length > 1) {
      if (value == widget.p.limite[0].toInt()) {
        text = "basso";
        colore = const Color(0xFFFFF275);
      } else if (value == widget.p.limite[1].toInt()) {
        text = "medio";
        colore = const Color(0xFFFBAF55);
      } else if (value == widget.p.limite[2].toInt()) {
        text = "alto";
        colore = const Color(0xFFD33C3C);
      } else {
        return Container();
      }
    } else {
      if (value == widget.p.limite.first.toInt()) {
        text = "alto";
        colore = const Color(0xFFD33C3C);
      } else {
        return Container();
      }
    }

    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: colore,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  LineChartData mainData(List<double> listVal, num maxY) {
    //                                                                creare punti grafo
    List<FlSpot> listaPunti = [];
    print(maxY);
    for (double i = 0; i < listVal.length; i++) {
      listaPunti.add(FlSpot(i, listVal[i.toInt()].toDouble()));
    }
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 10,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.shade400,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 60,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
            left: BorderSide(color: Colors.black, width: 2),
            bottom: BorderSide(color: Colors.black, width: 2)),
      ),
      minX: 0,
      maxX: listVal.length.toDouble() - 1,
      minY: 0,
      maxY: maxY.toDouble(),
      lineTouchData: LineTouchData(
          enabled: true,
          touchCallback:
              (FlTouchEvent event, LineTouchResponse? touchResponse) {
            // TODO : Utilize touch event here to perform any operation
          },
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.green,
            tooltipRoundedRadius: 13.0,
            showOnTopOfTheChartBoxArea: false,
            fitInsideHorizontally: true,
            tooltipMargin: 20,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map(
                (LineBarSpot touchedSpot) {
                  const textStyle = TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  );
                  return LineTooltipItem(
                    listaPunti[touchedSpot.spotIndex].y.toStringAsFixed(2),
                    textStyle,
                  );
                },
              ).toList();
            },
          ),
          getTouchedSpotIndicator:
              (LineChartBarData barData, List<int> indicators) {
            return indicators.map(
              (int index) {
                final line = FlLine(
                    color: Colors.grey.shade500,
                    strokeWidth: 2,
                    dashArray: [2, 4]);
                return TouchedSpotIndicatorData(
                  line,
                  FlDotData(show: true),
                );
              },
            ).toList();
          },
          getTouchLineEnd: (_, __) => double.infinity),
      lineBarsData: [
        LineChartBarData(
          isStepLineChart: false,
          spots: listaPunti,
          isCurved: false,
          color: Colors.green,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData(List<double> listVal, num maxY) {
    // media
    List<FlSpot> valoriY = [];
    double media = 0;
    if (listVal.length == 1) {
      media = listVal.first.toDouble();
    } else {
      media = listVal.reduce((a, b) => a + b) / listVal.length;
    }
    for (double i = 0; i < listVal.length; i++) {
      valoriY.add(FlSpot(i, media));
    }
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: listVal.length.toDouble() - 1,
      minY: 0,
      maxY: maxY.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: valoriY,
          isCurved: false,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
