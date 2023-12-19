import 'drug.dart';
//export based on size requires dependency : "collection: ^1.14.13"

class ReferenceList {
  //  static list
  static List<Drug> list = [];

  //  fetch drug list
  //  @aipMap Map constructed by api requests
  //  @return a list of drug object
  static List<Drug> fetch(Map<String, String> idMap, Map apiMap) {
    var drugs;
    Set checked = {};
    try {
      drugs = apiMap["ndcPropertyList"]["ndcProperty"];
    } catch (e) {
      throw const FormatException('api data not formated correctly');
    }
    if (drugs.isEmpty) {
      throw const FormatException('empty api data');
    }
    List<Drug> drugList = <Drug>[];
    for (Map item in drugs) {
      if (item.keys.isEmpty) {
        continue;
      }
      String id = item["rxcui"];
      String name = idMap[id] ?? "";
      String color = "";
      String shape = "";
      String size = "";
      try {
        if (!checked.contains(id)) {
          var propertyList = item["propertyConceptList"]["propertyConcept"];
          for (var concept in propertyList) {
            if (concept["propName"] == "COLORTEXT") {
              color = concept["propValue"];
            }
            if (concept["propName"] == "SHAPETEXT") {
              shape = concept["propValue"];
            }
            if (concept["propName"] == "SIZE") {
              size = concept["propValue"];
            }
          }
          drugList.add(Drug(name, id, color, shape, size));
          checked.add(id);
        }
      } catch (e) {
        print("drug omitted: $id");
        continue;
      }
    }
    //for (int i = 0; i < drugList.length; i++) {
    //  print(drugList[i].info());
    //}
    return drugList;
  }

  //  build rank map
  //  @drugList           the referencing list
  //  @target             target drug
  //  @return             the sorted list
  static List<Drug> build(List<Drug> drugList, Drug target) {
    for (Drug drug in drugList) {
      if (drug.rank == -1) {
        drug.getRank(target);
      }
      list.add(drug);
    }
    list.sort((a, b) => b.compareTo(a));
    return list;
  }

  // clean rank map
  static void clean() {
    list = [];
  }

  // export result
  static List<Drug> export() {
    return list;
  }
}
