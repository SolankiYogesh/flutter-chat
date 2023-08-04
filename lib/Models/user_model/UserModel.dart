class UserModel {
  String? username;
  String? email;
  String? image;
  String? uid;

  UserModel({this.username, this.email, this.image, this.uid});

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    image = json['image'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['image'] = this.image;
    data['uid'] = this.uid;
    return data;
  }
}
