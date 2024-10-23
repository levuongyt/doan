import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
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
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      result = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return result;
  }



  Future<bool> register(String email,String name, String password,double tongSoDu) async {
    bool result = false;
    try {
      final UserCredential credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid=credential.user?.uid ?? '';
      await FirebaseStorageUtil().addUsers(uid: uid, Email: email, name: name, ngayTao: DateTime.now(), tongSoDu: tongSoDu);

      result = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  ///fb
  Future<bool> signInWithFacebook() async {
    bool result = false;
    try {
      // await FirebaseAuth.instance.signOut();
      // await FacebookAuth.instance.logOut();
      final LoginResult loginResult = await FacebookAuth.instance.login();
      // Create a credential from the access token
      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(
            '${loginResult.accessToken?.tokenString}');
        await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        result = true;
      } else {
        print('Lỗi:  ');
        Get.snackbar('Lỗi', 'Moi thu lai');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Moi thu lai12');
      print('Looix : $e');
      //isLoading.value=false;
    }
    return result;
  }

  ///Đăng nhập Google
  Future<bool> signInWithGoogle() async{
    bool result=false;
    try{
      final GoogleSignIn googleSignIn = GoogleSignIn();

      ///dangxuat
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      result=true;
    }catch(e){
      result=false;
    }
    return result;
  }

  ///Reset mk(quen mat khau)

  Future<bool> sendPasswordResetEmail(String emailReset) async {
    bool result=false;
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailReset);
      result=true;
    }catch(e){

    }
    return result;
  }

}
