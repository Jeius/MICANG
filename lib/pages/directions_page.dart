import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:micang/providers/graph_provider.dart';
import 'package:micang/providers/list_provider.dart';
import 'package:micang/widget/distance_widget.dart';
import 'package:provider/provider.dart';

import '../providers/location_provider.dart';
import '../utilities/error_trapper.dart';
import '../widget/go_button.dart';
import '../widget/item_list.dart';
import '../widget/search_text_field.dart';
import '../widget/side_buttons.dart';

class DirectionsPage extends StatelessWidget {
  const DirectionsPage({super.key});

  Widget searchFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Consumer<ListProvider>(
        builder: (_, listProvider, __) {
          final toKey = listProvider.toKey;
          final fromKey = listProvider.fromKey;

          return Column(
            children: [
              SearchTextField(
                fieldKey: fromKey,
                height: 45,
                iconSize: 18,
                hintText: 'Current Location',
                borderRadius: BorderRadius.circular(5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
              ),
              const SizedBox(height: 10),
              SearchTextField(
                fieldKey: toKey,
                height: 45,
                iconSize: 18,
                hintText: 'Search destination',
                borderRadius: BorderRadius.circular(5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget icons(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    final graphProvider = Provider.of<GraphProvider>(context, listen: false);
    return Column(
      children: [
        IconButton(
          onPressed: (){
            listProvider.clearTextField(listProvider.fromKey);
            if (ErrorTrapper(context: context).showError()) {
              graphProvider.setPathFinding(false);
            }
          },
          icon: const Icon(
            Icons.gps_fixed,
            color: Colors.white,
            size: 20,
          ),
        ),
        const Icon(
          Icons.arrow_downward,
          color: Colors.white,
          size: 17,
        ),
        const IconButton(
          onPressed: null,
          icon: Icon(
            Icons.flag_sharp,
            color: Colors.white,
            size: 23,
          ),
        ),
      ],
    );
  }

  Widget texts() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'From:',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 35,
        ),
        Text(
          'To:',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).resumeStream();
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    listProvider.activeKey = listProvider.toKey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ///AppBar
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    texts(),
                    const SizedBox(width: 5),
                    Expanded(
                      child: searchFields(),
                    ),
                    const SizedBox(width: 5),
                    icons(context),
                    const SizedBox(width: 8),
                    const Column(
                      children: [
                        GoButton(),
                        SizedBox(
                          height: 10,
                        ),
                        DistanceWidget(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).asGlass(),

        const Expanded(
          child: Stack(
            children: [
              /// Side buttons,
              Positioned(
                right: 0,
                top: 10,
                child: SideButtons(),
              ),

              /// Item list
              Positioned(
                top: 8,
                right: 8,
                left: 8,
                child: ItemList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
