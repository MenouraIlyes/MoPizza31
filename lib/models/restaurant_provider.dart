import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mopizza/models/cart_item.dart';
import 'package:mopizza/models/food.dart';

class Restaurant extends ChangeNotifier {
  // list of food menu
  final List<Food> _menu = [
    // pizzas
    Food(
      name: 'MARGARITA',
      description: 'Sauce Tomate , Mozzarella .',
      price: 500,
      imageUrl: 'lib/images/pizzas/margerita.webp',
      category: FoodCategory.pizzas,
      availabelAddons: [
        Addon(name: "Extra cheese", price: 200),
      ],
    ),
    Food(
      name: 'Napolitana',
      description: 'Sauce Tomate , Mozzarella , Anchois , Capres',
      price: 600,
      imageUrl: 'lib/images/pizzas/napolitana.jpg',
      category: FoodCategory.pizzas,
      availabelAddons: [
        Addon(name: "Extra cheese", price: 200),
        Addon(name: "Extra Anchois", price: 200),
      ],
    ),
    Food(
      name: 'Thon',
      description: 'Sauce Tomate , Thon , Capres , Mozzarella ',
      price: 700,
      imageUrl: 'lib/images/pizzas/thon.jpg',
      category: FoodCategory.pizzas,
      availabelAddons: [
        Addon(name: "Extra cheese", price: 200),
        Addon(name: "Extra Thon", price: 200),
      ],
    ),

    // Vip Pizzas
    Food(
      name: 'Quattro Fromagi',
      description: 'Créme roquefort , Mozzarella, Cheddar , Gruyére , Parmesan',
      price: 1200,
      imageUrl: 'lib/images/vip/four_cheese.jpg',
      category: FoodCategory.vip,
      availabelAddons: [],
    ),
    Food(
      name: 'Saumon Fumé',
      description: 'Créme Fraiche , Saumon Fumé , Mozzarella',
      price: 1200,
      imageUrl: 'lib/images/vip/saumon.jpg',
      category: FoodCategory.vip,
      availabelAddons: [],
    ),
    Food(
      name: 'Fruits di Mare',
      description:
          'Sauce Tomate , Mozzarella , Crevettes , Fruits Saisonnieres.',
      price: 1500,
      imageUrl: 'lib/images/vip/fruits_di_mare.jpg',
      category: FoodCategory.vip,
      availabelAddons: [],
    ),

    // family
    Food(
      name: 'Pizza 1 Mettre',
      description:
          'Sauce Tomate , Créme Roquefort , Poulet Fumé ,Crevettes , Viande , Thon , Mozzarella , Cheddar ',
      price: 4500,
      imageUrl: 'lib/images/family/1meter.jpg',
      category: FoodCategory.family,
      availabelAddons: [],
    ),

    // drinks
    Food(
      name: 'Coca Cola',
      description: 'Canette 24 cl',
      price: 100,
      imageUrl: 'lib/images/drinks/coke.png',
      category: FoodCategory.drinks,
      availabelAddons: [],
    ),
  ];

  // Getters
  List<Food> get menu => _menu;
  List<CartItem> get cart => _cart;

  // user cart
  final List<CartItem> _cart = [];

  // Restaurant coordinates
  final double restaurantLatitude = 35.71459180217602;
  final double restaurantLongitude = -0.5809025533727596;

  // Shipping fee
  double _shippingFee = 100.0;

  // Getter for shipping fee
  double get shippingFee => _shippingFee;

  // Setter for shipping fee
  set shippingFee(double fee) {
    _shippingFee = fee;
    notifyListeners();
  }

  /* O P E R A T I O N S */

  // add to cart
  void addToCart(Food food, List<Addon> selectedAddons) {
    // see if there is a cart item already with the same food and selected addons
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      // check if the food items are the same
      bool isSameFood = item.food == food;

      // check if the list of selected addons are the same
      bool isSameAddons =
          const ListEquality().equals(item.selectedAddons, selectedAddons);

      return isSameFood && isSameAddons;
    });

    // if item already exists, increase it's quantity
    if (cartItem != null) {
      cartItem.quantity++;
    }

    // otherwise, add a new cart item to the cart
    else {
      _cart.add(CartItem(food: food, selectedAddons: selectedAddons));
    }

    notifyListeners();
  }

  // remove from cart
  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }
    notifyListeners();
  }

  // get total price of cart
  double getTotalPrice() {
    double total = 0.0;

    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;

      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }
      total += itemTotal * cartItem.quantity;
    }

    return total;
  }

  // get total number of items in cart
  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }

    return totalItemCount;
  }

  // get final total price including shipping fee
  double getFinalTotalPrice() {
    double subtotal = getTotalPrice();
    return subtotal + _shippingFee;
  }

  // Calculate the shipping fee
  Future<void> calculateShippingFee(Position userPosition) async {
    double distanceInMeters = Geolocator.distanceBetween(
      restaurantLatitude,
      restaurantLongitude,
      userPosition.latitude,
      userPosition.longitude,
    );

    double distanceInKm = distanceInMeters / 1000.0;

    _shippingFee = distanceInKm * 50;
    notifyListeners();
  }

  // clear the cart
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  /* H E L P E R S */

  // generate a receipt
  String dispayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Here's your receipt.");
    receipt.writeln();

    // format the date to include up to seconds only
    String formattedDate =
        DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());

    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln('----------');
    receipt.writeln();

    for (final CartItem in _cart) {
      receipt.writeln(
          '${CartItem.quantity} x ${CartItem.food.name} - ${_formatPrice(CartItem.food.price)}');
      if (CartItem.selectedAddons.isNotEmpty) {
        receipt.writeln("  Add-ons: ${_formatAddons(CartItem.selectedAddons)}");
      }
      receipt.writeln();
    }

    receipt.writeln('----------');
    receipt.writeln();
    receipt.writeln('Total Items: ${getTotalItemCount()}');
    receipt.writeln('Subtotal Price: ${_formatPrice(getTotalPrice())}');
    receipt.writeln();

    receipt.writeln('----------');
    receipt.writeln();
    receipt.writeln('Shipping Fee: ${(shippingFee)}');
    receipt.writeln();

    receipt.writeln('----------');
    receipt.writeln();
    receipt.writeln('Total Price: ${_formatPrice(getFinalTotalPrice())}');

    return receipt.toString();
  }

  // format double value
  String _formatPrice(double price) {
    return "${price.toStringAsFixed(2)} Da";
  }

  // format list of addons into a string summary
  String _formatAddons(List<Addon> addons) {
    return addons
        .map((addon) => "${addon.name} (${_formatPrice(addon.price)})")
        .join(', ');
  }
}
