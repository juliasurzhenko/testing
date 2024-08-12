import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static String verifyId = "";

  Stream<User?> get authChanges => _firebaseAuth.authStateChanges();

  // Send OTP to user
  static Future<void> sentOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    try {
      print("Attempting to send OTP to +380$phone");
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+380$phone",
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          // Auto-retrieval or instant verification case
          print("Verification completed automatically.");
          nextStep(); // You might want to handle this differently
        },
        verificationFailed: (FirebaseAuthException error) async {
          // Handle verification failure
          print("Verification failed with error: ${error.message}");
          errorStep();
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          // Code sent successfully
          print("OTP code sent successfully. Verification ID: $verificationId");
          verifyId = verificationId;
          nextStep();
        },
        codeAutoRetrievalTimeout: (String verificationId) async {
          // Auto-retrieval timeout
          print(
              "Code auto-retrieval timeout. Verification ID: $verificationId");
          verifyId = verificationId;
        },
      );
    } catch (e) {
      print("Error in sending OTP: $e");
      errorStep();
    }
  }

  // Verify code and login
  static Future<String> loginWithOtp({required String otp}) async {
    try {
      final PhoneAuthCredential cred = PhoneAuthProvider.credential(
        verificationId: verifyId,
        smsCode: otp,
      );

      final UserCredential user =
          await _firebaseAuth.signInWithCredential(cred);
      if (user.user != null) {
        print("User signed in successfully: ${user.user!.uid}");
        return "Success";
      } else {
        print("Error in OTP login: User is null");
        return "Error in OTP login";
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException during login: ${e.message}");
      return e.message.toString();
    } catch (e) {
      print("Error during login with OTP: $e");
      return e.toString();
    }
  }
}
