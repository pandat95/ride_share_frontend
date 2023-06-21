import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'SignUpPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'Login App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorText = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    String url = 'http://192.168.1.77:8000/api/login';
//10.0.2.2 for android emulator
    //192.168.1.77 for phone
    //127.0.0.1 for web
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
        var apiToken = responseData['student'];
        var firstName = responseData['first_name'];
        var lastName = responseData['last_name'];
        var phoneNumber = responseData['phone'];
        var email = responseData['email'];
        var stu_id=responseData['stu_id'];

        Provider.of<UserProvider>(context, listen: false).setName(firstName, lastName);
        Provider.of<UserProvider>(context, listen: false).setEmail(email);
        Provider.of<UserProvider>(context, listen: false).setPhone(phoneNumber);
        Provider.of<UserProvider>(context, listen: false).setToken(apiToken);
        Provider.of<UserProvider>(context, listen: false).setStu_id(stu_id);

        // Process the response data and navigate to the appropriate screen
        print('Login Successful');
        print(apiToken);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Failed login, handle the error response
        var errorData = jsonDecode(response.body);
        setState(() {
          _errorText = errorData['message'];
          _emailController.clear();
          _passwordController.clear();
        });
        print('Login Failed: ${errorData['message']}');
      }
    } catch (e) {
      // Handle any exceptions or connection errors
      setState(() {
        _errorText = 'An error occurred. Please try again.';
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter Uni Email',
                prefixIcon: Icon(Icons.email),
                errorText: _errorText.isNotEmpty ? 'Invalid email or password' : null,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 8.0),
            if (_errorText.isNotEmpty)
              Text(
                _errorText,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
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
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                // );
              },
              child: Text(
                'Forget Password?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                'Sign Up',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
