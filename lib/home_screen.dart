import 'package:flutter/material.dart';
import 'package:diabetes_predictor/custom_bottom_navigation.dart';
import 'package:diabetes_predictor/upload_page.dart';
import 'package:diabetes_predictor/debug_screen.dart';

class HomeScreen extends StatefulWidget {
  final int? userId;

  const HomeScreen({super.key, this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    print('HomeScreen: userId = ${widget.userId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Diabetes Predictor",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Your Health Dashboard",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1, // Square buttons
                children: [
                  buildImageButton(
                    context,
                    "Cornea Analysis",
                    'assets/cornea.png',
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadPage(userId: widget.userId),
                      ),
                    ),
                  ),
                  buildImageButton(
                    context,
                    "Set Reminder",
                    'assets/reminder.png',
                        () => Navigator.pushNamed(context, '/reminder'),
                  ),
                  buildImageButton(
                    context,
                    "Find Doctors",
                    'assets/doctors.png',
                        () => Navigator.pushNamed(context, '/doctors'),
                  ),
                  buildImageButton(
                    context,
                    "Recommendations",
                    'assets/recommendations.png',
                        () => Navigator.pushNamed(context, '/recommendation'),
                  ),
                  buildImageButton(
                    context,
                    "Debug Data",
                    'assets/debug.png',
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DebugScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedNavIndex,
        onTabTapped: (index) {
          if (index != selectedNavIndex) {
            setState(() {
              selectedNavIndex = index;
            });
            final routes = ['/home', '/profile', '/settings'];
            print('HomeScreen: Navigating to ${routes[index]} with userId = ${widget.userId}');
            Navigator.pushNamed(context, routes[index], arguments: widget.userId);
          }
        },
      ),
    );
  }

  Widget buildImageButton(
      BuildContext context, String label, String imagePath, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}