import 'package:flutter/material.dart';
import 'package:diabetes_predictor/SQLite/database_helper.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  _DebugScreenState createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> photos = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final db = DatabaseHelper.instance;
    try {
      final userData = await db.queryTable('users');
      final photoData = await db.queryTable('photos');
      setState(() {
        users = userData;
        photos = photoData;
      });
    } catch (e) {
      print('Error loading data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> clearData() async {
    final db = DatabaseHelper.instance;
    try {
      await db.clearData();
      // Navigate to AuthScreen after clearing data
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/auth',
            (route) => false, // Remove all previous routes
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data cleared successfully')),
      );
    } catch (e) {
      print('Error clearing data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error clearing data: $e')),
      );
    }
  }

  Future<bool?> showClearDataConfirmation() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
            'Are you sure you want to clear all data? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Debug Data",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () async {
              final confirm = await showClearDataConfirmation();
              if (confirm == true) {
                await clearData();
              }
            },
            tooltip: 'Clear All Data',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Users",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            users.isEmpty
                ? const Text(
              "No users found.",
              style: TextStyle(color: Colors.grey),
            )
                : Column(
              children: users.map((user) => Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    "Name: ${user['fullName']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: ${user['email']}"),
                      Text("Phone: ${user['phoneNumber']}"),
                      Text(
                          "Blood Sugar: ${user['bloodSugarLevel'] ?? 'N/A'}"),
                      Text("Profile Photo: ${user['profilePhotoPath'] ?? 'N/A'}"),
                    ],
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              "Photos",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            photos.isEmpty
                ? const Text(
              "No photos found.",
              style: TextStyle(color: Colors.grey),
            )
                : Column(
              children: photos.map((photo) => Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    "Photo Path: ${photo['photoPath']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User ID: ${photo['userId']}"),
                      Text(
                          "Has Diabetes: ${photo['hasDiabetes'] == 1 ? 'Yes' : 'No'}"),
                      Text("Confidence: ${photo['confidence']}"),
                      Text("Analysis Date: ${photo['analysisDate']}"),
                    ],
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}