import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _selectedFrequency = 'Daily'; // Daily, Alternate, Custom
  int _canQuantity = 1;
  bool _isPaused = false;
  final Set<int> _pausedDates = {14, 15, 16}; // Example pre-paused vacation dates
  final Set<int> _deliveredDates = {1, 2, 3, 4, 5, 6, 7}; // Oct dates

  final List<String> _frequencies = ['Daily', 'Alternate Days', 'Custom Days'];

  void _togglePauseDelivery() {
    setState(() {
      _isPaused = !_isPaused;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _isPaused ? Colors.orange.shade800 : AppColors.primary,
        content: Text(
          _isPaused
              ? 'Subscription paused! Deliveries put on hold.'
              : 'Subscription resumed! Water deliveries active.',
        ),
      ),
    );
  }

  void _showCustomPlanDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Custom Delivery Days', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CheckboxListTile(value: true, onChanged: null, title: Text('Monday')),
            CheckboxListTile(value: false, onChanged: null, title: Text('Tuesday')),
            CheckboxListTile(value: true, onChanged: null, title: Text('Wednesday')),
            CheckboxListTile(value: false, onChanged: null, title: Text('Thursday')),
            CheckboxListTile(value: true, onChanged: null, title: Text('Friday')),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('SAVE DAYS'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'WATER SUBSCRIPTION',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_circle_fill_rounded : Icons.pause_circle_filled_rounded, color: Colors.white),
            onPressed: _togglePauseDelivery,
            tooltip: _isPaused ? 'Resume Plan' : 'Pause Vacation Mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _isPaused ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _isPaused ? const Color(0xFFFDE68A) : const Color(0xFFBBF7D0)),
              ),
              child: Row(
                children: [
                  Icon(
                    _isPaused ? Icons.pause_circle_outline_rounded : Icons.check_circle_outline_rounded,
                    color: _isPaused ? const Color(0xFFB45309) : const Color(0xFF15803D),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isPaused ? 'Subscription On Pause' : 'Active Subscription: 20L Can Daily',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _isPaused ? const Color(0xFF92400E) : const Color(0xFF166534),
                          ),
                        ),
                        Text(
                          _isPaused ? 'Deliveries resumed automatically next week' : 'Next Drop: Tomorrow Morning (8:00 AM - 3:00 PM)',
                          style: TextStyle(
                            fontSize: 11,
                            color: _isPaused ? const Color(0xFFB45309) : const Color(0xFF15803D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _togglePauseDelivery,
                    child: Text(
                      _isPaused ? 'RESUME' : 'PAUSE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: _isPaused ? const Color(0xFF92400E) : const Color(0xFF166534),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Plan Frequency Switcher
            const Text(
              'SELECT SUBSCRIPTION PATTERN',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            Row(
              children: _frequencies.map((freq) {
                final isSelected = _selectedFrequency == freq;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedFrequency = freq);
                      if (freq == 'Custom Days') {
                        _showCustomPlanDialog();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            freq == 'Daily' ? Icons.calendar_today_rounded : (freq == 'Alternate Days' ? Icons.repeat_rounded : Icons.tune_rounded),
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            size: 18,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            freq,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Daily Bottle Quantity Counter
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Cans Per Delivery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                      Text('Standard 20-Litre Pure Mineral Water', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _canQuantity > 1 ? () => setState(() => _canQuantity--) : null,
                        icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                      ),
                      Text('$_canQuantity', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                      IconButton(
                        onPressed: () => setState(() => _canQuantity++),
                        icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // October 2026 Delivery Calendar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'DELIVERY CALENDAR (OCTOBER 2026)',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
                ),
                Text(
                  'Tap date to skip',
                  style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text('M', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textSecondary)),
                      Text('T', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textSecondary)),
                      Text('W', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textSecondary)),
                      Text('T', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textSecondary)),
                      Text('F', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textSecondary)),
                      Text('S', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textSecondary)),
                      Text('S', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                  const Divider(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 31,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                    ),
                    itemBuilder: (ctx, idx) {
                      final day = idx + 1;
                      final isDelivered = _deliveredDates.contains(day);
                      final isPausedDay = _pausedDates.contains(day);
                      final isToday = day == 7;

                      Color bg = AppColors.background;
                      Color txt = AppColors.textPrimary;
                      if (isDelivered) {
                        bg = const Color(0xFFDCFCE7);
                        txt = const Color(0xFF15803D);
                      } else if (isPausedDay) {
                        bg = const Color(0xFFFEE2E2);
                        txt = const Color(0xFFB91C1C);
                      }

                      return GestureDetector(
                        onTap: () {
                          if (!isDelivered) {
                            setState(() {
                              if (_pausedDates.contains(day)) {
                                _pausedDates.remove(day);
                              } else {
                                _pausedDates.add(day);
                              }
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isToday ? AppColors.primary : Colors.transparent,
                              width: isToday ? 2 : 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$day',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isToday ? FontWeight.w900 : FontWeight.bold,
                              color: txt,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _legend(const Color(0xFFDCFCE7), 'Delivered'),
                      _legend(const Color(0xFFFEE2E2), 'Skipped / Paused'),
                      _legend(AppColors.background, 'Scheduled'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Plan CTA
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.primaryDark,
                      content: Text('Plan Confirmed: $_canQuantity Can ($_selectedFrequency)'),
                    ),
                  );
                },
                child: const Text('UPDATE SUBSCRIPTION ROUTINE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legend(Color color, String text) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2), border: Border.all(color: Colors.black12)),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
      ],
    );
  }
}