import 'dart:async';
import 'package:flutter/material.dart';
import '../../home/presentation/customer_home_screen.dart';
import '../../orders/presentation/rider_dashboard_screen.dart';
import '../../orders/presentation/plant_hub_screen.dart';

enum AuthPortal { customer, partner }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthPortal _currentPortal = AuthPortal.customer;
  
  // Controllers
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());
  final TextEditingController _partnerPasscodeController = TextEditingController();

  // State
  bool _isOtpSent = false;
  bool _isLoading = false;
  int _timerSeconds = 30;
  Timer? _resendTimer;

  // Registered Whitelist DB for Riders and Vendors
  static const Map<String, String> _partnerRegistry = {
    '9826011111': 'rider',   // Ramesh Rider (Bhopal MP Nagar)
    '9826022222': 'rider',   // Suresh Rider (Arera Colony)
    '9826099999': 'vendor',  // Bhopal Bottling Plant Hub
  };

  @override
  void dispose() {
    _phoneController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    _partnerPasscodeController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timerSeconds = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  void _requestOtp() {
    final phone = _phoneController.text.trim();
    if (phone.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
      _showToast('Please enter a valid 10-digit Indian mobile number', isError: true);
      return;
    }

    if (_currentPortal == AuthPortal.partner) {
      // Check Whitelist Security Check
      if (!_partnerRegistry.containsKey(phone)) {
        _showAccessDeniedDialog();
        return;
      }
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isOtpSent = true;
      });
      _startTimer();
      _showToast('OTP sent successfully to +91 $phone');
    });
  }

  void _verifyOtpAndLogin() {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 4) {
      _showToast('Please enter the 4-digit verification code', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final phone = _phoneController.text.trim();

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (_currentPortal == AuthPortal.partner) {
        final role = _partnerRegistry[phone];
        if (role == 'rider') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const RiderDashboardScreen()),
          );
        } else if (role == 'vendor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const PlantHubScreen()),
          );
        }
      } else {
        // Customer Default Entry
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
        );
      }
    });
  }

  void _showAccessDeniedDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.shield_outlined, color: Color(0xFFDC2626)),
            SizedBox(width: 8),
            Text('Access Restricted', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ],
        ),
        content: const Text(
          'This mobile number is not registered in the Shodasha Partner & Operations Network.\n\nOnly verified Delivery Riders and Plant Hub Managers can access this portal.',
          style: TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _currentPortal = AuthPortal.customer;
                _isOtpSent = false;
              });
            },
            child: const Text('Login as Customer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showToast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: isError ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCustomer = _currentPortal == AuthPortal.customer;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Brand Hero Section with Delivery Illustration
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, bottom: 24, left: 20, right: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCustomer
                        ? [const Color(0xFFE8F5E9), const Color(0xFFDCFCE7)]
                        : [const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/login_hero.png',
                      height: 220,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        height: 180,
                        alignment: Alignment.center,
                        child: const Icon(Icons.water_drop_rounded, size: 90, color: Color(0xFF16A34A)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'SHODASHA MINERAL\nWATER SERVICE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF14532D),
                        letterSpacing: 0.8,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isCustomer
                          ? 'Pure 20L mineral water delivered directly to your doorstep in Bhopal'
                          : 'Operational Gateway for Authorized Riders & Plant Vendors',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Portal Switcher Tabs (Customer vs Partner)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (_isOtpSent) return;
                            setState(() => _currentPortal = AuthPortal.customer);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isCustomer ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: isCustomer
                                  ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person, size: 16, color: isCustomer ? const Color(0xFF16A34A) : const Color(0xFF64748B)),
                                const SizedBox(width: 6),
                                Text(
                                  'Customer App',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: isCustomer ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (_isOtpSent) return;
                            setState(() => _currentPortal = AuthPortal.partner);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !isCustomer ? const Color(0xFF0F172A) : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: !isCustomer
                                  ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock_outline, size: 16, color: !isCustomer ? Colors.white : const Color(0xFF64748B)),
                                const SizedBox(width: 6),
                                Text(
                                  'Partner / Staff',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: !isCustomer ? Colors.white : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Dynamic Auth Form (Step 1: Phone vs Step 2: OTP)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _isOtpSent ? _buildOtpSection() : _buildPhoneInputSection(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mobile Number',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          decoration: InputDecoration(
            counterText: '',
            prefixIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🇮🇳 +91', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF0F172A))),
                  SizedBox(width: 8),
                  VerticalDivider(width: 1, thickness: 1, indent: 14, endIndent: 14, color: Color(0xFFCBD5E1)),
                ],
              ),
            ),
            hintText: 'Enter 10-digit mobile number',
            hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF16A34A), width: 2)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _requestOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: _currentPortal == AuthPortal.customer ? const Color(0xFF16A34A) : const Color(0xFF0F172A),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: _isLoading
                ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                : Text(
                    _currentPortal == AuthPortal.customer ? 'Get Verification Code' : 'Verify Partner Credentials',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            _currentPortal == AuthPortal.customer
                ? 'By continuing, you agree to Shodasha Terms & Privacy Policy'
                : 'Partner Gateway is protected by Shodasha Operations Guard',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Verification Code', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                const SizedBox(height: 2),
                Text('Sent to +91 ${_phoneController.text}', style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
              ],
            ),
            TextButton(
              onPressed: () => setState(() => _isOtpSent = false),
              child: const Text('Edit Phone', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: Color(0xFF16A34A))),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 4 Modern OTP Input Boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            return SizedBox(
              width: 58,
              height: 58,
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF16A34A), width: 2)),
                ),
                onChanged: (val) {
                  if (val.isNotEmpty && index < 3) {
                    _otpFocusNodes[index + 1].requestFocus();
                  } else if (val.isEmpty && index > 0) {
                    _otpFocusNodes[index - 1].requestFocus();
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 20),

        // Resend Timer Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _timerSeconds > 0 ? 'Resend code in ${_timerSeconds}s' : 'Didn\'t receive OTP? ',
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
            ),
            if (_timerSeconds == 0)
              GestureDetector(
                onTap: _requestOtp,
                child: const Text(
                  'Resend OTP',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF16A34A)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),

        // Verify and Enter Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _verifyOtpAndLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: _currentPortal == AuthPortal.customer ? const Color(0xFF16A34A) : const Color(0xFF0F172A),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: _isLoading
                ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                : const Text(
                    'Confirm & Enter',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }
}