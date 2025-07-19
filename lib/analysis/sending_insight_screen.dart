import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingAnalysisScreen extends StatelessWidget {
  const SpendingAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text("Spending Analysis & Prediction"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Top Spending Categories"),
            const SizedBox(height: 12),
            AspectRatio(
              aspectRatio: 1.3,
              child: _buildPieChart(),
            ),

            const SizedBox(height: 30),
            _sectionTitle("Predicted Expense (Next Month)"),
            const SizedBox(height: 12),
            _predictionCard("₹12,400", "Based on your trend, expenses may increase 8%"),

            const SizedBox(height: 30),
            _sectionTitle("Spending Over Time"),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: _buildBarChart(),
            ),

            const SizedBox(height: 30),
            _sectionTitle("Smart Insights"),
            const SizedBox(height: 10),
            _tip("🍽️  You spend 30% of income on Dining Out."),
            _tip("🎯  You're on track to reach your saving goal."),
            _tip("📈  Last month saw a 12% spike in utility bills."),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: Colors.white70,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _predictionCard(String value, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162447),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.trending_up, color: Colors.tealAccent, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tip(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: Colors.redAccent,
            value: 30,
            title: "Dining\n30%",
            radius: 50,
            titleStyle: const TextStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          PieChartSectionData(
            color: Colors.orangeAccent,
            value: 25,
            title: "Groceries\n25%",
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          PieChartSectionData(
            color: Colors.blueAccent,
            value: 20,
            title: "Bills\n20%",
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          PieChartSectionData(
            color: Colors.greenAccent,
            value: 25,
            title: "Others\n25%",
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
        sectionsSpace: 4,
        centerSpaceRadius: 0,
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        barGroups: [
          _barGroup(0, 8000),
          _barGroup(1, 9200),
          _barGroup(2, 8800),
          _barGroup(3, 10400),
          _barGroup(4, 11200),
          _barGroup(5, 12400), // predicted
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, _) => Text("₹${value.toInt()}",
                  style: const TextStyle(color: Colors.white54, fontSize: 10)),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, _) {
                const months = ['Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
                return Text(months[value.toInt()],
                    style: const TextStyle(color: Colors.white54, fontSize: 10));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.tealAccent,
          width: 16,
          borderRadius: BorderRadius.circular(4),
        )
      ],
    );
  }
}
