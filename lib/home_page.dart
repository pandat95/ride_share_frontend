import 'package:flutter/material.dart';
 import 'package:last_chance/NewRidePage.dart';

import 'Login.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'EditProfilePage.dart';
import 'Board.dart';


void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String Name = Provider.of<UserProvider>(context).Name;
    String email = Provider.of<UserProvider>(context).email;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _showSettingsMenu(context); // Show settings menu
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 150),
            Center(
              child: Image.asset(
                'assets/m1.jpg',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 16),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    icon: Icon(Icons.add),
                    label: Text('New Ride'),
                    onPressed: () {
                      // TODO: Implement onPressed for New Ride button
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewRidePage()),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Text('Board'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Board()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                onTap: () {
                  _showAboutDialog(context); // Show about dialog
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  _showLogoutDialog(context); // Show logout dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About'),
          content: Text(
            'Welcome to MEU ride share application.\n\n'
                'This app was developed by students '
                'of the Faculty of Information Technology '
                'as a graduation project.\n\n'
                'Done by: Dodge + Panda + Jesus.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
            ),
          ),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                // Perform logout logic
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
              child: Text('Logout'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
