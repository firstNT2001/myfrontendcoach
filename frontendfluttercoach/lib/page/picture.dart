import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:video_player/video_player.dart';

class UploadpicturePage extends StatefulWidget {
  const UploadpicturePage({super.key});

  @override
  State<UploadpicturePage> createState() => _UploadpicturePageState();
}

class _UploadpicturePageState extends State<UploadpicturePage> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  

  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles();
    if(result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }
  Future uploadFile() async{
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() => {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เล่นวิดีโอ"),      
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(pickedFile != null)
            Expanded(
              child: Container(               
                color: Colors.green,
                
                child: Image.file(
                  File(pickedFile!.path!),
                  width: double.infinity,
                  fit: BoxFit.cover,)
               ),
               ),
               const SizedBox(height: 12,),
            ElevatedButton(             
              child: const Text('Select File'),
              onPressed: selectFile ,
              ),
              const SizedBox(height: 12,),
              ElevatedButton(
                child: const Text('Upload File'),
              onPressed: uploadFile ,
              ),
              ElevatedButton(             
              child: const Text('ดูรูปภาพที่เลือก'),
              onPressed: (){
                Expanded(
              child: Container(
                color: Colors.green,
                child: Image.file(
                  File(pickedFile!.path!),
                  width: double.infinity,
                  fit: BoxFit.cover,)
               ),
               );
              } ,
              ),
              

              
          ],
        ),)
    );
  }
}