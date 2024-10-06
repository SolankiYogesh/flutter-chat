class UserModel {
  String? username;
  String? email;
  String? image;
  String? uid;
  String? last_msg;

  UserModel({this.username, this.email, this.image, this.uid, this.last_msg});

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    image = json['image'];
    uid = json['uid'];
    last_msg = json['last_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['image'] = this.image;
    data['uid'] = this.uid;
    data['last_msg'] = this.last_msg;
    return data;
  }
}
