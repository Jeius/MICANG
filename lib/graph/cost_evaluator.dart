import 'package:micang/utilities/math_utils.dart';
import 'interface/icost_evaluator.dart';
import 'interface/iedge.dart';
import 'interface/inode.dart';

class CostEvaluator implements ICostEvaluator {
  const CostEvaluator();

  @override
  double evaluateCost(INode candidate, IEdge edge) {
    return edge.getOpposite(candidate).getCost() + edge.getWeight();
  }

  @override
  double evaluateHeuristic(INode node, INode end) {
    return MathUtils().getDistance(node.getCoordinates(), end.getCoordinates());
  }
}
