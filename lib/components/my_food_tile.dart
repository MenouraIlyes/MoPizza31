import 'package:flutter/material.dart';
import 'package:mopizza/models/food.dart';

class FoodTile extends StatelessWidget {
  final Food food;
  final void Function()? onTap;

  const FoodTile({
    super.key,
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  // text food details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(food.name),
                        Text(
                          '${food.price.toString()} Da',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.background),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          food.description,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 15),

                  // food image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      food.imageUrl,
                      height: 120,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Divider Line
          Divider(
            color: Theme.of(context).colorScheme.tertiary,
            endIndent: 25,
            indent: 25,
          ),
        ],
      ),
    );
  }
}
