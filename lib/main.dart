import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/settings_service.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
    
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load dark mode setting saat app pertama kali dibuka
  bool isDarkMode = await SettingsService.getDarkMode();
  themeNotifier.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'Aplikasi Pengeluaran',
          themeMode: themeMode, 
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}