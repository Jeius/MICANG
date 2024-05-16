import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:micang/graph/algorithm.dart';
import 'package:micang/providers/data_provider.dart';
import 'package:micang/utilities/math_utils.dart';
import '../graph/edge.dart';
import '../graph/graph_builder.dart';
import '../graph/interface/inode.dart';
import '../graph/node.dart';

class GraphProvider extends ChangeNotifier {
  final AStarPathAlgorithm algorithm = AStarPathAlgorithm();
  final DataProvider dataProvider;
  final distanceStream = StreamController<int>.broadcast()..sink.add(0);

  bool enabled = false;
  bool isWalking = true;
  final List<Polyline> pathResult = [];

  GraphProvider(this.dataProvider);

  bool isPathFinding() {
    return enabled;
  }

  void setPathResult(List<Polyline> result) {
    pathResult.clear();
    pathResult.addAll(result);
  }

  void setWalking(bool value) {
    isWalking = value;
    notifyListeners();
  }

  void setPathFinding(bool state) {
    enabled = state;
    notifyListeners();
  }

  void setDistance() {
    final distance = algorithm.distance.round();
    distanceStream.sink.add(distance);
    debugPrint('Distance: $distance');
  }

  void buildGraph(INode endNode) {
    GraphBuilder.buildGraph(isWalking, dataProvider, endNode);
  }

  Future<List<Polyline>> findPath(Position? position, {
    required INode? start,
    required INode? end,
  }) async {
    if (!isPathFinding()) return [];
    if (end == null) return [];
    buildGraph(end);
    start ??= getStartNode(position, end);

    if (start == null) return [];

    if (algorithm.searchPath(start, end)) {
      final path = algorithm.markPath(start, end);
      return drawPath(start, path);
    }
    // throw Exception('No path found');
    return [];
  }

  /// This function iteratively expands the search range until it finds at
  /// least one node within the range. Then, it creates edges from the start
  /// node to each detected node and returns the start node with these edges.
  INode? getStartNode(Position? position, INode endNode) {
    double range = 20;
    final detectedNodes = <INode>[];
    if (position == null) return null;
    final start = LatLng(position.latitude, position.longitude);

    Map<INode, double> nodeMap = {};

    // Populate nodeMap
    for (final node in List.from(dataProvider.nodes)) {
      final distance = MathUtils().getDistance(start, node.getCoordinates());
      nodeMap[node] = distance;
    }

    do {
      // If found, add corresponding values to detectedNodes
      detectedNodes.addAll(
        nodeMap.keys
            .where((key) => (nodeMap[key] ?? double.maxFinite) <= range),
      );
      if (detectedNodes.isEmpty) {
        range += 20;
      }
      if (range >= 10000) {
        break;
      }
    } while (detectedNodes.isEmpty);

    if (detectedNodes.isEmpty) return null;
    debugPrint('Nodes detected: ${detectedNodes.length}');

    final startNode = Node(coordinates: start);
    final edges = detectedNodes
        .map(
          (node) => Edge(
            nodeA: startNode,
            nodeB: node,
            weight: MathUtils().getDistance(
              start,
              node.getCoordinates(),
            ),
          ),
        )
        .toList();
    startNode.addEdges(edges);
    return startNode;
  }

  List<Polyline> drawPath(INode start, List<INode> path) {
    final pathLineCoord = path
        .where((node) => node.getCategory() != null)
        .map((node) => node.getCoordinates())
        .toList();
    pathLineCoord.add(start.getCoordinates());

    final dottedLineCoord = [pathLineCoord[0], path[0].getCoordinates()];

    Polyline pathLine = Polyline(
      points: pathLineCoord,
      color: const Color(0xFF0F56B3),
      borderStrokeWidth: 4,
      borderColor: const Color(0xFF4EC0F9),
      strokeWidth: 10,
    );

    Polyline indoorLine = Polyline(
      points: dottedLineCoord,
      color: const Color(0xFF0F56B3),
      borderColor: const Color(0xFF4EC0F9),
      strokeWidth: 10,
      borderStrokeWidth: 2,
      isDotted: true,
    );

    return [pathLine, indoorLine];
  }

  @override
  void dispose() {
    distanceStream.sink.close();
    super.dispose();
  }
}
