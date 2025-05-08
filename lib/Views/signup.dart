import 'package:flutter/material.dart';
import 'package:diabetes_predictor/Components/button.dart';
import 'package:diabetes_predictor/Components/textfield.dart';
import 'package:diabetes_predictor/JSON/users.dart';
import 'package:diabetes_predictor/SQLite/database_helper.dart';
import 'package:diabetes_predictor/Views/login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final fullName = TextEditingController();
  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final db = DatabaseHelper.instance;

  Future<void> signUp() async {
    if (password.text != confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    var res = await db.createUser(Users(
      fullName: fullName.text,
      phoneNumber: phoneNumber.text,
      email: email.text,
      password: password.text,
    ));
    if (res > 0 && mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              InputField(
                  hint: "Full Name", icon: Icons.person, controller: fullName),
              InputField(
                  hint: "Phone Number",
                  icon: Icons.phone,
                  controller: phoneNumber),
              InputField(
                  hint: "Email", icon: Icons.email, controller: email),
              InputField(
                  hint: "Password",
                  icon: Icons.lock,
                  controller: password,
                  passwordInvisible: true),
              InputField(
                  hint: "Confirm Password",
                  icon: Icons.lock,
                  controller: confirmPassword,
                  passwordInvisible: true),
              const SizedBox(height: 20),
              Button(
                label: "SIGN UP",
                press: signUp,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ",
                      style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: const Text("Login", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}