// inputPatientMed.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MedicationProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputPatientMed extends StatefulWidget {
  const InputPatientMed({Key? key}) : super(key: key);

  @override
  _InputPatientMedState createState() => _InputPatientMedState();
}

class _InputPatientMedState extends State<InputPatientMed> {
  final TextEditingController _newDrugNameController = TextEditingController();
  bool isVisible = true;

  //newly added function called ClearAllData to implemet clear data button in the homepage
  void clearAllData() {
    final medicationProvider =
        Provider.of<MedicationProvider>(context, listen: false);
    medicationProvider.clearAllData();
  }

  Future<void> _showClearDataConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Data Confirmation'),
          content: const Text(
              'Are you sure you want to clear all data? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                clearAllData(); // Call the function to clear data
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
  void initState() {
    super.initState();
    _loadDrugList();
  }

  @override
  void dispose() {
    _newDrugNameController.dispose();
    super.dispose();
  }

  Future<void> _loadDrugList() async {
    final prefs = await SharedPreferences.getInstance();
    final drugList = prefs.getStringList('drugList') ?? [];
    final medicationProvider =
        Provider.of<MedicationProvider>(context, listen: false);

    // Clear the drug list when loading - this is the update we made
    medicationProvider.clearMedicines();

    // Add the loaded drugs to the provider
    medicationProvider.setDrugList(drugList);
  }

  Future<void> _saveDrugList(List<String> drugList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('drugList', drugList);
  }

  Widget buildMedicineList() {
    final medicationProvider = Provider.of<MedicationProvider>(context);
    final drugList = medicationProvider.drugList;

    return drugList.isEmpty
        ? const Text('No medications added.')
        : Column(
            children: drugList.asMap().entries.map((entry) {
              final int index = entry.key;
              final String drugName = entry.value;

              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                tileColor: Colors.green,
                title: Text(
                  drugName,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: () {
                        _editDrugName(index);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.white,
                      onPressed: () {
                        medicationProvider.removeDrugName(drugName);
                        final updatedDrugList = [
                          ...medicationProvider.drugList
                        ];
                        _saveDrugList(updatedDrugList);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
  }

  void _editDrugName(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final medicationProvider =
            Provider.of<MedicationProvider>(context, listen: false);
        String editedDrugName = medicationProvider.drugList[index];
        return AlertDialog(
          title: const Text('Edit Drug Name'),
          content: TextField(
            controller: TextEditingController(text: editedDrugName),
            onChanged: (value) {
              editedDrugName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (editedDrugName.trim().isNotEmpty) {
                  medicationProvider.editDrugName(index, editedDrugName);
                  final updatedDrugList = [...medicationProvider.drugList];
                  _saveDrugList(updatedDrugList);
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void clearMedicines() {
    final medicationProvider =
        Provider.of<MedicationProvider>(context, listen: false);
    medicationProvider.clearMedicines();
    _saveDrugList([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('Patient Medications'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildMedicineList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.lightBlue,
            splashColor: Colors.lightBlueAccent,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Add Drug Name'),
                    content: TextField(
                      controller: _newDrugNameController,
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          final newDrugName = _newDrugNameController.text;
                          if (newDrugName.trim().isNotEmpty) {
                            _newDrugNameController.clear();
                            final medicationProvider =
                                Provider.of<MedicationProvider>(context,
                                    listen: false);
                            medicationProvider.addDrugName(newDrugName);

                            final updatedDrugList = [
                              ...medicationProvider.drugList
                            ];
                            _saveDrugList(updatedDrugList);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$newDrugName added'),
                              ),
                            );

                            setState(() {
                              //isVisible = false;
                            });

                            Navigator.of(context)
                                .pop(); // Clear and Close the dialog
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
            tooltip: 'Add Items',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showClearDataConfirmationDialog(); // Show the confirmation dialog
            },
            child: const Text('Clear Medicines'),
          ),
        ],
      ),
    );
  }
}
