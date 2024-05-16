import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/graph_provider.dart';
import '../utilities/error_trapper.dart';

class GoButton extends StatelessWidget {
  const GoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GraphProvider>(
      builder: (context, graphProvider, __) {
        final state = graphProvider.isPathFinding();

        return PopScope(
          canPop: false,
          onPopInvoked: (_) {
            if (state) return graphProvider.setPathFinding(false);
          },
          child: FloatingActionButton(
            onPressed: () {
              if (state) {
                graphProvider.setPathFinding(false);
                return;
              }
              if (ErrorTrapper(context: context).showError()) return;
              graphProvider.setPathFinding(true);
            },
            backgroundColor: (state)
                ? Theme.of(context).colorScheme.secondaryContainer
                : Theme.of(context).colorScheme.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (!state)
                    ? const Icon(
                        Icons.directions,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                const SizedBox(
                  width: 5,
                ),
                text(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget text(bool value) {
    if (!value) {
      return const Text(
        'GO',
        style: TextStyle(
          fontWeight: FontWeight.w100,
        ),
      );
    } else {
      return const Text(
        'Cancel',
        style: TextStyle(fontWeight: FontWeight.w100, fontSize: 10),
      );
    }
  }
}
