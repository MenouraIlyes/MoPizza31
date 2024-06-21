import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mopizza/pages/home_page.dart';
import 'package:mopizza/screens/verification_email_screen.dart';
import 'package:mopizza/services/auth.dart';
import 'package:mopizza/widgets/custom_text_button.dart';
import 'package:mopizza/widgets/custom_text_field.dart';

class LoginWithEmailScreen extends StatefulWidget {
  const LoginWithEmailScreen({super.key});

  @override
  State<LoginWithEmailScreen> createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends State<LoginWithEmailScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String passwordText = '';
  String emailText = '';
  final AuthService _authService = AuthService();

  Future<void> _loginWithEmail() async {
    _showLoadingDialog();
    User? user = await _authService.signInWithEmail(
      emailController.text,
      passwordController.text,
    );
    if (!mounted) return;
    Navigator.pop(context);

    if (user != null) {
      // If the user is successfully logged in, navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      // Show an error message if login failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed. Please check your credentials.'),
        ),
      );
    }
  }

  // loading indicator
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // email Icon
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 20),
                      child: Image.asset(
                        'assets/email.png',
                        width: 60,
                      ),
                    ),

                    // Descriptions
                    Text(
                      "Log in with your email",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Log in with your email and password\nOr get a login link via email.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // email textfield
                    CustomTextField(
                      controller: emailController,
                      labelText: 'Email',
                      onChanged: (value) {
                        // we can also set validation on password (if it's right)
                        setState(() {
                          emailText = value;
                        });
                      },
                    ),

                    const SizedBox(height: 30),

                    // password textfield
                    CustomTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      noIcon: false,
                      onChanged: (value) {
                        // we can also set validation on password (if it's right)
                        setState(() {
                          passwordText = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Forgot password?
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "I forgot my password?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // continue button
            Column(
              children: [
                Divider(
                  height: 40,
                  color: Colors.grey[200],
                ),
                CustomTextButton(
                  text: 'Login with password',
                  onPressed: () async {
                    await _loginWithEmail();
                  },
                  isDisabled: passwordText.isEmpty || emailText.isEmpty,
                ),

                const SizedBox(height: 15),

                // email link button
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmailVerificationScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.background),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Send me a login link',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
