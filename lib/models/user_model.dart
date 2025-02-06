class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // 'student' or 'teacher'
  final String? rfidUid;
  final String? uuid;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.rfidUid,
    this.uuid,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      name: data['name'],
      role: data['role'],
      rfidUid: data['rfidUid'],
      uuid: data['uuid'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'rfidUid': rfidUid,
      'uuid': uuid,
    };
  }
}