import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'location_provider.dart';

class MapProvider extends ChangeNotifier {
  /// State provider for the Map widget
  MapProvider(this.locationProvider);

  /// URL for the raster tile server
  final rasterTileURL =
      'https://jeius.github.io/MSUIIT_raster_tiles/tile/{z}/{x}/{y}.png';

  /// Tile provider to handle the fetching of raster tiles from the URL
  final tileProvider = CancellableNetworkTileProvider();

  /// LatLng bounds to constraint the map camera view
  final LatLngBounds bounds = LatLngBounds(
    const LatLng(8.244424, 124.241822),
    const LatLng(8.239023, 124.245358),
  );

  /// Animated map controller for the map. Map controllers control the state
  /// of the map camera
  late AnimatedMapController controller;

  /// State provider of the location
  final LocationProvider locationProvider;

  /// Current zoom state of the map camera
  double currentZoom = 17;

  /// Callback for position changes in the flutter map.
  void onPositionChanged(bool hasGesture) {
    /// Stop following the location marker on the map if the
    /// user interacts with the map.
    if (hasGesture && locationProvider.alignPosition != AlignOnUpdate.never) {
      if (locationProvider.buttonState) {
        locationProvider.buttonState = false;
      } else {
        locationProvider.unPressButton();
      }
    }
    notifyListeners();
  }

  /// Callback for map events in the flutter map.
  void onMapEvent(MapEvent e) {
    currentZoom = e.camera.zoom;
    notifyListeners();
  }

  /// Move the map camera to the specified LatLng coordinates
  void moveCamera([LatLng? target, double? zoom]) {
    if (target == null) {
      throw Exception('Invalid or could not find the coordinates');
    }
    controller.animateTo(dest: target, zoom: zoom ?? currentZoom);
  }

  void rotateNorth() {
    controller.animatedRotateTo(0.0);
  }
}
