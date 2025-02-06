import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/class_model.dart';
import '../models/user_model.dart';

class ClassService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ClassModel?> createClass(ClassModel classModel) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('classes')
          .add(classModel.toFirestore());

      return ClassModel.fromFirestore(
          await docRef.get().then((doc) => doc.data() as Map<String, dynamic>),
          docRef.id
      );
    } catch (e) {
      print('Error creating class: $e');
      return null;
    }
  }

  Future<List<ClassModel>> getTeacherClasses(String teacherId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('classes')
          .where('teacherId', isEqualTo: teacherId)
          .get();

      return querySnapshot.docs
          .map((doc) => ClassModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id
      ))
          .toList();
    } catch (e) {
      print('Error fetching classes: $e');
      return [];
    }
  }

  Future<bool> addStudentToClass(String classId, String studentId) async {
    try {
      await _firestore
          .collection('classes')
          .doc(classId)
          .update({
        'studentIds': FieldValue.arrayUnion([studentId])
      });
      return true;
    } catch (e) {
      print('Error adding student to class: $e');
      return false;
    }
  }

  Future<List<UserModel>> getClassStudents(String classId) async {
    try {
      // First, get the list of student IDs from the class
      DocumentSnapshot classDoc = await _firestore
          .collection('classes')
          .doc(classId)
          .get();

      List<String> studentIds = List<String>.from(
          (classDoc.data() as Map<String, dynamic>)['studentIds'] ?? []
      );

      // Then fetch user details for these student IDs
      QuerySnapshot userQuery = await _firestore
          .collection('users')
          .where('uid', whereIn: studentIds)
          .get();

      return userQuery.docs
          .map((doc) => UserModel.fromFirestore(
          doc.data() as Map<String, dynamic>
      ))
          .toList();
    } catch (e) {
      print('Error fetching class students: $e');
      return [];
    }
  }
}