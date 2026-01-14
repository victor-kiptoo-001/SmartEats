import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: 'vic_demo_user')
            .snapshots(),
        builder: (context, snapshot) {
          
          // --- CALCULATION LOGIC ---
          int mealsSaved = 0;
          double moneySaved = 0;

          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            mealsSaved = docs.length; // Count total orders
            
            for (var doc in docs) {
              final data = doc.data() as Map<String, dynamic>;
              double price = (data['price'] ?? 0).toDouble();
              double original = (data['originalPrice'] ?? price).toDouble();
              
              // Only add savings if original price is higher
              moneySaved += (original - price);
            }
          }
          // -------------------------

          return CustomScrollView(
            slivers: [
              // HEADER
              SliverAppBar(
                expandedHeight: 280,
                backgroundColor: const Color(0xFF1B5E20),
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        const CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 40, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        const Text("Vic Developer", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        
                        // IMPACT STATS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStatBox(mealsSaved.toString(), "Meals\nSaved"),
                            const SizedBox(width: 12),
                            _buildStatBox("KES ${moneySaved.toStringAsFixed(0)}", "Money\nSaved"),
                            const SizedBox(width: 12),
                            _buildStatBox("${(mealsSaved * 2.5).toStringAsFixed(1)}kg", "CO2e\nAvoided"),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),

              // LIST ITEMS
              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),
                  _buildSectionHeader("Account"),
                  _buildListTile(Icons.person_outline, "Personal Details", "Edit name"),
                  _buildListTile(Icons.payment, "Payment Methods", "M-PESA connected"),
                  
                  const SizedBox(height: 20),
                  _buildSectionHeader("Business"),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.store, color: Color(0xFF1B5E20)),
                      title: const Text("Register your Shop", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                      subtitle: const Text("Join the fight against food waste."),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 50),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatBox(String value, String label) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 10, height: 1.2)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(title.toUpperCase(), style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[800]),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[300]),
      ),
    );
  }
}