import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sheet_widget_demo/geoLocation/googleMap/googleMap.dart';
import 'package:sheet_widget_demo/utils/color.dart';

class LocationHomePage extends StatefulWidget {
  @override
  _LocationHomePageState createState() => _LocationHomePageState();
}

class _LocationHomePageState extends State<LocationHomePage> {
  Position _currentPosition;
  String _currentAddress;

  @override
  Widget build(BuildContext context) {
    EasyLoading.dismiss();
    print("currant page -->$runtimeType");
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentAddress != null) Text(_currentAddress),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(themeColor)),
              child: Text(
                "Get location",
                style: TextStyle(color: black),
              ),
              onPressed: () {
                _getCurrentLocation();
              },
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(themeColor)),
              child: Text(
                "Google Map *",
                style: TextStyle(color: black),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoogleMapPage(
                          // latitude: _currentPosition.latitude,
                          // location: _currentAddress,
                          // longitude: _currentPosition.longitude,
                          ),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    print("_getCurrentLocation -->1");

    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,)
        .then((Position position) {
      print("_getCurrentLocation -position->$position");
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
        print(_currentPosition);
        print("_getCurrentLocation -->$_currentPosition");
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      print("_getAddressFromLatLng -->1");
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
}
