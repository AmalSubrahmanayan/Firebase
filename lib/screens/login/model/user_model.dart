class UserModel {
  String? email;
  String? name;
  String? mob;

  UserModel({
    this.email,
    this.name,
    this.mob,
  });

  factory UserModel.fromMap(map) {
    return UserModel(
      email: map['email'],
      name: map['name'],
      mob: map['mob'],
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        "name": name,
        'mob': mob,
      };
}
