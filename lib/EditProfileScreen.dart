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
    // تهيئة الـ Controllers مع البيانات القديمة
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
        title: const Text("Edit Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // لجعل المحتوى قابلًا للتمرير
          child: Column(
            children: [
              // CircleAvatar لتصميم صورة الملف الشخصي
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              const SizedBox(height: 20),

              // حقول الإدخال
              buildTextField(fullNameController, 'Full Name'),
              buildTextField(phoneController, 'Phone Number', keyboardType: TextInputType.phone),
              buildTextField(emailController, 'Email', keyboardType: TextInputType.emailAddress),
              buildTextField(bloodSugarController, 'Blood Sugar Level', keyboardType: TextInputType.number),

              const SizedBox(height: 20),

              // زر حفظ التعديلات
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // إعادة البيانات المعدلة عند العودة إلى الصفحة الرئيسية
                    Navigator.pop(context, {
                      'fullName': fullNameController.text,
                      'phone': phoneController.text,
                      'email': emailController.text,
                      'bloodSugarLevel': bloodSugarController.text,
                    });
                  },
                  child: const Text("Save Changes" ,style: TextStyle(color: Colors.blue),),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة لبناء الـ TextField مع تصميم احترافي
  Widget buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // تحسين الخط
          hintText: 'Enter your $label',  // إظهار النص التلميحي عند عدم وجود قيمة
          hintStyle: const TextStyle(color: Colors.grey),  // تحسين مظهر النص التلميحي
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),  // جعل الحواف دائرية
            borderSide: const BorderSide(color: Colors.blue, width: 1),  // تحديد لون الحدود
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),  // تغيير لون الحدود عند التركيز
          ),
        ),
      ),
    );
  }
}
