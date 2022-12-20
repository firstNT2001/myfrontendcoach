/*import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  // 1. กำหนดตัวแปร
  List<Destination> destinations = [];
  late Future<void> loadDataMethod;
  late DestinationService destinationService;

  // 2. สร้าง initState เพื่อสร้าง object ของ service 
  // และ async method ที่จะใช้กับ FutureBuilder
  @override
  void initState() {
    super.initState();
  // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    destinationService = 
        DestinationService(Dio(), baseUrl: context.read<AppData>().baseurl); 
  // 2.2 async method
    loadDataMethod = loadData(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
  // 3. เรียก service ในรูปแบบของ FutureBuilder (หรือจะไม่ใช้ก็ได้ แค่ตัวอย่างให้ดูเฉยๆ)
      body: FutureBuilder(
          future: loadDataMethod, // 3.1 object ของ async method
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(child: Text(jsonEncode(destinations)));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
  // 4. Async method ที่เรียก service เมื่อได้ข้อมูลก็เอาไปเก็บไว้ที่ destinations ที่ประกาศไว้ด้านบนเป็น List
  Future<void> loadData() async {
    try {
      destinations = await destinationService.getDestinations();
    } catch (err) {
      log('Error: $err');
    }
  }
}*/
