import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _selectedChoice = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("สมัครสมาชิก"),
      ),
      body: Container(
        child: Form(
          child: Column(
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
              TextFormField(),
              // ignore: prefer_const_constructors
              Text("รหัสผ่าน",style: TextStyle(fontSize: 20)),
              TextFormField(),
              // ignore: prefer_const_constructors
              Text("เพศ",style: TextStyle(fontSize: 20)),
              ListTile(
                title: const Text('ชาย'),
                leading: Radio(
                  value: 1, 
                  groupValue: _selectedChoice, 
                  onChanged: ( value) {},
                  ),
              ),  
              ListTile(
                title: const Text('หญิง'),
                leading: Radio(
                  value: 2, 
                  groupValue: _selectedChoice, 
                  onChanged: ( value) {},
                  ),
              ),
              Text("คุณเป็นผู็ใช้ประเภทใด",style: TextStyle(fontSize: 20)),
              ListTile(
                title: const Text('ผู้ใช้'),
                leading: Radio(
                  value: 3, 
                  groupValue: _selectedChoice, 
                  onChanged: ( value) {},
                  ),
              ),  
              ListTile(
                title: const Text('โค้ช'),
                leading: Radio(
                  value: 4, 
                  groupValue: _selectedChoice, 
                  onChanged: ( value) {},
                  ),
              ),
              
            ]
            ),
          ),
      ),

      
    );
  }
}