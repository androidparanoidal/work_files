class Student {
  int? id;
  late String name;

  Student(this.id, this.name);

  // method for conversion TO map
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    return map;
  }

  // FROM map
  Student.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }
}
