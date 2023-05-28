import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/profileUser.dart';

import 'chatOfCus.dart';
import 'homepageUser.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int _selectedIndex = 0;
  PageController pageController = PageController();

  void onTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
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