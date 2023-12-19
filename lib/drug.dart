class Drug implements Comparable<Drug> {
  //  attributes are set to "DEFAULT" by default
  String name = "DEFAULT";
  String id = "DEFAULT";
  String color = "DEFAULT"; //{"propName":"COLORTEXT","propValue":"WHITE"}
  String shape =
      "DEFAULT"; //{"propName":"SHAPETEXT","propValue":"barrel shaped"}
  String size = "DEFAULT"; //{"propName":"SIZE","propValue":"11 mm"}
  double rank = -1;
  Set<String> keywords = {};
  String nameStartKeyword = "";
  //  constructor
  Drug.empty();
  //  pass in "" if empty input
  Drug(String name, String id, String color, String shape, String size) {
    List<String> temp = [];
    if (name.isNotEmpty) {
      this.name = name.trim().toLowerCase();
      nameStartKeyword = this.name;
    }
    if (id.isNotEmpty) {
      this.id = id.trim().toLowerCase();
      temp = this.id.split(" ");
      for (String word in temp) {
        keywords.add(word.trim().replaceAll(new RegExp(r'[^\w\s]+'), ''));
      }
    }
    if (color.isNotEmpty) {
      this.color = color.trim().toLowerCase();
      temp = this.color.split(" ");
      for (String word in temp) {
        keywords.add(word.trim().replaceAll(new RegExp(r'[^\w\s]+'), ''));
      }
    }
    if (shape.isNotEmpty) {
      this.shape = shape.trim().toLowerCase();
      temp = this.shape.split(" ");
      for (String word in temp) {
        keywords.add(word.trim().replaceAll(new RegExp(r'[^\w\s]+'), ''));
      }
    }
    if (size.isNotEmpty) {
      this.size = size.trim().toLowerCase();
      temp = this.size.split(" ");
      for (String word in temp) {
        keywords.add(word.trim().replaceAll(new RegExp(r'[^\w\s]+'), ''));
      }
    }
  }

  //  get & set rank
  //  @target       target drug
  double getRank(Drug target) {
    int temp = 0;
    if (nameStartKeyword.startsWith(target.nameStartKeyword) &&
        target.nameStartKeyword != "") {
      temp++;
    }
    for (String word in target.keywords) {
      if (keywords.any((element) => element.contains(word))) {
        temp++;
      }
    }
    rank = temp / keywords.length;
    return rank;
  }

  //  compareTo based on rank
  //  @drug         another drug in the referencing list
  //  @return       1 with higher rank, 0 with same rank, -1 with lower rank
  //  @exception    if any of the 2 drugs in comparison has no rank, throw exception
  @override
  int compareTo(Drug drug) {
    if (rank == -1 || drug.rank == -1) {
      throw const FormatException('rank not acquired.');
    }
    if (rank > drug.rank) {
      return 1;
    } else if (rank < drug.rank) {
      return -1;
    } else {
      return 0;
    }
  }

  //  print all info
  //  @return     all existing info of current drug
  String info() {
    String s = "";
    if (name != "DEFAULT") {
      s += "Name: $name\t";
    }
    if (id != "DEFAULT") {
      s += "ID: $id\t";
    }
    if (color != "DEFAULT") {
      s += "Color: $color\t";
    }
    if (shape != "DEFAULT") {
      s += "Shape: $shape\t";
    }
    if (size != "DEFAULT") {
      s += "Dosage: $size\t";
    }
    if (s.isEmpty) {
      return "Empty info";
    }
    return s;
  }
}
