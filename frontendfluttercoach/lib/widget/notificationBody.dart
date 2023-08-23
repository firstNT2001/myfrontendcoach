import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationBody extends StatelessWidget {
  final int count;
  final double minHeight;
  final String message;
  NotificationBody({
    Key? key,
    this.count = 0,
    this.minHeight = 0.0,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minHeight = math.min(
      this.minHeight,
      MediaQuery.of(context).size.height,
    );
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                 color: Colors.grey.shade600,
                spreadRadius: 5,
                blurRadius: 30,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color.fromARGB(115, 255, 255, 255).withOpacity(0.4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(message,
                          style: Theme.of(context).textTheme.titleMedium!
                          //.copyWith(color: Colors.white),
                          ),
                      const Icon(
                        FontAwesomeIcons.chevronUp,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
