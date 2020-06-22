import 'dart:async';
import 'package:drop_bites/components/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/components/circle_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';

class LocationView extends StatefulWidget {
  static const String id = 'location_view';
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  final Function toggler;

  LocationView({this.toggler});

  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  bool loading = false;
  double loadingOpacity = 1;
  Completer<GoogleMapController> _controller = Completer();
  final Map<String, Marker> _markers = {};
  String address;

  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(3.7105, 101.9758),
    zoom: 7.5,
  );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: LocationView.scaffoldKey,
      backgroundColor: kGrey6,
      body: AbsorbPointer(
        absorbing: loading,
        child: Opacity(
          opacity: loadingOpacity,
          child: Stack(
            children: <Widget>[
              // Bottom Checkout buttons
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    if (_markers.length != 0) {
                      widget.toggler();
                      Navigator.pop(context, address);
                    } else {
                      CustomSnackbar.showSnackbar(
                        text: 'No location detected',
                        scaffoldKey: LocationView.scaffoldKey,
                        iconData: Icons.location_disabled,
                      );
                    }
                  },
                  child: Container(
                    width: width,
                    height: height / 8.5,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Confirm ',
                                  style: kCardTitleTextStyle.copyWith(
                                      color: kGrey1, letterSpacing: .5),
                                ),
                                TextSpan(
                                  text: 'Location',
                                  style: kCardTitleTextStyle.copyWith(
                                      color: kGrey0,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: .5),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: kGrey6,
                            height: 30,
                          ),
                        ),
                        Center(
                          child: Icon(
                            Icons.add_location,
                            color: _markers.length != 0 ? kOrange3 : kGrey4,
                            size: 45,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // Middle UI (Map)
              Positioned(
                // Google Maps
                child: Container(
                  height: height / 1.125,
                  width: width,
                  child: Stack(
                    children: <Widget>[
                      // Map
                      GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _initialPosition,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        markers: _markers.values.toSet(),
                        buildingsEnabled: true,
                        zoomControlsEnabled: false,
                        rotateGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                      ),
                      // TODO: Search bar / abanddon?
                      // Positioned(
                      //   width: width,
                      //   child: Container(
                      //     margin: EdgeInsets.all(16),
                      //     decoration: BoxDecoration(
                      //       boxShadow: [
                      //         kButtonShadow,
                      //       ],
                      //     ),
                      //     child: Center(
                      //       child: TextField(
                      //         decoration: InputDecoration(
                      //             filled: true,
                      //             fillColor: Colors.white,
                      //             hintText: 'Search',
                      //             border: InputBorder.none),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Current location button
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: FloatingActionButton.extended(
                          backgroundColor: Colors.white,
                          onPressed: () {
                            _getCurrentLocation();
                            LocationView.scaffoldKey.currentState
                                .hideCurrentSnackBar();
                          },
                          label: Text(
                            'Find Me',
                            style: kDefaultTextStyle.copyWith(color: kGrey6),
                          ),
                          icon: Icon(
                            Icons.my_location,
                            color: kOrange4,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Back button
              Positioned(
                top: 40,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CircleButton(
                    color: kOrange4,
                    child: Icon(Icons.arrow_back_ios),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              (loading) ? kSpinKitLoader : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void _getCurrentLocation() async {
    // Get location
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    final CameraPosition _currPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        bearing: 0,
        tilt: 0,
        zoom: 17.5);

    // Get nearest address
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
      new Coordinates(currentLocation.latitude, currentLocation.longitude),
    );

    // Set marker & address
    setState(() {
      address = addresses.first.addressLine;

      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;
    });

    // Pan camera
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currPosition));
  }
}
