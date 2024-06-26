import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontendfluttercoach/page/user/chat/chat.dart';

import '../../waitingForEdit/chat.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});
  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  TextEditingController roomCtl = TextEditingController();
  TextEditingController userIdCtl = TextEditingController();
  TextEditingController firstNameCtl = TextEditingController();
  TextEditingController roomNameCtl = TextEditingController();

  // Initial Firebase App connection => this will load config from
  // google-services.json
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
    
    roomCtl.text = "301";
    roomNameCtl.text = "เผา";
    userIdCtl.text = "111";
    firstNameCtl.text = "pond";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatroom'),
      ),
      body: FutureBuilder(
          future: firebase, // Connect to Firebase App
          builder: (context, snapShot) {
            // If connection success => Firebase instance will be created
            if (snapShot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          const Text('Room ID'),
                          TextField(
                            controller: roomCtl,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('User ID'),
                          TextField(
                            controller: userIdCtl,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('Firstname'),
                          TextField(
                            controller: firstNameCtl,
                            textAlign: TextAlign.center,
                          ),
                           TextField(
                            controller: roomNameCtl,
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                if (roomCtl.text.isNotEmpty &&
                                    userIdCtl.text.isNotEmpty &&
                                    firstNameCtl.text.isNotEmpty) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          roomID: roomCtl.text,
                                          userID: userIdCtl.text,
                                          firstName: firstNameCtl.text, roomName: roomNameCtl.text,
                                        ),
                                      ));
                                }
                              },
                              child: const Text('Enter Chatroom'))
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const Text('Connecting to Firebase...'),
                  ],
                ),
              );
            }
          }),
    );
  }
}
