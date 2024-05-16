import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';

import '../model/facility.dart';
import '../model/room.dart';
import '../providers/list_provider.dart';
import '../providers/map_provider.dart';

class Item extends StatelessWidget {
  /// Individual item in the list view
  const Item({
    super.key,
    required this.item,
    this.showAddress = true,
    this.showIcon = false,
    this.icon,
  });

  final dynamic item;
  final bool showAddress;
  final bool showIcon;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    String name = '';
    String? address;
    if (item is Facility) {
      name = item.name;
    } else if (item is Room) {
      name = item.name;
      address = 'Floor ${item.floor}, ${item.facility.name}';
    }
    return itemBuilder(name, address);
  }

  Widget itemBuilder(String name, String? address) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Consumer<ListProvider>(builder: (context, listProvider, __) {
        final mapProvider = Provider.of<MapProvider>(context, listen: false);
        return Container(
          constraints: const BoxConstraints(
            minHeight: 45,
            maxHeight: 200,
          ),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: MaterialButton(
            color: Colors.transparent,
            onPressed: () {
              listProvider.selectItem(item);
              mapProvider.moveCamera(item.node.getCoordinates(), 19);
            },
            child: content(name, address),
          ),
        ).asGlass(
          clipBorderRadius: BorderRadius.circular(8),
        );
      }),
    );
  }

  Widget content(String name, String? address) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              name,
              softWrap: true,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Visibility(
            visible: (address ?? '').isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 10,
              ),
              child: Text(
                address ?? '',
                softWrap: true,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
}
