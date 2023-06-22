import 'package:flutter/material.dart';

class RequestPage extends StatelessWidget {
  final String? destination;
  final String? genderType;
  final String? smokerDriver;
  final String? canEat;
  final TextEditingController locationController = TextEditingController(); // Added controller for location

  RequestPage({
    required this.destination,
    required this.genderType,
    required this.smokerDriver,
    required this.canEat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your destination selection is:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              destination ?? '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Select your current location:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: Placeholder(), // Replace Placeholder() with your Google Map widget
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                saveLocation(); // Save the location when the button is pressed
                searchRide(); // Perform the search for a ride
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

  void saveLocation() {
    String currentLocation = locationController.text;
    // Do something with the currentLocation, like storing it in a variable or database
  }

  void searchRide() {
    // Implement your logic to search for a ride based on the user's preferences and location
  }
}
