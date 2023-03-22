import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Grafico extends StatefulWidget {
  const Grafico({super.key, required this.p, required this.listVal});
  final Particella p;
  final Map<DateTime, num> listVal;

  @override
  State<Grafico> createState() => _GraficoState();
}

class _GraficoState extends State<Grafico> {
  late List<double> limiti;

  @override
  Widget build(BuildContext context) {
    num maxVal = 0;
    for (num i in widget.listVal.values.map((e) => e.toDouble()).toList()) {
      if (i > maxVal) maxVal = i;
    }
    List<double> valori =
        widget.listVal.values.map((e) => e.toDouble()).toList();
    limiti = widget.p.limite.map((e) => (e).toDouble()).toList();
    // calcolo valore massimo y
    num max = maxVal;
    if (limiti.last > max) {
      max = limiti.last;
    }

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: Card(
            elevation: 10,
            color: const Color(0xFFF1F1F1),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 20,
                left: 2,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                mainData(valori, max, limiti),
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
      fontSize: 14,
    );
    //                                                              asse x nomi
    Widget text;
    if (value == value.toInt()) {
      text = Text(
        "${widget.listVal.keys.elementAt(value.toInt()).month}/${widget.listVal.keys.elementAt(value.toInt()).day}",
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
    //                                                              asse y nomi
    String text;
    Color colore = Colors.grey;
    Color coloreTesto = Colors.white;
    text = value.toStringAsFixed(0);

    if (limiti.length > 1) {
      if (value == limiti[0].toInt()) {
        colore = const Color(0xFFFFF275);
        coloreTesto = Colors.black;
      } else if (value == limiti[1].toInt()) {
        colore = const Color(0xFFFBAF55);
      } else if (value == limiti[2].toInt()) {
        colore = const Color(0xFFD33C3C);
      } else {
        return Container();
      }
    } else {
      if (value == limiti.first.toInt()) {
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
          borderRadius: const BorderRadius.all(Radius.circular(50))),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: coloreTesto),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  LineChartData mainData(List<double> listVal, num maxY, List<double> limiti) {
    //                                                                creare punti grafo
    List<FlSpot> listaPunti = [];

    for (double i = 0; i < listVal.length; i++) {
      listaPunti.add(FlSpot(i, listVal[i.toInt()].toDouble()));
    }

    return LineChartData(
      gridData: FlGridData(
        show: false,
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
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.green.shade700,
            tooltipRoundedRadius: 13.0,
            showOnTopOfTheChartBoxArea: false,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipMargin: 15,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map(
                (LineBarSpot touchedSpot) {
                  const textStyle = TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  );
                  return LineTooltipItem(
                    (listaPunti[touchedSpot.spotIndex].y ==
                            listaPunti[touchedSpot.spotIndex].y.toInt())
                        ? listaPunti[touchedSpot.spotIndex].y.toStringAsFixed(0)
                        : listaPunti[touchedSpot.spotIndex]
                            .y
                            .toStringAsFixed(2),
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
                    strokeWidth: 4,
                    dashArray: [8, 16]);
                return TouchedSpotIndicatorData(
                  line,
                  FlDotData(show: true),
                );
              },
            ).toList();
          },
          getTouchLineEnd: (_, x) => listVal[x]),
      lineBarsData: [
        LineChartBarData(
          isStepLineChart: false,
          spots: listaPunti,
          isCurved: false,
          color: Colors.green,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
      ],
    );
  }
}
