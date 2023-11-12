/// Directly Send IR codes
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_arduino_ir/helperFunctions.dart';
import 'package:http/http.dart' as http;

void testPing(int device, int speed, BuildContext context) async {
  try {
    showVariousDialogs(context, 1, "Transmitting...");
    var url3 =
        Uri.parse("http://192.168.29.17/testPing?output=$device&state=$speed");
    var response = await http.get(url3).timeout(const Duration(seconds: 2));
    Future.microtask(
          () => Navigator.of(context).pop(),
    );
    if (response.statusCode == 200) {
      Future.microtask(() => showVariousDialogs(context, 2, "IR Code Sent",));
    }
    else {
      Future.microtask(() => showVariousDialogs(context, 3, "Something went wrong",));
    }
  } on TimeoutException {
    Navigator.of(context).pop();
    showVariousDialogs(context, 3, "Couldn\'t reach ESP",);
  } on Error {
    Navigator.of(context).pop();
    showVariousDialogs(context, 3, "Couldn\'t reach ESP",);
  }
}

class sendIrClass extends StatefulWidget {
  const sendIrClass({super.key});

  @override
  State<sendIrClass> createState() => _sendIrClassState();
}

class _sendIrClassState extends State<sendIrClass> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Send IR"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.yellow,
                            width: 5,
                          )),
                      child: ElevatedButton(
                        onPressed: () {
                          testPing(1, 2, context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          "FAN 2",
                          style: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'Lucida',
                            fontWeight: FontWeight.w500,
                            // color: Colors.black,
                          ),
                          // style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.yellow,
                            width: 5,
                          )),
                      child: ElevatedButton(
                        onPressed: () {
                          testPing(1, 3, context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          "FAN 3",
                          style: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'Lucida',
                            fontWeight: FontWeight.w500,
                            // color: Colors.black,
                          ),
                          // style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.yellow,
                            width: 5,
                          )),
                      child: ElevatedButton(
                        onPressed: () {
                          testPing(2, 25, context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          "AC 25",
                          style: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'Lucida',
                            fontWeight: FontWeight.w500,
                            // color: Colors.black,
                          ),
                          // style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.yellow,
                            width: 5,
                          )),
                      child: ElevatedButton(
                        onPressed: () {
                          testPing(2, 26, context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          "AC 26",
                          style: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'Lucida',
                            fontWeight: FontWeight.w500,
                            // color: Colors.black,
                          ),
                          // style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
