import 'package:flutter/material.dart';
import 'package:mopizza/components/my_button.dart';
import 'package:mopizza/components/my_receipt.dart';
import 'package:mopizza/models/cart_item.dart';
import 'package:mopizza/services/firestore.dart';

class DeliveryProgressPage extends StatefulWidget {
  final List<CartItem> cartItems;

  const DeliveryProgressPage({
    super.key,
    required this.cartItems,
  });

  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
  // firestore
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
        title: const Text("Delivery in progress..."),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const MyReceipt(),

              // button to save order
              MyButton(
                onTap: () async {
                  try {
                    await firestoreService.addOrder(widget.cartItems);
                    Navigator.pop(context);
                  } catch (e) {
                    // Show an error message if the order fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save order: $e')),
                    );
                  }
                },
                text: 'Save order',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
