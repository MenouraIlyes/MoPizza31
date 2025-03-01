import 'package:flutter/material.dart';
import 'package:mopizza/models/food.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final Food food;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool readOnly;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.food,
    required this.onDecrement,
    required this.onIncrement,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!readOnly) // Only show decrement button if not readOnly
            // decrease button
            GestureDetector(
              onTap: onDecrement,
              child: const Icon(
                Icons.remove,
                size: 20,
              ),
            ),

          // quantity count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: 20,
              child: Center(
                child: Text(
                  quantity.toString(),
                ),
              ),
            ),
          ),

          if (!readOnly) // Only show decrement button if not readOnly
            // increase button
            GestureDetector(
              onTap: onIncrement,
              child: const Icon(
                Icons.add,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}
