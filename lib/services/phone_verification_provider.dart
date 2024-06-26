import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mopizza/screens/get_phone_number_screen.dart';
import 'package:mopizza/screens/otp_screen.dart';

class PhoneVerification extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Check if the user's phone number is verified
  bool isPhoneVerified() {
    User? user = _firebaseAuth.currentUser;
    return user?.phoneNumber != null;
  }

  // Proceed to checkout or prompt for phone verification
  void proceedToCheckout(BuildContext context) {
    if (isPhoneVerified()) {
      // Navigate to the checkout screen
      Navigator.pushNamed(
          context, '/checkout'); // Assuming you have a named route for checkout
    } else {
      // Prompt for phone verification
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GetPhoneNumberScreen(), // Create a screen for phone number input
        ),
      );
    }
  }

  // Send the OTP code
  void continueWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          // Automatically sign in the user upon verification completion
          await _firebaseAuth.currentUser
              ?.linkWithCredential(phoneAuthCredential);
          Navigator.pushNamed(context,
              '/checkout'); // Navigate to checkout upon successful verification
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {
          // Handle code auto retrieval timeout
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('The SMS code has expired. Please request a new code.'),
          ));
        },
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
      ));
    }
  }

  // Verify OTP code
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOtp,
      );

      // Reauthenticate the current user with the phone credentials
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.linkWithCredential(creds);
      }

      _isLoading = false;
      notifyListeners();

      // Call the onSuccess callback
      onSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'session-expired') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The SMS code has expired. Please request a new code.'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message.toString()),
        ));
      }

      _isLoading = false;
      notifyListeners();
    }
  }
}
