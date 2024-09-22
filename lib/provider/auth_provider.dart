import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingopanda_task/utils/colors.dart';
import 'package:overlay_support/overlay_support.dart';

enum Status { SignUp, Login, Authenticating, Authenticated }

class UserAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User? _user;
  String? _name;
  Status _status = Status.SignUp;
  String? error;

  User? get user => _user;
  String? get name => _name;

  Status get status => _status;
  void toggleLogin(Status authState) {
    _status = authState;
    notifyListeners();
  }

  UserAuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      print('User changed: $user');
      if (user == null) {
        _status = _status == Status.SignUp ? Status.SignUp : Status.Login;
      } else {
        _user = user;
        _status = Status.Authenticated;
      }
      notifyListeners();
    });
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      UserCredential creds = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user = creds.user;

      await createFetchUser(creds.user!,name);
      _status = Status.Authenticated;
      error = '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error = 'The password is weak.';
      } else if (e.code == 'email-already-in-use') {
        error = 'This email is already in use.';
      } else {
        error = e.code;
      }
      print(e.message);
      showSimpleNotification(
        Text(
          error ?? 'An error occurred.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: kPrimaryColor,
        elevation: 5,
        position: NotificationPosition.bottom,
      );
      _status = Status.SignUp;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      showSimpleNotification(
        const Text(
          'An error occurred.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: kPrimaryColor,
        elevation: 5,
        position: NotificationPosition.bottom,
      );
      _status = Status.SignUp;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      UserCredential creds = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = creds.user;

      await createFetchUser(_user!,'');
      _status = Status.Authenticated;
      print(_status);
      error = '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        error = 'Invalid login credentials.';
      } else if (e.code == 'user-not-found') {
        error = 'User doesn\'t exists.';
      } else {
        error = e.code;
      }
      print(e.message);
      showSimpleNotification(
        Text(
          error ?? 'An error occurred.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: kPrimaryColor,
        elevation: 5,
        position: NotificationPosition.bottom,
      );
      _status = Status.Login;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      showSimpleNotification(
        const Text(
          'An error occurred.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: kPrimaryColor,
        elevation: 5,
        position: NotificationPosition.bottom,
      );
      _status = Status.Login;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _auth.signOut();
      _status = Status.SignUp;
      _user = null;
      _name = null;
      error = '';
    } on Exception catch (e) {
      print(e.toString());
      showSimpleNotification(
        Text(
          e.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: kPrimaryColor,
        elevation: 5,
        position: NotificationPosition.bottom,
      );
      notifyListeners();
    }
  }

  Future<void> createFetchUser(User user, String name) async {
    try {
      var collectionRef = _firestore.collection('users');
      var doc = await collectionRef.doc(user.uid).get();

      if (doc.exists == false && name.isNotEmpty) {
        await collectionRef.doc(user.uid).set({
          "name": name[0].toUpperCase() + name.substring(1),
          "uid": user.uid,
          "email": user.email,
        });
        var value = await collectionRef.doc(user.uid).get();
        _name = value.get('name');
      } else {
        var value = await collectionRef.doc(user.uid).get();
        _name = value.get('name');
      }
      showSimpleNotification(
        Text(
          'Welcome $_name',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: kPrimaryColor,
        elevation: 5,
        position: NotificationPosition.bottom,
      );
      notifyListeners();
    } on FirebaseException catch (e) {
      error = "Firestore error: ${e.message}";
      print(e.message);
      showSimpleNotification(
        Text(
          error ?? 'An error occurr;ed.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: kPrimaryColor,
        elevation: 5,
        position: NotificationPosition.bottom,
      );
      _status = Status.SignUp;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      showSimpleNotification(
        Text(
          e.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: kPrimaryColor,
        elevation: 5,
        position: NotificationPosition.bottom,
      );
      _status = Status.SignUp;
      notifyListeners();
    }
  }
}
