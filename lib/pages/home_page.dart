import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:micang/pages/directions_page.dart';
import 'package:micang/pages/explore_page.dart';
import 'package:micang/widget/legend_widget.dart';
import 'package:provider/provider.dart';
import '../providers/page_provider.dart';
import '../widget/bottom_nav_bar.dart';
import '../widget/location_button.dart';
import '../widget/map_widget.dart';
import '../widget/north_button.dart';
import 'places_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ExplorePage(),
      const DirectionsPage(),
      const PlacesPage(),
    ];

    return Consumer<PageProvider>(
      builder: (context, page, __) {
        return Scaffold(
          backgroundColor:
              Theme.of(context).colorScheme.background.withOpacity(0.8),
          resizeToAvoidBottomInset: false,
          extendBody: true,
          drawer: const LegendWidget(),
          body: Stack(
            children: [
              const MapWidget(),
              Positioned(
                bottom: 90,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const NorthButton(),
                    const SizedBox(height: 20),
                    Builder(
                      builder: (context) {
                        return Container(
                          width: 40,
                          height: 40,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: FloatingActionButton(
                            backgroundColor: Colors.transparent,
                            mini: true,
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            child: const Icon(Icons.info_outlined, size: 20,),
                          ),
                        ).asGlass(clipBorderRadius: BorderRadius.circular(20));
                      }
                    ),
                    const SizedBox(height: 20),
                    const LocationButton(),
                  ],
                ),
              ),
              pages[page.index],
            ],
          ),
          bottomNavigationBar: const BottomNavBar(),
        );
      },
    );
  }
}
