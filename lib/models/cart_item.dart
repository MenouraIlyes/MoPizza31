import 'package:mopizza/models/food.dart';

class CartItem {
  Food food;
  List<Addon> selectedAddons;
  int quantity;

  CartItem({
    required this.food,
    required this.selectedAddons,
    this.quantity = 1,
  });

  // getters
  double get totalPrice {
    double addonsPrice =
        selectedAddons.fold(0, (sum, addon) => sum + addon.price);
    return (food.price + addonsPrice) * quantity;
  }

  // Convert a CartItem object into a map
  Map<String, dynamic> toMap() {
    return {
      'food': food.toMap(),
      'selectedAddons': selectedAddons.map((addon) => addon.toMap()).toList(),
      'quantity': quantity,
    };
  }

  // Create a CartItem object from a map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      food: Food.fromMap(map['food']),
      selectedAddons:
          List<Addon>.from(map['selectedAddons']?.map((x) => Addon.fromMap(x))),
      quantity: map['quantity'],
    );
  }
}
