import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../utilities/math_utils.dart';

class LocationProvider extends ChangeNotifier {
  AlignOnUpdate alignPosition = AlignOnUpdate.never;
  bool buttonState = false;
  bool serviceEnabled = false;
  Position? lastPosition;
  Position? currentPosition;

  late StreamSubscription<Position> positionStreamSub;

  final StreamController<double?> followLocationStream =
      StreamController<double?>.broadcast();

  final StreamController<Position> positionStream =
      StreamController<Position>.broadcast();

  final StreamController<LocationMarkerHeading> headingStream =
      StreamController<LocationMarkerHeading>()
        ..add(
          LocationMarkerHeading(
            heading: 0,
            accuracy: pi * 0.2,
          ),
        );

  final LocationSettings locationSettings = const LocationSettings(
    distanceFilter: 0,
  );

  void pressButton(double? currentZoom) {
    if (isButtonPressed()) {
      unPressButton();
    } else {
      // Follow the location marker on the map when location
      // updated until user interact with the map.
      alignPosition = AlignOnUpdate.always;
      buttonState = true;

      // Follow the location marker on the map.
      followLocationStream.sink.add(currentZoom);
      notifyListeners();
    }
  }

  void unPressButton() {
    buttonState = false;
    alignPosition = AlignOnUpdate.never;
    notifyListeners();
  }

  bool isButtonPressed() {
    return (alignPosition == AlignOnUpdate.always) ? true : false;
  }

  void pauseStream() {
    positionStreamSub.pause();
  }

  void resumeStream() {
    positionStreamSub.resume();
  }

  @override
  void dispose() {
    positionStream.sink.close();
    headingStream.sink.close();
    followLocationStream.sink.close();
    positionStreamSub.cancel();
    super.dispose();
  }

  Future<bool> checkService() async {
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //Shows a prompt to enable the location service
      throw Exception(
          'Location services are disabled. Enable to locate your position.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception(
            'Location permissions are denied. Cannot use location services.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, cannot request permissions.');
    }
    return serviceEnabled;
  }

  void startService() async {
    List<dynamic> result = [];
    double heading = 0.0;

    checkService();

    positionStreamSub =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position != null) {
        positionStream.sink.add(position);

        result = MathUtils().calculateHeading(position, lastPosition);
        heading = result[0];
        lastPosition = result[1];

        headingStream.sink.add(LocationMarkerHeading(
          heading: heading,
          accuracy: round(pi * 0.15, decimals: 2),
        ));

        currentPosition = position;
        notifyListeners();
      }
    });
  }
}
