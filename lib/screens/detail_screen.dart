import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // IMPORT MAP
import 'package:latlong2/latlong.dart'; // IMPORT COORDINATES
import '../widgets/mpesa_sheet.dart';
import 'success_screen.dart';
import '../models/food_pack.dart';

class DetailScreen extends StatelessWidget {
  final FoodPack pack;

  const DetailScreen({super.key, required this.pack});

  @override
  Widget build(BuildContext context) {
    // ELDORET COORDINATES (Rupa's Mall area approximately)
    final LatLng shopLocation = const LatLng(0.514277, 35.269781); 

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. APP BAR (Keep existing code)
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

              // 2. CONTENT
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Value Pack", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
                              child: Text("KES ${pack.price.toStringAsFixed(0)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text("Contains items worth KES ${pack.originalPrice.toStringAsFixed(0)}", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 24),

                        // Time
                        _buildSectionTitle(Icons.access_time, "Pickup time"),
                        const SizedBox(height: 8),
                        Text("Today, ${pack.pickupTime}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 24),

                        // MAP SECTION (The Big Change)
                        _buildSectionTitle(Icons.location_on_outlined, "Location"),
                        const SizedBox(height: 8),
                        Container(
                          height: 200, // Taller map
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: shopLocation, // Center on Eldoret
                                initialZoom: 15.0,
                                interactionOptions: const InteractionOptions(flags: InteractiveFlag.none), // Disable scrolling so page scrolls
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.smart_eats',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: shopLocation,
                                      width: 40,
                                      height: 40,
                                      child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text("Uganda Road, Eldoret CBD", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),

          // 3. BUTTON
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
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (context) => MpesaSheet(
                      amount: pack.price,
                      onSuccess: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SuccessScreen()));
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                ),
                child: const Text("Reserve Now", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}