import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class RideOffersPage extends StatelessWidget {
  final  rideOffers;

  RideOffersPage({required this.rideOffers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Offers Nearby'),
      ),
      body: ListView.builder(
        itemCount: rideOffers.length,
        itemBuilder: (context, index) {
          final rideOffer = rideOffers[index];
          //print(rideOffer.car);
          return ListTile(
            title: Text('Offer ID: ${rideOffer.id.toString()}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${rideOffer.FName} ${rideOffer.LName}'),

              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RideOfferDetailsPage(rideOffer: rideOffer),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RideOfferDetailsPage extends StatelessWidget {
  final  rideOffer;


  RideOfferDetailsPage({required this.rideOffer});


  Future<void> acceptOffer(accessToken, BuildContext context) async {
    try {

        final response = await http.post(
          Uri.parse('http://192.168.1.77:8000/api/RideOffer/${rideOffer.id}/accept'),
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
        title: Text('Offer Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Offer ID:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  rideOffer.id.toString(),
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
                  rideOffer.FName+''+rideOffer.LName,
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
                  rideOffer.phone,
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
              ],

            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                  rideOffer.pickupLat.toString()+',\n'+rideOffer.pickupLong.toString(),
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
              ],

            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                  rideOffer.destLat.toString()+',\n'+rideOffer.destLong.toString(),
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
                  'Car:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  rideOffer.carCompany.toString(),
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
                  'Model:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  rideOffer.model.toString(),
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
                  'Color:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  rideOffer.color.toString(),
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
                  'Plates Number:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  rideOffer.platesNumber.toString(),
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
                    acceptOffer(accessToken, context);


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
