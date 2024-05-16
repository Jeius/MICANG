import 'package:micang/model/campus_structure.dart';

import 'facility.dart';

/// A room that is located in a facility
class Room extends CampusStructure{
  /// Floor in the facility where the room is located
  final int floor;
  /// Facility where the room is located
  final Facility facility;

  const Room({
    required this.floor,
    required this.facility,
    required super.name,
    required super.node,
    required super.category,
  });
}
