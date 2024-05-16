import 'inode.dart';

/// Defines a graph edge. In graph theory, a graph contains nodes and edges, an edge connects
/// two nodes.
abstract class IEdge {
  /// Returns node A.
  INode getNodeA();

  /// Returns node B.
  INode getNodeB();

  /// Given either node A or B, returns the other node of the two.
  INode getOpposite(INode node);

  /// Returns the weight of the edge.
  double getWeight();
}
