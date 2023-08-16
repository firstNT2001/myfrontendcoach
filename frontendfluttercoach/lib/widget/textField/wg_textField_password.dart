import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextFieldPassword extends StatefulWidget {
  const TextFieldPassword(
      {super.key, required this.controller, required this.title});
  final TextEditingController controller;
  final String title;
  @override
  State<TextFieldPassword> createState() => _TextFieldPasswordState();
}

class _TextFieldPasswordState extends State<TextFieldPassword> {
  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return TextPassword();
  }

  Column TextPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        TextField(
          obscureText: passwordVisible,
          controller: widget.controller,

          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            // hintText: "Password",
            // labelText: "Password",
            //helperText: "Password must contain special character",
            //helperStyle: const TextStyle(color: Colors.green),
            prefixIcon: const Icon(FontAwesomeIcons.lock),

            suffixIcon: IconButton(
              icon: Icon(
                  passwordVisible ?  Icons.visibility_off : Icons.visibility ),
              onPressed: () {
                setState(
                  () {
                    passwordVisible = !passwordVisible;
                  },
                );
              },
            ),
            // alignLabelWithHint: false,
            // filled: true,
          ),
          keyboardType: TextInputType.visiblePassword,
          // textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
