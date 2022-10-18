class DetailsModel {
  String? name;
  String? age;
  String? domain;
  String? mobileNumber;
  String? uid;
  DetailsModel({
    this.name,
    this.age,
    this.domain,
    this.mobileNumber,
    this.uid,
  });

  factory DetailsModel.fromMap(Map<String, dynamic> map) {
    return DetailsModel(
      name: map['name']  ,
      age: map['age'] ,
      domain: map['domain'] ,
      mobileNumber: map['mob'] ,
      uid: map['uid'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        "name": name,
        'age': age,
        'domain': domain,
        "mob": mobileNumber,
        'uid': uid,
      };
}
