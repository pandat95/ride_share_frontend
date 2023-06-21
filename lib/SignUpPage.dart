import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'home_page.dart';
import 'Login.dart';
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _passwordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showHelpMessage = false;
  String _errorText = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  Future<void> _finishSignup() async {
    String url = 'http://127.0.0.1:8000/api/register'; // Replace with your Laravel login endpoint

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );


      if (response.statusCode == 200) {
        // Successful login, handle the response accordingly
        var responseData = jsonDecode(response.body);




        // Process the response data and navigate to the appropriate screen
        print('Sign up Successful');
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        // Failed login, handle the error response
        var errorData = jsonDecode(response.body);
        setState(() {
          _errorText = errorData['message'];
          _emailController.clear();
          _passwordController.clear();
        });
        print('Sign Up Failed: ${errorData['message']}');
      }
    } catch (e) {
      // Handle any exceptions or connection errors
      setState(() {
        _errorText = 'An error occurred. Please try again.';
      });
      print('Error: $e');
    }
  }
  // void _finishSignup() {
  //   String email = _emailController.text;
  //   String password = _passwordController.text;
  //
  //   // Perform the signup logic here
  //   // Search the local database for a match
  //
  //   // Example: Print the entered email and password
  //   print('Email: $email');
  //   print('Password: $password');
  // }

  void _toggleHelpMessage() {
    setState(() {
      _showHelpMessage = !_showHelpMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Please enter Your University Email',
                prefixIcon: Icon(Icons.email),
                errorText: _errorText.isNotEmpty ? 'Invalid email or password' : null,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: 'Enter your Password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  child: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                errorText: _errorText.isNotEmpty ? 'Invalid email or password' : null,
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: _toggleHelpMessage,
              child: Tooltip(
                message:
                'Enter the email and password the same as your university credentials',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.help),
                    SizedBox(width: 8.0),
                    Text(
                      'Need Help?',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.0),
            _showHelpMessage
                ? Text(
              'Enter the email and password the same as your university credentials',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            )
                : SizedBox(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _finishSignup,
              child: Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
