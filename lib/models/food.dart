// food item
class Food {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final FoodCategory category;
  List<Addon> availabelAddons;

  Food({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.availabelAddons,
  });

  // Convert a Food object into a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category.toString().split('.').last,
      'availableAddons': availabelAddons.map((addon) => addon.toMap()).toList(),
    };
  }

  // Create a Food object from a map
  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      name: map['name'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      category: FoodCategory.values
          .firstWhere((e) => e.toString() == 'FoodCategory.${map['category']}'),
      availabelAddons: List<Addon>.from(
          map['availableAddons']?.map((x) => Addon.fromMap(x))),
    );
  }
}

// food categories
enum FoodCategory {
  pizzas,
  vip,
  family,
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

  // Convert an Addon object into a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }

  // Create an Addon object from a map
  factory Addon.fromMap(Map<String, dynamic> map) {
    return Addon(
      name: map['name'],
      price: map['price'],
    );
  }
}
