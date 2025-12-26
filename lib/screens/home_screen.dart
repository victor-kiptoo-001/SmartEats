import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // IMPORT FIREBASE
import '../models/food_pack.dart';
import '../widgets/food_card.dart';
import 'vendor_add_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.location_on, color: Color(0xFF1B5E20), size: 20),
            SizedBox(width: 8),
            Text("Eldoret, CBD", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
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
            
            // THE REAL-TIME LIST
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('food_packs')
                    .orderBy('createdAt', descending: true) // Newest first
                    .snapshots(),
                builder: (context, snapshot) {
                  // 1. Loading State
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 2. Error State
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  // 3. Empty State
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No food available right now."));
                  }

                  // 4. Data State
                  final docs = snapshot.data!.docs;
                  
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      
                      // Convert Firebase Data to our FoodPack object
                      final pack = FoodPack(
                        id: docs[index].id,
                        restaurantName: data['restaurantName'] ?? 'Unknown',
                        category: data['category'] ?? 'General',
                        imageUrl: data['imageUrl'] ?? '',
                        originalPrice: (data['originalPrice'] ?? 0).toDouble(),
                        price: (data['price'] ?? 0).toDouble(),
                        pickupTime: data['pickupTime'] ?? '18:00',
                        quantityLeft: (data['quantityLeft'] ?? 0).toInt(),
                      );

                      return FoodCard(pack: pack);
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