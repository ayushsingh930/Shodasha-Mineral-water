import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/subscription_service.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  void _showNewPlanModal(BuildContext context) {
    int selectedCans = 1;
    String selectedFreq = 'Daily (7:00 AM)';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final double cost = selectedCans * 65.0;

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SET UP 7:00 AM MILK-RUN SCHEDULE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('Fresh mineral water dropped at your door every morning.', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                  const SizedBox(height: 18),
                  
                  const Text('SELECT FREQUENCY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Daily (7:00 AM)', 'Alternate Days', 'Weekdays (Mon-Fri)'].map((freq) {
                      final isSelected = selectedFreq == freq;
                      return ChoiceChip(
                        label: Text(freq, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 12)),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        onSelected: (val) {
                          if (val) setModalState(() => selectedFreq = freq);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  const Text('CANS PER DROP', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              onPressed: () {
                                if (selectedCans > 1) setModalState(() => selectedCans--);
                              },
                            ),
                            Text('$selectedCans Can${selectedCans > 1 ? "s" : ""}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              onPressed: () {
                                setModalState(() => selectedCans++);
                              },
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text('Rs ${cost.toStringAsFixed(0)} / drop', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        SubscriptionNotifier.instance.addNewSubscription(
                          title: '$selectedCans x 20L Chilled Cans',
                          frequency: selectedFreq,
                          cans: selectedCans,
                          price: cost,
                        );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(backgroundColor: Color(0xFF16A34A), content: Text('7:00 AM Morning Plan Activated!')),
                        );
                      },
                      icon: const Icon(Icons.alarm_on_rounded, size: 20),
                      label: const Text('ACTIVATE AUTO-DELIVERY', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('MILK-RUN SUBSCRIPTION', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.white)),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: SubscriptionNotifier.instance,
        builder: (context, _) {
          final subs = SubscriptionNotifier.instance.activeSubscriptions;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Info Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF0284C7), Color(0xFF0369A1)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Guaranteed 7:00 AM Delivery', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                          SizedBox(height: 2),
                          Text('Zero hassle. Doorstep drop before your family wakes up.', style: TextStyle(color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ACTIVE PLANS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 0.8)),
                  TextButton.icon(
                    onPressed: () => _showNewPlanModal(context),
                    icon: const Icon(Icons.add_circle_outline, size: 16),
                    label: const Text('NEW PLAN', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              ...subs.map((sub) => _buildSubCard(context, sub)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubCard(BuildContext context, WaterSubscription sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: sub.isPaused ? const Color(0xFFFCA5A5) : const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sub.id, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.primary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: sub.isPaused ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  sub.isPaused ? 'PAUSED (VACATION)' : 'ACTIVE (DAILY 7 AM)',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: sub.isPaused ? const Color(0xFFDC2626) : const Color(0xFF15803D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(sub.planTitle, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text('${sub.frequency} \vert{}${sub.deliveryTime}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rs ${sub.pricePerDrop.toStringAsFixed(0)} / delivery', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              SizedBox(
                height: 36,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: sub.isPaused ? const Color(0xFF15803D) : const Color(0xFFDC2626),
                    side: BorderSide(color: sub.isPaused ? const Color(0xFF15803D) : const Color(0xFFDC2626)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    SubscriptionNotifier.instance.togglePause(sub.id);
                  },
                  icon: Icon(sub.isPaused ? Icons.play_arrow : Icons.pause, size: 16),
                  label: Text(sub.isPaused ? 'RESUME DELIVERIES' : 'PAUSE FOR VACATION', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}