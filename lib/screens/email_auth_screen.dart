import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mopizza/screens/login_with_email_screen.dart';
import 'package:mopizza/widgets/custom_text_button.dart';
import 'package:mopizza/widgets/custom_text_field.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  TextEditingController emailController = TextEditingController();
  String emailText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Continue',
              style: TextStyle(
                color: emailText.isEmpty
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
          children: [
            Expanded(
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
                    "What'\s your email?",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "We\'ll check if you have an account",
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
                      // we can also set validation on email (if it's right)
                      setState(() {
                        emailText = value;
                      });
                    },
                  )
                ],
              ),
            ),

            // continue button
            Divider(
              height: 40,
              color: Colors.grey[300],
            ),
            CustomTextButton(
              text: 'Continue',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginWithEmailScreen(),
                  ),
                );
              },
              isDisabled: emailText.isEmpty,
            ),
          ],
        ),
      ),
    );
  }
}
