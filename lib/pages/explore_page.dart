import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:micang/providers/list_provider.dart';
import 'package:micang/providers/location_provider.dart';
import 'package:provider/provider.dart';

import '../widget/item_list.dart';
import '../widget/map_search_bar.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).resumeStream();

    return Consumer<ListProvider>(builder: (context, listProvider, __) {
      listProvider.activeKey = listProvider.toKey;
      final size = MediaQuery.of(context).size;
      return Stack(
        children: [
          Container(
            /// Glass Background
            height: listProvider.listShowed() ? size.height : 0,
            width: size.width,
            color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
          ).asGlass(),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                width: size.width,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MapSearchBar(
                      hintText: 'Search for places',
                    ),
                    SizedBox(height: 5),
                    ItemList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
