import '../model/edge_data.dart';
import '../model/room.dart';
import '../providers/data_provider.dart';
import '../utilities/math_utils.dart';
import 'cost_evaluator.dart';
import 'edge.dart';
import 'interface/iedge.dart';
import 'interface/inode.dart';

class GraphBuilder {
  static void buildGraph(
    bool isWalking,
    DataProvider dataProvider,
    INode endNode,
  ) {
    Map<String, INode> nodeMap = Map.fromIterable(
      dataProvider.nodes,
      key: (node) {
        node.reset();
        return node.getId();
      },
    );

    for (Room room in dataProvider.rooms) {
      room.node.reset();
      final edge = Edge(
        nodeA: room.node,
        nodeB: room.facility.node,
        weight: MathUtils().getDistance(
          room.node.getCoordinates(),
          room.facility.node.getCoordinates(),
        ),
      );
      room.facility.node.addEdge(edge);
      room.node.addEdge(edge);
    }

    List<EdgeData> edges = dataProvider.edges;

    /// Don't include footpath edges if the user is walking
    if (!isWalking) {
      edges = dataProvider.edges
          .where((edge) => edge.category != 'Footpath')
          .toList();
    }

    /// Assign edges to nodes based on their IDs
    for (final edge in edges) {
      if (!nodeMap.containsKey(edge.nodeA) ||
          !nodeMap.containsKey(edge.nodeB)) {
        continue;
      }

      final nodeA = nodeMap[edge.nodeA]!;
      final nodeB = nodeMap[edge.nodeB]!;
      final IEdge routeEdge = Edge(
        nodeA: nodeA,
        nodeB: nodeB,
        weight: MathUtils().getDistance(
          nodeA.getCoordinates(),
          nodeB.getCoordinates(),
        ),
      );

      nodeA.addEdge(routeEdge);
      nodeB.addEdge(routeEdge);

      if (edge.category == null) continue;
      nodeA.setCategory(edge.category);
      nodeA.setHeuristic(
          const CostEvaluator().evaluateHeuristic(nodeA, endNode));
      nodeB.setCategory(edge.category);
      nodeB.setHeuristic(
          const CostEvaluator().evaluateHeuristic(nodeB, endNode));
    }
  }
}
