import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Active Order Card
          _buildOrderCard(
            context,
            status: "READY TO PICKUP",
            color: Colors.green,
            shop: "Java House - Eldoret",
            item: "Pastry Surprise Bag",
            code: "XJ-99-AB",
            time: "Today, 18:00 - 19:00",
          ),
          
          const SizedBox(height: 16),
          
          // Past Order Card (Greyed out)
          _buildOrderCard(
            context,
            status: "COLLECTED",
            color: Colors.grey,
            shop: "Naivas Bakery",
            item: "Bread Value Pack",
            code: "NV-22-OK",
            time: "Yesterday",
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, {
    required String status,
    required Color color,
    required String shop,
    required String item,
    required String code,
    required String time,
    bool isActive = true,
  }) {
    return Container(
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
                Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Big Code Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text("CODE", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text(code.split('-')[0], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(code.split('-')[1], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shop, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(item, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                      const SizedBox(height: 8),
                      Text("Pickup: $time", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                if (isActive)
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          )
        ],
      ),
    );
  }
}