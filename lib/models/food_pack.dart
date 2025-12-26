class FoodPack {
  final String id;
  final String restaurantName;
  final String category; // e.g., "Baked Goods", "Meals"
  final String imageUrl;
  final double originalPrice;
  final double price;
  final String pickupTime;
  final int quantityLeft;

  FoodPack({
    required this.id,
    required this.restaurantName,
    required this.category,
    required this.imageUrl,
    required this.originalPrice,
    required this.price,
    required this.pickupTime,
    required this.quantityLeft,
  });
}

// DUMMY DATA (Kenyan Context - Fixed Images)
// Note: This is NOT 'final' so we can add new items to it at runtime.
List<FoodPack> dummyPacks = [
  FoodPack(
    id: '1',
    restaurantName: 'Java House - Eldoret',
    category: 'Pastry Surprise Bag',
    // Reliable Coffee/Pastry image
    imageUrl: 'https://images.unsplash.com/photo-1517433670267-08bbd4be890f?w=800&q=80', 
    originalPrice: 800,
    price: 250,
    pickupTime: '18:00 - 19:00',
    quantityLeft: 3,
  ),
  FoodPack(
    id: '2',
    restaurantName: 'Naivas Bakery',
    category: 'Bread & Buns Value Pack',
    // Reliable Bread image
    imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&q=80',
    originalPrice: 500,
    price: 150,
    pickupTime: '19:00 - 20:30',
    quantityLeft: 8,
  ),
  FoodPack(
    id: '3',
    restaurantName: 'Sizzlers',
    category: 'Lunch Leftovers (Fries/Chicken)',
    // Reliable Chicken/Fries image
    imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=800&q=80',
    originalPrice: 650,
    price: 200,
    pickupTime: '16:00 - 17:00',
    quantityLeft: 1,
  ),
];