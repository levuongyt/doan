import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../storage/firebase_storage.dart';

class FireBaseUtil {
  static final FireBaseUtil singleton = FireBaseUtil._internal();

  factory FireBaseUtil() {
    return singleton;
  }

  FireBaseUtil._internal();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> login(String email, String password) async {
    bool result = false;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      result = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {
      }
    }
    return result;
  }

  Future<bool> register(
      String email, String name, String password, double tongSoDu) async {
    bool result = false;
    try {
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user?.uid ?? '';
      await FirebaseStorageUtil().addUsers(
          uid: uid,
          email: email,
          name: name,
          ngayTao: DateTime.now(),
          tongSoDu: tongSoDu);

      result = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {
      }
    } catch (e) {
    }
    return result;
  }

  ///Đăng nhập Google
  Future<bool> signInWithGoogle() async {
    bool result = false;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      ///dangxuat
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final String uid = userCredential.user?.uid ?? '';
      final String name = googleUser?.displayName ?? '';
      final String email = googleUser?.email ?? '';
      await FirebaseStorageUtil().addUsers(
          uid: uid,
          email: email,
          name: name,
          ngayTao: DateTime.now(),
          tongSoDu: 0.0);
      result = true;
    } catch (e) {
      result = false;
    }
    return result;
  }

  ///Reset mk(quen mat khau)

  Future<bool> sendPasswordResetEmail(String emailReset) async {
    bool result = false;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailReset);
      result = true;
    } catch (e) {
      result = false;
    }
    return result;
  }
}
