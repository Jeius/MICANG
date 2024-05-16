import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:micang/utilities/custom_icons.dart';

class LegendWidget extends StatelessWidget {
  const LegendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      width: MediaQuery.of(context).size.width * 0.5,
      elevation: 10,
      child: ListView(
        children: [
          const SizedBox(
            height: 70,
            child: DrawerHeader(
              child: Text(
                'Map Legend:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Column(
            children: generateTiles(),
          ),
        ],
      ),
    ).asGlass(
      clipBorderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    );
  }

  List<ListTile> generateTiles() {
    final tiles = CategoryIcon.icons.entries.map((entry) {
      final name = entry.key[0].toUpperCase() +
          entry.key.substring(1); // Capitalized the first letter
      final icon = entry.value;

      return ListTile(
        leading: icon,
        title: Text(name),
      );
    }).toList();
    return tiles;
  }
}
