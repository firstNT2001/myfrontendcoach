import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/coach/profile/coach_page.dart';
import 'package:frontendfluttercoach/page/coach/usersBuyCourses/show_user_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'FoodAndClip/coach_food_clip_page.dart';
import 'course/course_new_page.dart';
import 'home_coach_page.dart';


class NavbarBottomCoach extends StatelessWidget {
  const NavbarBottomCoach({super.key});
  
  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

_controller = PersistentTabController(initialIndex: 0);
    List<Widget> _buildScreens() {
        return [
          const HomePageCoach(),
          const FoodCoachPage(),
          const CourseNewPage(),
          const ShowUserByCoursePage(),
          const CoachPage()
        ];
    }
    List<PersistentBottomNavBarItem> _navBarsItems() {
        return [
            PersistentBottomNavBarItem(
                icon: const Icon(FontAwesomeIcons.house),
                title: "Home",
                activeColorPrimary:Theme.of(context).colorScheme.primary,
                inactiveColorPrimary:  Color.fromARGB(255, 0, 0, 0),
                // activeColorPrimary: Color.fromARGB(255, 101, 6, 255),
                // inactiveColorPrimary:  const Color.fromARGB(255, 255, 255, 255),
            ),
            PersistentBottomNavBarItem(
                icon: const Icon(FontAwesomeIcons.utensils),
                title: "History",
                activeColorPrimary:Theme.of(context).colorScheme.primary,
                inactiveColorPrimary:  Color.fromARGB(255, 0, 0, 0),
                // activeColorPrimary: CupertinoColors.activeBlue,
                // inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
                icon: const Icon(FontAwesomeIcons.plus,color: Colors.black,),
                title: "Add",
                activeColorPrimary: Theme.of(context).colorScheme.primary,
                inactiveColorPrimary:  Color.fromARGB(255, 0, 0, 0),
                // activeColorPrimary: CupertinoColors.activeBlue,
                // inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
                icon: const Icon(FontAwesomeIcons.comment),
                title: "Chat",
                activeColorPrimary: Theme.of(context).colorScheme.primary,
                inactiveColorPrimary: Color.fromARGB(255, 0, 0, 0),
                // activeColorPrimary: CupertinoColors.activeBlue,
                // inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
                icon: const Icon(FontAwesomeIcons.solidUser),
                title: "Profile",
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
        backgroundColor: Color.fromARGB(255, 245, 245, 245), // Default is Colors.white.
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
        navBarStyle: NavBarStyle.style15, // Choose the nav bar style with this property.
    );
  }

}