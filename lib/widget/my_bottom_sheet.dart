import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:micang/utilities/custom_icons.dart';
import 'package:micang/providers/page_provider.dart';
import 'package:micang/providers/graph_provider.dart';
import 'package:provider/provider.dart';

import '../model/room.dart';
import '../utilities/error_trapper.dart';
import '../providers/list_provider.dart';

class MyBottomSheet {
  Size size = const Size(0, 0);
  String name = '';
  String address = '';
  dynamic selectedItem;

  Widget border() {
    return Positioned(
      bottom: 3,
      child: Container(
        width: size.width,
        height: size.height * 0.35,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF204E),
              Color(0xFFA0153E),
              Color(0xFF5D0E41),
              Color(0xFF00224D),
            ],
            begin: Alignment.topRight,
            end: Alignment.topLeft,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
      ),
    );
  }

  Widget background() {
    return Positioned(
      bottom: 0,
      child: Container(
        width: size.width,
        height: size.height * 0.35,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            const Color(0xFF171818).withOpacity(0.6),
            const Color(0xFF2e2f2f).withOpacity(0.6),
            const Color(0xFF454646).withOpacity(0.6),
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
        ),
      ).asGlass(
        clipBorderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
    );
  }

  Widget directionsButton(BuildContext context) {
    final graphProvider = Provider.of<GraphProvider>(context, listen: false);
    final navProvider = Provider.of<PageProvider>(context, listen: false);
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    return Positioned(
      top: 0,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 250, minWidth: 150),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.3),
              offset: const Offset(1, 5),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width * 0.35,
        child: MaterialButton(
          onPressed: () {
            listProvider.toKey.setSelected(selectedItem);
            if (ErrorTrapper(context: context).showError()) return;
            graphProvider.setPathFinding(true);
            navProvider.setIndex(1);
            Navigator.pop(context);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          color: Colors.transparent,
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CustomIcons.directions,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Get Direction',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nameWidget() {
    return Positioned(
      top: size.height * 0.16,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.2,
        child: Text(
          name,
          softWrap: true,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget addressWidget() {
    return Positioned(
      top: size.height * 0.27,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.2,
        child: Text(
          address,
          softWrap: true,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 17,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  SizedBox empty() {
    return const SizedBox();
  }

  bool setUp() {
    if (selectedItem == null) return false;
    name = selectedItem.name;
    if (selectedItem is Room) {
      address = 'Floor ${selectedItem.floor}, ${selectedItem.facility.name}';
    }
    return true;
  }

  Future show(BuildContext context, dynamic selectedItem) {
    this.selectedItem = selectedItem;
    size = MediaQuery.of(context).size;

    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      elevation: 0,
      context: context,
      builder: (_) {
        return !setUp()
            ? empty()
            : SizedBox(
                width: size.width,
                height: size.height * 0.4,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Border
                    border(),

                    // Main bg
                    background(),

                    // Directions button
                    directionsButton(context),

                    // Name
                    nameWidget(),

                    // Address
                    addressWidget(),
                  ],
                ),
              );
      },
    );
  }
}
