import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/coach.dart';
import '../../service/provider/appdata.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}
Future<void>main()async{
   WidgetsFlutterBinding.ensureInitialized();
   
}

class _HomePageUserState extends State<HomePageUser> {
    late CoachService coachService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     coachService =
        CoachService(Dio(), baseUrl: context.read<AppData>().baseurl);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            color: Color.fromARGB(255, 152, 10, 0),
            alignment: Alignment.topCenter,
            padding: new EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .15,
                right: 20.0,
                left: 20.0),
            child: new Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              child: new Card(
                color: Colors.white,
                elevation: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
