// View profile page
import 'package:flutter/material.dart';

class ViewProfilePage extends StatefulWidget {
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}
class _ViewProfilePageState extends State<ViewProfilePage> {
  bool isChangingPassword = false;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildPasswordField(
                labelText: 'Current Password',
                controller: currentPasswordController,
                isVisible: isCurrentPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    isCurrentPasswordVisible = !isCurrentPasswordVisible;
                  });
                },
              ),
              SizedBox(height: 16),
              buildPasswordField(
                labelText: 'New Password',
                controller: newPasswordController,
                isVisible: isNewPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    isNewPasswordVisible = !isNewPasswordVisible;
                  });
                },
              ),
              SizedBox(height: 16),
              buildPasswordField(
                labelText: 'Confirm Password',
                controller: confirmPasswordController,
                isVisible: isConfirmPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Clear the text field values and reset the visibility state
                currentPasswordController.clear();
                newPasswordController.clear();
                confirmPasswordController.clear();
                setState(() {
                  isCurrentPasswordVisible = false;
                  isNewPasswordVisible = false;
                  isConfirmPasswordVisible = false;
                });

                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle change password logic here
                // Retrieve the entered values
                String currentPassword = currentPasswordController.text;
                String newPassword = newPasswordController.text;
                String confirmPassword = confirmPasswordController.text;

                // Validate the entered passwords and perform necessary actions
                if (newPassword == confirmPassword) {
                  // Passwords match, proceed with password change
                  // Implement your logic here
                  print('Changing password...');
                } else {
                  // Passwords do not match, show an error message
                  // Implement your logic here
                  print('Passwords do not match!');
                }

                // Clear the text field values and reset the visibility state
                currentPasswordController.clear();
                newPasswordController.clear();
                confirmPasswordController.clear();
                setState(() {
                  isCurrentPasswordVisible = false;
                  isNewPasswordVisible = false;
                  isConfirmPasswordVisible = false;
                });

                // Close the dialog
                Navigator.pop(context);
              },
              child: Text('Change'),
            ),
          ],
        );
      },
    );
  }

  Widget buildPasswordField({
    required String labelText,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: IconButton(
          icon: isVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
      ),
      obscureText: !isVisible,
      controller: controller,
    );
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avatar-login.png'), // Replace with your avatar image
            ),
            SizedBox(height: 16),
            Text(
              'Lavanya Ravi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
              readOnly: true,
              controller: TextEditingController(text: 'Lavanya'), // Replace with actual first name
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Last Name',
              ),
              readOnly: true,
              controller: TextEditingController(text: 'Ravi'), // Replace with actual last name
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email ID',
              ),
              readOnly: true,
              controller: TextEditingController(text: 'lavanya.ravi@techgenzi.com'), // Replace with actual email ID
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showChangePasswordDialog();
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
