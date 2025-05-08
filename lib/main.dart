import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:diabetes_predictor/Views/auth.dart';
import 'package:diabetes_predictor/home_screen.dart';
import 'package:diabetes_predictor/recommendation_screen.dart';
import 'package:diabetes_predictor/doctors_screen.dart';
import 'package:diabetes_predictor/reminder_screen.dart';
import 'package:diabetes_predictor/profile_screen.dart';
import 'package:diabetes_predictor/settings_screen.dart';
import 'package:diabetes_predictor/upload_page.dart';
import 'package:diabetes_predictor/debug_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/auth':
            return MaterialPageRoute(builder: (_) => const AuthScreen());
          case '/home':
            final userId = settings.arguments as int?;
            return MaterialPageRoute(builder: (_) => HomeScreen(userId: userId));
          case '/reminder':
            return MaterialPageRoute(builder: (_) => const ReminderScreen());
          case '/doctors':
            return MaterialPageRoute(builder: (_) => const DoctorsScreen());
          case '/recommendation':
            return MaterialPageRoute(builder: (_) => RecommendationScreen());
          case '/profile':
            final userId = settings.arguments as int?;
            return MaterialPageRoute(builder: (_) => ProfileScreen(userId: userId));
          case '/settings':
            final userId = settings.arguments as int?;
            return MaterialPageRoute(builder: (_) => SettingsScreen(userId: userId));
          case '/corneal-exam':
            final userId = settings.arguments as int?;
            return MaterialPageRoute(builder: (_) => UploadPage(userId: userId));
          case '/debug':
            return MaterialPageRoute(builder: (_) => const DebugScreen());
          default:
            return MaterialPageRoute(builder: (_) => const AuthScreen());
        }
      },
    );
  }
}