/// Fetch existing rules from ESP-32
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'globalVar.dart';

class DataPoint {
  DateTime instance;
  double temperature;

  DataPoint(this.instance, this.temperature);
}


// bool connectedToESP = true;

Future<bool> accessESP(List<int>? fileBytes) async {
  valuesToGraph="";

  try {
    // Fetch the file from the server
    // List<int>? fileBytes = await fetchFileFromServer('http://192.168.29.17/temperature-humidity');

    if(fileBytes==null){
      return false;
    }
    else{
      await saveTempFile(fileBytes);

      if (kDebugMode) {
        print(tempFilePath);
      }
      return true;
    }
  } catch (e) {
    return false;
  }
}

Future<void> saveTempFile(List<int> bytes) async {
  final tempDir = await getTemporaryDirectory();
  tempFilePath = '${tempDir.path}/data.txt';
  final file = File(tempFilePath);
  await file.writeAsBytes(bytes, flush: true);
  return;
  // return file;
}


///
/// Above is for fetching data from ESP
/// Below is for processing data before graphing it
///

Future<void> extractData() async {
  List<DataPoint> dataPoints = await readDataFromFile();
  for (var element in dataPoints) {
    valuesToGraph += "[${element.instance.millisecondsSinceEpoch + 19800000},${element.temperature}],\r\n";
  }
  return ;
  // plotChart();

}

Future<List<DataPoint>> readDataFromFile() async {
  // final tempDir = await getTemporaryDirectory();
  final file = File(tempFilePath);
  if (await file.exists()) {
    final contents = await file.readAsString();
    if (kDebugMode) {
      print("ALL WELL");
    }
    return parseCSVData(contents, limit: 360);
  } else {
    throw Exception('File not found');
  }
}

List<DataPoint> parseCSVData(String csvData, {int limit = 360}) {
  List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvData);
  int startIndex = csvTable.length - limit;
  if (startIndex < 1) {
    startIndex = 1;
  }
  // if (kDebugMode) {
  //   print(csvTable.length);
  //   print(startIndex);
  // }

  List<DataPoint> dataPoints = [];
  DateTime currentDateTime = DateTime.now(); // The current DateTime

  for (int i = startIndex; i < csvTable.length; i++) {
    var row = csvTable[i];
    // String date = "${row[0]}";
    // String time = "${row[1]}";
    DateTime tempDT = DateTime.parse("${row[0]} ${row[1]}");
    double temperature = double.parse("${row[2]}");

    Duration difference = tempDT.difference(currentDateTime);

    if (difference.inHours.abs() < 30) {
      dataPoints
          .add(DataPoint(tempDT, temperature));
    }


  }
  if (kDebugMode) {
    print("HELLO");
  }
  return dataPoints;
}
