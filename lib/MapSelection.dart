import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'NewPostPage.dart';

class MapScreen extends StatefulWidget {
  final LatLng? currentLocation;


  MapScreen({this.currentLocation});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? pickedLocation;
  Set<Marker> markers = {};
  LatLng? currentLocation;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMapTap(LatLng tappedLocation) {
    setState(() {
      pickedLocation = tappedLocation;
      markers = {
        Marker(
          markerId: MarkerId('pickedLocation'),
          position: tappedLocation,
        ),
      };
    });
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(currentLocation!),
      );
    }
  }

  void _navigateToNewPostPage() {
    if (pickedLocation != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPostPage(pickedLocation: pickedLocation),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        onTap: _onMapTap,
        markers: markers,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: widget.currentLocation ?? LatLng(0, 0),
          zoom: 10.0,
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FloatingActionButton(
                onPressed: _getCurrentLocation,
                child: Icon(Icons.my_location),
              ),
              SizedBox(height: 16.0),
              FloatingActionButton(
                onPressed: _navigateToNewPostPage,
                child: Icon(Icons.check),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
