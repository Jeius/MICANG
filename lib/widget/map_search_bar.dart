import 'package:flutter/material.dart';
import 'package:micang/widget/search_text_field.dart';
import 'package:provider/provider.dart';

import '../providers/list_provider.dart';
import 'map_back_button.dart';

class MapSearchBar extends StatelessWidget {
  /// Search bar for searching campus facilities
  const MapSearchBar({
    super.key,
    required this.hintText,
  });

  /// Specify the hint text when the field is empty.
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MapBackButton(),
          const SizedBox(width: 5),
          Expanded(
            child: Consumer<ListProvider>(
              builder: (_, listProvider, __) {
                final key = listProvider.toKey;
                return SearchTextField(
                  fieldKey: key,
                  hintText: 'Search for places',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
