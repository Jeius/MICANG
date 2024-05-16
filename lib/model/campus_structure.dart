import '../graph/interface/inode.dart';

/// Defines the properties of a campus structure, it mainly contains a name
/// and coordinates of its location.
abstract class CampusStructure {
  /// Name of the campus structure
  final String name;

  /// Node representation of the campus structure
  final INode node;

  /// Refers to a type of facility e.g Park, Building, Office
  final String category;

  const CampusStructure({
    required this.name,
    required this.node,
    required this.category,
  });
}
