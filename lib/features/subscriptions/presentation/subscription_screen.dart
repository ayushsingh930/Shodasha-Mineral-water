import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _selectedFrequency = 'Daily';
  String _selectedSlot = 'Morning (6:30 AM - 8:30 AM)';
  int _cansPerDelivery = 1;
  bool _isPaused = false;
  bool _isLoading = false;

  final List<String> _frequencies = ['Daily', 'Alternate Days', 'Weekly 3 Days'];
  final List<String> _slots = [
    'Morning (6:30 AM - 8:30 AM)',
    'Evening (5:00 PM - 7:00 PM)'
  ];

  Future<void> _saveSubscription() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('subscriptions').add({
        'planName': '$_selectedFrequency Plan',
        'frequency': _selectedFrequency,
        'slot': _selectedSlot,
        'quantity': _cansPerDelivery,
        'isPaused': _isPaused,
        'pricePerCan': 35, // Discounted for subscribers
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'ACTIVE',
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.primaryDark,
            content: Text('Subscription Activated Successfully!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Failed to save subscription. Check network.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'WATER SUBSCRIPTIONS',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pause/Resume Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _isPaused ? const Color(0xFFFEF3C7) : AppColors.surface,
                borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                border: Border.all(
                  color: _isPaused ? AppColors.accentDark : AppColors.border,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isPaused ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                        color: _isPaused ? AppColors.accentDark : AppColors.primary,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isPaused ? 'Subscription Paused' : 'Subscription Active',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            _isPaused ? 'No deliveries scheduled' : 'Deliveries running normally',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: !_isPaused,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _isPaused = !val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Frequency Options
            const Text(
              'DELIVERY FREQUENCY',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            Row(
              children: _frequencies.map((freq) {
                final isSelected = _selectedFrequency == freq;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFrequency = freq),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withOpacity(0.12) : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        freq,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Preferred Slot
            const Text(
              'PREFERRED TIME SLOT',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            Column(
              children: _slots.map((slot) {
                final isSelected = _selectedSlot == slot;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSlot = slot),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent.withOpacity(0.15) : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? AppColors.accentDark : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              slot.contains('Morning') ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
                              color: isSelected ? AppColors.accentDark : AppColors.textSecondary,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              slot,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppColors.textOnAccent : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded, color: AppColors.accentDark, size: 20),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Quantity Selection
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cans Per Delivery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('20L Mineral Water Can', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_cansPerDelivery > 1) {
                            setState(() => _cansPerDelivery--);
                          }
                        },
                        icon: const Icon(Icons.remove_circle, color: AppColors.primary, size: 28),
                      ),
                      Text(
                        '$_cansPerDelivery',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _cansPerDelivery++),
                        icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 28),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveSubscription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'ACTIVATE SUBSCRIPTION',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.8),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
