class MyUser {
  String? id;
  String? image;
  String? username;
  String? email;

  MyUser({
    this.id,
    this.image,
    this.username,
    this.email,
  });
  MyUser.empty();

  MyUser.fromJson(Map<String, dynamic> json,this.id) {
    // id = json['id'];
    image = json['image'];
    username = json['username'];
    email = json['email'];
  }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   return data;
  // }
}
