class MyUser {
  String? id;
  String? image;
  String? firstName;
  String? lastName;
  String? email;

  MyUser({
    this.id,
    this.image,
    this.firstName,
    this.lastName,
    this.email,
  });
  MyUser.empty();

  MyUser.fromJson(Map<String, dynamic> json,this.id) {
    // id = json['id'];
    image = json['image'];
    firstName = json['firstname'];
    lastName = json['lastname'];
    email = json['email'];
  }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   return data;
  // }
}
