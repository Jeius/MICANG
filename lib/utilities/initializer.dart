import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:micang/providers/location_provider.dart';
import 'package:micang/utilities/error_trapper.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../providers/page_provider.dart';
import '../providers/data_provider.dart';
import '../providers/graph_provider.dart';
import '../providers/list_provider.dart';
import '../providers/map_provider.dart';

class Initializer extends StatelessWidget {
  const Initializer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dataProvider = DataProvider();
    final locationProvider = LocationProvider()..startService();
    return MultiProvider(
      providers: providers(dataProvider, locationProvider),
      child: FutureBuilder(
        future: dataProvider.initialize(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return child;
            } else {
              // Display error dialog when data initialization fails
              return const CustomErrorDialog(
                title: 'Connection Error',
                message: 'Failed to fetch data from the database',
                enableReload: true,
              );
            }
          } else if (snapshot.hasError) {
            // Handle error case
            return CustomErrorDialog(
              title: 'Error',
              message: 'An error occurred: ${snapshot.error}',
              enableReload: true,
            );
          } else {
            // Show loading animation while waiting for data
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: const Color(0xFFd0d0ce),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/icons/192x192.png'),
                  const SizedBox(height: 20,),
                  LoadingAnimationWidget.threeArchedCircle(
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  List<SingleChildWidget> providers(
    DataProvider dataProvider,
    LocationProvider locationProvider,
  ) {
    return [
      ChangeNotifierProvider(
        create: (_) => dataProvider,
      ),
      ChangeNotifierProvider(
        create: (_) => locationProvider,
      ),
      ChangeNotifierProvider(
        create: (_) => GraphProvider(dataProvider),
      ),
      ChangeNotifierProvider(
        create: (_) => MapProvider(locationProvider),
      ),
      ChangeNotifierProvider(
        create: (_) => PageProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ListProvider(locationProvider, dataProvider),
      ),
    ];
  }
}
