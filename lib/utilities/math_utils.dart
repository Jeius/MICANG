import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Utility class for math calculations
class MathUtils {
  final double _earthRadius = 6371; // Earth's radius in kilometers

  /// Calculates the distance between two coordinates
  double getDistance(LatLng pointA, LatLng pointB) {
    double xDiff = degreesToRadians(pointB.longitude - pointA.longitude);
    double yDiff = degreesToRadians(pointB.latitude - pointA.latitude);

    double a = sin(yDiff / 2) * sin(yDiff / 2) +
        cos(degreesToRadians(pointA.latitude)) *
            cos(degreesToRadians(pointB.latitude)) *
            sin(xDiff / 2) *
            sin(xDiff / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return _earthRadius * c * 1000; //Distance in meters
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  ///Function to calculate the direction or heading based from the distance traveled
  List<dynamic> calculateHeading(Position position, Position? lastPosition) {
    double heading = 0.0;

    if (lastPosition != null) {
      double x = position.latitude - lastPosition.latitude;
      double y = position.longitude - lastPosition.longitude;
      heading = (atan2(y, x) + pi * 2) % (pi * 2);
    }
    lastPosition = position;
    return [heading, lastPosition];
  }
}
