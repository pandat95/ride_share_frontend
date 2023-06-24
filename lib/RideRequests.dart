import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class RideRequestsPage extends StatelessWidget {
  final  rideRequests;

  RideRequestsPage({required this.rideRequests});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Requests Nearby'),
      ),
      body: ListView.builder(
        itemCount: rideRequests.length,
        itemBuilder: (context, index) {
          final rideRequest = rideRequests[index];
          return ListTile(
            title: Text('Request ID: ${rideRequest.id.toString()}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${rideRequest.FName} ${rideRequest.LName}'),

              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RideRequestDetailsPage(rideRequest: rideRequest),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RideRequestDetailsPage extends StatelessWidget {
  final  rideRequest;

  RideRequestDetailsPage({required this.rideRequest});
  Future<void> acceptRequest(accessToken, BuildContext context) async {
    try {

      final response = await http.post(
        Uri.parse('http://192.168.1.77:8000/api/RideRequest/${rideRequest.id}/accept'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Request successful, handle the response if needed
        var responseData = jsonDecode(response.body);
        print('Ride Offer post accepted successfully');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Offer Accepted'),
              content: Text('$responseData'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Request failed, handle the error
        var responseData = jsonDecode(response.body);
        print('Error accepting Ride Offer : $responseData');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Error accepting Ride Offer : $responseData'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }

    } catch (e) {
      // Error occurred, handle the exception
      print('An error occurred. Please try again.');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String accessToken = Provider.of<UserProvider>(context).token;
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Details'),

      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Request ID:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Increase the font size as desired
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    rideRequest.id.toString(),
                    style: TextStyle(
                      fontSize: 18, // Increase the font size as desired
                    ),
                  ),
                ],

              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Name:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Increase the font size as desired
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    rideRequest.FName+''+rideRequest.LName,
                    style: TextStyle(
                      fontSize: 18, // Increase the font size as desired
                    ),
                  ),
                ],

              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Phone:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Increase the font size as desired
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    rideRequest.phone,
                    style: TextStyle(
                      fontSize: 18, // Increase the font size as desired
                    ),
                  ),
                ],

              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Pick-Up Location:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Increase the font size as desired
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    rideRequest.pickupLat.toString()+',\n'+rideRequest.pickupLong.toString(),
                    style: TextStyle(
                      fontSize: 18, // Increase the font size as desired
                    ),
                  ),
                ],

              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Destination:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Increase the font size as desired
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    rideRequest.destLat.toString()+',\n'+rideRequest.destLong.toString(),
                    style: TextStyle(
                      fontSize: 18, // Increase the font size as desired
                    ),
                  ),
                ],

              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      acceptRequest(accessToken, context);

                    },
                    child: Text(
                      'Accept',
                      style: TextStyle(
                        fontSize: 18, // Increase the font size as desired
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]
        // Add other details of the ride Offer as needed
      ),
    );
  }
}
