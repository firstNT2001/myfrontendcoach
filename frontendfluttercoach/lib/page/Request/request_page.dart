import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/response/md_request.dart';
import '../../service/provider/appdata.dart';
import '../../service/request.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String cid = "";

  //show
  bool isVisibles = true;

  //Request
  List<Request> requests = [];
  late Future<void> loadRequestDataMethod;
  late RequestService _RequestService;

  @override
  void initState() {
    // TODO: implement initState
    cid = context.read<AppData>().cid.toString(); //ID Course

    //Request
    _RequestService = context.read<AppData>().requestService;
    loadRequestDataMethod = loadRequestData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text("Notification"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        children: [
           Visibility(
              visible: isVisibles,
              child: SizedBox(
                height: MediaQuery.of(context).size.width,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: showRequest(),
                ),
              ),
            ),
        ],
      )),
    );
  }

  Widget showRequest() {
    return FutureBuilder(
        future: loadRequestDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ignore: unnecessary_null_comparison
                if (requests != null)
                  Expanded(
                    child: ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Container(
                            padding:
                                const EdgeInsets.only(top: 8, left: 8, right: 8),
                            color: Theme.of(context).colorScheme.primaryContainer,
                            child: GestureDetector(
                              onTap: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, bottom: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          requests[index].rpId.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          requests[index].details,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<void> loadRequestData() async {
    try {
      var datas = await _RequestService.request(rqID: '', uid: '', cid: cid);
      requests = datas.data;
      log(requests.length.toString());
    } catch (err) {
      log('Error: $err');
    }
  }
}
