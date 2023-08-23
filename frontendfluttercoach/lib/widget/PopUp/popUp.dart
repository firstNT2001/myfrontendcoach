import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

void warningFood(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.warning,
    text: 'กรุณาเลือกมืออาหาร',
  );
}

void warning(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.warning,
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
    text: 'คุณต้องการออกจากระบบใช่หรือไม่',
    confirmBtnText: 'ใช่',
    cancelBtnText: 'ไม่',
    confirmBtnColor: Colors.green,
  );
}

void popUpWarningDelete(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.warning,
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
