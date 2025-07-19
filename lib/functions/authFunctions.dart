import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

signup(String email, String password, String name) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // 👇 Update the display name
    await userCredential.user!.updateDisplayName(name);

    debugPrint("::::::::::::::::: ${FirebaseAuth.instance.currentUser?.displayName} ::::::::::::::::");
    print(":::::::::::::::::: success :::::::::::::::::");

    await userCredential.user!.reload(); // Refresh user info
    print('/////// Success ////////');
    print('Username set to: ${FirebaseAuth.instance.currentUser!.displayName}');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}


signin(String email, password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    print('/////// Success ////////');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}
