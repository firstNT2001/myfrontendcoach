import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/auth/login.dart';
import 'package:frontendfluttercoach/widget/wg_infoCard.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../page/coach/course/course_new_page.dart';
import '../page/coach/food/foodCoach/food_page.dart';
import '../page/coach/home_coach_page.dart';

class SideMenu extends StatefulWidget {
  final String name, price, image;
  const SideMenu(
      {required this.name,
      required this.price,
      required this.image,
      super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: (MediaQuery.of(context).size.width - 36 - (2 * 28)),
        height: double.infinity,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: SafeArea(
          child: Column(
            children: [
              //Info User
              InfoCard(
                name: widget.name,
                price: widget.price,
                image: widget.image,
              ),

              //Menu
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Divider(
                      color: Theme.of(context).colorScheme.background,
                      height: 1,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => const HomePageCoach());
                    },
                    leading: const SizedBox(
                        height: 34,
                        width: 34,
                        child: Icon(
                          FontAwesomeIcons.house,
                        )),
                    title: Text(
                      "Home",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => const CourseNewPage());
                    },
                    leading: const SizedBox(
                        height: 34,
                        width: 34,
                        child: Icon(
                          FontAwesomeIcons.house,
                        )),
                    title: Text(
                      "สร้างคอร์ส",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => const FoodCoachPage());
                    },
                    leading: const SizedBox(
                        height: 34,
                        width: 34,
                        child: Icon(
                          FontAwesomeIcons.house,
                        )),
                    title: Text(
                      "เมนูอาหาร",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() =>  LoginPage());
                    },
                    leading: const SizedBox(
                        height: 34,
                        width: 34,
                        child: Icon(
                          FontAwesomeIcons.house,
                        )),
                    title: Text(
                      "ออกจารระบบ",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
