import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../page/coach/coach_page.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
  });
  final String name, price, image;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
         Get.to(() => const CoachPage());
      },
      leading: Column(
        children: [
          if (image != "") ...{
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(image),
              backgroundColor: Colors.transparent,
            )
          } else
            CircleAvatar(
              radius: 25.0,
                backgroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                child: const Icon(
                  CupertinoIcons.person,
                  color: Colors.white,
                )),
        ],
      ),
      title: Text(
        name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(FontAwesomeIcons.bahtSign, size: 20),
          Padding(
            padding: const EdgeInsets.only(top: 3, left: 3),
            child: Text(
              price,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
