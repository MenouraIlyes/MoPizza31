import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  bool noIcon;
  Function(String)? onChanged;
  bool phoneNumber;

  CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.noIcon = true,
    this.onChanged,
    this.phoneNumber = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
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
  bool isObsecure = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObsecure,
      onChanged: widget.onChanged,
      controller: widget.controller,
      style: widget.phoneNumber
          ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
          : null,
      decoration: InputDecoration(
        prefix: widget.phoneNumber
            ? Container(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    '${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : null,
        suffixIconColor: Theme.of(context).colorScheme.primary,
        suffixIcon: widget.noIcon
            ? const SizedBox()
            : IconButton(
                onPressed: () {
                  setState(() {
                    isObsecure = !isObsecure;
                  });
                },
                icon: isObsecure
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              ),
        labelText: widget.labelText,
        contentPadding: const EdgeInsets.all(15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[200]!,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[200]!,
          ),
        ),
      ),
    );
  }
}
