import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserServices {  
  Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    print(e.toString());
  }
}  

}
