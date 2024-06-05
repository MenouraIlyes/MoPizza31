import 'package:mopizza/models/food.dart';

class CartItem {
  Food food;
  List<Addon> selectedAddons;
  int quantiy;

  CartItem({
    required this.food,
    required this.selectedAddons,
    this.quantiy = 1,
  });

  // getters
  double get totalPrice {
    double addonsPrice =
        selectedAddons.fold(0, (sum, addon) => sum + addon.price);
    return (food.price + addonsPrice) * quantiy;
  }
}
