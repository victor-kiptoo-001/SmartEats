import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

class VendorAddScreen extends StatefulWidget {
  const VendorAddScreen({super.key});

  @override
  State<VendorAddScreen> createState() => _VendorAddScreenState();
}

class _VendorAddScreenState extends State<VendorAddScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _selectedCategory = "Bakery";

  // Now we let you type the shop name!
  final _shopController = TextEditingController(); 
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();

  // POLISHED DATA: Auto-generate descriptions
  String _getDescription(String category) {
    switch (category) {
      case 'Bakery':
        return "A surprise bag of fresh baked goods. May contain croissants, baguettes, donuts, or sweet buns that didn't find a home today.";
      case 'Meals':
        return "Hearty leftover meals from the lunch rush. Could be rice & stew, fried chicken, or pasta. Ready to heat and eat!";
      case 'Groceries':
        return "Fresh produce box. Contains perfectly good fruits or vegetables that are slightly misshapen or ripe. Great for smoothies!";
      default:
        return "A mystery bag of delicious food saved from waste.";
    }
  }

  String _getImageForCategory(String category) {
    switch (category) {
      case 'Bakery':
        return 'https://images.unsplash.com/photo-1517433670267-08bbd4be890f?w=800&q=80'; // Better Bakery Image
      case 'Meals':
        return 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80';
      case 'Groceries':
        return 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=80';
      default:
        return 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80';
    }
  }

  void _postFood() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseFirestore.instance.collection('food_packs').add({
          'restaurantName': _shopController.text, // USES YOUR INPUT
          'category': _selectedCategory,
          'description': _getDescription(_selectedCategory), // SAVES POLISHED TEXT
          'imageUrl': _getImageForCategory(_selectedCategory),
          'originalPrice': double.parse(_priceController.text) * 2.0, // Higher perceived value
          'price': double.parse(_priceController.text),
          'quantityLeft': int.parse(_qtyController.text),
          'pickupTime': 'Today, 18:00 - 20:00',
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success! Posted Live.")));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vendor Portal")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Create New Offer", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Text("Make it sound delicious.", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),

              // 1. SHOP NAME INPUT
              TextFormField(
                controller: _shopController,
                decoration: const InputDecoration(
                  labelText: "Restaurant / Shop Name",
                  hintText: "e.g. Java House, Naivas",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.store),
                ),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 20),
              
              const Text("Select Category:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: ["Bakery", "Meals", "Groceries"].map((cat) {
                  return ChoiceChip(
                    label: Text(cat),
                    selected: _selectedCategory == cat,
                    selectedColor: Colors.green[100],
                    checkmarkColor: Colors.green[900],
                    onSelected: (bool selected) {
                      setState(() => _selectedCategory = cat);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Item Name", 
                  hintText: "e.g. Magic Pastry Bag",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Price (KES)", border: OutlineInputBorder()),
                      validator: (value) => value!.isEmpty ? "Required" : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Qty", border: OutlineInputBorder()),
                      validator: (value) => value!.isEmpty ? "Required" : null,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _postFood,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20), 
                    foregroundColor: Colors.white,
                    elevation: 3,
                  ),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("PUBLISH LIVE DEAL"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}