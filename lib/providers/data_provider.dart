import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../graph/interface/inode.dart';
import 'package:http/http.dart' as http;

import '../graph/node.dart';
import '../model/edge_data.dart';
import '../model/facility.dart';
import '../model/room.dart';

/// Defines the interface for fetching graph data from the database
class DataProvider extends ChangeNotifier {
  DataProvider();
  final List<INode> nodes = [];
  final List<INode> road = [];
  final List<INode> footpath = [];
  final List<Facility> facilities = [];
  final List<Room> rooms = [];
  final List<EdgeData> edges = [];
  final _directory = "https://jeius.heliohost.us/backend/";

  Future<bool> initialize() async {
    try {
      fetchEdges();
      await fetchNodes();
      await fetchFacilities();
      await fetchRooms();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Fetches the facilities data from the database
  Future<void> fetchFacilities() async {
    final url = "${_directory}getFacilities.php";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;

      Map<String, INode> nodesMap = Map.fromIterable(
        nodes,
        key: (node) => node.getId(),
      );

      facilities.addAll(
        jsonData.map(
          (item) {
            final name = item['name'] as String? ?? '';
            final nodeId = item['node_id'] as String;
            final category = item['category'] as String? ?? 'Others';

            if (nodesMap.containsKey(nodeId)) {
              return Facility(
                  name: name, node: nodesMap[nodeId]!, category: category);
            }

            throw Exception('Cannot find nodeId for facility: $name ');
          },
        ),
      );

      debugPrint('Facilities Loaded : ${facilities.length}');
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    notifyListeners();
  }

  /// Fetches the edges data from the database
  Future<void> fetchEdges() async {
    final String url = "${_directory}getEdges.php";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;

      edges.addAll(
        jsonData.map(
          (item) {
            final nodeA = item['nodeA'] as String;
            final nodeB = item['nodeB'] as String;
            final category = item['category'] as String?;
            return EdgeData(nodeA: nodeA, nodeB: nodeB, category: category);
          },
        ),
      );

      debugPrint('Edges Loaded : ${edges.length}');
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    notifyListeners();
  }

  /// Fetches the nodes data from the database
  Future<void> fetchNodes() async {
    final url = "${_directory}getNodes.php";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;

      nodes.addAll(
        jsonData.map(
          (nodeData) {
            final id = nodeData['id'] as String;
            final x = double.parse(nodeData['x'] as String);
            final y = double.parse(nodeData['y'] as String);

            /// Create Node objects from JSON data
            return Node(id: id, coordinates: LatLng(y, x));
          },
        ),
      );

      debugPrint('Nodes Loaded : ${nodes.length}');
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    notifyListeners();
  }

  /// Fetches the rooms data from the database
  Future<void> fetchRooms() async {
    final url = "${_directory}getRooms.php";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;

      /// Create a map to store facilities by name
      Map<String, Facility> facilityMap = Map.fromIterable(
        facilities,
        key: (facility) => facility.name,
      );

      rooms.addAll(
        jsonData.map(
          (roomData) {
            final name = roomData['room_name'] as String? ?? '';
            final parent = roomData['facility_name'] as String;
            final category = roomData['category'] as String? ?? 'Others';
            final floor = int.parse(roomData['floor'] as String);
            final x = double.parse(roomData['x'] as String);
            final y = double.parse(roomData['y'] as String);

            /// Create a node object for the current room
            final INode roomNode = Node(coordinates: LatLng(y, x));
            nodes.add(roomNode);

            /// Check if the facility with the parent name exists
            if (facilityMap.containsKey(parent)) {
              return Room(
                name: name,
                facility: facilityMap[parent]!,
                node: roomNode,
                floor: floor,
                category: category,
              );
            }
            throw Exception('No facilities found for room: $name ');
          },
        ),
      );

      debugPrint('Rooms Loaded : ${rooms.length}');
      debugPrint('Nodes with rooms loaded : ${nodes.length}\n');
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    notifyListeners();
  }
}
