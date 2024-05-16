import 'package:latlong2/latlong.dart';
import 'interface/iedge.dart';
import 'interface/inode.dart';

class Node implements INode {
  final List<IEdge> edges = [];
  final String id;
  final LatLng coordinates;

  bool open = true;
  bool visited = false;
  bool selected = false;
  INode? predecessor;
  double cost = 0;
  double heuristic = double.infinity;
  String? category;

  Node({
    this.id = '',
    required this.coordinates,
  });

  /// Resets to the original values.
  @override
  void reset() {
    predecessor = null;
    cost = 0;
    open = true;
    visited = false;
    selected = false;
    edges.clear();
    heuristic = double.infinity;
    category = null;
  }

  @override
  bool isOpen() {
    return open;
  }

  @override
  void setOpen(bool open) {
    this.open = open;
  }

  @override
  bool isVisited() {
    return visited;
  }

  @override
  void setVisited(bool visited) {
    this.visited = visited;
  }

  @override
  bool isSelected() {
    return selected;
  }

  @override
  void setSelected(bool selected) {
    this.selected = selected;
  }

  @override
  void addEdge(IEdge edge) {
    edges.add(edge);
  }

  @override
  void addEdges(List<IEdge> edges) {
    this.edges.addAll(edges);
  }

  @override
  bool removeEdge(IEdge edge) {
    edges.remove(edge);
    return true;
  }

  @override
  List<IEdge>? getEdges() {
    return edges;
  }

  @override
  INode? getPredecessor() {
    return predecessor;
  }

  @override
  void setPredecessor(INode? node) {
    predecessor = node;
  }

  @override
  double getCost() {
    return cost;
  }

  @override
  void setCost(double cost) {
    this.cost = cost;
  }

  @override
  double getHeuristic() {
    return heuristic;
  }

  @override
  void setHeuristic(double heuristic) {
    this.heuristic = heuristic;
  }

  @override
  String toString() {
    return '$heuristic$cost($cost,$heuristic)';
  }

  @override
  String? getId() {
    return id;
  }

  @override
  LatLng getCoordinates() {
    return coordinates;
  }

  @override
  void setCategory(String? category) {
    this.category = category;
  }

  @override
  String? getCategory() {
    return category;
  }


}
