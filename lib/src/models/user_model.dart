class userInforAt {
/*
{
  "createdAt": "2023-10-28T06:41:13.530Z",
  "createdBy": 0,
  "id": 0,
  "name": "string"
}
*/

  String? createdAt;
  int? createdBy;
  int? id;
  String? name;

  userInforAt({
    this.createdAt,
    this.createdBy,
    this.id,
    this.name,
  });

  userInforAt.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt']?.toString();
    createdBy = json['createdBy']?.toInt();
    id = json['id']?.toInt();
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class UserInfor {
/*
{
  "avatar": "string",
  "email": "string",
  "firstName": "string",
  "lastName": "string",
  "nickName": "string",
  "password": "string",
  "phone": "string",
  "role": [
    {
      "createdAt": "2023-10-28T06:41:13.530Z",
      "createdBy": 0,
      "id": 0,
      "name": "string"
    }
  ],
  "status": "ACTIVE",
  "username": "string"
}
*/

  String? avatar;
  String? email;
  String? firstName;
  String? lastName;
  String? nickName;
  String? password;
  String? phone;
  List<userInforAt?>? role;
  String? status;
  String? username;

  UserInfor({
    this.avatar,
    this.email,
    this.firstName,
    this.lastName,
    this.nickName,
    this.password,
    this.phone,
    this.role,
    this.status,
    this.username,
  });

  UserInfor.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar']?.toString();
    email = json['email']?.toString();
    firstName = json['firstName']?.toString();
    lastName = json['lastName']?.toString();
    nickName = json['nickName']?.toString();
    password = json['password']?.toString();
    phone = json['phone']?.toString();
    if (json['role'] != null) {
      final v = json['role'];
      final arr0 = <userInforAt>[];
      v.forEach((v) {
        arr0.add(userInforAt.fromJson(v));
      });
      role = arr0;
    }
    status = json['status']?.toString();
    username = json['username']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['avatar'] = avatar;
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['nickName'] = nickName;
    data['password'] = password;
    data['phone'] = phone;
    if (role != null) {
      final v = role;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['role'] = arr0;
    }
    data['status'] = status;
    data['username'] = username;
    return data;
  }
}
