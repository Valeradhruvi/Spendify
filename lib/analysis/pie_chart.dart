import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartScreen extends StatelessWidget {
  const PieChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text("Spending by Category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "📊 Pie Chart",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.redAccent,
                      value: 30,
                      title: "Dining\n30%",
                      radius: 55,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.orangeAccent,
                      value: 25,
                      title: "Groceries\n25%",
                      radius: 50,
                      titleStyle:
                      const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.blueAccent,
                      value: 20,
                      title: "Bills\n20%",
                      radius: 50,
                      titleStyle:
                      const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.greenAccent,
                      value: 25,
                      title: "Others\n25%",
                      radius: 50,
                      titleStyle:
                      const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                  centerSpaceRadius: 0,
                  sectionsSpace: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
