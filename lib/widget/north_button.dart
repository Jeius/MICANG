import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:micang/providers/map_provider.dart';
import 'package:provider/provider.dart';

class NorthButton extends StatelessWidget {
  const NorthButton({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      height: 40,
      width: 40,
      child: FloatingActionButton(
        mini: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () => mapProvider.rotateNorth(),
        child: const Stack(
          children: [
            Positioned(
              top: 3,
              right: 11.5,
              child: Icon(
                Icons.arrow_drop_up,
                size: 18,
                color: Colors.redAccent,
              ),
            ),
            Positioned(
              top: 13.5,
              right: 15,
              child: Text(
                'N',
                style: TextStyle(
                  // color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ).asGlass(
      clipBorderRadius: BorderRadius.circular(20),
    );
  }
}
