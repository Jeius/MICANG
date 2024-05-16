import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';

import '../providers/graph_provider.dart';
import '../providers/list_provider.dart';
import '../providers/map_provider.dart';
import '../utilities/error_trapper.dart';
import '../utilities/text_field_key.dart';

class SearchTextField extends StatelessWidget {
  /// TextField of the SearchWidget.
  const SearchTextField({
    super.key,
    this.borderRadius,
    this.iconSize = 24,
    this.hintText = '',
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 15,
    ),
    this.height = 50,
    required this.fieldKey,
  });

  /// Specify the radius of border. Defaults to BorderRadius.circular(20).
  final BorderRadius? borderRadius;

  /// Specify the hint text when the field is empty.
  final String hintText;

  /// Set the size of the suffix icon. Defaults to 24
  final double iconSize;

  /// Specify the padding of text inside.
  final EdgeInsets contentPadding;

  final double height;

  final TextFieldKey fieldKey;

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    return AnimatedContainer(
      // Search Bar
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 300),
      color: Theme.of(context).colorScheme.primaryContainer,
      height: height,
      child: TextField(
        onTap: () => onTap(listProvider),
        onChanged: (value) => onChanged(listProvider, context, value),
        decoration: searchBarDecor(context),
        focusNode: fieldKey.focusNode,
        controller: fieldKey.textController,
        cursorColor: Colors.white,
      ),
    ).asGlass(
      clipBorderRadius: borderRadius ?? BorderRadius.circular(20),
    );
  }

  /// Decoration of the search bar
  InputDecoration searchBarDecor(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    return InputDecoration(
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        borderRadius: borderRadius ?? BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: borderRadius ?? BorderRadius.circular(20),
      ),
      contentPadding: contentPadding,
      suffixIcon: Consumer<MapProvider>(
        builder: (_, map, __) {
          return Consumer<GraphProvider>(builder: (_, graph, __) {
            return IconButton(
              onPressed: () {
                listProvider.setActiveKey(fieldKey);
                listProvider.clearTextField(fieldKey);
                if (ErrorTrapper(context: context).showError()) {
                  graph.setPathFinding(false);
                }
              },
              icon: (fieldKey.query.isEmpty)
                  ? const Icon(Icons.search_rounded, color: Colors.white)
                  : const Icon(Icons.clear_rounded, color: Colors.white),
              iconSize: iconSize,
            );
          });
        },
      ),
    );
  }

  void onChanged(
      ListProvider listProvider, BuildContext context, String value) {
    if (!fieldKey.focusNode.hasFocus && value.isEmpty) {
      listProvider.clearTextField(fieldKey);
      ErrorTrapper(context: context).showError();
    }
    listProvider.setActiveKey(fieldKey);
    listProvider.setQuery(fieldKey, value);
    listProvider.showList(true);
  }

  void onTap(ListProvider listProvider) {
    listProvider.setActiveKey(fieldKey);
    listProvider.showList(true);
  }
}
