import 'package:flutter/material.dart';

class OfferPage extends StatelessWidget {
  final String? destination;
  final String? genderType;
  final String? smokerPassenger;
  final String? carType;
  final String? carModel;
  final String? plateNumber;
  final String? carColor;
  final String? eatingAllowed;

  OfferPage({
    required this.destination,
    required this.genderType,
    required this.smokerPassenger,
    required this.carType,
    required this.carModel,
    required this.plateNumber,
    required this.carColor,
    required this.eatingAllowed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offer'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your destination selection is: $destination',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Select your current location:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Container(
                height: 200, // Adjust the height of the map container as needed
                child:Text('hii') //GoogleMap( // Replace GoogleMap with your preferred map widget
              // Add the necessary parameters to set up the map
              //   ),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Logic to save the current location and other selections
                // and send them to the desired destination
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
