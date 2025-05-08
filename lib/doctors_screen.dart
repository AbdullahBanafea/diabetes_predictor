import 'package:flutter/material.dart';
import 'package:diabetes_predictor/custom_bottom_navigation.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  final List<Map<String, String>> doctors = const [
    {
      'name': 'Dr. John Smith',
      'specialty': 'Endocrinologist',
      'phone': '+1 555-123-4567',
    },
    {
      'name': 'Dr. Emily Johnson',
      'specialty': 'General Physician',
      'phone': '+1 555-987-6543',
    },
    {
      'name': 'Dr. Michael Brown',
      'specialty': 'Ophthalmologist',
      'phone': '+1 555-456-7890',
    },
    {
      'name': 'Dr. Sarah Davis',
      'specialty': 'Diabetologist',
      'phone': '+1 555-321-6549',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Find Doctors",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: isLargeScreen
            ? GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns on large screens
            crossAxisSpacing: screenWidth * 0.03,
            mainAxisSpacing: screenHeight * 0.02,
            childAspectRatio: 3 / 2, // Adjust card width-to-height ratio
          ),
          itemCount: doctors.length,
          itemBuilder: (context, index) => buildDoctorCard(
            context,
            doctors[index],
            screenWidth,
            screenHeight,
          ),
        )
            : ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (context, index) => buildDoctorCard(
            context,
            doctors[index],
            screenWidth,
            screenHeight,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 2,
        onTabTapped: (index) {
          final routes = ['/home', '/profile', '/doctors', '/settings'];
          Navigator.pushReplacementNamed(context, routes[index]);
        },
      ),
    );
  }

  Widget buildDoctorCard(BuildContext context, Map<String, String> doctor,
      double screenWidth, double screenHeight) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor['name']!,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              "Specialty: ${doctor['specialty']}",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              "Phone: ${doctor['phone']}",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Add action (e.g., call, email, or navigate to details)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Contact ${doctor['name']}")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Contact"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}