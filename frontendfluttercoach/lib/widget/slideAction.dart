import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../model/response/md_FoodList_get.dart';

  const actions = [
    SlideAction(
      color: Color(0xFFFE4A49),
      icon: Icons.delete,
      label: 'Delete',
    ),
    SlideAction(
      color: Color(0xFF21B7CA),
      icon: Icons.share,
      label: 'Share',
    ),
  ];
class SlidablePlayer extends StatefulWidget {
  const SlidablePlayer({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key);

  final Animation<double>? animation;
  final Widget child;

  @override
  _SlidablePlayerState createState() => _SlidablePlayerState();

  static _SlidablePlayerState? of(BuildContext context) {
    return context.findAncestorStateOfType<_SlidablePlayerState>();
  }
}

class _SlidablePlayerState extends State<SlidablePlayer> {
  final Set<SlidableController?> controllers = <SlidableController?>{};

  @override
  void initState() {
    super.initState();
    widget.animation!.addListener(handleAnimationChanged);
  }

  @override
  void dispose() {
    widget.animation!.removeListener(handleAnimationChanged);
    super.dispose();
  }

  void handleAnimationChanged() {
    final value = widget.animation!.value;
    controllers.forEach((controller) {
      controller!.ratio = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class SlidableControllerSender extends StatefulWidget {
  const SlidableControllerSender({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  _SlidableControllerSenderState createState() =>
      _SlidableControllerSenderState();
}

class _SlidableControllerSenderState extends State<SlidableControllerSender> {
  SlidableController? controller;
  _SlidablePlayerState? playerState;

  @override
  void initState() {
    super.initState();
    controller = Slidable.of(context);
    playerState = SlidablePlayer.of(context);
    playerState!.controllers.add(controller);
  }

  @override
  void dispose() {
    playerState!.controllers.remove(controller);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}

class MySlidable extends StatelessWidget {
  const MySlidable({
    Key? key,
    required this.motion,
    required this.foods,
  }) : super(key: key);

  final Widget motion;
    final ModelFoodList foods;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Slidable(
        startActionPane: ActionPane(
          motion: motion,
          children: actions,
        ),
        child: SlidableControllerSender(
          child: TileFood(text: motion.runtimeType.toString(), foods: foods, ),
        ),
      ),
    );
  }
}

class SlideAction extends StatelessWidget {
  const SlideAction({
    Key? key,
    required this.color,
    required this.icon,
    required this.label,
    this.flex = 1,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final int flex;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      flex: flex,
      backgroundColor: color,
      foregroundColor: Colors.white,
      onPressed: (_) {},
      icon: icon,
      label: label,
    );
  }
}
class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    this.color = const Color(0xFFF4F4F8),
    required this.text,
  }) : super(key: key);

  final Color color;
  final String text;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: 100,
      child: Center(child: Text(text)),
    );
  }
}
class TileFood extends StatelessWidget {
  const TileFood({
    Key? key,
    this.color = const Color(0xFFF4F4F8),
    required this.text,
    required this.foods,
  }) : super(key: key);

  final Color color;
  final String text;
  final ModelFoodList foods;
  @override
  Widget build(BuildContext context) {
    return Card(
      //color: colorFood[index],
      child: InkWell(
        onTap: () {
          //setState(() {});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (foods.image != '') ...{
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      image: DecorationImage(
                        image: NetworkImage(foods.image),
                      ),
                    )),
              ),
            } else
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        color: Colors.black26)),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: AutoSizeText(
                    foods.name,
                    maxLines: 5,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: AutoSizeText(
                    'Calories: ${foods.calories.toString()}',
                    maxLines: 5,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width * 0.4,
                //   child: AutoSizeText(
                //     widget.increaseFood[index].time == '1'
                //         ? 'มื้อเช้า'
                //         : widget.increaseFood[index].time == '2'
                //             ? 'มื้อเที่ยง'
                //             : widget.increaseFood[index].time == '3'
                //                 ? 'มื้อเย็น'
                //                 : 'มื้อใดก็ได้',
                //     maxLines: 5,
                //     style: Theme.of(context).textTheme.bodyLarge,
                //   ),
                // ),
              ],
            ),
            const SizedBox(
              width: 50,
            )
          ],
        ),
      ),
    );
  }
}