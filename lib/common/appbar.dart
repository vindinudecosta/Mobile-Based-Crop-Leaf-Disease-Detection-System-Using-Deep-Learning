import 'package:flutter/material.dart';

List<String> titlelist = [
  'Home',
  'Potato Leaf Diagnose',
  'Paddy Leaf Diagnose',
  'Tomato Leaf Diagnose',
  'Tea Leaf Diagnose'
];
var _bottomNavIndex = 0;

class AppBarMain extends StatelessWidget {
  const AppBarMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titlelist[_bottomNavIndex],
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 19,
            )),
        const Icon(
          Icons.more_vert,
          color: Colors.black,
          size: 30.0,
        )
      ],
    );
  }
}
