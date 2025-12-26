import 'package:flutter/material.dart';

class MpesaSheet extends StatefulWidget {
  final double amount;
  final VoidCallback onSuccess; // The function that saves to Firebase

  const MpesaSheet({super.key, required this.amount, required this.onSuccess});

  @override
  State<MpesaSheet> createState() => _MpesaSheetState();
}

class _MpesaSheetState extends State<MpesaSheet> {
  bool _isLoading = false;
  final _phoneController = TextEditingController();

  void _handlePayment() async {
    setState(() => _isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context); // 1. Close the sheet
      widget.onSuccess();     // 2. TRIGGER THE SUCCESS SCREEN
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Confirm Payment", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text("Pay KES ${widget.amount.toStringAsFixed(0)} via M-PESA", style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 20),
          
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: "M-PESA Phone Number",
              hintText: "0712 345 678",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone_android),
            ),
          ),
          const SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handlePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50), // M-PESA Green
                foregroundColor: Colors.white,
              ),
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text("PAY NOW", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}