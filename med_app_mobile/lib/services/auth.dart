import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:med_app_mobile/models/user_patient.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  Future<UserPatient?> _userFromFirebase(User? user) async {
    if (user == null) {
      return null;
    }
    DocumentReference userDoc = _firestore.collection('patients').doc(user.uid);
    DocumentSnapshot data = await userDoc.get();

    if (data.exists) {
      UserPatient? loadedUser = UserPatient.fromJSON(user.uid, data.data());
      return loadedUser;
    } else if (_auth.currentUser!.providerData[0].providerId == 'google.com') {
      User? currentUser = _auth.currentUser;
      UserPatient? loadedUser = UserPatient(
        name: currentUser!.displayName ?? '',
        email: currentUser.email ?? '',
        phone: currentUser.phoneNumber ?? '',
      );
      return loadedUser;
    } else {
      return null;
    }
  }

  Stream<UserPatient?> get user =>
      _auth.authStateChanges().asyncMap((user) async {
        return _userFromFirebase(user);
      });

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      return;
    }
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await _auth.signInWithCredential(credential);
  }

  Future<void> googleSignOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signUp(
    String name,
    String phone,
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        DocumentReference newUserDoc =
            _firestore.collection('patients').doc(result.user!.uid);
        await newUserDoc.set(
          UserPatient(
            name: name,
            email: email,
            phone: phone,
          ).toJson(),
        );
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    try {
      if (_auth.currentUser!.providerData[0].providerId == 'google.com') {
        await signInWithGoogle();
      }
      return await _auth.signOut();
    } catch (e) {
      throw e.toString();
    }
  }
}
