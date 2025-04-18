import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:snapbook/screeen/contact.dart';
// import 'package:snapbook/screeen/editor/imagecrop.dart';
// import 'package:snapbook/screeen/explore.dart';
// import 'package:snapbook/screeen/home.dart';
// import 'package:snapbook/screeen/search.dart';
import 'package:snapbook/utils/constants/colors.dart';
import 'package:snapbook/utils/helpers/helper_functions.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final dark = THelperFunctions.isDarkMode(context);

    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedIndex.value != 0) {
          controller.selectedIndex.value = 0; // Navigate back to home
          return false; // Prevent app from closing
        }
        return true; // Allow app to close when on the home screen
      },
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            backgroundColor: dark ? TColors.black : Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.selectedIndex.value,
            selectedItemColor: TColors.primary,
            //onTap: (index) => controller.selectedIndex.value = index,
            onTap: (index) {
              controller.selectedIndex.value = index;
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: 'New'),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Contacts',
              ),
            ],
          ),
        ),
        body: Obx(() => controller.screens[controller.selectedIndex.value]),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    Container(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];
}
