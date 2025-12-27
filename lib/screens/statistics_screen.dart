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
  PeriodType selectedPeriodType = PeriodType.all;
  String selectedPeriod = 'All Time';
  
  // Filter values
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedWeek = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    Map<String, double> totals;
    
    // Load data based on selected period
    switch (selectedPeriodType) {
      case PeriodType.week:
      case PeriodType.month:
      case PeriodType.year:
        totals = ExpenseManager.getCategoryTotalsByPeriod(
          period: selectedPeriodType,
          year: selectedYear,
          month: selectedMonth,
          week: selectedWeek,
        );
        break;
      case PeriodType.all:
      totals = ExpenseManager.getCategoryTotals();
    }
    
    setState(() {
      categoryTotals = totals;
    });
  }

  PeriodType _getPeriodType(String period) {
    switch (period) {
      case 'Week':
        return PeriodType.week;
      case 'Month':
        return PeriodType.month;
      case 'Year':
        return PeriodType.year;
      default:
        return PeriodType.all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPengeluaran = categoryTotals.values.fold(0.0, (a, b) => a + b);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark 
            ? [
                Color(0xFF1a1a2e), // Dark purple
                Color(0xFF16213e),
                Color(0xFF0f3460),
              ]
            : [
                Color(0xFF8B7AB8),
                Color(0xFF6B5B95),
                Color(0xFF4A4063),
              ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Statistics',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF1e1e2e) : Color(0xFFF5F3F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        
                        // Period Selector
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF9B87C6).withOpacity(0.15),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedPeriod,
                              isExpanded: true,
                              icon: Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7B68AA)),
                              style: TextStyle(
                                color: Color(0xFF5D4E7C),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              items: ['Week', 'Month', 'Year', 'All Time'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      Icon(
                                        value == 'Week' ? Icons.calendar_view_week_rounded :
                                        value == 'Month' ? Icons.calendar_month_rounded :
                                        value == 'Year' ? Icons.calendar_today_rounded :
                                        Icons.all_inclusive_rounded,
                                        color: Color(0xFF7B68AA),
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Text(value),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedPeriod = newValue!;
                                  selectedPeriodType = _getPeriodType(newValue);
                                });
                                _loadData();
                              },
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Additional Filters based on selected period
                        if (selectedPeriodType != PeriodType.all)
                          _buildPeriodFilters(),
                        
                        SizedBox(height: 30),

                        // Pie Chart
                        if (categoryTotals.isEmpty)
                          Container(
                            padding: EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: isDark ? Color(0xFF2d2d44) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF9B87C6).withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.pie_chart_outline_rounded,
                                  size: 64,
                                  color: Color(0xFF9B8BB4).withOpacity(0.5),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No expense data available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF9B8BB4),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                             color: isDark ? Color(0xFF2d2d44) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF9B87C6).withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: PieChartWidget(data: categoryTotals),
                          ),
                        
                        SizedBox(height: 25),

                        // Legend
                        if (categoryTotals.isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDark ? Color(0xFF2d2d44) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF9B87C6).withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: LegendWidget(data: categoryTotals),
                          ),
                        
                        SizedBox(height: 25),

                        // Card Total Pengeluaran
                        Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFD4C5F9),
                                Color(0xFFB4A5D5),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFB4A5D5).withOpacity(0.4),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Expenses',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF5D4E7C),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Rp ${totalPengeluaran.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4A4063),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.account_balance_wallet_rounded,
                                  color: Color(0xFF4A4063),
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 20),
                      ],
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

  Widget _buildPeriodFilters() {
    return Column(
      children: [
        // Year Filter (for Week, Month, Year)
        _buildFilterDropdown(
          label: 'Year',
          value: selectedYear,
          items: [2023, 2024, 2025].map((year) {
            return DropdownMenuItem(
              value: year,
              child: Text('$year'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedYear = value!;
            });
            _loadData();
          },
        ),
        
        // Month Filter (only for Month period)
        if (selectedPeriodType == PeriodType.month)
          _buildFilterDropdown(
            label: 'Month',
            value: selectedMonth,
            items: [
              'January', 'February', 'March', 'April', 'May', 'June',
              'July', 'August', 'September', 'October', 'November', 'December'
            ].asMap().entries.map((entry) {
              return DropdownMenuItem(
                value: entry.key + 1,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedMonth = value!;
              });
              _loadData();
            },
          ),
        
        // Week Filter (only for Week period)
        if (selectedPeriodType == PeriodType.week)
          _buildFilterDropdown(
            label: 'Week',
            value: selectedWeek,
            items: List.generate(52, (i) {
              return DropdownMenuItem(
                value: i + 1,
                child: Text('Week ${i + 1}'),
              );
            }),
            onChanged: (value) {
              setState(() {
                selectedWeek = value!;
              });
              _loadData();
            },
          ),
      ],
    );
  }

  Widget _buildFilterDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF9B87C6).withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF7B68AA),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7B68AA)),
              style: TextStyle(
                color: Color(0xFF5D4E7C),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ],
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
    Color(0xFF7B68AA),
    Color(0xFF9B87C6),
    Color(0xFFB4A5D5),
    Color(0xFF8B7AB8),
    Color(0xFF6B5B95),
    Color(0xFF9B8BB4),
    Color(0xFFD4C5F9),
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
      Color(0xFF7B68AA),
      Color(0xFF9B87C6),
      Color(0xFFB4A5D5),
      Color(0xFF8B7AB8),
      Color(0xFF6B5B95),
      Color(0xFF9B8BB4),
      Color(0xFFD4C5F9),
    ];

    return Column(
      children: data.entries.map((entry) {
        final index = data.keys.toList().indexOf(entry.key);
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFFF8F6FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5D4E7C),
                  ),
                ),
              ),
              Text(
                'Rp ${entry.value.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7B68AA),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}