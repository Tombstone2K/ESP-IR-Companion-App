/// HomePage with 4 options to proceed
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'graph.dart';
import 'helperFunctions.dart';
import 'fetchAndReadyData.dart';
import 'sendRules.dart';
import 'sendIR.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.yellow,
                            width: 5,
                          )),
                      child: ElevatedButton(
                        onPressed: () async {
                          showVariousDialogs(context, 1, "Plotting...");


                          try {
                            final response = await http.get(Uri.parse('http://192.168.29.17/temperature-humidity')).timeout(const Duration(seconds: 5));
                            if(response.statusCode == 200){
                              await accessESP(response.bodyBytes);
                              await extractData();
                              Future.microtask(() => Navigator.of(context).pop());
                              Future.microtask(() => Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const plotChart())),);
                            }

                          } on TimeoutException {
                            if (kDebugMode) {
                              print('Timeout');
                            }
                            Navigator.of(context).pop();
                            showVariousDialogs(context, 3,"Can't reach ESP");
                          } on Error catch (e) {
                            if (kDebugMode) {
                              print('Error: $e');
                            }
                            Navigator.of(context).pop();
                            showVariousDialogs(context, 3,"Can't reach ESP");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          "Graph",
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Lucida',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.yellow,
                            width: 5,
                          )),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const createRules()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          "Send Rules",
                          style: TextStyle(
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
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.yellow,
                            width: 5,
                          )),
                      child: ElevatedButton(
                        onPressed: () {
                          checkLogs(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          "Ping",
                          style: TextStyle(
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
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.yellow,
                            width: 5,
                          )),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const sendIrClass()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          "Send IR",
                          style: TextStyle(
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
    );
  }

  Future<void> checkLogs(BuildContext context) async {
    showVariousDialogs(context, 1,"Loading...");
    try {
      var url3 = Uri.parse("http://192.168.29.17/logs");
      var response = await http.get(url3).timeout(const Duration(seconds: 5));
      Future.microtask(
            () =>
            Navigator.of(context).pop(),
      );
      if (response.statusCode == 200) {
        Future.microtask(
              () =>
              showVariousDialogs(context, 2,"Connected"),
        );
      } else {
        Future.microtask(
              () =>
              showVariousDialogs(context, 3,"Can't reach ESP"),
        );
      }
    } on TimeoutException {
      if (kDebugMode) {
        print('Timeout');
      }
      Navigator.of(context).pop();
      showVariousDialogs(context, 3,"Can't reach ESP");
    } on Error catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      Navigator.of(context).pop();
      showVariousDialogs(context, 3,"Can't reach ESP");
    }
  }

}