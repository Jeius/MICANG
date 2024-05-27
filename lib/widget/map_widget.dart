import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:micang/widget/path_lines.dart';
import 'package:provider/provider.dart';

import '../providers/page_provider.dart';
import '../providers/map_provider.dart';
import 'map_markers.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  late final _animatedMapController = AnimatedMapController(
    vsync: this,
    curve: Curves.easeInOut,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(builder: (_, mapProvider, __) {
      mapProvider.controller = _animatedMapController;
      return mapLayer(mapProvider);
    });
  }

  @override
  void dispose() {
    _animatedMapController.dispose();
    super.dispose();
  }

  Widget mapLayer(MapProvider mapProvider) {
    return FlutterMap(
      mapController: _animatedMapController.mapController,
      options: MapOptions(
        initialCenter: const LatLng(8.24195, 124.24390),
        cameraConstraint: CameraConstraint.containCenter(
          bounds: mapProvider.bounds,
        ),
        initialZoom: 17,
        maxZoom: 22,
        minZoom: 13, 
        backgroundColor: Colors.transparent,
        onPositionChanged: (_, hasGesture) =>
            mapProvider.onPositionChanged(hasGesture),
        onMapEvent: (mapEvent) => mapProvider.onMapEvent(mapEvent),
      ),
      children: [
        const RasterTile(),
        const MarkerWidget(),
        Consumer<PageProvider>(builder: (_, page, __) {
          return (page.index == 1)
              ? const PathLines()
              : const SizedBox.shrink();
        }),
        const CurrentLocationMarker(),
        const SelectionMarker(),
      ],
    );
  }
}

class RasterTile extends StatelessWidget {
  const RasterTile({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    return TileLayer(
      tileProvider: NetworkTileProvider(),
      urlTemplate: mapProvider.rasterTileURL,
      maxNativeZoom: 22,
      minNativeZoom: 13, 
      tileBounds: mapProvider.bounds,
    );
  }
}
