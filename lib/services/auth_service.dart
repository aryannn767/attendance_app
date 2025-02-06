import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
    String? rfidUid,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      UserModel userModel = UserModel(
        uid: result.user!.uid,
        email: email,
        name: name,
        role: role,
        rfidUid: rfidUid,
      );

      await _firestore
          .collection('users')
          .doc(result.user!.uid)
          .set(userModel.toFirestore());

      return userModel;
    } catch (e) {
      print('Signup Error: $e');
      return null;
    }
  }

  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(result.user!.uid)
          .get();

      return UserModel.fromFirestore(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      print('SignIn Error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get user => _auth.authStateChanges();
}