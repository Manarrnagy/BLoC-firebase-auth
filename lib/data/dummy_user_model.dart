class DummyUser {
  String id;
  String firstname;
  String lastname;
  String email;
  String image;

  DummyUser(
      {
        required this.id,
        required this.firstname,
      required this.lastname,
      required this.email,
      required this.image});

  DummyUser copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? email,
    String? image,
  }) {
    return DummyUser(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      image: image ?? this.image,
    );
  }
}
