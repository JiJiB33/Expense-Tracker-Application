import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BarChartWidget extends StatefulWidget {
  final Map<String, double> data;
  final bool isIncome;

  BarChartWidget({required this.data, required this.isIncome});

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  @override
  Widget build(BuildContext context) {
    double maxYValue = widget.data.values.fold(0, (prev, amount) => amount > prev ? amount : prev);

    List<BarChartGroupData> barGroups = [];
    int index = 0;

    final currencyFormatter = NumberFormat("#,##0.0", "en_US");

    widget.data.forEach((category, amount) {
      final formattedPrice = '${currencyFormatter.format(amount)} Ks';
      barGroups.add(BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(
            y: amount,
            colors: [widget.isIncome ? Colors.green.shade400 : Colors.red.shade300],
            width: 16,
            borderRadius: BorderRadius.circular(4),
          )
        ],
      ));
    });

    return BarChart(
      BarChartData(
        maxY: maxYValue,
        barGroups: barGroups,
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          leftTitles: SideTitles(
            showTitles: false,
            getTextStyles: (context, value) => GoogleFonts.montserrat(color: Colors.grey, fontSize: 10),
            margin: 16,
            reservedSize: 40,
          ),
          topTitles: SideTitles(
            showTitles: false,
          ),
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => GoogleFonts.montserrat(color: Colors.white, fontSize: 10),
            margin: 16,
            getTitles: (double value) {
              return widget.data.keys.elementAt(value.toInt());
            },
          ),
          rightTitles: SideTitles( // Add this section for right-side titles
            showTitles: true,
            getTextStyles: (context, value) =>  GoogleFonts.montserrat(color: Colors.teal[200], fontSize: 8),
            margin: 16,
            getTitles: (double value) {
              // Format the values as needed (e.g., 0, 10k, 20k, ...)
              final formattedValue = '${(value * 0.001).toInt()}k';
              return formattedValue;
            },
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
        backgroundColor: Colors.black.withOpacity(0.2),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final formattedPrice = '${currencyFormatter.format(rod.y)} Ks';
              return BarTooltipItem(
                formattedPrice,
                TextStyle(color: Colors.white, fontSize: 12),
              );
            },
          ),
        ),
      ),
    );
  }
}
