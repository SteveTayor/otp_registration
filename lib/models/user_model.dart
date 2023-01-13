
class UserModel {
  late String uid;
  late String phoneNumber;

  UserModel({
    required this.uid,
    required this.phoneNumber,
  });

  UserModel.fromMap(String key, Map<String, dynamic> map,) {
    uid = key;
    phoneNumber = map['phoneNumber'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
    };
  }
}
