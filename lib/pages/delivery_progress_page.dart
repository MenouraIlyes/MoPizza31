import 'package:flutter/material.dart';
import 'package:mopizza/components/my_receipt.dart';

class DeliveryProgressPage extends StatelessWidget {
  const DeliveryProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Delivery in progress..."),
        centerTitle: true,
      ),
      body: const Column(
        children: [
          MyReceipt(),
        ],
      ),
    );
  }
}
