import 'package:firebase_auth/firebase_auth.dart';
import 'package:med_app_mobile/models/user_patient.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserPatient? _user;

  UserPatient? _userFromFirebase(User? user) {
    return user != null
        ? UserPatient(
            id: user.uid,
            name: 'test',
            email: 'test@gmail.com',
            phone: '123456789')
        : null;
  }

  Stream<UserPatient?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  UserPatient? getUser() => _user;

  void setUser(UserPatient user) {
    _user = user;
  }

  Future<UserPatient?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(result.user);
    } catch (e) {
      return null;
    }
  }

  // Future<void> signUp(String email, String password, String name, String phone) {

  // }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      throw e.toString();
    }
  }
}
