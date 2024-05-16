import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/expandable_tile.dart';
import '../providers/list_provider.dart';
import '../providers/map_provider.dart';
import '../providers/page_provider.dart';

class ExpandableList extends StatelessWidget {
  const ExpandableList({super.key, required this.tile});

  final ExpandableTile tile;

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    final navProvider = Provider.of<PageProvider>(context, listen: false);

    if (tile.tiles.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).splashColor,
            ),
          ),
        ),
        child: MaterialButton(
          onPressed: () {
            navProvider.setIndex(0);
            listProvider.selectItem(tile.item);
            mapProvider.moveCamera(tile.item.node.getCoordinates(), 19);
          },
          child: ListTile(
            title: Text(tile.title),
          ),
        ),
      );
    } else {
      return expandableTile(context);
    }
  }

  Widget expandableTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        onExpansionChanged: (isExpanded) {},
        key: UniqueKey(),
        title: Text(tile.title),
        children: [
          ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: tile.tiles.length,
            itemBuilder: (_, index) => ExpandableList(
              tile: tile.tiles[index],
            ),
          ),
        ],
      ),
    );
  }
}
