import 'package:flutter/material.dart';
import 'package:micang/utilities/list_tile_generator.dart';
import 'package:micang/providers/location_provider.dart';

import '../model/expandable_tile.dart';
import '../model/facility.dart';
import '../model/room.dart';
import '../utilities/text_field_key.dart';
import 'data_provider.dart';

class ListProvider extends ChangeNotifier {
  final DataProvider dataProvider;
  final LocationProvider locationProvider;
  final fromKey = TextFieldKey();
  final toKey = TextFieldKey();
  bool listState = false;
  late TextFieldKey activeKey;

  ListProvider(this.locationProvider, this.dataProvider);

  @override
  void dispose() {
    fromKey.dispose();
    toKey.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  void showList(bool state) {
    if (state) {
      locationProvider.pauseStream();
    } else {
      activeKey.unFocus();
      locationProvider.resumeStream();
    }
    listState = state;
    notifyListeners();
  }

  void setQuery(TextFieldKey key, String? value) {
    key.query = value ?? '';
    notifyListeners();
  }

  void setActiveKey(TextFieldKey key) {
    activeKey = key;
    notifyListeners();
  }

  bool listShowed() {
    return listState;
  }

  void clearTextField(TextFieldKey key) {
    key.clear();
    notifyListeners();
  }

  dynamic selectItem(dynamic item) {
    if (item == null) return null;
    activeKey.setSelected(item);
    showList(false);
    notifyListeners();
    return item;
  }

  List<ExpandableTile> generateTiles() {
    return ListTileGenerator().generateTiles(dataProvider);
  }

  /// Defines the search function
  List<dynamic> search() {
    final searchResults = [];
    final facilities = dataProvider.facilities;
    final rooms = dataProvider.rooms;

    // Search through facilities
    for (Facility facility in facilities) {
      if (facility.name.toLowerCase().contains(
            activeKey.query.toLowerCase(),
          )) {
        searchResults.add(facility);
      }
    }

    // Search through rooms
    for (Room room in rooms) {
      final name = "${room.name} ${room.facility.name}";

      if (name.toLowerCase().contains(
            activeKey.query.toLowerCase(),
          )) {
        searchResults.add(room);
      }
    }

    return searchResults;
  }
}
