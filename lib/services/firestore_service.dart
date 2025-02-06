import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserUuid(String userUid, String uuid) async {
    await _firestore.collection('users').doc(userUid).update({
      'uuid': uuid,
    });
  }

  Future<bool> validateUuidForRfid(String rfidUid) async {
    QuerySnapshot query = await _firestore
        .collection('users')
        .where('rfidUid', isEqualTo: rfidUid)
        .get();

    return query.docs.isNotEmpty;
  }

  Future<void> markAttendance(AttendanceModel attendance) async {
    await _firestore.collection('attendance').add(attendance.toFirestore());
  }

  Stream<List<AttendanceModel>> getClassAttendance(String classId) {
    return _firestore
        .collection('attendance')
        .where('classId', isEqualTo: classId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => AttendanceModel.fromFirestore(
        doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<List<UserModel>> getStudentsForClass(String classId) async {
    QuerySnapshot query = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'student')
        .where('classId', isEqualTo: classId)
        .get();

    return query.docs
        .map((doc) => UserModel.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }
}