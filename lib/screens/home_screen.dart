import 'package:flutter/material.dart';
import '../models/food_pack.dart';
import '../widgets/food_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Very light grey background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFF1B5E20), size: 20),
            const SizedBox(width: 8),
            const Text(
              "Eldoret, CBD",
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            // THE HERO HEADER
            const Text(
              "Save food,\nsave money.",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                height: 1.1,
                letterSpacing: -1,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Grab a bag before it's gone.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            
            // THE LIST
            ...dummyPacks.map((pack) => FoodCard(pack: pack)).toList(),
          ],
        ),
      ),
    );
  }
}