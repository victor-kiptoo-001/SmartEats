import 'package:flutter/material.dart';

class MpesaSheet extends StatefulWidget {
  final double amount;
  final VoidCallback onSuccess;

  const MpesaSheet({super.key, required this.amount, required this.onSuccess});

  @override
  State<MpesaSheet> createState() => _MpesaSheetState();
}

class _MpesaSheetState extends State<MpesaSheet> {
  bool _isLoading = false;
  final TextEditingController _phoneController = TextEditingController(text: "07");

  void _initiatePayment() async {
    setState(() => _isLoading = true);

    // 1. SIMULATE NETWORK DELAY (STK PUSH)
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.pop(context); // Close the sheet
      widget.onSuccess(); // Trigger the success ticket
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
          // Header
          Row(
            children: [
              // M-PESA Logo Placeholder (Green Box)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.money, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Lipa na M-PESA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("Pay KES ${widget.amount.toStringAsFixed(0)}", style: TextStyle(color: Colors.grey[600])),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),

          // Input
          const Text("Enter M-PESA Number", style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "07XX XXX XXX",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          const SizedBox(height: 24),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _initiatePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text("PAY NOW", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}