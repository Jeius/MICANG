import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';

import '../providers/graph_provider.dart';

class SideButtons extends StatelessWidget {
  const SideButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final containerColor = Theme.of(context).colorScheme.primaryContainer;
    final selectedColor = Theme.of(context).colorScheme.primary;

    return Consumer<GraphProvider>(
      builder: (_, graph, __) => Column(
        children: [
          /// Walking button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: graph.isWalking ? selectedColor : containerColor,
              width: 40,
              height: 40,
              child: FloatingActionButton(
                elevation: 0,
                mini: true,
                backgroundColor: Colors.transparent,
                onPressed: () => graph.setWalking(true),
                child: const Icon(
                  Icons.directions_walk,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ).asGlass(
              clipBorderRadius: BorderRadius.circular(20),
            ),
          ),

          /// Driving button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: !graph.isWalking ? selectedColor : containerColor,
              width: 40,
              height: 40,
              child: FloatingActionButton(
                elevation: 0,
                mini: true,
                onPressed: () => graph.setWalking(false),
                backgroundColor: Colors.transparent,
                child: const Icon(
                  Icons.drive_eta,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ).asGlass(
              clipBorderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}
