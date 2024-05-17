class People {
  People(
      {required this.id,
      required this.name,
      required this.birthday,
      required this.biography});

  factory People.fromJson(Map<String, dynamic> json) {
    return People(
      id: json['id'],
      name: json['name'],
      birthday: json['birthday'],
      biography: json['biography'],
    );
  }

  final int id;
  final String name;
  final String? birthday;
  final String? biography;
}
