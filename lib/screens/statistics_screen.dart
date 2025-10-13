import 'dart:math';
import 'package:flutter/material.dart';
import '../services/expense_manager.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<String, double> categoryTotals = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final totals = ExpenseManager.getCategoryTotals();
    setState(() {
      categoryTotals = totals;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalPengeluaran = categoryTotals.values.fold(0.0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Pengeluaran'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: categoryTotals.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada data pengeluaran',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Pie Chart
                    PieChartWidget(data: categoryTotals),
                    const SizedBox(height: 20),

                    // Legend
                    LegendWidget(data: categoryTotals),
                    const SizedBox(height: 20),

                    // Card Total Pengeluaran
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Total Pengeluaran: Rp ${totalPengeluaran.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// PieChart
class PieChartWidget extends StatelessWidget {
  final Map<String, double> data;
  const PieChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 250,
      child: CustomPaint(
        painter: PieChartPainter(data),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final Map<String, double> data;
  final List<Color> colors = [
    const Color.fromARGB(255, 91, 111, 183),
    const Color.fromARGB(255, 43, 53, 91),
    const Color.fromARGB(255, 48, 53, 183),
    const Color.fromARGB(255, 29, 95, 152),
    const Color.fromARGB(255, 58, 44, 138),
    const Color.fromARGB(255, 139, 152, 183),
    const Color.fromARGB(255, 108, 131, 247)
  ];

  PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.values.fold(0.0, (a, b) => a + b);
    if (total == 0) return;

    double startAngle = -pi / 2;
    final radius = min(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final value = data.values.elementAt(i);
      final sweepAngle = (value / total) * 2 * pi;
      paint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Legend
class LegendWidget extends StatelessWidget {
  final Map<String, double> data;
  const LegendWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color.fromARGB(255, 91, 111, 183),
      const Color.fromARGB(255, 43, 53, 91),
      const Color.fromARGB(255, 48, 53, 183),
      const Color.fromARGB(255, 29, 95, 152),
      const Color.fromARGB(255, 58, 44, 138),
      const Color.fromARGB(255, 139, 152, 183),
      const Color.fromARGB(255, 108, 131, 247)
    ];

    return Column(
      children: data.entries.map((entry) {
        final index = data.keys.toList().indexOf(entry.key);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text('${entry.key} - Rp ${entry.value.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 14)),
            ],
          ),
        );
      }).toList(),
    );
  }
}