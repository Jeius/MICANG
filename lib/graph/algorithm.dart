import 'package:micang/graph/cost_evaluator.dart';
import 'binary_heap.dart';
import 'interface/icost_evaluator.dart';
import 'interface/iedge.dart';
import 'interface/inode.dart';

class AStarPathAlgorithm {
  double distance = 0.0;
  final ICostEvaluator evaluator = const CostEvaluator();
  final binaryHeap = BinaryHeap<INode>((INode o1, INode o2) {
    /// Compare the sum of cost and heuristic
    double diff =
        (o1.getCost() + o1.getHeuristic()) - (o2.getCost() + o2.getHeuristic());

    /// Return a negative value if o1 should come before o2,
    /// a positive value if o1 should come after o2,
    /// and zero if they are considered equal.
    return diff.compareTo(0); // Use compareTo for comparison
  });

  bool searchPath(INode start, INode end) {
    try {
      return _search(start, end);
    } finally {
      binaryHeap.clear();
    }
  }

  bool _search(INode start, INode end) {
    INode? node = start;
    node.setVisited(true);
    node.setCost(0);
    node.setHeuristic(0);

    binaryHeap.add(node);

    while (binaryHeap.size() > 0) {
      node = binaryHeap.removeTop();
      node?.setOpen(false);
      List<IEdge>? edges = node?.getEdges();
      if (edges != null) {
        for (IEdge edge in edges) {
          INode candidate = edge.getOpposite(node!);
          if (!candidate.isOpen()) {
            continue;
          }
          double cost = evaluator.evaluateCost(candidate, edge);
          if (!candidate.isVisited()) {
            candidate.setVisited(true);
            candidate.setCost(cost);
            candidate.setPredecessor(node);
            binaryHeap.add(candidate);
          } else if (cost < candidate.getCost()) {
            candidate.setCost(cost);
            candidate.setPredecessor(node);
            binaryHeap.remove(candidate);
            binaryHeap.add(candidate);
          }
        }
      }
      if (binaryHeap.contains(end)) {
        distance = end.getCost();
        return true;
      }
    }
    return false;
  }

  List<INode> markPath(INode start, INode end) {
    INode? node = end;
    List<INode> path = [];
    while (node != null && node != start) {
      node.setSelected(true);
      path.add(node);
      node = node.getPredecessor();
    }
    if (node != null) {
      node.setSelected(true);
      path.add(node);
    }
    return path;
  }

}
