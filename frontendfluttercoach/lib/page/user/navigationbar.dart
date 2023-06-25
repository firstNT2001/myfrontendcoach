import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/profileUser.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

import 'chatOfCus.dart';
import 'homepageUser.dart';
import 'mycourse.Detaildart/mycourse.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {

  int selectedIndex =0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: <Widget>[
            const HomePageUser(),           
            const chatOfCustomer(),
            const MyCouses(),
            const ProfileUser()
          ],
        ),
      bottomNavigationBar: WaterDropNavBar(barItems: [
        BarItem(filledIcon: FontAwesomeIcons.house, outlinedIcon: FontAwesomeIcons.house),
        BarItem(filledIcon: FontAwesomeIcons.facebookMessenger, outlinedIcon: FontAwesomeIcons.facebookMessenger),
        BarItem(filledIcon: FontAwesomeIcons.solidBookmark, outlinedIcon: FontAwesomeIcons.solidBookmark),
        BarItem(filledIcon: FontAwesomeIcons.solidUser, outlinedIcon: FontAwesomeIcons.solidUser),
      ], selectedIndex: selectedIndex, onItemSelected: (index){
        setState(() {
          selectedIndex = index;
        });
         pageController.animateToPage(selectedIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad);
      }),
     
    );
  }
}