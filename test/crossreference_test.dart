import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_pill/search.dart' as searchlib;
import 'package:photo_pill/drug.dart' as druglib;
import 'dart:convert';

void main() {
  test('keyword test', () {
    druglib.Drug drug = druglib.Drug("", "", "BLUE", "barrel shaped", "11 mm");
    debugPrint(drug.keywords.toString());
    expect(drug.name, "DEFAULT");
    expect(drug.color, "BLUE");
    expect(drug.shape, "barrel shaped".toUpperCase());
    expect(drug.size, "11 mm".toUpperCase());
  });
  test('empty drug object creation test', () {
    druglib.Drug drug = druglib.Drug.empty();
    expect(drug.name, "DEFAULT");
    expect(drug.color, "DEFAULT");
    expect(drug.shape, "DEFAULT");
    expect(drug.size, "DEFAULT");
  });
  test('sample drug object creation test', () {
    druglib.Drug drug = druglib.Drug("", "", "BLUE", "barrel shaped", "11 mm");
    expect(drug.name, "DEFAULT");
    expect(drug.color, "BLUE");
    expect(drug.shape, "barrel shaped");
    expect(drug.size, "11 mm");
  });
  test('sample drug rank test', () {
    druglib.Drug drug = druglib.Drug("", "", "BLUE", "barrel shaped", "11 mm");
    druglib.Drug target = druglib.Drug("", "", "", "barrel shaped", "11 mm");
    drug.getRank(target);
    debugPrint("${drug.rank}");
    expect(drug.rank, 0.8);
  });
  test('fetch test', () {
    String input = """{"ndcPropertyList":{"ndcProperty":[{   "ndcItem":"00378451793","ndc9":"0378-4517","ndc10":"0378-4517-93","rxcui":"597987","splSetIdItem":"4be76756-4114-4d50-a36c-fd410f6c773d","packagingList":{"packaging":["30 TABLET, FILM COATED in 1 BOTTLE, PLASTIC (0378-4517-93)"]},"propertyConceptList":{"propertyConcept":[{"propName":"ANDA","propValue":"ANDA200465"},{"propName":"COLORTEXT","propValue":"BLUE"},{"propName":"COLOR","propValue":"C48333"},{"propName":"DM_SPL_ID","propValue":"633412"},{"propName":"IMPRINT_CODE","propValue":"M;AA8"},{"propName":"LABELER","propValue":"Mylan Pharmaceuticals Inc."},{"propName":"LABEL_TYPE","propValue":"HUMAN PRESCRIPTION DRUG"},{"propName":"MARKETING_CATEGORY","propValue":"ANDA"},{"propName":"MARKETING_EFFECTIVE_TIME_LOW","propValue":"20141106"},{"propName":"MARKETING_STATUS","propValue":"ACTIVE"},{"propName":"SCORE","propValue":"1"},{"propName":"SHAPETEXT","propValue":"barrel shaped"},{"propName":"SHAPE","propValue":"C48345"},{"propName":"SIZE","propValue":"11 mm"}]},"source":"Hybrid"}]}}""";
    var map = jsonDecode(input);
    assert(map is Map);
    List<druglib.Drug> druglist = searchlib.ReferenceList.fetch({},map);
    var drug = druglist[0];
    debugPrint(drug.id);
    debugPrint(drug.color);
    debugPrint(drug.shape);
    debugPrint(drug.size);
    expect(drug.id, "597987");
    expect(drug.color, "BLUE");
    expect(drug.shape, "barrel shaped".toUpperCase());
    expect(drug.size, "11 mm".toUpperCase());
    expect(druglist.length, 1);
  });
  test('integration test', () {
    String input = """{"ndcPropertyList":{"ndcProperty":[{   "ndcItem":"00378451793","ndc9":"0378-4517","ndc10":"0378-4517-93","rxcui":"597987","splSetIdItem":"4be76756-4114-4d50-a36c-fd410f6c773d","packagingList":{"packaging":["30 TABLET, FILM COATED in 1 BOTTLE, PLASTIC (0378-4517-93)"]},"propertyConceptList":{"propertyConcept":[{"propName":"ANDA","propValue":"ANDA200465"},{"propName":"COLORTEXT","propValue":"BLUE"},{"propName":"COLOR","propValue":"C48333"},{"propName":"DM_SPL_ID","propValue":"633412"},{"propName":"IMPRINT_CODE","propValue":"M;AA8"},{"propName":"LABELER","propValue":"Mylan Pharmaceuticals Inc."},{"propName":"LABEL_TYPE","propValue":"HUMAN PRESCRIPTION DRUG"},{"propName":"MARKETING_CATEGORY","propValue":"ANDA"},{"propName":"MARKETING_EFFECTIVE_TIME_LOW","propValue":"20141106"},{"propName":"MARKETING_STATUS","propValue":"ACTIVE"},{"propName":"SCORE","propValue":"1"},{"propName":"SHAPETEXT","propValue":"barrel shaped"},{"propName":"SHAPE","propValue":"C48345"},{"propName":"SIZE","propValue":"11 mm"}]},"source":"Hybrid"}]}}""";
    var map = jsonDecode(input);
    List<druglib.Drug> druglist = searchlib.ReferenceList.fetch({},map);
    var drug = druglist[0];
    druglib.Drug target = druglib.Drug("", "", "BLUE", "barrel shaped", "11 mm");
    searchlib.ReferenceList.build(druglist, target);
    List<druglib.Drug> result = searchlib.ReferenceList.export();
    searchlib.ReferenceList.clean();
    debugPrint(result[0].info());
  });
}