import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController contact_controller = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  
  bool isCurrentPasswordObscure = true;
  bool isNewPasswordObscure = true;

  void _toggleCurrentPasswordVisibility() {
    setState(() {
      isCurrentPasswordObscure = !isCurrentPasswordObscure;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      isNewPasswordObscure = !isNewPasswordObscure;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    contact_controller.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('lib/asset/images/image.png'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contact_controller,
              decoration: InputDecoration(
                labelText: 'Contact #',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _currentPasswordController,
              obscureText: isCurrentPasswordObscure,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isCurrentPasswordObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _toggleCurrentPasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: isNewPasswordObscure,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isNewPasswordObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _toggleNewPasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // SSAAVEE BUTTTTONNNNNNNNN
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Color(0xFF242760), 
                ),
                child: const Text(
                  'Save changes',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, 
                    fontFamily: 'Arial',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
