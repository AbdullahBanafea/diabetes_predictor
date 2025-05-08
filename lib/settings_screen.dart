import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_bottom_navigation.dart';

class SettingsScreen extends StatefulWidget {
  final int? userId;

  const SettingsScreen({super.key, this.userId});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;
  int selectedNavIndex = 2;

  @override
  void initState() {
    super.initState();
    print('SettingsScreen: userId = ${widget.userId}');
    _loadSettings();
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
      isNotificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  void _updateSetting(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
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
            print('SettingsScreen: Navigating to ${routes[index]} with userId = ${widget.userId}');
            Navigator.pushNamed(context, routes[index], arguments: widget.userId);
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingOption(
              title: "Dark Mode",
              subtitle: "Enable or disable dark mode",
              value: isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  isDarkMode = value;
                });
                _updateSetting('darkMode', value);
              },
            ),
            _buildSettingOption(
              title: "Notifications",
              subtitle: "Enable or disable notifications",
              value: isNotificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  isNotificationsEnabled = value;
                });
                _updateSetting('notifications', value);
              },
            ),
            _buildSettingOption(
              title: "Change Language",
              subtitle: "Select your preferred language",
              value: false,
              onChanged: (bool value) {},
              isLanguageOption: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLanguageOption = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 6.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: isLanguageOption
            ? const Icon(Icons.language)
            : Switch(value: value, onChanged: onChanged),
        onTap: isLanguageOption
            ? () {}
            : null,
      ),
    );
  }
}