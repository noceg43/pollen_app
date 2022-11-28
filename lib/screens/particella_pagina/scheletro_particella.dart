import 'package:demo_1/providers/per_polline.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScheletroParticella extends StatelessWidget {
  const ScheletroParticella({super.key, required this.p, required this.s});
  final Polline p;
  final Stazione s;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(p.partNameI),
        leading: const BackButton(),
      ),
      body: FutureBuilder<Map<DateTime, num>>(
          future: PerPolline.fetch(s, p),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return LineChartSample2(
                p: p,
                s: s,
                listVal: snapshot.data!,
              );
            } else {
              return Container();
            }
          }),
    );
  }
}

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2(
      {super.key, required this.p, required this.s, required this.listVal});
  final Polline p;
  final Stazione s;
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
    // calcolo valore massimo y
    num maxVal = 0;
    for (num i in widget.listVal.values) {
      if (i > maxVal) maxVal = i;
    }
    num max = (widget.p.partHigh > maxVal) ? widget.p.partHigh : maxVal;
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
              color: Color(0xff232d37),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                showAvg
                    ? avgData(
                        widget.listVal.values.toList(),
                        max,
                      )
                    : mainData(widget.listVal.values.toList(), max),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(fontSize: 20),
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
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
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
    if (value == widget.p.partLow.toInt()) {
      text = "basso";
    } else if (value == widget.p.partMiddle.toInt()) {
      text = "medio";
    } else if (value == widget.p.partHigh.toInt()) {
      text = "alto";
    } else {
      return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData(List<num> listVal, num maxY) {
    //                                                                creare punti grafo
    List<FlSpot> listaPunti = [];
    for (double i = 0; i < listVal.length; i++) {
      listaPunti.add(FlSpot(i, listVal[i.toInt()].toDouble()));
      print("X: $i Y: ${i.toDouble()}");
    }
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
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
            reservedSize: 42,
          ),
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
          isStepLineChart: false,
          spots: listaPunti,
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
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

  LineChartData avgData(List<num> listVal, num maxY) {
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
