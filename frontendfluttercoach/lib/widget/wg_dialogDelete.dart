
import 'package:flutter/material.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class WidgetDialogDelect extends StatefulWidget {
  const WidgetDialogDelect({super.key});

  @override
  State<WidgetDialogDelect> createState() => _WidgetDialogDelectState();
}

class _WidgetDialogDelectState extends State<WidgetDialogDelect> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
    );
  }
}


void dialogDelete(BuildContext context, TextEditingController delete) {
  //target widget
  SmartDialog.show(builder: (_) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 16),
            child: Text("คุณต้องการลบหรือไม",
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              //mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(onPressed: () {
                  SmartDialog.dismiss();
                }, child: Text("ยกเลิก")),
                FilledButton(
                    onPressed: () {
                      delete.text = "ss";
                      
                      SmartDialog.dismiss();
                      
                    },
                    child: Text("ตกลง"))
              ],
            ),
          ),
        ],
      ),
    );
  });
}

