import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:last_chance/RequestPage.dart';
import 'OfferPage.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'dart:async';


class PlateNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;

    int selectionIndex = newValue.selection.end;
    final StringBuffer newText = StringBuffer();

    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, 2) + '-');
      if (newValue.selection.end >= 2) selectionIndex++;
    }

    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(2, newTextLength));
      if (newValue.selection.end >= 3) selectionIndex++;
    }

    // Dump the rest.
    if (newTextLength > 8) {
      newText.write(newValue.text.substring(8, newTextLength));
      if (newValue.selection.end >= 8) selectionIndex++;
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}


class NewRidePage extends StatefulWidget {
  @override
  _NewRidePageState createState() => _NewRidePageState();


}

class _NewRidePageState extends State<NewRidePage> {
  bool _isSmokerSelected = false;
  bool _isNonSmokerSelected = false;
  bool _isEatingSelected = false;
  bool _isDrinkingSelected = false;
  String OfferGender = 'Prefered Passenger Gender';
  String RequestGender = 'Prefered Driver Gender';
  TextEditingController _lat = TextEditingController();
  TextEditingController _long = TextEditingController();
  double MeuLat=31.80924111250302;
  double MeuLong=35.91942630708218;
  String? typeOfRide;
  String? selectYourDestination;
  String? genderType;
  String? smokerDriver;
  String? smokerPassenger;
  String? carType;
  String? carModel;
  String? plateNumber;
  String? carColor;
  String? eatingAllowed;
  String? canEat;
  TextEditingController _locationController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  LatLng? selectedLocation;
  GoogleMapController? mapController;


  List<String> yessNoOptions = ['Yes', 'No'];
  List<String> genders = ['Male', 'Female', 'No specific'];
  List<String> yesNoOptions = ['Yes', 'No'];
  List<String> carColors = [
    'Black',
    'White',
    'Blue',
    'Red',
    'Gray',
    'Navy',
    'Brown',
    'Green',
    'Yellow'
  ];

