import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mopizza/services/phone_verification_provider.dart';
import 'package:mopizza/widgets/custom_text_button.dart';
import 'package:mopizza/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class GetPhoneNumberScreen extends StatefulWidget {
  const GetPhoneNumberScreen({super.key});

  @override
  State<GetPhoneNumberScreen> createState() => _GetPhoneNumberScreenState();
}

class _GetPhoneNumberScreenState extends State<GetPhoneNumberScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  String phoneText = '';
  Country selectedCountry = Country(
    phoneCode: '213',
    countryCode: "DZ",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Algeria',
    example: 'Algeria',
    displayName: 'Algeria',
    displayNameNoCountryCode: 'DZ',
    e164Key: '',
  );

  void sendPhoneNumber() {
    final ap = Provider.of<PhoneVerification>(context, listen: false);
    String phoneNumber = phoneText.trim();
    ap.continueWithPhone(context, '+${selectedCountry.phoneCode}$phoneNumber');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 35),
              child: Column(
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset('assets/phone.png'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Verify your phone number",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Add your phone number, we'll send you a verification code",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: _phoneNumberController,
                    labelText: 'Enter your phone number',
                    phoneNumber: true,
                    onChanged: (value) {
                      // we can also set validation on password (if it's right)
                      setState(() {
                        phoneText = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomTextButton(
                    isDisabled: phoneText.length < 9,
                    onPressed: () => sendPhoneNumber(),
                    text: 'Continue',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
