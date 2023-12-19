import 'dart:async';
import 'dart:convert';
import 'package:photo_pill/inputDrugDescription.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart'
    show XmlDocument, XmlElement; // Import the xml package

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_pill/search.dart';
import 'drug.dart';
import 'package:provider/provider.dart';
import 'MedicationProvider.dart';

/**
 * @param drugNames: the list of patient medications that we pass in to look up properties
 * @param descriptionDrug: the patient descriptions that we convert to a drug, primary means of comparison
 * @returns a list of drugs, ranked in order given the cross-referencing
 */
Future<List<Drug>> returnProperties(
    List<String> drugNames, Drug descriptionDrug) async {
  const String baseUrl = 'https://rxnav.nlm.nih.gov/REST/rxcui.xml';
  List<Drug> drugList = [];
  for (int i = 0; i < drugNames.length; i++) {
    try {
      final Map<String, dynamic> firstParams = {
        'name': drugNames[i],
        'search': '2',
      };

      final Uri uri = Uri.parse(baseUrl).replace(queryParameters: firstParams);
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final XmlDocument xmlDoc = XmlDocument.parse(response.body);
        final rxNormIdElements = xmlDoc.findAllElements('rxnormId');
        String rxcui = rxNormIdElements.single.innerText;
        const String baseUrl2 =
            'https://rxnav.nlm.nih.gov/REST/ndcproperties.json';

        final Map<String, dynamic> secondParams = {
          'id': rxcui,
          'ndcstatus': 'ALL',
        };

        final Uri uri2 =
            Uri.parse(baseUrl2).replace(queryParameters: secondParams);
        final http.Response response2 = await http.get(uri2);
        if (response2.statusCode == 200) {
          Map<String, dynamic> jsonMap = json.decode(response2.body);
          print(jsonMap);
          Map<String, String> idNameMap = {rxcui: drugNames[i]};
          Drug formattedDrug = ReferenceList.fetch(idNameMap, jsonMap)[0];
          drugList.add(formattedDrug);
        } else {
          throw Exception(
              'Failed to load NDC properties: ${response2.reasonPhrase}');
        }
      } else {
        throw Exception('Failed to load drug: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle errors for individual drugs
      print('Error for drug ${drugNames[i]}: $e');
    }
  }
  ReferenceList.build(drugList, descriptionDrug);
  List<Drug> rankedDrugsInfo = ReferenceList.export();
  return rankedDrugsInfo;
}

void main() => runApp(searchResults(descriptionDrug: Drug("", "", "", "", "")));

class searchResults extends StatefulWidget {
  final Drug descriptionDrug; // Add this line

  searchResults({Key? key, required this.descriptionDrug}) : super(key: key);

  @override
  State<searchResults> createState() => _searchResults();
}

class _searchResults extends State<searchResults> {
  late Future<List<Drug>> properties;
  //late Future<List<Drug>> formattedProp = Future.value([]);

  @override
  void initState() {
    super.initState();
    Drug descriptionDrug = widget.descriptionDrug;
    final medicationProvider =
        Provider.of<MedicationProvider>(context, listen: false);
    List<String> drugList = medicationProvider.drugList;
    properties = returnProperties(drugList, descriptionDrug);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Results',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Search Results'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              ReferenceList.clean();
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: FutureBuilder<List<Drug>>(
            future: properties,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No data available.');
              }

              List<Drug> drugDataList = snapshot.data!;

              return ListView.builder(
                itemCount: drugDataList.length,
                itemBuilder: (context, index) {
                  Drug drug = drugDataList[index];

                  return Column(
                    children: [
                      ListTile(
                        title: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(
                                text: 'Name: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text: '${drug.name}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text('ID: ${drug.id}'),
                      ),
                      ListTile(
                        title: Text('Color: ${drug.color}'),
                      ),
                      ListTile(
                        title: Text('Shape: ${drug.shape}'),
                      ),
                      ListTile(
                        title: Text('Size: ${drug.size}'),
                      ),
                      Divider(
                          color: Colors.deepPurple,
                          thickness: 1.5,
                          height: 10.0), // A divider to separate sections
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
