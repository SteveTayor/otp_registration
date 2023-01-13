// ignore_for_file: unnecessary_null_comparison, prefer_conditional_assignment, deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // import the Firebase Auth package
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_messaging_service/screens/home/home.dart';
import '../../models/user_model.dart';
import '../../services/user_services.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  late String _phoneNumber;
  late String _verificationId;
  int? _resendOtp;
  bool _isCodeSent = false;

  final _key = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  final UserServices userServices = UserServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            if (!_isCodeSent) mobilePhoneNumberVerification(context),
            if (_isCodeSent) otpVerification(context),
          ],
        ),
      ),
    );
  }

  mobilePhoneNumberVerification(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 200, left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    const Text(
                      'Enter',
                      style: TextStyle(
                        fontSize: 53,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'Your Mobile Number',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'e.g(+2341234567890)\n',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const Text(
                      "And please wait for verification",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.phone_iphone,
                          color: Colors.cyan,
                        ),
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Enter Mobile Number...",
                        fillColor: Colors.white70,
                      ),
                      onChanged: (value) {
                        _phoneNumber = value;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 1.0,
                color: Colors.deepOrange,
                child: const Padding(
                  padding: EdgeInsets.only(
                    top: 8.0,
                    left: 140,
                    right: 140,
                    bottom: 8,
                  ),
                  child: Text(
                    "Next",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                onPressed: () {
                  _phoneNumber == null ? null : sendOtp();
                  _key.currentState?.showSnackBar(
                    const SnackBar(
                      content:
                          Text("Please wait Your account is being verified..."),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  otpVerification(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 28,
                  right: 28,
                  bottom: 0,
                  top: 280,
                ),
                child: Column(
                  children: [
                    const Text(
                      "We've sent you a verification code.",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Enter OTP",
                        fillColor: Colors.white70,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Did not get otp',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              sendOtp();
                            },
                            child: Text(
                              'Resend?',
                              style: TextStyle(
                                color: Colors.deepOrange.shade700,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 500),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 68.0,
                        left: 28,
                      ),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () {
                          verifyOtp();
                        },
                        elevation: 1.0,
                        color: Colors.deepOrange,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            top: 10.0,
                            left: 100,
                            right: 120,
                            bottom: 10,
                          ),
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future sendOtp() async {
    _phoneNumber =
        _phoneController.text; // add the country code to the phone number

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (credential) {
          verifyOtp();
        },
        verificationFailed: (error) {
          print(error);
          _key.currentState?.showSnackBar(
            SnackBar(
              dismissDirection: DismissDirection.horizontal,
              backgroundColor: Colors.red.shade800,
              padding: const EdgeInsets.all(16.0),
              content: const Text('Something went wrong, Try again later'),
            ),
          );
        },
        codeSent: (verificationId, [forceResendingToken]) {
          setState(() {
            _isCodeSent = true;
            _verificationId = verificationId;
            _resendOtp = forceResendingToken;

            _key.currentState?.showSnackBar(
              const SnackBar(
                content: Text('OTP has been successfully send'),
              ),
            );
          });
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
        },
        forceResendingToken: _resendOtp,
      );
    } catch (e) {
      rethrow;
    }
  }

  verifyOtp() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseDatabase database = FirebaseDatabase.instance;
    AuthCredential? credential;
    if (credential == null) {
      credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _codeController.text,
      );
    }

    // sign in or create the user
    User? user = (await auth.signInWithCredential(credential)).user;
    if (user == null) {
      user = UserModel(
        uid: (auth.currentUser)!.uid,
        phoneNumber: _phoneNumber,
      ) as User?;
      database.reference().child('users').child(user!.uid).set(user as Map);
      return user;
    }

    // navigate to the user list screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }
}
