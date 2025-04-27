import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';

import '../../constant/text_style.dart';
import '../../constant/theme.dart';
import '../screens/bar/bar_page_controller.dart';

void main() => runApp(const MaterialApp(home: BottomNavBar()));

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  BarPageController controller = Get.find();
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      key: bottomNavigationKey,
      index: 0,
      height: 75,
      items: <Widget>[
        bottomBarUnit('Bar', Icons.wine_bar_rounded),
        bottomBarUnit('Orders', Icons.task_alt_rounded),
        bottomBarUnit('Door', Icons.door_sliding_rounded),
      ],
      color: Get.isDarkMode ? darkPrimaryColor : primaryColor,
      buttonBackgroundColor: Get.isDarkMode
          ? darkPrimaryColor.withOpacity(0.7)
          : primaryColor.withOpacity(0.7),
      backgroundColor: Get.isDarkMode
          ? backGroundDarkColor.withOpacity(0.1)
          : skinColorWhite!.withOpacity(0.1),
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 500),
      onTap: (index) {
        setState(() {
          controller.changePage(index);
        });
      },
      letIndexChange: (index) => true,
    );
  }

  Widget bottomBarUnit(String title, IconData? icon) {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SizedBox(
          height: 70,
          width: 65,
          child: Column(
            children: [
              Icon(
                icon,
                color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
              ),
              Text(
                title.tr,
                style: generalTextStyle(null),
              ),
            ],
          ),
        ));
  }
}
