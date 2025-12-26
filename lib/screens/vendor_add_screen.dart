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
  String _selectedCategory = "Bakery"; // Default

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();

  // RELIABLE IMAGES
  String _getImageForCategory(String category) {
    switch (category) {
      case 'Bakery':
        return 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&q=80'; // Bread
      case 'Meals':
        return 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80'; // Salad/Meal
      case 'Groceries':
        return 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=80'; // Veggies
      default:
        return 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&q=80';
    }
  }

  void _postFood() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseFirestore.instance.collection('food_packs').add({
          'restaurantName': "Vic's Demo Shop", 
          'category': _selectedCategory,
          'imageUrl': _getImageForCategory(_selectedCategory), // SMART IMAGE
          'originalPrice': double.parse(_priceController.text) * 1.5,
          'price': double.parse(_priceController.text),
          'quantityLeft': int.parse(_qtyController.text),
          'pickupTime': '18:00 - 20:00',
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success! Saved to Cloud.")));
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
      appBar: AppBar(title: const Text("Vendor Mode")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Post New Pack", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              
              // CATEGORY SELECTOR
              const Text("Select Category:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ["Bakery", "Meals", "Groceries"].map((cat) {
                  return ChoiceChip(
                    label: Text(cat),
                    selected: _selectedCategory == cat,
                    selectedColor: Colors.green[100],
                    onSelected: (bool selected) {
                      setState(() => _selectedCategory = cat);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Description (e.g. Mixed Donuts)", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price (KES)", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Quantity", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _postFood,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20), foregroundColor: Colors.white),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("POST LIVE"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}