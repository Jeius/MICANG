import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../utilities/custom_icons.dart';
import '../providers/data_provider.dart';
import '../providers/graph_provider.dart';
import '../providers/list_provider.dart';
import '../providers/location_provider.dart';
import '../providers/map_provider.dart';
import 'my_bottom_sheet.dart';

class CurrentLocationMarker extends StatelessWidget {
  const CurrentLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return currentLocationLayer();
  }

  Widget currentLocationLayer() {
    return Consumer<LocationProvider>(builder: (_, locationProvider, __) {
      return CurrentLocationLayer(
        positionStream: const LocationMarkerDataStreamFactory()
            .fromGeolocatorPositionStream(
          stream: locationProvider.positionStream.stream,
        ),
        headingStream: locationProvider.headingStream.stream,
        alignPositionOnUpdate: locationProvider.alignPosition,
        alignPositionAnimationDuration: const Duration(seconds: 1),
        alignPositionAnimationCurve: Curves.easeInOut,
        alignPositionStream: locationProvider.followLocationStream.stream,
        alignDirectionAnimationDuration: const Duration(milliseconds: 500),
        moveAnimationCurve: Curves.easeInOut,
        moveAnimationDuration: const Duration(milliseconds: 500),
        style: const LocationMarkerStyle(
          marker: DefaultLocationMarker(
            color: Color.fromARGB(255, 205, 11, 11),
          ),
          showAccuracyCircle: false,
          headingSectorColor: Color.fromARGB(200, 205, 11, 11),
          headingSectorRadius: 40,
        ),
      );
    });
  }
}

class SelectionMarker extends StatelessWidget {
  const SelectionMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GraphProvider>(builder: (_, graphProvider, __) {
      return selectionMarker(graphProvider);
    });
  }

  Widget selectionMarker(GraphProvider graph) {
    return Consumer<ListProvider>(
      builder: (context, listProvider, __) {
        var selectedItem = listProvider.activeKey.selectedItem;
        Color color = Theme.of(context).colorScheme.surface;

        if (graph.isPathFinding()) {
          selectedItem = listProvider.toKey.selectedItem;
        }

        return (selectedItem != null)
            ? AnimatedMarkerLayer(
                markers: [
                  AnimatedMarker(
                    curve: Curves.bounceIn,
                    point: selectedItem.node.getCoordinates(),
                    builder: (context, animation) {
                      final size = 35 * animation.value;
                      return Transform.translate(
                        offset: Offset(0, -size / 2),
                        child: FloatingActionButton(
                          elevation: 2,
                          backgroundColor: Colors.white70,
                          onPressed: () =>
                              MyBottomSheet().show(context, selectedItem),
                          child: Icon(
                            CustomIcons.location,
                            size: size,
                            color: color,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class MarkerWidget extends StatelessWidget {
  const MarkerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, __) {
      return MarkerLayer(
        markers: markers(context, dataProvider),
      );
    });
  }

  Marker marker(BuildContext context, dynamic item) {
    final coordinates = item.node.getCoordinates() as LatLng;
    final categoryName = item.category.toLowerCase() as String;
    return Marker(
      point: coordinates,
      child: Consumer<MapProvider>(
        builder: (_, mapProvider, __) {
          return Visibility(
            visible: filter(item, mapProvider.currentZoom),
            child: FloatingActionButton(
              heroTag: '${item.name} marker',
              onPressed: () {
                MyBottomSheet().show(context, item);
                mapProvider.moveCamera(coordinates);
              },
              elevation: 3,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: CategoryIcon.icons[categoryName] ??
                  const Icon(
                    CustomIcons.location,
                    size: 18 * 0.8,
                    color: Colors.blueAccent,
                  ),
            ),
          );
        },
      ),
    );
  }

  bool filter(dynamic item, double currentZoom) {
    if (currentZoom >= 15.5) {
      if ((item.category).toLowerCase() == 'college') {
        return true;
      }
    }
    if (currentZoom >= 17.2) {
      switch (item.category.toLowerCase()) {
        case 'building':
          return true;
        case 'park':
          return true;
        case 'library':
          return true;
        default:
          break;
      }
    }
    if (currentZoom >= 18.3) {
      return true;
    }
    return false;
  }

  List<Marker> markers(BuildContext context, DataProvider dataProvider) {
    List<Marker> markers = [];

    markers.addAll(
      dataProvider.facilities.map((facility) {
        return marker(context, facility);
      }),
    );

    markers.addAll(
      dataProvider.rooms
          .where(
            (room) {
              switch (room.category.toLowerCase()) {
                case 'food':
                  return true;
                case 'clinic':
                  return true;
                case 'college':
                  return true;
                case 'library':
                  return true;
                default:
                  return false;
              }
            },
          )
          .map((room) => marker(context, room)),
    );
    debugPrint('Markers with rooms: ${markers.length}');
    return markers;
  }
}
