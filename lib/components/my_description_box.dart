import 'package:flutter/material.dart';

class MyDescriptionBox extends StatelessWidget {
  const MyDescriptionBox({super.key});

  @override
  Widget build(BuildContext context) {
    // textstyle
    var myPrimaryTextStyle =
        TextStyle(color: Theme.of(context).colorScheme.tertiary);
    var mySecondaryTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.tertiary,
      fontWeight: FontWeight.bold,
    );

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.tertiary),
          borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // delivery fee
          Column(
            children: [
              Text(
                "Delivery fee",
                style: mySecondaryTextStyle,
              ),
              Text(
                "50 Da Per Km",
                style: myPrimaryTextStyle,
              ),
            ],
          ),

          // delivery time
          Column(
            children: [
              Text(
                "Delivery time",
                style: mySecondaryTextStyle,
              ),
              Text(
                "15-30 min",
                style: myPrimaryTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
