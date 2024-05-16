import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:micang/providers/location_provider.dart';
import 'package:provider/provider.dart';

import '../providers/list_provider.dart';
import '../widget/expandable_list.dart';

class PlacesPage extends StatelessWidget {
  const PlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).pauseStream();
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    final tiles = listProvider.generateTiles();
    listProvider.activeKey = listProvider.toKey;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 68,
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [const PlacesAppBar()];
          },
          body: ListView.builder(
            itemCount: tiles.length,
            itemBuilder: (_, index) => ExpandableList(
              tile: tiles[index],
            ),
          ),
        ),
      ).asGlass(blurY: 20, blurX: 20),
    );
  }
}

class PlacesAppBar extends StatelessWidget {
  const PlacesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 30,
      forceElevated: true,
      shadowColor: Colors.black,
      floating: true,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      expandedHeight: MediaQuery.of(context).size.height * 0.2,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        background: Opacity(
          opacity: 0.6,
          child: Image.asset(
            'images/entrance.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
