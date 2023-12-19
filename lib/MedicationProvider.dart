import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MedicationProvider with ChangeNotifier {
  List<String> _drugList = [];

  // initialize with a list of drugs
  MedicationProvider(List<String> initialDrugs) {
    _drugList = initialDrugs;
  }

  // Get the current drug list
  List<String> get drugList => _drugList;

  // Add a drug to the list
  void addDrugName(String drugName) {
    _drugList.add(drugName);
    notifyListeners();
  }

  // Clear the list of drugs
  void clearMedicines() {
    _drugList.clear();
    notifyListeners();
  }
  
  //newly added function called ClearAllData to implemet clear data button in the homepage
  void clearAllData() {
    _drugList.clear();
    _saveDrugList([]);
    notifyListeners();
  }
  Future<void> _saveDrugList(List<String> drugList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('drugList', drugList);
  }

  // Set the drug list (useful when loading from shared preferences)
  void setDrugList(List<String> newDrugList) {
    _drugList = newDrugList;
    notifyListeners();
  }

  // Remove a drug from the list
  void removeDrugName(String drugName) {
    _drugList.remove(drugName);
    notifyListeners();
  }

  // Edit a drug name at a specific index
  // partial update for edit drug name
  void editDrugName(int index, String editedDrugName) {
    if (index >= 0 && index <= _drugList.length - 1) {
      _drugList[index] = editedDrugName;
      notifyListeners();
    }
  }
}
