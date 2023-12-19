import 'package:flutter/material.dart';
import 'package:photo_pill/inputDrugDescription.dart';
import 'package:photo_pill/inputPatientMed.dart';
import 'package:provider/provider.dart';
import 'MedicationProvider.dart';
import 'myHomePage.dart'; // Assuming this is your home page
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  // Ensure WidgetsBinding is initialized before calling SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // Load drugs from SharedPreferences and clear the list
  final prefs = await SharedPreferences.getInstance();
  final drugList = prefs.getStringList('drugList') ?? [];
  prefs.remove('drugList'); // Remove the drug list from SharedPreferences

  final medicationProvider = MedicationProvider(drugList);

  runApp(
    ChangeNotifierProvider.value(
      value: medicationProvider,
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhotoPill',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late int _selectedIndex = 0;
  static const _pages = [
    MyHomePage(title: "PhotoPill"),
    InputPatientMed(),
    InputDrugDescription(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart_rounded),
            label: "Data",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
