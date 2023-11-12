/// Helper functions
import 'package:flutter/material.dart';

Future<String?> selectTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
      builder: (context, _) {
        return MediaQuery(
            data:
            MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: _!);
      });

  if (picked != null) {
    String hour = picked.hour.toString().padLeft(2, '0');
    String minute = picked.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  } else {
    return null;
  }
}

void showVariousDialogs(BuildContext context, int choice, String textToBeDisplayed) {
  switch (choice) {
    case 1:
      showDialog(
        context: context,
        barrierDismissible:
        false, // Prevent dismissing the dialog by tapping outside
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 175,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 72, width: 72, child: Center(child: FittedBox(child: CircularProgressIndicator()))), // Show loading circle in the dialog
                    Text(textToBeDisplayed,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
      break;
    case 2:
      showDialog(
        context: context,
        barrierDismissible:
        true, // Prevent dismissing the dialog by tapping outside
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 175,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 72,
                    ), // Show loading circle in the dialog
                    Text(textToBeDisplayed,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
      break;
    case 3:
      showDialog(
        context: context,
        barrierDismissible:
        true, // Prevent dismissing the dialog by tapping outside
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 175,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 72,
                    ),
                    const Text('ERROR...',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Text(textToBeDisplayed,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
      break;
    default:
      break;
  }
}
