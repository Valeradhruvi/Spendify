import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AnalyticsChartsScreen extends StatefulWidget {
  const AnalyticsChartsScreen({super.key});

  @override
  State<AnalyticsChartsScreen> createState() => _AnalyticsChartsScreenState();
}

class _AnalyticsChartsScreenState extends State<AnalyticsChartsScreen> {
  final String uid = '101'; // Replace with user's UID
  String groupBy = "Category"; // Pie group by

  bool showPieChart = true;

  final List<String> groupOptions = [
    "Category",
    "Payment Method",
    // Add more if needed
  ];

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
            if (showPieChart) ...[
              _sectionTitle("📊 Pie Chart - Spending by"),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text("Group by: ",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  DropdownButton<String>(
                    value: groupBy,
                    dropdownColor: const Color(0xFF1B1B2F),
                    focusColor: Colors.transparent,
                    items: groupOptions
                        .map(
                          (g) => DropdownMenuItem(
                        value: g,
                        child: Text(
                          g,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => groupBy = val);
                    },
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: const Color(0xFF1B1B2F),
                    ),
                    onPressed: () {
                      setState(() => showPieChart = false);
                    },
                    child: const Icon(Icons.bar_chart),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildPieChartStream(),
            ] else ...[
              _sectionTitle("📈 Bar Chart - Monthly Spending"),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00ADB5),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() => showPieChart = true);
                  },
                  icon: const Icon(Icons.pie_chart),
                  label: const Text('Pie Chart'),
                ),
              ),
              const SizedBox(height: 16),
              _buildBarChartStream(),
            ],
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

  Widget _buildPieChartStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transaction')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final txDocs = snapshot.data!.docs;
        String groupField = groupBy == "Category"
            ? "category"
            : groupBy == "Payment Method"
            ? "paymentMethod"
            : "category"; // fallback

        Map<String, double> pieTotals = {};
        for (var doc in txDocs) {
          final data = doc.data() as Map<String, dynamic>;
          final type = data['type'] ?? 'Expense';
          if (type != 'Expense') continue;
          final amount = (data['amount'] is num)
              ? (data['amount'] as num).toDouble()
              : double.tryParse(data['amount'].toString()) ?? 0.0;
          final groupValue = data[groupField] ?? 'Others';
          pieTotals[groupValue] = (pieTotals[groupValue] ?? 0) + amount;
        }
        final total = pieTotals.values.fold(0.0, (a, b) => a + b);

        final List<Color> pieColors = [
          Colors.redAccent,
          Colors.orangeAccent,
          Colors.blueAccent,
          Colors.greenAccent,
          Colors.purpleAccent,
          Colors.yellowAccent,
          Colors.cyanAccent,
          Colors.pinkAccent,
        ];
        final sorted = pieTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final pieData = <Map<String, dynamic>>[];
        double others = 0.0;
        for (var i = 0; i < sorted.length; i++) {
          if (i < 6) {
            pieData.add({
              'value': total == 0 ? 0.0 : (sorted[i].value / total * 100),
              'label': sorted[i].key,
              'color': pieColors[i % pieColors.length],
            });
          } else {
            others += sorted[i].value;
          }
        }
        if (others > 0) {
          pieData.add({
            'value': total == 0 ? 0.0 : (others / total * 100),
            'label': 'Others',
            'color': Colors.grey,
          });
        }

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 40,
                  sectionsSpace: 3,
                  startDegreeOffset: -90,
                  sections: pieData
                      .map((item) => PieChartSectionData(
                    color: item['color'],
                    value: item['value'],
                    radius: 55,
                    title: '',
                  ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 8,
              children: pieData.map((item) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item['color'],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${item['label']} (${item['value'].toStringAsFixed(1)}%)",
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBarChartStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transaction')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final txDocs = snapshot.data!.docs;
        Map<String, double> monthlyTotals = {};

        for (var doc in txDocs) {
          final data = doc.data() as Map<String, dynamic>;
          final type = data['type'] ?? 'Expense';
          if (type != 'Expense') continue;
          if (data['date'] == null) continue;
          final dt = data['date'] is DateTime
              ? data['date']
              : (data['date'] is Timestamp
              ? (data['date'] as Timestamp).toDate()
              : null);
          if (dt == null) continue;
          final key = "${dt.year}-${dt.month.toString().padLeft(2, '0')}";
          final amount = (data['amount'] is num)
              ? (data['amount'] as num).toDouble()
              : double.tryParse(data['amount'].toString()) ?? 0.0;
          monthlyTotals[key] = (monthlyTotals[key] ?? 0) + amount;
        }
        final now = DateTime.now();
        final months = List.generate(6, (i) {
          final date = DateTime(now.year, now.month - 5 + i);
          return "${date.year}-${date.month.toString().padLeft(2, '0')}";
        });
        final barData = months.map((key) => monthlyTotals[key] ?? 0.0).toList();
        final monthLabels = months.map((key) {
          final parts = key.split('-');
          final m = int.tryParse(parts[1] ?? '') ?? 1;
          return DateFormat.MMM().format(DateTime(0, m));
        }).toList();

        // Add "headroom" to maxY to avoid value clashing for similar values
        double maxBar = barData.fold(0.0, (a, b) => a > b ? a : b);
        double chartMaxY = maxBar > 0 ? maxBar * 1.15 : 1000.0; // 15% more than max value or a minimum

        return SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              maxY: chartMaxY,
              barGroups: List.generate(6, (i) => _barGroup(i, barData[i])),
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
                      if (value.toInt() < 0 || value.toInt() > 5) return const SizedBox.shrink();
                      return Text(
                        monthLabels[value.toInt()],
                        style: const TextStyle(color: Colors.white60, fontSize: 11),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(show: true, horizontalInterval: chartMaxY / 4),
              borderData: FlBorderData(show: false),
            ),
          ),
        );
      },
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
