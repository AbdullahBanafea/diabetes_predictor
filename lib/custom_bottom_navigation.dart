import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Define the items
    const items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];

    // Clamp the selectedIndex to a valid range
    final validIndex = selectedIndex.clamp(0, items.length - 1);

    return BottomNavigationBar(
      currentIndex: validIndex,
      onTap: onTabTapped,
      items: items,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    );
  }
}