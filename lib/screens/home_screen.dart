import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/screens/advanced_expense_list_screen.dart';
import 'package:pemrograman_mobile/screens/category_screen.dart';
import 'package:pemrograman_mobile/screens/statistics_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';
import 'expense_list_screen.dart';
import 'profile_screen.dart';
import '../models/user.dart';
import '../screens/shared_expanse_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Menu Button
                    Builder(
                      builder: (context) => IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(Icons.menu_rounded, color: Colors.white, size: 28),
                      ),
                    ),
                    // Title
                    Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    // Logout Button
                    IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      icon: Icon(Icons.logout_rounded, color: Colors.white, size: 26),
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
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D4E7C),
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            children: [
                              _buildDashboardCard('Expenses', Icons.attach_money_rounded, Color(0xFF7B68AA), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ExpenseListScreen()),
                                );
                              }),
                              _buildDashboardCard('Profile', Icons.person_rounded, Color(0xFF9B87C6), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                                );
                              }),
                              _buildDashboardCard('Settings', Icons.settings_rounded, Color(0xFFB4A5D5), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                                );
                              }),
                              _buildDashboardCard('Expense Analytics', Icons.analytics_rounded, Color(0xFF8B7AB8), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AdvancedExpenseListScreen()),
                                );
                              }),
                              _buildDashboardCard('Category', Icons.category_rounded, Color(0xFF6B5B95), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CategoryScreen()),
                                );
                              }),
                              _buildDashboardCard('Statistic', Icons.bar_chart_rounded, Color(0xFF9B8BB4), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const StatisticsScreen()),
                                );
                              }),
                              _buildDashboardCard('Shared Expenses', Icons.group_rounded, Color(0xFF7B68AA), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SharedExpensesScreen()),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF8B7AB8),
                Color(0xFF6B5B95),
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(Icons.person_rounded, size: 40, color: Color(0xFF7B68AA)),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Welcome ${user.fullName}!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(Icons.home_rounded, 'Home', () {
                Navigator.pop(context);
              }),
              _buildDrawerItem(Icons.person_rounded, 'Profile', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              }),
              _buildDrawerItem(Icons.settings_rounded, 'Settings', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              }),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Divider(color: Colors.white30, thickness: 1),
              ),
              _buildDrawerItem(Icons.logout_rounded, 'Logout', () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDashboardCard(String title, IconData icon, Color color, VoidCallback? onTap) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Builder(
        builder: (context) => InkWell(
          onTap: onTap ?? () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Fitur $title segera hadir!')),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 32, color: color),
                ),
                SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5D4E7C),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}