import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
class NotificationBody extends StatelessWidget {
  final int count;
  final double minHeight;

  NotificationBody({
    Key? key,
    this.count = 0,
    this.minHeight = 0.0,
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
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 12,
                blurRadius: 16,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.lightGreen.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    width: 1.4,
                    color: Colors.lightGreen.withOpacity(0.2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Count: $count',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.white),
                    ),
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