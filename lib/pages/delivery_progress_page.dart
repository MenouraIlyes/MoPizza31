import 'package:flutter/material.dart';
import 'package:mopizza/components/my_button.dart';
import 'package:mopizza/components/my_receipt.dart';
import 'package:mopizza/models/restaurant_provider.dart';
import 'package:mopizza/services/firestore.dart';
import 'package:provider/provider.dart';

class DeliveryProgressPage extends StatefulWidget {
  const DeliveryProgressPage({Key? key}) : super(key: key);

  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
  final FirestoreService firestoreService = FirestoreService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<Restaurant>(context).cart;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            foregroundColor: Theme.of(context).colorScheme.tertiary,
            title: const Text("Delivery in progress..."),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const MyReceipt(),
                  SizedBox(height: 20),
                  MyButton(
                    onTap: () async {
                      setState(() {
                        isLoading = true; // Start loading
                      });
                      try {
                        await firestoreService.addOrder(cartItems);
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to save order: $e')),
                        );
                      } finally {
                        setState(() {
                          isLoading = false; // Stop loading
                        });
                      }
                    },
                    text: 'Save order',
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
