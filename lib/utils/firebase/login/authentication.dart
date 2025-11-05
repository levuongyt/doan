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
      result=false;
    }
    return result;
  }

  Future<bool> signInWithGoogle() async {
    bool result = false;
    try {
      print('>>> Bước 1: Khởi tạo GoogleSignIn');
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      print('>>> Bước 2: Mở màn hình chọn tài khoản Google');
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print('>>> User hủy đăng nhập');
        return false;
      }
      
      print('>>> Bước 3: Lấy authentication token');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('>>> Bước 4: Tạo Firebase credential');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      print('>>> Bước 5: Đăng nhập vào Firebase');
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print('>>> Bước 6: Lưu user vào Firestore');
      final String uid = userCredential.user?.uid ?? '';
      final String name = googleUser.displayName ?? '';
      final String email = googleUser.email;
      await FirebaseStorageUtil().addUsers(
          uid: uid,
          email: email,
          name: name,
          ngayTao: DateTime.now(),
          tongSoDu: 0.0);
      
      print('>>> ✅ Đăng nhập thành công!');
      result = true;
    } catch (e) {
      print('>>> ❌ LỖI ĐĂNG NHẬP GOOGLE: $e');
      print('>>> Stack trace: ${StackTrace.current}');
      result = false;
    }
    return result;
  }


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

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
    } catch (e) {
      // Logout error
    }
  }
}
