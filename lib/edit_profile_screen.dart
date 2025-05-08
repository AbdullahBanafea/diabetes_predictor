import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String fullName;
  final String phone;
  final String email;
  final String bloodSugarLevel;

  const EditProfileScreen({
    super.key,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.bloodSugarLevel,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController bloodSugarController;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.fullName);
    phoneController = TextEditingController(text: widget.phone);
    emailController = TextEditingController(text: widget.email);
    bloodSugarController = TextEditingController(text: widget.bloodSugarLevel);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    bloodSugarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: Colors.blue)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              buildTextField(fullNameController, 'Full Name'),
              buildTextField(phoneController, 'Phone Number',
                  keyboardType: TextInputType.phone),
              buildTextField(emailController, 'Email',
                  keyboardType: TextInputType.emailAddress),
              buildTextField(bloodSugarController, 'Blood Sugar Level',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'fullName': fullNameController.text,
                      'phoneNumber': phoneController.text,
                      'email': emailController.text,
                      'bloodSugarLevel': bloodSugarController.text,
                    });
                  },
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          hintText: 'Enter your $label',
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}