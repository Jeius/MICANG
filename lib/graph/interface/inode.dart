import 'package:latlong2/latlong.dart';
import 'iedge.dart';

/// Defines a graph node. In graph theory, a graph contains nodes and edges, the nodes
/// are connected to each other through edges.
abstract class INode {
  /// Returns the edges through which this node is connected to other nodes.
  List<IEdge>? getEdges();

  /// Adds an edge to the node
  void addEdge(IEdge edge);

  void addEdges(List<IEdge> edges);

  /// Removes an edge from the node
  bool removeEdge(IEdge edge);

  /// Returns the predecessor of the node.
  INode? getPredecessor();

  /// Sets the predecessor of the node. In the graph path search, an algorithm finds the nodes
  /// to form possibly the best path (the best is relative, depending on how the algorithm
  /// evaluates the cost) between the origin and destination. The search goes node by node
  /// from the origin to the destination, for every two consecutive nodes, the leading node
  /// is the predecessor of the trailing node.
  void setPredecessor(INode? node);

  void reset();

  void setCategory(String? category);

  String? getCategory();

  /// Returns `true` if the node is open, `false` otherwise.
  bool isOpen();

  /// Makes the node open or closed. When set to closed, it will no longer be considered
  /// as a candidate in the graph path search.
  void setOpen(bool open);

  /// Returns `true` if this node has been visited during the graph path search.
  bool isVisited();

  /// Indicates whether or not the node has been visited during the graph path search.
  void setVisited(bool visited);

  /// Returns `true` if the node has been selected to be part of the resulted path, `false` otherwise.
  bool isSelected();

  /// Indicates whether or not the node has been selected to be part of the resulted path.
  void setSelected(bool selected);

  /// Returns the heuristic value of the node.
  double getHeuristic();

  /// Sets the heuristic value evaluated as the cost from the node to the destination.
  void setHeuristic(double heuristic);

  /// Returns the cost of node.
  double getCost();

  /// Sets the cost evaluated from the origin to the node.
  void setCost(double cost);

  /// Returns the latitude and longitude of the node
  LatLng getCoordinates();

  /// Returns the id of the node
  String? getId();
}
