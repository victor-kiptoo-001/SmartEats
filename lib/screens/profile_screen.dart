import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // 1. HEADER (The "Verified User" Look)
          SliverAppBar(
            expandedHeight: 200,
            backgroundColor: const Color(0xFF1B5E20),
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Vic Developer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Verified Saver",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. SETTINGS LIST
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              
              // Section: Account
              _buildSectionHeader("Account"),
              _buildListTile(Icons.person_outline, "Personal Details", "Edit name, phone"),
              _buildListTile(Icons.payment, "Payment Methods", "M-PESA connected"),
              _buildListTile(Icons.notifications_outlined, "Notifications", "On"),
              
              const SizedBox(height: 20),

              // Section: Business (The Pitch Hook)
              _buildSectionHeader("Business"),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9), // Light Green
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: ListTile(
                  leading: const Icon(Icons.store, color: Color(0xFF1B5E20)),
                  title: const Text(
                    "Register your Shop",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
                  ),
                  subtitle: const Text("Have leftover food? Sell it here."),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF1B5E20)),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Redirecting to Merchant Portal..."))
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Section: Support
              _buildSectionHeader("Support"),
              _buildListTile(Icons.help_outline, "Get Help", ""),
              _buildListTile(Icons.info_outline, "About SmartEats", "Version 1.0.0"),
              
              const SizedBox(height: 30),
              
              // Log Out
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Log Out"),
                ),
              ),
              const SizedBox(height: 50),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[800]),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle.isNotEmpty ? Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)) : null,
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[300]),
        onTap: () {},
      ),
    );
  }
}