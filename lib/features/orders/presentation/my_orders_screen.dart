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

  Widget _buildStepNode({
    required IconData icon,
    required String label,
    required bool isCompleted,
    required bool isCurrent,
  }) {
    Color bg = isCompleted
        ? const Color(0xFF16A34A)
        : (isCurrent ? AppColors.primary : Colors.grey.shade300);

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            fontWeight: isCurrent || isCompleted ? FontWeight.w900 : FontWeight.w600,
            color: isCurrent
                ? AppColors.primary
                : (isCompleted ? const Color(0xFF16A34A) : AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine({required bool isCompleted}) {
    return Expanded(
      child: Container(
        height: 2.5,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: isCompleted ? const Color(0xFF16A34A) : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderItem order, {bool isActive = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(
          color: isActive ? AppColors.primary.withOpacity(0.4) : AppColors.border,
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
          // 1. Status header
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
                  isActive ? order.status : 'DELIVERED & VERIFIED',
                  style: TextStyle(
                    color: isActive ? const Color(0xFF854D0E) : const Color(0xFF15803D),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                order.orderId,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 2. Title & Details
          Text(
            order.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Address: ${order.address}',
            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            'Slot: ${order.timeSlot} • Total: ${order.amount}',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 12),

          // 3. Driver & Delivery PIN
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isActive ? Icons.delivery_dining_rounded : Icons.check_circle_rounded,
                          color: isActive ? AppColors.primary : const Color(0xFF16A34A),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.deliveryAgent,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              isActive ? 'Van: MP-04 5412' : 'Delivered to Door',
                              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      if (isActive)
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.phone_in_talk_rounded, color: Color(0xFF16A34A), size: 18),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Calling Driver: ${order.deliveryAgent}')),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              if (isActive) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFBBF7D0), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'DELIVERY PIN',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: Color(0xFF166534),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '5892',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 12),

          // 4. FULL 4-STEP DELIVERY TRACKER (Booked -> Dispatched -> On Route -> Delivered)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'DELIVERY PROGRESS',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      isActive ? '🚚 ETA: ${order.eta}' : '✅ Delivered',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isActive ? const Color(0xFF16A34A) : const Color(0xFF15803D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Node 1: Booked
                    _buildStepNode(
                      icon: Icons.check,
                      label: 'Booked',
                      isCompleted: true,
                      isCurrent: false,
                    ),
                    _buildStepLine(isCompleted: true),

                    // Node 2: Dispatched
                    _buildStepNode(
                      icon: Icons.factory_rounded,
                      label: 'Dispatched',
                      isCompleted: true,
                      isCurrent: false,
                    ),
                    _buildStepLine(isCompleted: true),

                    // Node 3: On Route
                    _buildStepNode(
                      icon: Icons.local_shipping_rounded,
                      label: 'On Route',
                      isCompleted: !isActive,
                      isCurrent: isActive,
                    ),
                    _buildStepLine(isCompleted: !isActive),

                    // Node 4: Delivered (Saaf visible fourth step)
                    _buildStepNode(
                      icon: Icons.done_all_rounded,
                      label: 'Delivered',
                      isCompleted: !isActive,
                      isCurrent: false,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 5. Bottle Exchange / Delivered summary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive ? const Color(0xFFFECACA) : const Color(0xFFBBF7D0),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isActive ? Icons.autorenew_rounded : Icons.check_circle_outline_rounded,
                  color: isActive ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isActive
                        ? 'Bottle Return: Keep ${order.emptyCansToReturn} empty cans ready for driver'
                        : 'Completed: ${order.emptyCansToReturn} empty cans collected & synced with ledger',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: isActive ? const Color(0xFF991B1B) : const Color(0xFF166534),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
          // Active
          activeList.isEmpty
              ? const Center(child: Text('No active deliveries right now.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: activeList.length,
                  itemBuilder: (ctx, i) => _buildOrderCard(activeList[i], isActive: true),
                ),

          // Past Orders (Delivered ones)
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