import 'dart:io';

void saveRideRequests(List responseData) {
  final file = File('RideRequests.dart');
  final contents = responseData.toString();
  file.writeAsStringSync(contents);
}


void saveRideOffers(List responseData) {
  final file = File('RideOffers.dart');
  final contents = responseData.toString();
  file.writeAsStringSync(contents);
}