import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: 'vic_demo_user') // Filter ONLY. No orderBy here.
            .snapshots(),
        builder: (context, snapshot) {
          // 1. Handle Errors explicitly
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong: ${snapshot.error}"));
          }

          // 2. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 3. Empty State
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text("No orders yet", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  const Text("Go rescue some food!", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }

          // 4. Data Success - MANUAL SORTING
          // We get the list, then sort it ourselves to avoid the "Index" error
          var orders = snapshot.data!.docs.toList();
          orders.sort((a, b) {
            // Sort by 'orderDate' descending (newest first)
            Timestamp t1 = a['orderDate'] ?? Timestamp.now();
            Timestamp t2 = b['orderDate'] ?? Timestamp.now();
            return t2.compareTo(t1); 
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;
              
              final status = data['status'] ?? 'Active';
              final isActive = status == 'Active';
              final color = isActive ? Colors.green : Colors.grey;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    // Status Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: Row(
                        children: [
                          Icon(isActive ? Icons.watch_later : Icons.check_circle, size: 16, color: color),
                          const SizedBox(width: 8),
                          Text(isActive ? "READY TO PICKUP" : "COLLECTED", 
                               style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                          const Spacer(),
                          Text(data['pickupTime'] ?? '', style: TextStyle(color: color, fontSize: 12)),
                        ],
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Code Box
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                const Text("CODE", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                Text(
                                  (data['pickupCode'] ?? '000').toString().replaceFirst('ORD-', ''), 
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data['restaurantName'] ?? 'Shop', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(data['itemName'] ?? 'Surprise Bag', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                                const SizedBox(height: 4),
                                Text("KES ${data['price']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Swipe/Collect Button
                    if (isActive)
                      InkWell(
                        onTap: () {
                           FirebaseFirestore.instance
                               .collection('orders')
                               .doc(orders[index].id)
                               .update({'status': 'Collected'});
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(top: BorderSide(color: Colors.grey[200]!)),
                          ),
                          child: const Center(
                            child: Text("Tap to Collect", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}