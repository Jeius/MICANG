import 'package:micang/providers/data_provider.dart';
import '../graph/binary_heap.dart';
import '../model/expandable_tile.dart';

class ListTileGenerator {
  List<String> getCategories(dynamic items) {
    Set<String> categories = {};

    for (final item in items) {
      if (item.category != null) {
        categories.add(item.category);
      }
    }

    final listCategories = categories.toList();
    listCategories.sort();

    return listCategories;
  }

  List<ExpandableTile> generateTiles(DataProvider dataProvider) {
    final categoryTiles = <ExpandableTile>[];
    final rooms = dataProvider.rooms;
    final facilities = dataProvider.facilities;
    final categoriesOfFacilities = getCategories(facilities);
    final categoriesOfRooms = getCategories(rooms);

    for (final facilityCategory in categoriesOfFacilities) {
      final categoryFacilities = facilities
          .where((facility) => facility.category == facilityCategory)
          .toList();

      if (categoryFacilities.isNotEmpty) {
        final facilityTiles = BinaryHeap<ExpandableTile>(
          (ExpandableTile o1, ExpandableTile o2) {
            return o2.tiles.length.compareTo(o1.tiles.length);
          },
        );

        for (final facility in categoryFacilities) {
          final roomCategoryTiles = BinaryHeap<ExpandableTile>(
            (ExpandableTile o1, ExpandableTile o2) {
              return o2.tiles.length.compareTo(o1.tiles.length);
            },
          );

          bool containsValue = rooms.any((room) => room.facility == facility);
          if (!containsValue) {
            facilityTiles.add(
              ExpandableTile(
                title: facility.name,
                item: facility,
              ),
            );
            continue;
          }

          for (final roomCategory in categoriesOfRooms) {
            final facilityRooms = rooms
                .where((room) =>
                    room.facility == facility && room.category == roomCategory)
                .map((room) => ExpandableTile(title: room.name, item: room))
                .toList();

            if (facilityRooms.isNotEmpty) {
              roomCategoryTiles.add(
                  ExpandableTile(title: roomCategory, tiles: facilityRooms));
            }
          }

          if (roomCategoryTiles.array.isNotEmpty) {
            facilityTiles.add(
              ExpandableTile(
                title: facility.name,
                item: facility,
                tiles: roomCategoryTiles.array
                    .whereType<ExpandableTile>()
                    .toList(),
              ),
            );
          }
        }

        if (facilityTiles.array.isNotEmpty) {
          categoryTiles.add(
            ExpandableTile(
              title: facilityCategory,
              tiles: facilityTiles.array.whereType<ExpandableTile>().toList(),
            ),
          );
        }
      }
    }
    return categoryTiles;
  }
}