  bool isPreferencesVisible = false;
  bool isRulesVisible = false;


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
        _lat.text='${result.latitude}';
        _long.text='${result.longitude}';

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
        print('Lat: ${result.latitude} , Lon: ${result.longitude}');
        //selectedLocation = result;
        _lat.text='${result.latitude}';
        _long.text='${result.longitude}';
      });
    }
  }




  bool isFormComplete() {
    if (typeOfRide == 'request' &&
        selectYourDestination != null &&
        genderType != null &&
        _isSmokerSelected != null && _isEatingSelected != null) {
      return true;
    } else if (typeOfRide == 'offer' &&
        selectYourDestination != null &&
        genderType != null &&
        _isSmokerSelected != null &&
        carType != null &&
        carModel != null &&
        plateNumber != null &&
        carColor != null && _isEatingSelected != null) {
      return true;
    } else {
      return false;
    }
  }

  void resetForm() {
    setState(() {
      typeOfRide = null;
      selectYourDestination = null;
      genderType = null;
      // smokerDriver = null;
      // smokerPassenger = null;
      carType = null;
      carModel = null;
      plateNumber = null;
      carColor = null;
      _isSmokerSelected = false;
      _isEatingSelected = false;
    });
  }




  @override
  Widget build(BuildContext context) {
    String accessToken = Provider
        .of<UserProvider>(context)
        .token;
    return Scaffold(
      appBar: AppBar(
        title: Text('New Ride'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Type Of Ride',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: [
                  FilterChip(
                    label: Text('Request'),
                    selected: typeOfRide == 'request',
                    onSelected: (selected) {
                      setState(() {
                        typeOfRide = selected ? 'request' : null;
                        isPreferencesVisible = selected;
                        isRulesVisible = !selected;
                      });
                    },
                  ),
                  FilterChip(
                    label: Text('Offer'),
                    selected: typeOfRide == 'offer',
                    onSelected: (selected) {
                      setState(() {
                        typeOfRide = selected ? 'offer' : null;
                        isPreferencesVisible = !selected;
                        isRulesVisible = selected;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),
              if (typeOfRide == 'request')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Your Destination',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      children: [
                        FilterChip(
                          label: Text('To MEU'),
                          selected: selectYourDestination == 'toMeu',
                          onSelected: (selected) {
                            setState(() {
                              selectYourDestination = selected ? 'toMeu' : null;
                              _locationController.text = '';
                              _destinationController.text =
                              'Middle East University';
                            });
                          },
                        ),
                        FilterChip(
                          label: Text('From MEU'),
                          selected: selectYourDestination == 'fromMeu',
                          onSelected: (selected) {
                            setState(() {
                              selectYourDestination =
                              selected ? 'fromMeu' : null;
                              _locationController.text =
                              'Middle East University';
                              _destinationController.text = '';
                            });
                          },
                        ),
                      ],
                    )
                    ,
                    if (selectYourDestination != null && isPreferencesVisible)
                      SizedBox(height: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preferences:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${RequestGender}:',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 8.0,
                              children: genders.map((String gender) {
                                return FilterChip(
                                  label: Text(gender),
                                  selected: genderType == gender,
                                  onSelected: (selected) {
                                    setState(() {
                                      genderType = selected ? gender : null;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        SizedBox(height: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Smoking Allowed ?',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 8.0,
                              children: [
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
                              ],
                              // children: yesNoOptions.map((String option) {
                              //   return FilterChip(
                              //     label: Text(option),
                              //     selected: smokerDriver == option,
                              //     onSelected: (selected) {
                              //       setState(() {
                              //         smokerDriver = selected ? option : null;
                              //       });
                              //     },
                              //   );
                              // }).toList(),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Is Eating Allowed?',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 8.0,
                              children: [
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
                              // children: yesNoOptions.map((String option) {
                              //   return FilterChip(
                              //     label: Text(option),
                              //     selected: canEat == option,
                              //     onSelected: (selected) {
                              //       setState(() {
                              //         canEat = selected ? option : null;
                              //       });
                              //     },
                              //   );
                              // }).toList(),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Text(
                              'Location',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            TextField(
                              controller: _locationController,
                              decoration: InputDecoration(
                                hintText: 'Enter your location',
                              ),
                            ),
                            if(selectYourDestination == 'toMeu')
                              ElevatedButton(
                                child: Text('Set Pick-Up Location'),
                                onPressed: _openMapDialog,
                              ),
                            SizedBox(height: 16),
                            Text(
                              'Destination',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            TextField(
                              controller: _destinationController,
                              decoration: InputDecoration(
                                hintText: 'Enter your destination',
                              ),
                            ),
                            if(selectYourDestination == 'fromMeu')
                              ElevatedButton(
                                child: Text('Set Destination'),
                                onPressed: _openMapDialog2,
                              ),


                          ],
                        ),

                      ],
                    ),
                  ],
                ),
              if (typeOfRide == 'offer')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Destination',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      children: [
                        FilterChip(
                          label: Text('To MEU'),
                          selected: selectYourDestination == 'toMeu',
                          onSelected: (selected) {
                            setState(() {
                              selectYourDestination = selected ? 'toMeu' : null;
                              _locationController.text = '';
                              _destinationController.text =
                              'Middle East University';
                            });
                          },
                        ),
                        FilterChip(
                          label: Text('From MEU'),
                          selected: selectYourDestination == 'fromMeu',
                          onSelected: (selected) {
                            setState(() {
                              selectYourDestination =
                              selected ? 'fromMeu' : null;
                              _locationController.text =
                              'Middle East University';
                              _destinationController.text = '';
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    if (selectYourDestination != null && isRulesVisible)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rules:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${OfferGender}:',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                spacing: 8.0,
                                children: genders.map((String gender) {
                                  return FilterChip(
                                    label: Text(gender),
                                    selected: genderType == gender,
                                    onSelected: (selected) {
                                      setState(() {
                                        genderType = selected ? gender : null;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          SizedBox(height: 15,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Smoking Allowed?',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                spacing: 8.0,
                                children: [
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
                                ],
                                // children: yesNoOptions.map((String option) {
                                //   return FilterChip(
                                //     label: Text(option),
                                //     selected: smokerPassenger == option,
                                //     onSelected: (selected) {
                                //       setState(() {
                                //         smokerPassenger =
                                //         selected ? option : null;
                                //       });
                                //     },
                                //   );
                                // }).toList(),
                              ),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Is Eating Allowed?',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                spacing: 8.0,
                                children: [
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
                                // children: yesNoOptions.map((String option) {
                                //   return FilterChip(
                                //     label: Text(option),
                                //     selected: eatingAllowed == option,
                                //     onSelected: (selected) {
                                //       setState(() {
                                //         eatingAllowed =
                                //         selected ? option : null;
                                //       });
                                //     },
                                //   );
                                // }).toList(),
                              ),
                            ],
                          ),
                          SizedBox(height: 15,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Car Details:',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                value: carType,
                                items: [
                                  'Toyota',
                                  'Maserati',
                                  'Volkswagen',
                                  'Peugeot',
                                  'Cadillac',
                                  'Land Rover',
                                  'Chrysler',
                                  'Ford',
                                  'Hyundai',
                                  'Audi',
                                  'Volvo',
                                  'Honda',
                                  'Nissan',
                                  'Daewoo',
                                  'Jeep',
                                  'Hummer',
                                  'Bentley',
                                  'Mazda',
                                  'Ferrari',
                                  'BMW',
                                  'Lexus',
                                  'Chevrolet',
                                  'Chery',
                                  'Citroën',
                                  'Datsun',
                                  'Dodge',
                                  'Fiat',
                                  'Geely',
                                  'Infiniti',
                                  'Isuzu',
                                  'Kia',
                                  'Lada',
                                  'Lincoln',
                                  'Mitsubishi',
                                  'Opel',
                                ].map((String car) {
                                  return DropdownMenuItem<String>(
                                    value: car,
                                    child: Text(car),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    carType = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Car Type',
                                  hintText: 'Select Car Type',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 15,),

                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    carModel = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Car Model',
                                  hintText: 'Enter Your Car Model e.g., Kia Sephia',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 15,),
                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    plateNumber = value;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(8),
                                  PlateNumberInputFormatter(),
                                  // Custom input formatter
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Plate Number',
                                  hintText: 'Type Your Plate Number e.g., 12-345678',
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              SizedBox(height: 15),
                              DropdownButtonFormField<String>(
                                value: carColor,
                                items: carColors.map((String color) {
                                  return DropdownMenuItem<String>(
                                    value: color,
                                    child: Text(color),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    carColor = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Car Color',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16),
                              Text(
                                'Location',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              TextField(
                                controller: _locationController,
                                decoration: InputDecoration(
                                  hintText: 'Enter your location',
                                ),
                              ),
                              if(selectYourDestination == 'toMeu')
                                ElevatedButton(
                                  child: Text('Set Pick-Up Location'),
                                  onPressed: _openMapDialog,
                                ),
                              SizedBox(height: 16),
                              Text(
                                'Destination',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              TextField(
                                controller: _destinationController,
                                decoration: InputDecoration(
                                  hintText: 'Enter your destination',
                                ),
                              ),
                              if(selectYourDestination == 'fromMeu')
                                ElevatedButton(
                                  child: Text('Set Destination'),
                                  onPressed: _openMapDialog2,
                                ),


                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: isFormComplete()
                        ? () {
                      if (typeOfRide == 'request') {
                        if (selectYourDestination=='toMEU'){
                          _createRequestToMeu(accessToken);
                        }else{
                          _createRequestFromMeu(accessToken);
                        }


                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => RequestPage(
                        //     destination: selectYourDestination,
                        //     genderType: genderType,
                        //     smokerDriver: smokerDriver,
                        //     canEat:canEat,
                        //   )),
                        // );
                      } else if (typeOfRide == 'offer') {
                        if (selectYourDestination=='toMEU'){
                          _createOfferToMeu(accessToken);
                        }else {
                          _createOfferFromMeu(accessToken);
                        }

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) =>
                        //       OfferPage(
                        //         destination: selectYourDestination,
                        //         genderType: genderType,
                        //         smokerPassenger: smokerPassenger,
                        //         carType: carType,
                        //         carModel: carModel,
                        //         plateNumber: plateNumber,
                        //         carColor: carColor,
                        //         eatingAllowed: eatingAllowed,
                        //       )),
                        // );
                      }
                      // Save button logic here
                    } : null,
                    child: Text('Search for Match'),
                  ),
                  ElevatedButton(
                    onPressed: resetForm,
                    child: Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _getCurrentLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  //   List<Placemark> placemarks = await placemarkFromCoordinates(
  //     position.latitude,
  //     position.longitude,
  //   );
  //   Placemark placemark = placemarks[0];
  //
  //   setState(() {
  //     _locationController.text =
  //     'Latitude: ${position.latitude} Longitude: ${position.longitude}';
  //     //_destinationController.text = placemark.name! + ', ' + placemark.locality!;
  //   });
  // }

  Future<void> _createRequestToMeu(accessToken) async {

    // Create a map containing the post data

    Map<String, dynamic> requestData = {


      'driver_gender': genderType!,

      'smoking': _isSmokerSelected == true ? true : false,
      //'nonSmoker': _isNonSmokerSelected,
      'eating': _isEatingSelected == true ? true : false,
      //'noEatingDrinking': _isDrinkingSelected,
      'pickup_loc_latitude': double.parse(_lat.text),
      'pickup_loc_longitude': double.parse(_long.text),
      'destination_latitude':  MeuLat,
      'destination_longitude': MeuLong,

    };
    print(requestData);

    try {
      // Send the POST request to the backend
      print(accessToken);
      final response = await http.post(
        Uri.parse('http://192.168.1.77:8000/api/RideRequest'),


        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
        body: jsonEncode(requestData),

      );

      if (response.statusCode == 200) {
        // Request successful, do something if needed
        var responseData = jsonDecode(response.body);
        print(responseData);
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
  }

  Future<void> _createRequestFromMeu(accessToken) async {

    // Create a map containing the post data

    Map<String, dynamic> requestData = {


      'driver_gender': genderType!,

      'smoking': _isSmokerSelected == true ? true : false,
      //'nonSmoker': _isNonSmokerSelected,
      'eating': _isEatingSelected == true ? true : false,
      //'noEatingDrinking': _isDrinkingSelected,
      'pickup_loc_latitude': MeuLat,//double.parse(_lat.text),
      'pickup_loc_longitude': MeuLong,//double.parse(_long.text),
      'destination_latitude': double.parse(_lat.text), //MeuLat,
      'destination_longitude': double.parse(_long.text),//MeuLong,

    };
    print(requestData);

    try {
      // Send the POST request to the backend
      print(accessToken);
      final response = await http.post(
        Uri.parse('http://192.168.1.77:8000/api/RideRequest'),


        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
        body: jsonEncode(requestData),

      );

      if (response.statusCode == 200) {
        // Request successful, do something if needed
        var responseData = jsonDecode(response.body);
        print(responseData);
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
  }


  Future<void> _createOfferToMeu(accessToken) async {

    // Create a map containing the post data

    Map<String, dynamic> offerData = {


      'passenger_gender': genderType!,

      'smoking': _isSmokerSelected == true ? true : false,

      'eating': _isEatingSelected == true ? true : false,

      'pickup_loc_latitude': double.parse(_lat.text),
      'pickup_loc_longitude': double.parse(_long.text),
      'destination_latitude': MeuLat,
      'destination_longitude': MeuLong,
      'manufacturer': carType,
      'model': carModel,
      'plates_number': plateNumber,
      'color': carColor,

    };
    print(offerData);

    try {
      // Send the POST request to the backend
      print(accessToken);
      final response = await http.post(
        Uri.parse('http://192.168.1.77:8000/api/RideOffer'),


        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
        body: jsonEncode(offerData),

      );

      if (response.statusCode == 200) {
        // Request successful, do something if needed
        var responseData = jsonDecode(response.body);
        print(responseData);
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
  }


  Future<void> _createOfferFromMeu(accessToken) async {

    // Create a map containing the post data

    Map<String, dynamic> offerData = {


      'passenger_gender': genderType!,

      'smoking': _isSmokerSelected == true ? true : false,

      'eating': _isEatingSelected == true ? true : false,
      'pickup_loc_latitude': MeuLat,//double.parse(_lat.text),
      'pickup_loc_longitude': MeuLong,//double.parse(_long.text),
      'destination_latitude': double.parse(_lat.text), //MeuLat,
      'destination_longitude': double.parse(_long.text),//MeuLong,
      'manufacturer': carType,
      'model': carModel,
      'plates_number': plateNumber,
      'color': carColor,
    };
    print(offerData);

    try {
      // Send the POST request to the backend
      print(accessToken);
      final response = await http.post(
        Uri.parse('http://192.168.1.77:8000/api/RideOffer'),


        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
        body: jsonEncode(offerData),

      );

      if (response.statusCode == 200) {
        // Request successful, do something if needed
        var responseData = jsonDecode(response.body);
        print(responseData);
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
  }
}








void main() {
  runApp(MaterialApp(
    home: NewRidePage(),
  ));
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

  // Future<void> _getCurrentLocation() async {
  //   final position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  //   setState(() {
  //     currentLocation = LatLng(position.latitude, position.longitude);
  //   });
  //   if (mapController != null) {
  //     mapController!.animateCamera(
  //       CameraUpdate.newLatLng(currentLocation!),
  //     );
  //   }
  // }

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