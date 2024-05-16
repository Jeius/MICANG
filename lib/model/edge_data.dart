class EdgeData {
  final String nodeA;
  final String nodeB;
  final String? category;

  const EdgeData({
    required this.nodeA,
    required this.nodeB,
    this.category,
  });
}
