import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/profileUser.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

import 'chatOfCus.dart';
import 'homepageUser.dart';
import 'money/money.dart';
import 'mycourse.Detaildart/mycourse.dart';

class NavbarBottom extends StatelessWidget {
  const NavbarBottom({super.key});
  
  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

_controller = PersistentTabController(initialIndex: 0);
    List<Widget> _buildScreens() {
        return [
          const HomePageUser(),
          const MyCouses(),
          const addCoin(),
          const ProfileUser()
        ];
    }
    List<PersistentBottomNavBarItem> _navBarsItems() {
        return [
            PersistentBottomNavBarItem(
                icon: const Icon(FontAwesomeIcons.house,size: 16,),
                title: "หน้าหลัก",
                activeColorPrimary:Theme.of(context).colorScheme.primary,
                inactiveColorPrimary:  Color.fromARGB(255, 0, 0, 0),
                // activeColorPrimary: Color.fromARGB(255, 101, 6, 255),
                // inactiveColorPrimary:  const Color.fromARGB(255, 255, 255, 255),
            ),
            PersistentBottomNavBarItem(
                icon: const Icon(FontAwesomeIcons.solidBookmark),
                title: "รายการซื้อ",
                activeColorPrimary:Theme.of(context).colorScheme.primary,
                inactiveColorPrimary:  Color.fromARGB(255, 0, 0, 0),
                // activeColorPrimary: CupertinoColors.activeBlue,
                // inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
                icon: const Icon(FontAwesomeIcons.wallet),
                title: "เติมเงิน",
                activeColorPrimary: Theme.of(context).colorScheme.primary,
                inactiveColorPrimary:  Color.fromARGB(255, 0, 0, 0),
                // activeColorPrimary: CupertinoColors.activeBlue,
                // inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
                icon: const Icon(FontAwesomeIcons.solidUser),
                title: "โปรไฟล์",
                activeColorPrimary: Theme.of(context).colorScheme.primary,
                inactiveColorPrimary: Color.fromARGB(255, 0, 0, 0),
                // activeColorPrimary: CupertinoColors.activeBlue,
                // inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
        ];
    }
    return PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255), // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          //borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }

}