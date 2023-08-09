import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

void warningFood(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.warning,
    title: 'Oops...',
    text: 'กรุณาเลือกมืออาหาร',
  );
}

void warning(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.warning,
    title: 'Oops...',
    text: 'บันทึกไม่สำเร็จ',
  );
}

void success(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    text: 'บันทึกสำเร็จ',
  );
}


void confirm(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    text: 'Do you want to logout',
    confirmBtnText: 'Yes',
    cancelBtnText: 'No',
    confirmBtnColor: Colors.green,
  );
}

void popUpWarningDelete(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.warning,
    title: 'Oops...',
    text: 'ลบไม่สำเร็จ',
  );
}

void popUpSuccessDelete(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    text: 'ลบสำเร็จ',
  );
}
