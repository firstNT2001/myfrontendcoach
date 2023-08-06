import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hex/hex.dart';
import 'package:base32/base32.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleAuthenticatorPage extends StatefulWidget {
  const GoogleAuthenticatorPage(
      {super.key, required this.email, required this.password});
  final String email;
  final String password;
  @override
  State<GoogleAuthenticatorPage> createState() =>
      _GoogleAuthenticatorPageState();
}

class _GoogleAuthenticatorPageState extends State<GoogleAuthenticatorPage> {
  String GenOTP = "";
  bool isvisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.chevronLeft,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              Center(
                child: Text(
                  'Google Authenticator',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:20 ,bottom: 18, left: 20, right: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FilledButton(
                      onPressed: () async {
                        GenOTP = getGoogleAuthenticatorUriQR(
                            "Coaching", widget.email, widget.password);
                        log(GenOTP);

                        if (GenOTP.isNotEmpty) {
                          setState(() {
                            isvisible = true;
                          });
                          // _launchUrl( Uri.parse(GenOTP));
                        }
                      },
                      child: Text("สร้างGoogle Authenticator")),
                ),
              ),
              Visibility(
                visible: isvisible,
                child: Column(
                  children: [
                    Container(
                        height: 200,
                        child: Image.network(
                            'https://www.google.com/chart?chs=200x200&chld=M|0&cht=qr&chl=$GenOTP')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilledButton(
                            onPressed: () {
                              setState(() {
                                isvisible = false;
                              });
                            },
                            child: Text("ซ่อน QR Code")),
                        FilledButton(
                            onPressed: () {
                              GenOTP = getGoogleAuthenticatorUri(
                                  "Coaching", widget.email, widget.password);
                            },
                            child: Text("เข้าสู่ Application"))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }

  String getGoogleAuthenticatorUri(String appname, String email, String key) {
    List<int> list = utf8.encode(email);
    String hex = HEX.encode(list);
    String secret = base32.encodeHexString(hex);
    log('secret $secret');
    // String uri =
    //     'otpauth://totp/${Uri.encodeComponent('$appname:$email?secret=$secret&issuer=$appname')}';
    String url =
        'otpauth://totp/$appname:$email?secret=$secret&issuer=$appname';
    launchUrl(Uri.parse(url));
    return url;
  }

  String getGoogleAuthenticatorUriQR(String appname, String email, String key) {
    List<int> list = utf8.encode(email);
    String hex = HEX.encode(list);
    String secret = base32.encodeHexString(hex);
    log('secret $secret');
    String uri =
        'otpauth://totp/${Uri.encodeComponent('$appname:$email?secret=$secret&issuer=$appname')}';

    return uri;
  }
}
