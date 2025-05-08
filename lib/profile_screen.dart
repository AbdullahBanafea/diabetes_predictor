import 'dart:io';
import 'package:flutter/material.dart';
import 'package:diabetes_predictor/SQLite/database_helper.dart';
import 'package:diabetes_predictor/custom_bottom_navigation.dart';

class ProfileScreen extends StatefulWidget {
  final int? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  List<Map<String, dynamic>> allUsers = [];
  int selectedNavIndex = 1;

  @override
  void initState() {
    super.initState();
    print('ProfileScreen: userId = ${widget.userId}');
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (widget.userId == null) {
      print('ProfileScreen: userId is null');
      setState(() {
        isLoading = false;
        userData = null;
      });
      return;
    }

    final db = DatabaseHelper.instance;
    try {
      // Fetch all users for debugging
      allUsers = await db.getAllUsers();
      print('ProfileScreen: All users = $allUsers');

      // Fetch specific user
      final user = await db.getUserById(widget.userId!);
      print('ProfileScreen: getUserById(${widget.userId}) returned: $user');
      setState(() {
        userData = user;
        isLoading = false;
      });
    } catch (e) {
      print('ProfileScreen: Error fetching user data: $e');
      setState(() {
        isLoading = false;
        userData = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
          ? Center(
        child: Text(
          allUsers.isEmpty
              ? "No users found in database. Please sign up."
              : "User not found for ID ${widget.userId}. Available users: ${allUsers.map((u) => u['usrId']).toList()}",
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: userData!['profilePhotoPath'] != null
                  ? FileImage(File(userData!['profilePhotoPath']))
                  : const AssetImage('assets/profile.jpg')
              as ImageProvider,
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.blue),
                title: const Text(
                  "Full Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(userData!['fullName'] ?? 'N/A'),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.blue),
                title: const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(userData!['email'] ?? 'N/A'),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.blue),
                title: const Text(
                  "Phone Number",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(userData!['phoneNumber'] ?? 'N/A'),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.favorite, color: Colors.blue),
                title: const Text(
                  "Blood Sugar Level",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle:
                Text(userData!['bloodSugarLevel'] ?? 'Not set'),
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
            print('ProfileScreen: Navigating to ${routes[index]} with userId = ${widget.userId}');
            Navigator.pushNamed(context, routes[index], arguments: widget.userId);
          }
        },
      ),
    );
  }
}