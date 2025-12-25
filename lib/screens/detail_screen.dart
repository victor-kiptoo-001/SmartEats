import 'package:flutter/material.dart';
import '../widgets/mpesa_sheet.dart';
import 'success_screen.dart';
import '../models/food_pack.dart';

class DetailScreen extends StatelessWidget {
  final FoodPack pack;

  const DetailScreen({super.key, required this.pack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. THE FANCY SCROLLING APP BAR
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                backgroundColor: const Color(0xFF1B5E20),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    pack.restaurantName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        pack.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey),
                      ),
                      // Gradient to make text readable
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                            stops: [0.6, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. THE CONTENT
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Value Pack",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "KES ${pack.price.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1B5E20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Contains items worth at least KES ${pack.originalPrice.toStringAsFixed(0)}",
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                        
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 24),

                        // Pickup Time Section
                        _buildSectionTitle(Icons.access_time, "Pickup time"),
                        const SizedBox(height: 8),
                        Text(
                          "Today, ${pack.pickupTime}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Please arrive on time. The shop closes immediately after.",
                          style: TextStyle(color: Colors.grey[600]),
                        ),

                        const SizedBox(height: 24),

                        // What you get Section
                        _buildSectionTitle(Icons.shopping_bag_outlined, "What you get"),
                        const SizedBox(height: 8),
                        Text(
                          "You will receive a ${pack.category}. The contents depend on what hasn't sold today, so it's a surprise! It could be bread, pastries, or savory snacks.",
                          style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey[800]),
                        ),

                        const SizedBox(height: 24),

                        // Location Section
                        _buildSectionTitle(Icons.location_on_outlined, "Location"),
                        const SizedBox(height: 8),
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.map, size: 40, color: Colors.grey),
                                Text("Map Placeholder"),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 100), // Space for bottom button
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),

          // 3. THE FLOATING BUTTON (Corrected Logic)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // Allows keyboard to push it up
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => MpesaSheet(
                      amount: pack.price,
                      onSuccess: () {
                        // Navigate to Success Ticket
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SuccessScreen()),
                        );
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "Reserve Now",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1B5E20), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}