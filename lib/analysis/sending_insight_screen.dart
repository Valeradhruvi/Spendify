// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class AnalyticsChartsScreen extends StatelessWidget {
//   const AnalyticsChartsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1B1B2F),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF00ADB5),
//         title: const Text("Analytics & Charts"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _sectionTitle("📊 Pie Chart - Spending by Category"),
//             const SizedBox(height: 16),
//             AspectRatio(
//               aspectRatio: 1.3,
//               child: _buildPieChart(),
//             ),
//             const SizedBox(height: 40),
//             _sectionTitle("📈 Bar Chart - Monthly Spending"),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 220,
//               child: _buildBarChart(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _sectionTitle(String text) {
//     return Text(
//       text,
//       style: GoogleFonts.poppins(
//         color: Colors.white,
//         fontSize: 16,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
//
//   Widget _buildPieChart() {
//     final List<Map<String, dynamic>> pieData = [
//       {
//         'value': 30.0,
//         'label': 'Dining',
//         'color': Colors.redAccent,
//       },
//       {
//         'value': 25.0,
//         'label': 'Groceries',
//         'color': Colors.orangeAccent,
//       },
//       {
//         'value': 20.0,
//         'label': 'Bills',
//         'color': Colors.blueAccent,
//       },
//       {
//         'value': 25.0,
//         'label': 'Others',
//         'color': Colors.greenAccent,
//       },
//     ];
//
//     return PieChart(
//       PieChartData(
//         centerSpaceRadius: 40,
//         sectionsSpace: 3,
//         startDegreeOffset: -90,
//         sections: pieData.map((item) {
//           final value = item['value'] as double;
//           final label = item['label'] as String;
//           final color = item['color'] as Color;
//
//           return PieChartSectionData(
//             color: color,
//             value: value,
//             radius: 55,
//             title: '$label\n${value.toStringAsFixed(0)}%',
//             titleStyle: const TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//
//   Widget _buildBarChart() {
//     return BarChart(
//       BarChartData(
//         barGroups: [
//           _barGroup(0, 7000),
//           _barGroup(1, 8200),
//           _barGroup(2, 9500),
//           _barGroup(3, 8900),
//           _barGroup(4, 10200),
//           _barGroup(5, 11400),
//         ],
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 40,
//               getTitlesWidget: (value, _) {
//                 return Text(
//                   '₹${value.toInt()}',
//                   style: const TextStyle(color: Colors.white60, fontSize: 10),
//                 );
//               },
//             ),
//           ),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 28,
//               getTitlesWidget: (value, _) {
//                 const months = ['Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
//                 return Text(
//                   months[value.toInt()],
//                   style: const TextStyle(color: Colors.white60, fontSize: 11),
//                 );
//               },
//             ),
//           ),
//         ),
//         gridData: FlGridData(show: false),
//         borderData: FlBorderData(show: false),
//       ),
//     );
//   }
//
//   BarChartGroupData _barGroup(int x, double y) {
//     return BarChartGroupData(
//       x: x,
//       barRods: [
//         BarChartRodData(
//           toY: y,
//           width: 14,
//           borderRadius: BorderRadius.circular(6),
//           color: Colors.tealAccent,
//         ),
//       ],
//     );
//   }
// }
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
        title: const Text("Spending Habit Analysis"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Top Spending Categories",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 10),
            _buildPieChart(),
            const SizedBox(height: 20),

            Text("Spending Insight",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 10),
            _buildInsightCard("You spend 30% of your income on dining out."),
            _buildInsightCard("20% goes to shopping."),
            _buildInsightCard("You save 25% monthly on average."),

            const SizedBox(height: 20),
            Text("Future Expense Prediction",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 10),
            _buildInsightCard("Predicted spending for next month: ₹18,500"),
            _buildInsightCard("Highest forecasted category: Groceries (₹5,500)"),

            const SizedBox(height: 20),
            Text("Monthly Spending Trends",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 10),
            _buildBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(String text) {
    return Card(
      color: const Color(0xFF162447),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          text,
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return AspectRatio(
      aspectRatio: 1.4,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 30,
              title: 'Dining 30%',
              color: Colors.orangeAccent,
              radius: 60,
              titleStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
            ),
            PieChartSectionData(
              value: 20,
              title: 'Shopping 20%',
              color: Colors.purpleAccent,
              radius: 60,
              titleStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
            ),
            PieChartSectionData(
              value: 25,
              title: 'Savings 25%',
              color: Colors.greenAccent,
              radius: 60,
              titleStyle: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
            ),
            PieChartSectionData(
              value: 25,
              title: 'Others 25%',
              color: Colors.blueAccent,
              radius: 60,
              titleStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: 18000, color: Colors.tealAccent, width: 18)
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: 17500, color: Colors.tealAccent, width: 18)
            ]),
            BarChartGroupData(x: 3, barRods: [
              BarChartRodData(toY: 18500, color: Colors.tealAccent, width: 18)
            ]),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 1:
                    return Text('May', style: GoogleFonts.poppins(color: Colors.white70));
                  case 2:
                    return Text('Jun', style: GoogleFonts.poppins(color: Colors.white70));
                  case 3:
                    return Text('Jul', style: GoogleFonts.poppins(color: Colors.white70));
                  default:
                    return const SizedBox.shrink();
                }
              }),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
