import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatPage extends StatefulWidget {
  final String roomID;
  final String userID;
  final String firstName;

  const ChatPage({Key? key, required this.roomID, required this.userID, required this.firstName}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // List of all messages in this chatroom
  List<types.Message> _messages = [];

  // User ID
  late final types.User _user;
  late final Stream<QuerySnapshot> _chatStream;

  // upload file state
  bool isUploading = false;

  void _initialSystem() {
    // Create stream to chatroom collection
    _chatStream = FirebaseFirestore.instance.collection(widget.roomID).snapshots();

    // Create chatUser object
    _user = types.User(id: widget.userID, firstName: widget.firstName);

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getString(widget.roomID) != null) {
    //   String? messagesTxt = prefs.getString(widget.roomID);
    //   if (messagesTxt != null) {
    //     var messages = jsonDecode(messagesTxt);
    //     for (var message in messages) {
    //       types.Message msg = types.Message.fromJson(message);
    //       _addMessage(msg);
    //     }
    //     setState(() {
    //       log('messages is loaded');
    //     });
    //   }
    // }
  }

  // Create Text message and send to firebase
  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _sendMessage(textMessage);
  }

// Create Image message and send to firebase
  void _handleImageSelection(ImageSource imageSource) async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: imageSource,
    );

    if (result != null) {
      setState(() {
        isUploading = true;
      });
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      // Generate unique file name
      String filename = Uuid().v4() + '.jpg';

      // Connect firestorage at Chatroom/filename.jpg
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('${widget.roomID}/${filename}');
      // Update file
      UploadTask uploadTask = firebaseStorageRef.putFile(io.File(result.path));
      // Wait for uploading
      TaskSnapshot taskSnapshot = await uploadTask;
      // if Upload success
      if (taskSnapshot.state == TaskState.success) {
        // Get link of the file
        String link = await firebaseStorageRef.getDownloadURL();
        // Create Image message
        final message = types.ImageMessage(
          author: _user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          height: image.height.toDouble(),
          id: const Uuid().v4(),
          name: filename,
          size: bytes.length,
          uri: link,
          width: image.width.toDouble(),
        );

        // Send to firebase
        _sendMessage(message);
        isUploading = false;
      }
    }
  }

  //  In case select file (not using)
  // void _handleFileSelection() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.any,
  //   );

  //   if (result != null && result.files.single.path != null) {
  //     final message = types.FileMessage(
  //       author: _user,
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       id: const Uuid().v4(),
  //       mimeType: lookupMimeType(result.files.single.path!),
  //       name: result.files.single.name,
  //       size: result.files.single.size,
  //       uri: result.files.single.path!,
  //     );

  //     _sendMessage(message);
  //   }
  // }

  // UI select image/file
  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection(ImageSource.camera);
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('ถ่ายภาพ'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection(ImageSource.gallery);
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('เลือกรูปภาพ'),
                  ),
                ),
                // TextButton(
                //   onPressed: () {
                //     Navigator.pop(context);
                //     _handleFileSelection();
                //   },
                //   child: const Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text('File'),
                //   ),
                // ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('ยกเลิก'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Display preview image in the chat
  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.FileMessage).copyWith(
      isLoading: true,
    );

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  // In case of tap on file (not using)
  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _sendMessage(types.Message message) {
    // Set State is NOT NEEDED
    // _messages.add(message);
    // Send message to Firebase
    FirebaseFirestore.instance.collection(widget.roomID).add(message.toJson());

    // SharedPreferences.getInstance().then((prefs) {
    //   prefs.setString(widget.roomID, jsonEncode(_messages));
    // });
  }

  @override
  void initState() {
    super.initState();
    // Load initial config
    _initialSystem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chatroom no: ${widget.firstName}'),
        ),
        body: StreamBuilder(
          // Start stream check
          stream: _chatStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // In case of any error
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.error.toString()),
                  ],
                ),
              );
            }

            // In case of waiting for data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Loading chat messages...'),
                    ),
                  ],
                ),
              );
            }

            // In case of data arrived
            if (snapshot.hasData) {
              // If NO Chatroom
              if (snapshot.data!.docs.isEmpty) {
                log('No chatroom');
                _messages = [];
                // SharedPreferences.getInstance().then((prefs) {
                //   prefs.setString(widget.roomID, jsonEncode({}));
                //   _messages = [];
                // });
              } else {
                log('Fecthing message');
                // Chat room has been created
                // Loop add all messages into the list
                for (QueryDocumentSnapshot item in snapshot.data!.docs) {
                  var jsonMessage = jsonDecode(jsonEncode(item.data()));
                  types.Message message = types.Message.fromJson(jsonMessage);
                  if (!_messages.contains(message)) {
                    _messages.add(message);
                  }
                }
              }

              // Sort message by create time (MUST)
              _messages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

              // Show Chat
              return SafeArea(
                  child: Chat(
                isAttachmentUploading: isUploading,
                showUserNames: true,
                messages: _messages,
                onAttachmentPressed: _handleAttachmentPressed,
                onMessageTap: _handleMessageTap,
                onPreviewDataFetched: _handlePreviewDataFetched,
                onSendPressed: _handleSendPressed,
                user: _user,
              ));
            } else {
              // Cannot get anything from Firebase
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No data available'),
                  ],
                ),
              );
            }
          },
        ));
  }
}
