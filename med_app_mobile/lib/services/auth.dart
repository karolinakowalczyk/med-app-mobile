import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:med_app_mobile/models/user_patient.dart';
import 'package:med_app_mobile/providers/main_page_provider.dart';
import 'package:provider/provider.dart';

class AuthServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserPatient? _user;
  bool _isPhoneNumberDefined = false;

  bool get isPhoneNumberDefined => _isPhoneNumberDefined;

  void setIsPhoneNumberDefined(bool isDefined) {
    _isPhoneNumberDefined = isDefined;
    notifyListeners();
  }

  Future<UserPatient?> _userFromFirebase(User? user) async {
    if (user == null) {
      return null;
    }
    DocumentReference userDoc = _firestore.collection('patients').doc(user.uid);
    DocumentSnapshot data = await userDoc.get();

    if (data.exists) {
      UserPatient? loadedUser =
          UserPatient.fromJSON(user.uid, data.data(), false);
      /*
      if (loadedUser.phone.isEmpty) {
        String? phoneNumber = await showDialog<String>(
          context: context!,
          builder: (context) {
            TextEditingController _textEditingController =
                TextEditingController(text: '');
            return TextFieldAlertDialogHelper().mainAlertDialog(
              context: context,
              title: 'Please enter phone number for better contact!',
              actions: [
                TextButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    Navigator.of(context).pop(_textEditingController.text);
                  },
                ),
              ],
              labelText: 'Phone number',
              hintText: 'Enter phone number',
              textFieldController: _textEditingController,
            );
          },
        );
        await userDoc.update({'phone': phoneNumber});
        loadedUser.setPhoneNumber(phoneNumber.toString());
      }
*/
      if (loadedUser.phone.isEmpty) {
        // Provider.of<MainPageProvider>(context!, listen: false)
        //     .setIfPhoneNumberProvided(false);
        setIsPhoneNumberDefined(false);
      } else {
        // Provider.of<MainPageProvider>(context!, listen: false)
        //     .setIfPhoneNumberProvided(true);
        setIsPhoneNumberDefined(true);
      }
      setUser(loadedUser);
      return loadedUser;
    } else if (_auth.currentUser!.providerData[0].providerId == 'google.com') {
      User? currentUser = _auth.currentUser;
      setIsPhoneNumberDefined(false);
      /*
      String? phoneNumber = await showDialog<String>(
        context: context!,
        builder: (context) {
          TextEditingController _textEditingController =
              TextEditingController(text: '');
          return TextFieldAlertDialogHelper().mainAlertDialog(
            context: context,
            title: 'Please enter phone number for better contact!',
            actions: [
              TextButton(
                child: const Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop(_textEditingController.text);
                },
              ),
            ],
            labelText: 'Phone number',
            hintText: 'Enter phone number',
            textFieldController: _textEditingController,
          );
        },
      );
*/
      UserPatient? loadedUser = UserPatient(
        id: currentUser!.uid,
        name: currentUser.displayName ?? '',
        email: currentUser.email ?? '',
        // phone: phoneNumber ?? '',
        phone: currentUser.phoneNumber ?? '',
        google: true,
      );
      await _firestore
          .collection('patients')
          .doc(user.uid)
          .set(loadedUser.toJson());
      setUser(loadedUser);
      return loadedUser;
    } else {
      setIsPhoneNumberDefined(true);
      setUser(null);
      return null;
    }
  }

  Stream<UserPatient?> get user =>
      _auth.authStateChanges().asyncMap((user) async {
        return _userFromFirebase(user);
      });

  UserPatient? getUser() => _user;

  void setUser(UserPatient? user) {
    _user = user;
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    DocumentReference userDoc =
        _firestore.collection('patients').doc(_user!.id);
    await userDoc.update({'phone': phoneNumber});
  }

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
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential =
            await _auth.signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        // return userCredential.user;
      }
    }
  }

  Future<void> googleSignOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
      await _auth.signOut();
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
            google: false,
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
        await googleSignOut();
      }
      await _auth.signOut();
      setUser(null);
    } catch (e) {
      throw e.toString();
    }
  }
}
