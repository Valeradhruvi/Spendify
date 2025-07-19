import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsChartsScreen extends StatelessWidget {
  const AnalyticsChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text("Analytics & Charts"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("📊 Pie Chart - Spending by Category"),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.3,
              child: _buildPieChart(),
            ),
            const SizedBox(height: 40),
            _sectionTitle("📈 Bar Chart - Monthly Spending"),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: _buildBarChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPieChart() {
    final List<Map<String, dynamic>> pieData = [
      {
        'value': 30.0,
        'label': 'Dining',
        'color': Colors.redAccent,
      },
      {
        'value': 25.0,
        'label': 'Groceries',
        'color': Colors.orangeAccent,
      },
      {
        'value': 20.0,
        'label': 'Bills',
        'color': Colors.blueAccent,
      },
      {
        'value': 25.0,
        'label': 'Others',
        'color': Colors.greenAccent,
      },
    ];

    return PieChart(
      PieChartData(
        centerSpaceRadius: 40,
        sectionsSpace: 3,
        startDegreeOffset: -90,
        sections: pieData.map((item) {
          final value = item['value'] as double;
          final label = item['label'] as String;
          final color = item['color'] as Color;

          return PieChartSectionData(
            color: color,
            value: value,
            radius: 55,
            title: '$label\n${value.toStringAsFixed(0)}%',
            titleStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        barGroups: [
          _barGroup(0, 7000),
          _barGroup(1, 8200),
          _barGroup(2, 9500),
          _barGroup(3, 8900),
          _barGroup(4, 10200),
          _barGroup(5, 11400),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, _) {
                return Text(
                  '₹${value.toInt()}',
                  style: const TextStyle(color: Colors.white60, fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, _) {
                const months = ['Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
                return Text(
                  months[value.toInt()],
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 14,
          borderRadius: BorderRadius.circular(6),
          color: Colors.tealAccent,
        ),
      ],
    );
  }
}