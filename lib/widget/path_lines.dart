import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../providers/graph_provider.dart';
import '../providers/list_provider.dart';
import '../providers/location_provider.dart';

class PathLines extends StatelessWidget {
  const PathLines({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (_, locationProvider, __) {
        return Consumer<ListProvider>(
          builder: (_, listProvider, __) {
            return Consumer<GraphProvider>(
              builder: (_, graphProvider, __) {
                final end = listProvider.toKey.getSelectedNode();
                final start = listProvider.fromKey.getSelectedNode();
                final position = locationProvider.currentPosition;

                return FutureBuilder(
                  future: graphProvider.findPath(
                    position,
                    start: start,
                    end: end,
                  ),
                  builder: (_, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        if (snapshot.hasData) {
                          graphProvider.setDistance();
                          return PolylineLayer(polylines: snapshot.data!);
                        } else {
                          return Center(
                                child: LoadingAnimationWidget.threeArchedCircle(
                                    color: Colors.white, size: 30),
                              );
                        }
                      case ConnectionState.done:
                      default:
                        if (snapshot.hasData) {
                          graphProvider.setDistance();
                          return PolylineLayer(polylines: snapshot.data!);
                        } else {
                          return Center(
                                child: LoadingAnimationWidget.threeArchedCircle(
                                    color: Colors.white, size: 30),
                              );
                        }
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
