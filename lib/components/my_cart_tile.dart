import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mopizza/components/my_quantity_selector.dart';
import 'package:mopizza/models/cart_item.dart';
import 'package:mopizza/models/restaurant_provider.dart';
import 'package:provider/provider.dart';

class MyCartTile extends StatelessWidget {
  final CartItem cartItem;
  final bool readOnly;

  const MyCartTile({
    super.key,
    required this.cartItem,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // food image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      cartItem.food.imageUrl,
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // name and price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // food name
                      Text(
                        cartItem.food.name,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      // food price
                      Text(
                        '${cartItem.food.price.toString()} Da',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 14),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // increment or decrement quantity
                  QuantitySelector(
                    food: cartItem.food,
                    quantity: cartItem.quantity,
                    onIncrement: () => restaurant.addToCart(
                        cartItem.food, cartItem.selectedAddons),
                    onDecrement: () => restaurant.removeFromCart(cartItem),
                    readOnly: readOnly,
                  ),
                ],
              ),
            ),

            // addons
            SizedBox(
              height: cartItem.selectedAddons.isEmpty ? 0 : 60,
              child: ListView(
                padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
                scrollDirection: Axis.horizontal,
                children: cartItem.selectedAddons
                    .map((addon) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Row(
                              children: [
                                // addon name
                                Text(addon.name),

                                // addon price
                                Text('  (${addon.price.toString()} Da)'),
                              ],
                            ),
                            shape: StadiumBorder(
                              side: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                            ),
                            onSelected: (value) {},
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiary,
                            labelStyle: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
