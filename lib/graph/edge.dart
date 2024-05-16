import 'interface/iedge.dart';
import 'interface/inode.dart';
import 'node.dart';

class Edge implements IEdge {
  INode nodeA;
  INode nodeB;
  double weight;

  Edge({
    required this.nodeA,
    required this.nodeB,
    required this.weight,
  });

  @override
  INode getNodeA() {
    return nodeA;
  }

  @override
  INode getNodeB() {
    return nodeB;
  }

  @override
  INode getOpposite(INode node) {
    if (node == nodeA) {
      return nodeB;
    } else {
      return nodeA;
    }
  }

  @override
  double getWeight() {
    return weight;
  }

  /// Set the weight of the edge.
  void setWeight(double weight) {
    this.weight = weight;
  }

  /// Set node A.
  void setNodeA(Node nodeA) {
    this.nodeA = nodeA;
  }

  /// Set node B.
  void setNodeB(Node nodeB) {
    this.nodeB = nodeB;
  }
}
