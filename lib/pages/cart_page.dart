import 'package:flutter/material.dart';
import 'package:mopizza/components/my_button.dart';
import 'package:mopizza/components/my_cart_tile.dart';
import 'package:mopizza/models/restaurant_provider.dart';
import 'package:mopizza/screens/checkout_screen.dart';
import 'package:mopizza/screens/get_phone_number_screen.dart';
import 'package:mopizza/services/phone_verification_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<Restaurant, PhoneVerification>(
      builder: (context, restaurant, phoneVerification, child) {
        // cart
        final userCart = restaurant.cart;

        // scaffold UI
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.background,
            foregroundColor: Theme.of(context).colorScheme.tertiary,
            actions: [
              // clear all cart button
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text(
                          'Are you sure you want to clear the cart?'),
                      actions: [
                        // cancel button
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        // yes button
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            restaurant.clearCart();
                          },
                          child: const Text('Yes',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
              )
            ],
          ),
          body: Container(
            color: Colors.white,
            child: Column(
              children: [
                // list of cart
                Expanded(
                  child: Column(
                    children: [
                      userCart.isEmpty
                          ? const Expanded(
                              child: Center(
                                child: Text(
                                  "Cart is empty..",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: userCart.length,
                                itemBuilder: (context, index) {
                                  // get individual cart item
                                  final cartItem = userCart[index];

                                  // return cart tile UI
                                  return MyCartTile(cartItem: cartItem);
                                },
                              ),
                            ),
                    ],
                  ),
                ),

                // button to pay
                MyButton(
                  onTap: () {
                    if (userCart.isEmpty) {
                      // Show a SnackBar message if the cart is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Your cart is empty.'),
                        ),
                      );
                    } else {
                      if (phoneVerification.isPhoneVerified()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GetPhoneNumberScreen(),
                          ),
                        );
                      }
                    }
                  },
                  text: 'Go to checkout',
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }
}
