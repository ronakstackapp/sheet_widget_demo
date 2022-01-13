// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:sheet_widget_demo/utils/color.dart';
//
// class CreateTripPage extends StatefulWidget {
//   const CreateTripPage({Key key}) : super(key: key);
//
//   @override
//   _CreateTripPageState createState() => _CreateTripPageState();
// }
//
// class _CreateTripPageState extends State<CreateTripPage> {
//   Set<Marker> markers = Set();
//   Position _currentPosition;
//   String _currentAddress;
//   GoogleMapController mapController;
//   Set<Polyline> _polylines = Set<Polyline>();
//   List<LatLng> polylineCoordinates = [];
//   PolylinePoints polylinePoints;
//   String _placeDistance;
//   String yourLocation;
//   String chooseLocation;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Create trip"),
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             InkWell(
//               onTap: () async {},
//               child: Container(
//                 height: 40,
//                 width: 300,
//                 decoration: BoxDecoration(
//                     border: Border.all(color: grey),
//                     borderRadius: BorderRadius.circular(5),
//                     color: white),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text((yourLocation == "" || yourLocation == null)
//                           ? "Your Location"
//                           : yourLocation)),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             InkWell(
//               onTap: () async {},
//               child: Container(
//                 height: 40,
//                 width: 300,
//                 decoration: BoxDecoration(
//                     border: Border.all(color: grey),
//                     borderRadius: BorderRadius.circular(5),
//                     color: white),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                           (chooseLocation == "" || chooseLocation == null)
//                               ? "Choose destination"
//                               : chooseLocation)),
//                 ),
//               ),
//             ),
//             MaterialButton(
//                 onPressed: () {
//                   _calculateDistance();
//                   setState(() {});
//                 },
//                 color: themeColor,
//                 child: Text("route"))
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<bool> _calculateDistance() async {
//     try {
//       // Retrieving placemarks from addresses
//       List<Location> startPlacemark = await locationFromAddress(yourLocation);
//       List<Location> destinationPlacemark =
//           await locationFromAddress(chooseLocation);
//
//       // Use the retrieved coordinates of the current position,
//       // instead of the address if the start position is user's
//       // current position, as it results in better accuracy.
//       double startLatitude = yourLocation == _currentAddress
//           ? _currentPosition.latitude
//           : startPlacemark[0].latitude;
//
//       double startLongitude = yourLocation == _currentAddress
//           ? _currentPosition.longitude
//           : startPlacemark[0].longitude;
//
//       double destinationLatitude = destinationPlacemark[0].latitude;
//       double destinationLongitude = destinationPlacemark[0].longitude;
//
//       String startCoordinatesString = '($startLatitude, $startLongitude)';
//       String destinationCoordinatesString =
//           '($destinationLatitude, $destinationLongitude)';
//
//       // Start Location Marker
//       Marker startMarker = Marker(
//         markerId: MarkerId(startCoordinatesString),
//         position: LatLng(startLatitude, startLongitude),
//         infoWindow: InfoWindow(
//           title: 'Start $startCoordinatesString',
//           snippet: yourLocation,
//         ),
//         icon: BitmapDescriptor.defaultMarker,
//       );
//
//       // Destination Location Marker
//       Marker destinationMarker = Marker(
//         markerId: MarkerId(destinationCoordinatesString),
//         position: LatLng(destinationLatitude, destinationLongitude),
//         infoWindow: InfoWindow(
//           title: 'Destination $destinationCoordinatesString',
//           snippet: chooseLocation,
//         ),
//         icon: BitmapDescriptor.defaultMarker,
//       );
//
//       // Adding the markers to the list
//       markers.add(startMarker);
//       markers.add(destinationMarker);
//
//       print(
//         'START COORDINATES: ($startLatitude, $startLongitude)',
//       );
//       print(
//         'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
//       );
//
//       // Calculating to check that the position relative
//       // to the frame, and pan & zoom the camera accordingly.
//       double miny = (startLatitude <= destinationLatitude)
//           ? startLatitude
//           : destinationLatitude;
//       double minx = (startLongitude <= destinationLongitude)
//           ? startLongitude
//           : destinationLongitude;
//       double maxy = (startLatitude <= destinationLatitude)
//           ? destinationLatitude
//           : startLatitude;
//       double maxx = (startLongitude <= destinationLongitude)
//           ? destinationLongitude
//           : startLongitude;
//
//       double southWestLatitude = miny;
//       double southWestLongitude = minx;
//
//       double northEastLatitude = maxy;
//       double northEastLongitude = maxx;
//
//       // Accommodate the two locations within the
//       // camera view of the map
//       mapController.animateCamera(
//         CameraUpdate.newLatLngBounds(
//           LatLngBounds(
//             northeast: LatLng(northEastLatitude, northEastLongitude),
//             southwest: LatLng(southWestLatitude, southWestLongitude),
//           ),
//           100.0,
//         ),
//       );
//
//       await setPolylines(startLatitude, startLongitude, destinationLatitude,
//           destinationLongitude);
//
//       double totalDistance = 0.0;
//
//       // Calculating the total distance by adding the distance
//       // between small segments
//       for (int i = 0; i < polylineCoordinates.length - 1; i++) {
//         totalDistance += _coordinateDistance(
//           polylineCoordinates[i].latitude,
//           polylineCoordinates[i].longitude,
//           polylineCoordinates[i + 1].latitude,
//           polylineCoordinates[i + 1].longitude,
//         );
//       }
//
//       setState(() {
//         _placeDistance = totalDistance.toStringAsFixed(2);
//         print('DISTANCE: $_placeDistance km');
//       });
//
//       return true;
//     } catch (e) {
//       print(e);
//     }
//     return false;
//   }
//
//   setPolylines(startLat, startLon, desLat, desLon) async {
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         "AIzaSyB_kIX5UrOzY9KC14LVNRAIsZCkx3xBXeA",
//         PointLatLng(startLat, startLon),
//         PointLatLng(desLat, desLon));
//     print("result-->" + result.status);
//     if (result.status == 'OK') {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//
//       setState(() {
//         _polylines.add(Polyline(
//             width: 10,
//             polylineId: PolylineId('polyLine'),
//             color: darkBlue,
//             points: polylineCoordinates));
//       });
//     }
//   }
//
//   double _coordinateDistance(lat1, lon1, lat2, lon2) {
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((lat2 - lat1) * p) / 2 +
//         c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
//     return 12742 * asin(sqrt(a));
//   }
// }
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyB_kIX5UrOzY9KC14LVNRAIsZCkx3xBXeA";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class demo extends StatefulWidget {
  @override
  demoState createState() => new demoState();
}

class demoState extends State<demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () async {
                // show input autocomplete with selected mode
                // then get the Prediction selected
                Prediction p = await PlacesAutocomplete.show(
                    context: context, apiKey: kGoogleApiKey);
                displayPrediction(p);
              },
              child: Text('Find address'),
            )));
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print(lat);
      print(lng);
    }
  }
}
