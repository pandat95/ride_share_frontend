import 'package:flutter/material.dart';

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
            title: Text('Request ID: ${rideRequest.id}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Details'),
      ),
      body: Center(
        child: Text('Request ID: ${rideRequest.id}'),
        // Add other details of the ride request as needed
      ),
    );
  }
}
