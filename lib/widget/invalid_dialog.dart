import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InvalidDialog extends StatelessWidget {
  const InvalidDialog({
    super.key,
    required this.enabled,
    required this.constraints,
  });

  final bool enabled;
  final Size? constraints;

  @override
  Widget build(BuildContext context) {
    return invalidSearch();
  }

  Widget invalidSearch() => Builder(
        builder: (context) {
          final size = MediaQuery.of(context).size;
          return Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              width:
                  (constraints != null) ? constraints!.width * 0.5 : size.width,
              height: enabled
                  ? (constraints != null)
                      ? constraints!.height * 0.3
                      : size.height
                  : 0,
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No place was found',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      LoadingAnimationWidget.waveDots(
                          color: Colors.white,
                          size: (constraints != null)
                              ? constraints!.width * 0.08
                              : size.width),
                    ],
                  ),
                ),
              ),
            ).asGlass(
              clipBorderRadius: BorderRadius.circular(20),
            ),
          );
        },
      );
}
