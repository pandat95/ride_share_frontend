import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _isPasswordVisible = false;
  bool _isSavePasswordEnabled = false;

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;
  bool _isSavePhoneNumberEnabled = false;
  bool _isOldPasswordValid = true;

  String _oldPhoneNumber='';
  String _oldPassword='';

  @override
  void initState() {
    super.initState();
    _oldPhoneNumber = Provider.of<UserProvider>(context, listen: false).phone;
    _oldPassword = 'meu';
  }

  int _getCountryCodeLength() {
    String phoneNumber = _phoneNumberController.text;
    int index = phoneNumber.indexOf(' ');
    if (index != -1) {
      return index;
    }
    return 0;
  }

  void _showConfirmationDialog(String newPhoneNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to change your phone number to +962 $newPhoneNumber?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _oldPhoneNumber = '+962$newPhoneNumber';
                });
                Navigator.of(context).pop();
                _showSuccessDialog('Your phone number has been changed.');
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _validateOldPassword() {
    String enteredPassword = _oldPasswordController.text;
    setState(() {
      _isOldPasswordValid = enteredPassword == _oldPassword;
    });
  }

  void _validateNewPassword() {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;
    setState(() {
      _isPasswordValid = newPassword.length >= 6;
      _isConfirmPasswordValid = newPassword == confirmPassword;
      _isSavePasswordEnabled = _isPasswordValid && _isConfirmPasswordValid;
    });
  }

  void _validateConfirmPassword() {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;
    setState(() {
      _isConfirmPasswordValid = newPassword == confirmPassword;
      _isSavePasswordEnabled = _isPasswordValid && _isConfirmPasswordValid;
    });
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Change Phone Number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(style: TextStyle(color: Colors.black), children: [
                TextSpan(text: 'Your Current Phone Number is: '),
                TextSpan(
                  text: '$_oldPhoneNumber',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                )
              ]),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Save Phone Number'),
              onPressed: () {
                String newPhoneNumber = _phoneNumberController.text;
                _showConfirmationDialog(newPhoneNumber);
              },
            ),
            SizedBox(height: 16),
            Text(
              'Change Password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _oldPasswordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Old Password',
                border: OutlineInputBorder(),
                errorText: _isOldPasswordValid ? null : 'Incorrect old password',
                errorStyle: TextStyle(fontSize: 12),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              onChanged: (value) {
                _validateOldPassword();
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _newPasswordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
                errorText: _isPasswordValid ? null : 'Password must contain at least 6 characters',
                errorStyle: TextStyle(fontSize: 12),
                suffixIcon: _isPasswordValid
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.error, color: Colors.red),
              ),
              onChanged: (value) {
                _validateNewPassword();
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
                errorText: _isConfirmPasswordValid ? null : 'Passwords do not match',
                errorStyle: TextStyle(fontSize: 12),
                suffixIcon: _isConfirmPasswordValid
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.error, color: Colors.red),
              ),
              onChanged: (value) {
                _validateConfirmPassword();
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              child: Text('Save Password'),
              onPressed: () {
                if (_isConfirmPasswordValid) {
                  setState(() {
                    _oldPassword = _newPasswordController.text;
                  });
                  _showSuccessDialog('Your password has been changed.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
