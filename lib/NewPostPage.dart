import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'MapSelection.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'home_page.dart';



class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
  final LatLng? pickedLocation;


  NewPostPage({this.pickedLocation});

}

class _NewPostPageState extends State<NewPostPage> {


  GoogleMapController? mapController;
  LatLng? selectedLocation;
  bool? _postType;
  bool? _direction;
  DateTime? _selectedDateTime;
  bool _isSmokerSelected = false;
  bool _isNonSmokerSelected = false;
  bool _isEatingSelected = false;
  bool _isDrinkingSelected = false;
  TextEditingController _locationController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _carCompanyController = TextEditingController();
  TextEditingController _carModelController = TextEditingController();
  TextEditingController _platesNumberController = TextEditingController();
  TextEditingController _carColorController = TextEditingController();
  TextEditingController _availableSeatsController = TextEditingController();
  String? _selectedGender;
  void _openMapDialog() async {
    final LatLng? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Location'),
          content: Container(
            width: double.infinity,
            height: 300,
            child: MapScreen(currentLocation: selectedLocation),
          ),
        );
      },

    );

    if (result != null) {
      setState(() {
        _locationController.text='Lat: ${result.latitude} , Lon: ${result.longitude}';
        //selectedLocation = result;
      });
    }
  }
  void _openMapDialog2() async {
    final LatLng? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Location'),
          content: Container(
            width: double.infinity,
            height: 300,
            child: MapScreen(currentLocation: selectedLocation),
          ),
        );
      },

    );

    if (result != null) {
      setState(() {
        _destinationController.text='Lat: ${result.latitude} , Lon: ${result.longitude}';
        //selectedLocation = result;
      });
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _destinationController.dispose();
    _carCompanyController.dispose();
    _carModelController.dispose();
    _platesNumberController.dispose();
    _carColorController.dispose();
    _availableSeatsController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    String accessToken = Provider.of<UserProvider>(context).token;
    // String token = Provider.of<UserProvider>(context).token;
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Post Type',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              FilterChip(
                label: Text('Offer a ride'),
                selected: _postType == false,
                onSelected: (bool selected) {
                  setState(() {
                    _postType = false;
                  });
                },
              ),
              FilterChip(
                label: Text('Request a ride'),
                selected: _postType == true,
                onSelected: (bool selected) {
                  setState(() {
                    _postType = true;
                  });
                },
              ),
              SizedBox(height: 16),
              if (_postType != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Direction',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    FilterChip(
                      label: Text('From MEU'),
                      selected: _direction == false,
                      onSelected: (bool selected) {
                        setState(() {
                          _direction = false;
                          if (_direction == false) {
                            _locationController.text = 'https://goo.gl/maps/xVaurK5RZmPFciL5A';
                            _destinationController.text='';

                          } else {
                            _locationController.text='';

                            _destinationController.text = 'https://goo.gl/maps/xVaurK5RZmPFciL5A';
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: Text('To MEU'),
                      selected: _direction == true,
                      onSelected: (bool selected) {
                        setState(() {
                          _direction = true;
                          if (_direction == false) {
                            _locationController.text = 'https://goo.gl/maps/xVaurK5RZmPFciL5A';
                            _destinationController.text='';

                          } else {
                            _locationController.text='';

                            _destinationController.text = 'https://goo.gl/maps/xVaurK5RZmPFciL5A';
                          }
                        });
                      },
                    ),
                  ],
                ),
              SizedBox(height: 16),
              if (_postType == false) // Show Car Details only if "Offer a ride" is selected
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Car Details',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    TextField(
                      controller: _carCompanyController,
                      decoration: InputDecoration(
                        hintText: 'Enter car company',
                      ),
                    ),
                    TextField(
                      controller: _carModelController,
                      decoration: InputDecoration(
                        hintText: 'Enter car model',
                      ),
                    ),
                    TextField(
                      controller: _platesNumberController,
                      decoration: InputDecoration(
                        hintText: 'Enter plates number',
                      ),
                    ),
                    TextField(
                      controller: _carColorController,
                      decoration: InputDecoration(
                        hintText: 'Enter car color',
                      ),
                    ),
                    TextField(
                      controller: _availableSeatsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter available seats',
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              Text(
                'Date and Time',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (selectedDate != null) {
                    final TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      setState(() {
                        _selectedDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      });
                    }
                  }
                },
                child: Text('Select Date and Time'),
              ),
              if (_selectedDateTime != null)
                Text('Selected Date and Time: ${_selectedDateTime.toString()}'),
              SizedBox(height: 16),
              Text(
                'Rules',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: Text('Male'),
                    selected: _selectedGender == 'Male',
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedGender = selected ? 'Male' : null;
                      });
                    },
                  ),
                  FilterChip(
                    label: Text('Female'),
                    selected: _selectedGender == 'Female',
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedGender = selected ? 'Female' : null;
                      });
                    },
                  ),
                  FilterChip(
                    label: Text('No specific'),
                    selected: _selectedGender == 'No specific',
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedGender = selected ? 'No specific' : null;
                      });
                    },
                  ),
                  FilterChip(
                    label: Text('Smoker'),
                    selected: _isSmokerSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _isSmokerSelected = selected;
                        if (selected) {
                          _isNonSmokerSelected = false;
                        }
                      });
                    },
                  ),
                  FilterChip(
                    label: Text('Non-Smoker'),
                    selected: _isNonSmokerSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _isNonSmokerSelected = selected;
                        if (selected) {
                          _isSmokerSelected = false;
                        }
                      });
                    },
                  ),
                  FilterChip(
                    label: Text('Eating/Drinking'),
                    selected: _isEatingSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _isEatingSelected = selected;
                        if (selected) {
                          _isDrinkingSelected = false;
                        }
                      });
                    },
                  ),
                  FilterChip(
                    label: Text('No Eating/Drinking'),
                    selected: _isDrinkingSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _isDrinkingSelected = selected;
                        if (selected) {
                          _isEatingSelected = false;
                        }
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Location',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Enter your location',
                ),
              ),
              if (_direction==true)
                ElevatedButton(
                  child: Text('Set Pick-Up Location'),
                  onPressed: _openMapDialog,
                ),
              SizedBox(height: 16),
              Text(
                'Destination',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextField(
                controller: _destinationController,
                decoration: InputDecoration(
                  hintText: 'Enter your destination',
                ),
              ),
              if (_direction==false)
                ElevatedButton(
                  child: Text('Set Destination'),
                  onPressed: _openMapDialog2,
                ),
              SizedBox(height: 16),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _createPost(accessToken);

                },
                child: Text('Create Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark placemark = placemarks[0];

    setState(() {
      _locationController.text =
      'Latitude: ${position.latitude} Longitude: ${position.longitude}';
      //_destinationController.text = placemark.name! + ', ' + placemark.locality!;
    });
  }



  Future<void> _createPost(accessToken) async {
    //createPost Flutter TEXT FILE



    // Pass the selected data to the database or make further operations
    // Create a map containing the post data
    if (_postType == false) {
      Map<String, dynamic> postData = {

        'title': 'Ride Offer',
        'Subtitle': _direction == false ? 'From MEU' : 'To MEU',
        'passenger_gender': _selectedGender!,
        'DateTime': _selectedDateTime.toString(),
        'smoking':_isSmokerSelected == true ? true : false,
        //'nonSmoker': _isNonSmokerSelected,
        'eating': _isEatingSelected == true ? true : false,
        //'noEatingDrinking': _isDrinkingSelected,
        'pickup_loc_latitude': _locationController.text,
        'pickup_loc_longitude': 'empty',
        'destination_latitude': _destinationController.text,
        'destination_longitude': 'empty',
        'manufacturer': _carCompanyController.text,
        'model': _carModelController.text,
        'plates_number': _platesNumberController.text,
        'color': _carColorController.text,
        'seats': int.parse(_availableSeatsController.text),
      };
      print(postData);

      try {
        // Send the POST request to the backend
        print(accessToken);
        final response = await http.post(
          Uri.parse('http://192.168.1.77:8000/api/PostRideOffer'),
          // Replace with your backend URL

          headers: {'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',},
          body: jsonEncode(postData),

        );

        if (response.statusCode == 200) {
          // Request successful, handle the response if needed
          var responseData = jsonDecode(response.body);
          print('Ride Offer post created successfully');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Post Created'),
                content: Text('$responseData'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
        else {
          // Request failed, handle the error
          var responseData = jsonDecode(response.body);
          print(responseData);
        }
      } catch (e) {
        // Error occurred, handle the exception
        print('An error occurred. Please try again.');
      }
    } else {
      Map<String, dynamic> postData = {

      'title': 'Ride Request',
      'Subtitle': _direction == false ? 'From MEU' : 'To MEU',
      'driver_gender': _selectedGender!,
      'DateTime': _selectedDateTime.toString(),
      'smoking':_isSmokerSelected == true ? true : false,
      //'nonSmoker': _isNonSmokerSelected,
      'eating': _isEatingSelected == true ? true : false,
      //'noEatingDrinking': _isDrinkingSelected,
      'pickup_loc_latitude': _locationController.text,
      'pickup_loc_longitude': 'empty',
      'destination_latitude': _destinationController.text,
      'destination_longitude': 'empty',

    };
    print(postData);

    try {
      // Send the POST request to the backend


      print(accessToken);
      final response = await http.post(
        Uri.parse('http://192.168.1.77:8000/api/PostRideRequest'),
        // Replace with your backend URL

        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
        body: jsonEncode(postData),

      );

      if (response.statusCode == 200) {
        // Request successful, handle the response if needed
        var responseData = jsonDecode(response.body);
        print('Ride Request post created successfully');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Post Created'),
              content: Text('$responseData'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()));
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
        print(responseData);
      }
    } catch (e) {
      // Error occurred, handle the exception
      print('An error occurred. Please try again.');
    }
    }
  }

 }

