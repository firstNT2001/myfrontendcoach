import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/home.dart';

import '../model/registerCus.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int? _selectedChoice;
  final formKey = GlobalKey<FormState>();
  //RegisterCusFromJson profileCus = RegisterCusFromJson();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("สมัครสมาชิก"),
      ),
      body: Container(
        child:Padding(
          padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[          
              // ignore: prefer_const_constructors
              Text("ชื่อนามสกุล",style: TextStyle(fontSize: 20)),
              TextFormField(),
              // ignore: prefer_const_constructors
              Text("วันเกิด",style: TextStyle(fontSize: 20)),
              TextFormField(),
              // ignore: prefer_const_constructors
              Text("เบอร์โทรศัพท์",style: TextStyle(fontSize: 20)),
              TextFormField(),
              // ignore: prefer_const_constructors
              Text("username",style: TextStyle(fontSize: 20)),
              TextFormField(),
              // ignore: prefer_const_constructors
              Text("E-mail",style: TextStyle(fontSize: 20)),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
              ),
              // ignore: prefer_const_constructors
              Text("รหัสผ่าน",style: TextStyle(fontSize: 20)),
              TextFormField(
                obscureText: true,
              ),
              // ignore: prefer_const_constructors
              Text("เพศ",style: TextStyle(fontSize: 20)),
              ListTile(
                title: const Text('ชาย'),
                leading: Radio(
                  value: 1, 
                  groupValue: _selectedChoice, 
                  onChanged: ( value) {
                    setState(() {
                      _selectedChoice = value;
                    });
                  },
                  ),
              ),  
              ListTile(
                title: const Text('หญิง'),
                leading: Radio(
                  value: 2, 
                  groupValue: _selectedChoice, 
                  onChanged: (value) {
                     setState(() {
                      _selectedChoice = value;
                    });
                  },
                  ),
              ),
              Text("คุณเป็นผู็ใช้ประเภทใด",style: TextStyle(fontSize: 20)),
              ListTile(
                title: const Text('ผู้ใช้'),
                leading: Radio(
                  value: 3, 
                  groupValue: _selectedChoice, 
                  onChanged: ( value) {
                     setState(() {
                      _selectedChoice = value;
                    });
                  },
                  ),
              ),  
              ListTile(
                title: const Text('โค้ช'),
                leading: Radio(
                  value: 4, 
                  groupValue: _selectedChoice, 
                  onChanged: ( value) {
                     setState(() {
                      _selectedChoice = value;
                    });
                  },
                  ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return HomePage();
                    })
                    );
                }, 
                child: Text('สมัครสมาชิก')),
              ),
           
            ]
            ),
          ),
      ),

      )
    );
  }
}