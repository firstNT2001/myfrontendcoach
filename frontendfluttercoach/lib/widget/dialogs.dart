import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_indicator/loading_indicator.dart';

Widget loadingIndicator(BuildContext context) => Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: SizedBox(
        width: 120,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: LoadingIndicator(
                indicatorType: Indicator.ballTrianglePathColoredFilled,
                colors: [Theme.of(context).colorScheme.onPrimaryContainer],
                strokeWidth: 5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'กำลังประมวลผล',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            )
          ],
        ),
      ),
    );

void startLoading(BuildContext context) {
  SmartDialog.showLoading(
    builder: (_) => loadingIndicator(context),
    animationType: SmartAnimationType.fade,
    maskColor: Colors.transparent,
  );
}

void stopLoading() {
  SmartDialog.dismiss();
}

Widget load(BuildContext context) => LoadingAnimationWidget.horizontalRotatingDots(
      color: const Color.fromARGB(255, 186, 182, 182),
      // leftDotColor: const Color(0xFF1A1A3F),
      // rightDotColor: const Color(0xFFEA3799),
      size: 50,
    );
// void warning(BuildContext context) {
//   CherryToast.warning(
//     title: const Text('บันทึกไม่สำเร็จ'),
//     displayTitle: false,
//     description: const Text('บันทึกไม่สำเร็จ'),
//     toastPosition: Position.bottom,
//     animationDuration: const Duration(milliseconds: 1000),
//     autoDismiss: true,
//   ).show(context);
// }
void warningDelete(BuildContext context) {
  CherryToast.warning(
    title: const Text('ลบไม่สำเร็จ'),
    displayTitle: false,
    description: const Text('ลบไม่สำเร็จ'),
    toastPosition: Position.bottom,
    animationDuration: const Duration(milliseconds: 1000),
    autoDismiss: true,
  ).show(context);
}
