import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class desmap2 extends StatefulWidget {
  @override
  State<desmap2> createState() => _desmapState();
}

class _desmapState extends State<desmap2> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  var _locationData;
  String apiKey = 'ใส่api'; // ใส่ API Key ของคุณที่นี่

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    Location location = new Location();
    _locationData = await location.getLocation();

    // Move the camera to the user's current location
    _goToCurrentLocation();

    // Fetch nearby restaurants using Google Places API
    fetchNearbyRestaurants();
  }

  Future<void> fetchNearbyRestaurants() async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${_locationData.latitude},${_locationData.longitude}'
        '&radius=1500'
        '&type=restaurant'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        List results = data['results'];

        setState(() {
          _markers.clear();
          for (var result in results) {
            final marker = Marker(
              markerId: MarkerId(result['place_id']),
              position: LatLng(result['geometry']['location']['lat'],
                  result['geometry']['location']['lng']),
              infoWindow: InfoWindow(
                title: result['name'],
                snippet: result['vicinity'],
                onTap: () {
                  _launchMaps(result['geometry']['location']['lat'],
                      result['geometry']['location']['lng']);
                },
              ),
            );
            _markers.add(marker);
          }
        });
      } else {
        print('Failed to load places: ${data['status']}');
      }
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<void> _goToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(_locationData.latitude!, _locationData.longitude!),
        zoom: 15,
      ),
    ));

    // Add a marker for the current location
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("current_location"),
          position: LatLng(_locationData.latitude!, _locationData.longitude!),
          infoWindow: InfoWindow(title: "คุณอยู่ที่นี่"),
        ),
      );
    });
  }

  void _launchMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        markers: _markers,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
