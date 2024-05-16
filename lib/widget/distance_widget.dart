import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/graph_provider.dart';

class DistanceWidget extends StatelessWidget {
  const DistanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GraphProvider>(builder: (context, graphProvider, __) {
      if (!graphProvider.isPathFinding()) {
        return Container(
          width: 65,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Center(
              child: Text(
                'Distance',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
                softWrap: false,
              ),
            ),
          ),
        );
      }
      return StreamBuilder<int>(
          stream: graphProvider.distanceStream.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                width: 65,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Center(
                    child: Text(
                      '${snapshot.data}m',
                      softWrap: false,
                    ),
                  ),
                ),
              );
            }
            return Container(
              width: 65,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Center(
                  child: Text(
                    'Distance',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    softWrap: false,
                  ),
                ),
              ),
            );
          });
    });
  }
}