class _getLocation {
}

class Post {
  final String postType;
  final String direction;
  final String gender;
  final DateTime dateTime;
  final bool smoker;
  final bool nonSmoker;
  final bool eatingDrinking;
  final bool noEatingDrinking;
  final String location;
  final String destination;
  final String carCompany;
  final String carModel;
  final String platesNumber;
  final String carColor;
  final int availableSeats;

  Post({
    required this.postType,
    required this.direction,
    required this.gender,
    required this.dateTime,
    required this.smoker,
    required this.nonSmoker,
    required this.eatingDrinking,
    required this.noEatingDrinking,
    required this.location,
    required this.destination,
    required this.carCompany,
    required this.carModel,
    required this.platesNumber,
    required this.carColor,
    required this.availableSeats,
  });
}

class Board extends StatelessWidget {
  final Post post;

  const Board({required this.post});

  static void addPost(Post post) {
    // Add the post to the database or perform necessary operations
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Post Type: ${post.postType}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Direction: ${post.direction}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Date and Time: ${post.dateTime.toString()}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Location: ${post.location}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Destination: ${post.destination}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () {
                // Show full details of the post
              },
              child: Text('See More'),
            ),
          ],
        ),
      ),
    );
  }
}

// select location
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
      Navigator.pop(context, pickedLocation);
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