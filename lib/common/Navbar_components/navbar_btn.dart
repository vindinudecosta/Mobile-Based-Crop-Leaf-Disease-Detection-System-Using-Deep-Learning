import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:plantrecogniser/widget/plant_notification.dart';

List<IconData> iconList = [
  Icons.home,
  Icons.favorite,
  Icons.notifications_active,
  Icons.person,
];

class NavBarMainBtn extends StatelessWidget {
  const NavBarMainBtn({super.key});

  @override
  Widget build(BuildContext context) {
    var bottomNavIndex = 0;
    return AnimatedBottomNavigationBar(
        splashColor: const Color.fromARGB(255, 124, 195, 127),
        activeColor: const Color.fromARGB(255, 124, 195, 127),
        inactiveColor: Colors.black.withOpacity(.5),
        icons: iconList,
        activeIndex: bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) {
          Navigator.push<PlantNotification>(
            context,
            MaterialPageRoute(
              builder: (context) => const PlantNotification(),
            ),
          );
        });
  }
}
