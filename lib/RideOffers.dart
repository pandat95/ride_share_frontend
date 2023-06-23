import 'package:flutter/material.dart';



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
          return ListTile(
            title: Text('Offer ID: ${rideOffer.id}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offer Details'),
      ),
      body: Center(
        child: Text('Offer ID: ${rideOffer.id}'),
        // Add other details of the ride Offer as needed
      ),
    );
  }
}
