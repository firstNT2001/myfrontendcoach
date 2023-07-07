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
          const chatOfCustomer(),
          const ProfileUser(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house),
            label: 'หน้าหลัก',
            backgroundColor: Color.fromARGB(255, 63, 63, 63),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.facebookMessenger),
            label: 'ข้อความ',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidUser),
            label: 'ฉัน',
          ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: onTapped,),
      
    );
  }

}
