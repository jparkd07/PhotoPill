import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MedicationProvider.dart';
import 'inputPatientMed.dart';
import 'inputDrugDescription.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void clearAllData(BuildContext context) {
    final medicationProvider = Provider.of<MedicationProvider>(context, listen: false);
    medicationProvider.clearAllData();
  }

  Future<void> _showClearDataConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Data Confirmation'),
          content: const Text('Are you sure you want to clear all data? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                clearAllData(context); // Call the function to clear data
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK, Clear Data'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 75,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const InputPatientMed();
                    }),
                  );
                },
                child: const Text(
                  'Input Patient Medications',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 200,
              height: 75,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const InputDrugDescription();
                    }),
                  );
                },
                child: const Text(
                  'Input Drug Description',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 200,
              height: 75,
              child: ElevatedButton(
                onPressed: () {
                  _showClearDataConfirmationDialog(); // Show the confirmation dialog
                },
                child: const Text(
                  'Clear Data',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
