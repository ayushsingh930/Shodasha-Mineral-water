import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/order_service.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final OrderStateNotifier _orderState = OrderStateNotifier.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _orderState.addListener(_onStateChange);
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _orderState.removeListener(_onStateChange);
    _tabController.dispose();
    super.dispose();
  }

  void _showOrderTrackingDetail(OrderItem order, bool isActive) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.orderId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary)),
                      const SizedBox(height: 2),
                      const Text('Delivery Status Tracker', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(sheetCtx),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const Divider(height: 20),

              // Visual Step Progress
              _buildStepTile(
                title: 'Order Received & Verified',
                subtitle: 'Order recorded in Bhopal Central Plant',
                isDone: true,
                isCurrent: false,
              ),
              _buildStepTile(
                title: 'Sanitized & Dispatched from Plant',
                subtitle: '20L BPA-Free Cans sealed & loaded',
                isDone: true,
                isCurrent: false,
              ),
              _buildStepTile(
                title: isActive ? 'Out for Delivery (On the way)' : 'Delivery Van Arrived',
                subtitle: isActive ? 'Van arriving at Arera Colony (~25 mins)' : 'Completed delivery',
                isDone: true,
                isCurrent: isActive,
              ),
              _buildStepTile(
                title: 'Handover & Can Exchange',
                subtitle: 'Collect ${order.emptyCansToReturn} empty bottle(s) for ledger',
                isDone: !isActive,
                isCurrent: false,
                isLast: true,
              ),

              const SizedBox(height: 16),

              // Delivery Van Details Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delivery_dining_rounded, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Driver: ${order.deliveryAgent}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('Plant Route: MP-04 Van 5412', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Calling Driver: ${order.deliveryAgent}')),
                        );
                      },
                      icon: const Icon(Icons.phone, size: 14),
                      label: const Text('Call', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(sheetCtx),
                  child: const Text('CLOSE TRACKER', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepTile({
    required String title,
    required String subtitle,
    required bool isDone,
    required bool isCurrent,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? (isCurrent ? AppColors.accent : AppColors.primary) : Colors.grey.shade300,
              ),
              child: Icon(
                isDone ? Icons.check : Icons.circle,
                size: 12,
                color: isDone ? (isCurrent ? AppColors.textOnAccent : Colors.white) : Colors.white,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: isDone ? AppColors.primary : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                    color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(OrderItem order, {bool isActive = true}) {
    return InkWell(
      onTap: () => _showOrderTrackingDetail(order, isActive),
      borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          border: Border.all(
            color: isActive ? AppColors.primary.withOpacity(0.5) : AppColors.border,
            width: isActive ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isActive ? 0.05 : 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFFFEF9C3) : const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: isActive ? const Color(0xFF854D0E) : const Color(0xFF15803D),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  order.orderId,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              order.title,
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'Location: ${order.address}',
              style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 2),
            Text(
              'Slot: ${order.timeSlot} • Total: ${order.amount}',
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isActive ? Icons.delivery_dining_rounded : Icons.check_circle_rounded,
                        color: isActive ? AppColors.primary : const Color(0xFF16A34A),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agent: ${order.deliveryAgent}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          isActive ? 'ETA: ${order.eta}' : 'Delivered Successfully',
                          style: TextStyle(
                            fontSize: 11,
                            color: isActive ? const Color(0xFF16A34A) : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  'Tap for Tracker >',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Can Exchange:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  Text('${order.emptyCansToReturn} Empty Can(s) to return', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeList = _orderState.activeOrders;
    final pastList = _orderState.pastOrders;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'MY ORDERS & DELIVERIES',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            Tab(text: 'Active Delivery (${activeList.length})'),
            Tab(text: 'Past Orders (${pastList.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Orders Tab
          activeList.isEmpty
              ? const Center(child: Text('No active deliveries right now.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: activeList.length,
                  itemBuilder: (ctx, i) => _buildOrderCard(activeList[i], isActive: true),
                ),

          // Past Orders Tab
          pastList.isEmpty
              ? const Center(child: Text('No past orders.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: pastList.length,
                  itemBuilder: (ctx, i) => _buildOrderCard(pastList[i], isActive: false),
                ),
        ],
      ),
    );
  }
}