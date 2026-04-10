import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart'; // Add this for the 4 boxes
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _otpSent = false; // Track if we should show OTP boxes

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // --- Step 1: Request OTP ---
  void _handleSendOtp() async {
    if (_phoneController.text.isEmpty) return;

    setState(() => _isLoading = true);
    bool success = await _authService.sendOtp(_phoneController.text);
    setState(() => _isLoading = false);

    if (success && mounted) {
      setState(() => _otpSent = true); // Show the OTP boxes
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Sent successfully!")),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send OTP")),
      );
    }
  }

  // --- Step 2: Verify OTP (Triggered automatically) ---
  void _handleVerify(String code) async {
    setState(() => _isLoading = true);
    bool success = await _authService.login(_phoneController.text, code);
    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (mounted) {
      _otpController.clear(); // Clear boxes on failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP, try again")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Dating App")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome,", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text(_otpSent ? "Enter the code sent to your phone" : "Enter your phone to continue"),
            const SizedBox(height: 30),

            // Phone Input Field (Disabled once OTP is sent)
            TextField(
              controller: _phoneController,
              enabled: !_otpSent,
              decoration: InputDecoration(
                labelText: "Phone Number",
                prefixText: "+91 ",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 20),

            // Logic: Show "Request OTP" button OR "4-Box PIN" input
            if (!_otpSent)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSendOtp,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Send OTP"),
                ),
              )
            else ...[
              // The 4-Box PIN Input
              Center(
                child: Pinput(
                  length: 4,
                  controller: _otpController,
                  autofocus: true,
                  onCompleted: (pin) => _handleVerify(pin), // AUTO-TRIGGERS LOGIN
                  defaultPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _otpSent = false),
                  child: const Text("Edit Phone Number"),
                ),
              ),
            ],

            if (_isLoading && _otpSent)
              const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              )),
          ],
        ),
      ),
    );
  }
}