/// Riverpod Variables
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main.dart';
import 'rulesCustomClass.dart';

class rulesArrayChangeNotifier extends ChangeNotifier {
  List<Rules> rulesArray = rulesBox.get("rulesBox")?.arrayOfRules ??
      [
        Rules("04:00", "06:00", 25.5, true, false, "AA0", 1),
        Rules("23:00", "02:00", 38.0, false, false, "AA0", 2),
        Rules("03:31", "03:32", 38.0, false, false, "AA0", 3),
        Rules("04:22", "4:23", 38.0, false, false, "AA0", 3),
      ];
  
  void saveRulesInHive(){
    rulesBox.put("rulesBox", listOfRules(rulesArray));
  }
}

final myGroupsChangeNotifierProvider =
    ChangeNotifierProvider<rulesArrayChangeNotifier>((ref) {
  return rulesArrayChangeNotifier();
});

String tempFilePath = "";
String valuesToGraph = "";
