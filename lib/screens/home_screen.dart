import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // IMPORT FIREBASE
import '../models/food_pack.dart';
import '../widgets/food_card.dart';
import 'vendor_add_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _secretTaps = 0;
  bool _isVendorMode = false;

  void _activateSecret() {
    setState(() {
      _secretTaps++;
      if (_secretTaps >= 5) {
        _isVendorMode = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("👨‍🍳 Vendor Mode Unlocked! Long press items to delete."))
        );
      }
    });
  }

  // NEW: Function to delete item
  void _deleteItem(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete this item?"),
        content: const Text("This will remove it from the database permanently."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              // Delete from Firebase
              await FirebaseFirestore.instance.collection('food_packs').doc(docId).delete();
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Item Deleted"))
                );
              }
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: GestureDetector(
          onTap: _activateSecret, 
          child: const Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFF1B5E20), size: 20),
              SizedBox(width: 8),
              Text(
                "Eldoret, CBD", 
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)
              ),
            ],
          ),
        ),
        actions: [
          if (_isVendorMode)
            IconButton(
              icon: const Icon(Icons.add_business, color: Color(0xFF1B5E20)),
              onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const VendorAddScreen()));
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Live from Cloud", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(height: 24),
            
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('food_packs')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No food available right now."));
                  }

                  final docs = snapshot.data!.docs;
                  
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final pack = FoodPack(
                        id: docs[index].id,
                        restaurantName: data['restaurantName'] ?? 'Unknown',
                        category: data['category'] ?? 'General',
                        // READ THE NEW DESCRIPTION
                        description: data['description'] ?? 'Surprise bag containing unsold items.', 
                        imageUrl: data['imageUrl'] ?? '',
                        originalPrice: (data['originalPrice'] ?? 0).toDouble(),
                        price: (data['price'] ?? 0).toDouble(),
                        pickupTime: data['pickupTime'] ?? '18:00',
                        quantityLeft: (data['quantityLeft'] ?? 0).toInt(),
                      );
                      
                      // WRAP WITH DELETE DETECTOR
                      return InkWell(
                        // If vendor mode is ON, allow Long Press. If OFF, do nothing.
                        onLongPress: _isVendorMode ? () => _deleteItem(docs[index].id) : null,
                        child: FoodCard(pack: pack),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}