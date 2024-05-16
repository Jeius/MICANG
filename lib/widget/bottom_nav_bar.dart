import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import '../providers/page_provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PageProvider>(builder: (context, provider, __) {
      return bottomNavigationBar(context, provider);
    });
  }

  Widget bottomNavigationBar(
    BuildContext context,
    PageProvider provider,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        child: GNav(
            mainAxisAlignment: MainAxisAlignment.center,
            selectedIndex: provider.index,
            onTabChange: provider.setIndex,
            haptic: true, // haptic feedback
            curve: Curves.easeInOut, // tab animation curves
            duration:
                const Duration(milliseconds: 400), // tab animation duration
            gap: 8, // the tab button gap between icon and text
            color: Colors.white, // unselected icon color
            activeColor: Colors.white, // selected icon and text color
            backgroundColor: Colors.transparent,
            tabBackgroundColor: Theme.of(context)
                .colorScheme
                .primary, // selected tab background color
            padding: const EdgeInsets.symmetric(
                horizontal: 25, vertical: 10), // navigation bar padding
            tabs: const [
              GButton(
                icon: Icons.location_on,
                text: 'Explore',
              ),
              GButton(
                icon: Icons.navigation,
                text: 'Directions',
              ),
              GButton(
                icon: Icons.apartment,
                text: 'Places',
              ),
            ]),
      ),
    ).asGlass();
  }
}
