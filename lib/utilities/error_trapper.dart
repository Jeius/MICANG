import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/graph_provider.dart';
import '../providers/list_provider.dart';
import '../providers/location_provider.dart';

class ErrorTrapper {
  final BuildContext context;
  final bool enableReload;

  final message = const [
    'Location services are disabled. Enable to locate your position.',
    'No target destination.'
  ];
  final title = const [
    'Location Error',
    'Route Error',
  ];

  const ErrorTrapper({
    required this.context,
    this.enableReload = false,
  });

  bool showError() {
    final toKey = Provider.of<ListProvider>(context, listen: false).toKey;
    final fromKey = Provider.of<ListProvider>(context, listen: false).fromKey;
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    final graphProvider = Provider.of<GraphProvider>(context, listen: false);

    if (locationProvider.currentPosition == null &&
        fromKey.selectedItem == null) {
      locationDialog();
      return true;
    }
    if (graphProvider.isPathFinding() && toKey.getSelectedNode() == null) {
      pathDialog();
      return true;
    }
    return false;
  }

  Future locationDialog() {
    return showAlertDialog(
      context: context,
      builder: (context, _) =>
          CustomErrorDialog(title: title[0], message: message[0]),
    );
  }

  Future pathDialog() {
    return showAlertDialog(
      context: context,
      builder: (context, _) =>
          CustomErrorDialog(title: title[1], message: message[1]),
    );
  }
}

class CustomErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final bool enableReload;

  const CustomErrorDialog({
    super.key,
    this.title = '',
    this.message = '',
    this.enableReload = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      shadowColor: Colors.black,
      elevation: 10,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w300),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      content: SizedBox(
        height: size.height * 0.2,
        width: size.width * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Text(
                      message,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: enableReload,
                    child: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyApp(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  MaterialButton(
                    padding: const EdgeInsets.all(10),
                    onPressed: () => Navigator.pop(context),
                    color: const Color(0xFF1E1F22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).asGlass(
      tintColor: Theme.of(context).colorScheme.secondary,
      blurX: 30,
      blurY: 30,
    );
  }
}
