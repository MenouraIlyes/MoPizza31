// food item
class Food {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final FoodCategory category;
  List<Addon> availabeAddons;

  Food({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.availabeAddons,
  });
}

// food categories
enum FoodCategory {
  burgers,
  salads,
  sides,
  dessert,
  drinks,
}

// food supplements

class Addon {
  String name;
  double price;

  Addon({
    required this.name,
    required this.price,
  });
}
