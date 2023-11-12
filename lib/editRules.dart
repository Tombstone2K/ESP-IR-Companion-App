import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_arduino_ir/globalVar.dart';
import 'package:flutter_arduino_ir/rulesCustomClass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'helperFunctions.dart';

class editRules extends ConsumerStatefulWidget {

  final int ruleIndice;
  editRules({super.key, required this.ruleIndice});

  @override
  ConsumerState<editRules> createState() => _editRulesState();
}

class _editRulesState extends ConsumerState<editRules> with WidgetsBindingObserver{
  late int ruleIndice;

  bool isKeyboardVisible = false;

  String dropDownValue = 'Temp & Time';
  String tempCondition = "Greater than >";
  String startTimeController ="08:00";
  String endTimeController ="09:00";
  double tempToBeEntered= 45.0;
  TextEditingController temperatureController =TextEditingController();
  TextEditingController actionController = TextEditingController();


  // List of items in our dropdown menu
  var itemss = [
    'Temp & Time',
    'Exact Time',
  ];

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ruleIndice =  widget.ruleIndice;
  }
  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final keyboardHeight = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      isKeyboardVisible = keyboardHeight > 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    final rulesArrayChangeNotifier =  ref.watch(myGroupsChangeNotifierProvider);
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Edit Rules"),
      ),
      body:
      GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // Hide keyboard when tapped outside the text field
            // FocusScope.of(context).requestFocus(_focusNode);
            FocusScope.of(context).unfocus();

          },
          child: SizedBox(
            width: double.infinity,
            // height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50,),
                  Container(
                    width: 200,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    // padding: const EdgeInsets.all(4.0),
                    child: Center(
                      child: DropdownButton(
                        // Initial Value
                        value: dropDownValue,
                        padding: const EdgeInsets.all(4.0),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        // Down Arrow Icon
                        iconSize: 32,
                        dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          // size: 24,
                          color: Colors.black,
                        ),

                        // Array list of items
                        items: itemss.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropDownValue = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 50,),
                  loadRemainingWidgets(),
                ],
              ),
            ),
          ),
      ),
      floatingActionButton: !isKeyboardVisible ? Container(
        height: 72,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: (){
              if(checkIfInputsAreCorrect()){
                if (kDebugMode) {
                  print("GOOD");
                }
                rulesArrayChangeNotifier.rulesArray[ruleIndice] = Rules(startTimeController, endTimeController, tempToBeEntered, (tempCondition=="Greater than >"), false, actionController.text.toUpperCase(), ruleTypeVar());
                rulesArrayChangeNotifier.notifyListeners();
                Navigator.of(context).pop();
              }
              else{
                //give message
                if (kDebugMode) {
                  print("NOT GOOD");
                }

              }
            },
            child: const Icon(Icons.save,
              size: 28,
            ),
          ),
        ),
      ) : null ,

    );
  }

  Widget loadRemainingWidgets() {
    if(dropDownValue=="Temp & Time"){
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 55,
                width: 200,
                color: Theme.of(context).colorScheme.inversePrimary,
                child: Center(
                  child: DropdownButton(
                    value: tempCondition,
                    padding: const EdgeInsets.all(4.0),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    // Down Arrow Icon
                    iconSize: 32,
                    dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      // size: 24,
                      color: Colors.black,
                      // color: Theme.of(context).colorScheme.onSecondary,
                    ),

                    // Array list of items
                    items: ["Greater than >","Less than <="].map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        tempCondition = newValue!;
                      });
                    },
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 55,
                color: Theme.of(context).colorScheme.inversePrimary,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 60,
                        child: TextField(
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          controller: temperatureController,
                          decoration: const InputDecoration(
                            // labelText: 'Temperature',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                        child: Padding(
                          padding: EdgeInsets.only(top: 7,),
                          child: Center(
                            child: Text("\u00B0C",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 150,
                // color: Colors.pink,
                child: Center(
                  child: Text(
                    "Action: ",
                    style: TextStyle(
                      color: Colors.white,
                      // Theme.of(context).colorScheme.onBackground,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                width: 120,
                height: 55,
                color: Theme.of(context).colorScheme.inversePrimary,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    width: 60,
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      // keyboardType: const TextInput,
                      inputFormatters: <TextInputFormatter>[
                        // FilteringTextInputFormatter.deny(RegExp(r'[ -]')), // Prohibit spaces and dashes
                        LengthLimitingTextInputFormatter(4),
                        // FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]{0,2}[0-9]{0,2}')),
                      ],
                      controller: actionController,
                      decoration: const InputDecoration(
                        // labelText: 'Temperature',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 150,
                // color: Colors.pink,
                child: Center(
                  child: Text(
                    "Start Time: ",
                    style: TextStyle(
                      color: Colors.white,
                      // Theme.of(context).colorScheme.onBackground,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  String? temp = await selectTime(context);
                  if (temp != null) {
                    setState(() {
                      startTimeController = temp;
                    });
                  }
                },
                child: Container(
                  height: 60,
                  width: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    startTimeController,
                    style: TextStyle(
                      color:
                      Theme.of(context).colorScheme.onTertiaryContainer,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 150,
                child: Center(
                  child: Text(
                    "End Time: ",
                    style: TextStyle(
                      color: Colors.white,
                      // Theme.of(context).colorScheme.onBackground,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  String? temp = await selectTime(context);
                  if (temp != null) {
                    setState(() {
                      endTimeController = temp;
                    });
                  }
                },
                child: Container(
                  height: 60,
                  width: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    endTimeController,
                    style: TextStyle(
                      color:
                      Theme.of(context).colorScheme.onTertiaryContainer,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),


        ],
      );
    }
    else if(dropDownValue=="Exact Time"){
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 150,
                // color: Colors.pink,
                child: Center(
                  child: Text(
                    "Action: ",
                    style: TextStyle(
                      color: Colors.white,
                      // Theme.of(context).colorScheme.onBackground,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                width: 120,
                height: 55,
                color: Theme.of(context).colorScheme.inversePrimary,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    width: 60,
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      // keyboardType: const TextInput,
                      inputFormatters: <TextInputFormatter>[
                        // FilteringTextInputFormatter.deny(RegExp(r'[ -]')), // Prohibit spaces and dashes
                        LengthLimitingTextInputFormatter(4),
                        // FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]{0,2}[0-9]{0,2}')),
                      ],
                      controller: actionController,
                      decoration: const InputDecoration(
                        // labelText: 'Temperature',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 150,
                // color: Colors.pink,
                child: Center(
                  child: Text(
                    "Start Time: ",
                    style: TextStyle(
                      color: Colors.white,
                      // Theme.of(context).colorScheme.onBackground,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  String? temp = await selectTime(context);
                  if (temp != null) {
                    setState(() {
                      startTimeController = temp;
                    });
                  }
                },
                child: Container(
                  height: 60,
                  width: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    startTimeController,
                    style: TextStyle(
                      color:
                      Theme.of(context).colorScheme.onTertiaryContainer,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return const Text("QQ");
  }

  bool checkIfInputsAreCorrect() {
    // print(temperatureController.text=="");
    if(dropDownValue=="Exact Time"){
      RegExp regex = RegExp(r'^[A-Za-z]{2}[0-9]{1,2}$');
      if(actionController.text.length>2 && regex.hasMatch(actionController.text)){
        return true;
      }
    }
    if((temperatureController.text !="") && double.parse("0${temperatureController.text}")!=0){
      tempToBeEntered = double.parse("0${temperatureController.text}");
      RegExp regex = RegExp(r'^[A-Za-z]{2}[0-9]{1,2}$');
      if(actionController.text.length>2 && regex.hasMatch(actionController.text)){
        return true;
      }
    }
    return false;
  }

  int ruleTypeVar(){
    if(dropDownValue=="Exact Time"){
      return 3;
    }
    else{
      int result = startTimeController.compareTo(endTimeController);
      if(result<=0){
        return 1;
      }
      else{
        return 2;
      }
    }
  }
}
