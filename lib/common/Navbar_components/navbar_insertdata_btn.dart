import 'package:flutter/material.dart';
import '../../insert_leafdata.dart';
//import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:page_transition/page_transition.dart';

List<IconData> iconList = [
  Icons.home,
  Icons.favorite,
  Icons.shopping_cart,
  Icons.person,
];

List<Widget> pages = const [InsertData()];
var bottomNavIndex = 0;

class NavBarMainInsertDataBtn extends StatelessWidget {
  const NavBarMainInsertDataBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            PageTransition<InsertData>(
                child: const InsertData(),
                type: PageTransitionType.bottomToTop));
      },
      backgroundColor: const Color.fromARGB(255, 180, 220, 182),
      child: Image.asset(
        'assets/images/upload_logo.png',
        height: 30.0,
      ),
    );
  }
}
