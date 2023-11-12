/// Send the Rules to ESP-32 as JSON data
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_arduino_ir/helperFunctions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'editRules.dart';
import 'globalVar.dart';
import 'rulesCustomClass.dart';
import 'package:http/http.dart' as http;

Future<void> sendJsonData(BuildContext context) async {
  var url = Uri.parse('http://192.168.29.17/json');

  final container = ProviderContainer();
  final rulesArrayChangeNotifier =
      container.read(myGroupsChangeNotifierProvider);

  try {
    showVariousDialogs(context, 1, "Uploading...");
    var response = await http.post(
      url,
      body: jsonEncode(rulesArrayChangeNotifier.rulesArray),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 5));
    container.dispose();
    Future.microtask(() =>     Navigator.of(context).pop(),);

    if (response.statusCode == 200) {
      Future.microtask(() =>     Navigator.of(context).pop(),);
      Future.microtask(() =>       showVariousDialogs(context, 2, "Successful Upload"),);
      if (kDebugMode) {
        print('Request sent successfully.');
        print(response.body);
      }
    } else {
      Future.microtask(() =>       showVariousDialogs(context, 3, "Something went wrong"),);
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
  } on TimeoutException {
    Future.microtask(() =>     Navigator.of(context).pop(),);

    Future.microtask(() =>       showVariousDialogs(context, 3, "Couldn\'t reach ESP"),);
    if (kDebugMode) {
      print('Timeout');
    }
  } on Error catch (e) {
    Future.microtask(() =>     Navigator.of(context).pop(),);

    Future.microtask(() =>       showVariousDialogs(context, 3, "Something went wrong"),);
    if (kDebugMode) {
      print('Error: $e');
    }
  }
}

class createRules extends ConsumerStatefulWidget {
  const createRules({super.key});

  @override
  ConsumerState<createRules> createState() => _createRulesState();
}

class _createRulesState extends ConsumerState<createRules> {
  Map<int, String> ruleTypeDecipher = {
    1: "Temp & Time",
    2: "Temp & Time",
    3: "Exact Time",
  };

  String actionDecipher(String action) {
    String toBeReturned = "";
    if (action.substring(0, 2) == "SF") {
      toBeReturned = "FAN - ${action.substring(2)}";
    } else if (action.substring(0, 2) == "AC") {
      toBeReturned = "AC - ${action.substring(2)}";
    } else {
      toBeReturned = "- - - - -";
    }
    return toBeReturned;
  }

  @override
  Widget build(BuildContext context) {
    final rulesArrayChangeNotifier = ref.watch(myGroupsChangeNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Send Rules"),
      ),
      body: Consumer(builder: (context, ref, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: rulesArrayChangeNotifier.rulesArray.length,
            itemBuilder: (context, index) {
              final currentRule = rulesArrayChangeNotifier.rulesArray[index];
              // print(jsonEncode(rulesArray));
              return SizedBox(
                // height: 100,
                // width: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "${ruleTypeDecipher[currentRule.ruleType]}",
                              style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          editRules(ruleIndice: index)));
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              actionDecipher(currentRule.action),
                              style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                              ),
                            ),
                          ),
                          // controlAffinity: ListTileControlAffinity.leading,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ruleDetailCard(
                                currentRule,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: SizedBox(
        height: 72,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () async {
              rulesArrayChangeNotifier.saveRulesInHive();
              sendJsonData(context);
            },
            mini: false,
            child: const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Icon(
                Icons.send_rounded,
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget ruleDetailCard(Rules currentRule) {
    if (currentRule.ruleType == 3) {
      return Center(
        child: RichText(
          text: TextSpan(
              style: TextStyle(
                fontSize: 22,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              children: <TextSpan>[
                const TextSpan(
                  text: "Time: ",
                ),
                TextSpan(
                  text: currentRule.startTime,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                )
              ]),
        ),
      );
    } else {
      String tempCondition = "less";
      if (currentRule.greaterThanTemperature) {
        tempCondition = "greater";
      }
      return Center(
        child: RichText(
          text: TextSpan(
              style: TextStyle(
                fontSize: 22,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              children: <TextSpan>[
                const TextSpan(
                  text: "Action if ",
                ),
                TextSpan(
                  text: tempCondition,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: " than ",
                ),
                TextSpan(
                  text: "${currentRule.temperatureThreshold} \u00B0C\n",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: "between ",
                ),
                TextSpan(
                  text: currentRule.startTime,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: " and ",
                ),
                TextSpan(
                  text: currentRule.endTime,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ]),
        ),
        // child: Text("$tempCondition ${currentRule.temperatureThreshold} \u00B0C\n"
        //     "between ${currentRule.startTime} and ${currentRule.endTime}",
        //   style: TextStyle(
        //     fontSize: 20,
        //     color: Theme.of(context).colorScheme.onPrimaryContainer,
        //   ),
        // ),
      );
    }
  }
}

// var jsonData2 = [
//   {
//     "startTime": "04:00",
//     "endTime": "06:00",
//     "temperatureThreshold": 25.5,
//     "greaterThanTemperature": true,
//     "actionTaken": false,
//     "action": "AA0",
//     "ruleType": 1
//   },
//   {
//     "startTime": "23:00",
//     "endTime": "02:00",
//     "temperatureThreshold": 38,
//     "greaterThanTemperature": false,
//     "actionTaken": false,
//     "action": "AA0",
//     "ruleType": 2
//   },
//   {
//     "startTime": "03:31",
//     "endTime": "03:32",
//     "temperatureThreshold": 38,
//     "greaterThanTemperature": false,
//     "actionTaken": false,
//     "action": "AA0",
//     "ruleType": 3
//   },
//   {
//     "startTime": "04:22",
//     "endTime": "4:23",
//     "temperatureThreshold": 38,
//     "greaterThanTemperature": false,
//     "actionTaken": false,
//     "action": "AA0",
//     "ruleType": 3
//   }
// ];
