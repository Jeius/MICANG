import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';

import '../providers/list_provider.dart';

class MapBackButton extends StatelessWidget {
  /// Back button
  const MapBackButton({
    super.key,
    this.borderRadius,
  });

  /// Specify the radius of border. Defaults to BorderRadius.circular(20).
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Consumer<ListProvider>(builder: (_, listProvider, __) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: Theme.of(context).colorScheme.primary,
        curve: Curves.easeInOut,
        width: listProvider.listShowed() ? 45 : 0,
        child: PopScope(
          canPop: false,
          onPopInvoked: (_) => listProvider.showList(false),
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: Colors.transparent,
            heroTag: 'Back Button',
            onPressed: () => listProvider.showList(false),
            child: const Icon(
              Icons.arrow_left,
              color: Colors.white,
            ),
          ),
        ),
      ).asGlass(
        clipBorderRadius: borderRadius ?? BorderRadius.circular(15),
      );
    });
  }
}
