class People {
  People(
      {required this.id,
      required this.name,
      required this.birthday,
      required this.biography,
      required this.profilePath,
      required this.birthPlace});

  factory People.fromJson(Map<String, dynamic> json) {
    return People(
      id: json['id'],
      name: json['name'],
      birthday: json['birthday'],
      biography: json['biography'],
      profilePath: json['profile_path'],
      birthPlace: json['place_of_birth'],
    );
  }

  final int id;
  final String name;
  final String? birthday;
  final String? biography;
  final String? birthPlace;
  final String? profilePath;
}
