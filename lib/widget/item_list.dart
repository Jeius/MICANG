import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';

import '../providers/list_provider.dart';
import '../utilities/text_field_key.dart';
import 'invalid_dialog.dart';
import 'item.dart';

class ItemList extends StatelessWidget {
  /// Renders the list of the search results
  const ItemList({
    super.key,
    this.height,
    this.width,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Consumer<ListProvider>(
      builder: (_, listProvider, __) {
        return TapRegion(
            onTapOutside: (_) {
              listProvider.activeKey.focusNode.unfocus();
              listProvider.showList(false);
              onTapOutside(listProvider, listProvider.activeKey);
            },
            onTapInside: (_) => listProvider.activeKey.focusNode.requestFocus(),
            child: listView(listProvider));
      },
    );
  }

  void onTapOutside(ListProvider listProvider, TextFieldKey key) {
    if (key.query.isEmpty) listProvider.clearTextField(key);
  }

  /// List view of the results
  Widget listView(ListProvider listProvider) {
    List<dynamic> results = listProvider.search();
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        listProvider.showList(false);
      },
      child: Builder(builder: (context) {
        final size = MediaQuery.of(context).size;
        return AnimatedContainer(
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 300),
          height: (listProvider.listShowed()) ? height ?? size.height * 0.5 : 0,
          width: width ?? size.width,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Stack(
            children: [
              InvalidDialog(
                enabled: results.isEmpty,
                constraints: size,
              ),
              AnimatedOpacity(
                opacity: results.isEmpty ? 0 : 1,
                curve: Curves.fastOutSlowIn,
                duration: const Duration(milliseconds: 500),
                child: listViewBuilder(results),
              ),
            ],
          ),
        ).asGlass(
          clipBorderRadius: BorderRadius.circular(15),
        );
      }),
    );
  }

  Widget listViewBuilder(List<dynamic> results) => ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) => Item(item: results[index]),
      ).asGlass(
        clipBorderRadius: BorderRadius.circular(15),
      );
}
