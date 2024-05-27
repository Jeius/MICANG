import 'iedge.dart';
import 'inode.dart';

/// A cost evaluator is responsible for evaluating the weight of a given edge,
/// the cost and the heuristic value of a given node with a necessary context.
abstract class ICostEvaluator {
  /// Evaluates the heuristic value of a node.
  double evaluateHeuristic(INode node, INode end);

  /// Evaluates the cost of a node.
  double evaluateCost(INode candidate, IEdge edge);
}
