import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';

import '../providers/location_provider.dart';
import '../providers/map_provider.dart';

class LocationButton extends StatelessWidget {
  const LocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MapProvider, double>(
      selector: (_, map) => map.currentZoom,
      builder: (_, currentZoom, __) => button(currentZoom),
    );
  }

  Widget button(double? currentZoom) {
    return Consumer<LocationProvider>(
      builder: (context, location, __) {
        List<Color> buttonColors = [
          Theme.of(context).colorScheme.primaryContainer,
          Theme.of(context).colorScheme.primary,
        ];

        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          width: location.isButtonPressed() ? 40 : 120,
          height: 40,
          color: location.isButtonPressed()
              ? buttonColors[1]
              : buttonColors[0],
          child: FloatingActionButton(
            elevation: 0,
            onPressed: () => location.pressButton(currentZoom),
            backgroundColor: Colors.transparent,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    location.isButtonPressed()
                        ? const SizedBox.shrink()
                        : const Text(
                            'Your Location',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ).asGlass(clipBorderRadius: BorderRadius.circular(20));
      },
    );
  }
}
