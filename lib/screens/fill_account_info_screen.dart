import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mopizza/pages/home_page.dart';
import 'package:mopizza/services/auth.dart';
import 'package:mopizza/widgets/custom_text_button.dart';
import 'package:mopizza/widgets/custom_text_field.dart';

class FillAccountInfoScreen extends StatefulWidget {
  const FillAccountInfoScreen({super.key});

  @override
  State<FillAccountInfoScreen> createState() => _FillAccountInfoScreenState();
}

class _FillAccountInfoScreenState extends State<FillAccountInfoScreen> {
  // controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String firstNameText = '';
  String lastNameText = '';
  String passText = '';
  String emailText = '';

  final AuthService _authService = AuthService(); // Initialize AuthService

  // Separate method for handling email registration
  Future<void> _registerWithEmail(BuildContext context) async {
    _showLoadingDialog();
    try {
      User? user = await _authService.registerWithEmail(
        emailController.text,
        passController.text,
      );

      Navigator.pop(context); // Close the loading dialog

      if (user != null) {
        // If the user is successfully registered, navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        // Show a general error message if registration failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed. Please try again.'),
          ),
        );
      }
    } on EmailAlreadyInUseException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('The email address is already in use by another account.'),
        ),
      );
    } catch (e) {
      // Handle other exceptions that might occur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
        ),
      );
    }
  }

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
        actions: [
          TextButton(
            onPressed: () async {
              await _registerWithEmail(context);
            },
            child: Text(
              'Continue',
              style: TextStyle(
                color: firstNameText.isEmpty ||
                        lastNameText.isEmpty ||
                        passText.isEmpty ||
                        emailText.isEmpty
                    ? Colors.grey[400]
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
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
                        'assets/add.png',
                        width: 60,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),

                    // Descriptions
                    Text(
                      "Let's get you started!",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "First, let's create your MoPizza account.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // first name textfield
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          padding: const EdgeInsets.only(right: 7),
                          child: CustomTextField(
                            controller: firstNameController,
                            labelText: 'First Name',
                            onChanged: (value) {
                              // we can also set validation on password (if it's right)
                              setState(() {
                                firstNameText = value;
                              });
                            },
                          ),
                        ),

                        // last name textfield
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          padding: const EdgeInsets.only(right: 7),
                          child: CustomTextField(
                            controller: lastNameController,
                            labelText: 'Last Name',
                            onChanged: (value) {
                              // we can also set validation on password (if it's right)
                              setState(() {
                                lastNameText = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

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

                    const SizedBox(height: 20),

                    // password textfield
                    CustomTextField(
                      controller: passController,
                      labelText: 'Password',
                      noIcon: false,
                      onChanged: (value) {
                        // we can also set validation on password (if it's right)
                        setState(() {
                          passText = value;
                        });
                      },
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
                  text: 'Continue',
                  onPressed: () async {
                    await _registerWithEmail(context);
                  },
                  isDisabled: firstNameText.isEmpty ||
                      lastNameText.isEmpty ||
                      passText.isEmpty ||
                      emailText.isEmpty,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
