import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

enum UserRole { customer, rider, vendor, owner }

class OwnerControlCenterScreen extends StatefulWidget {
  const OwnerControlCenterScreen({super.key});

  @override
  State<OwnerControlCenterScreen> createState() => _OwnerControlCenterScreenState();
}

class _OwnerControlCenterScreenState extends State<OwnerControlCenterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock Active Fleet Data
  final List<Map<String, dynamic>> _riders = [
    {
      'name': 'Vikram Rathore',
      'phone': '+91 98260 11223',
      'vehicle': 'MP-04-EA-4512 (Bike)',
      'status': 'Online - On Delivery',
      'activeOrders': 2,
      'isOnline': true,
    },
    {
      'name': 'Sunil Verma',
      'phone': '+91 98265 99881',
      'vehicle': 'MP-04-ZK-7890 (Loader Van)',
      'status': 'Online - At Plant Hub',
      'activeOrders': 0,
      'isOnline': true,
    },
    {
      'name': 'Deepak Soni',
      'phone': '+91 94250 44556',
      'vehicle': 'MP-04-MN-3344 (Bike)',
      'status': 'Offline',
      'activeOrders': 0,
      'isOnline': false,
    },
  ];

  // Mock Customer Base Data
  final List<Map<String, dynamic>> _customers = [
    {
      'name': 'Rahul Sharma',
      'phone': '+91 98930 12345',
      'address': 'Flat 302, Sagar Landmark, Ayodhya Bypass',
      'cansActive': 2,
      'planType': 'Daily 20L Subscription',
      'lastOrder': 'Today, 06:30 AM',
    },
    {
      'name': 'Pooja Tiwari',
      'phone': '+91 98270 56789',
      'address': 'B-14, Kasturba Nagar, Chetak Bridge',
      'cansActive': 1,
      'planType': 'On-Demand Delivery',
      'lastOrder': 'Yesterday, 04:15 PM',
    },
    {
      'name': 'Amit Saxena (Cafe Bhopal)',
      'phone': '+91 97555 88990',
      'address': 'Shop 12, 10 No. Market, Arera Colony',
      'cansActive': 5,
      'planType': 'Commercial Daily Supply',
      'lastOrder': 'Today, 07:00 AM',
    },
  ];

  // Mock Plant & Vendor Inventory
  final Map<String, dynamic> _plantData = {
    'hubName': 'Shodasha Central Plant - Govindpura Industrial Area',
    'filledCansAvailable': 480,
    'emptyCansInCirculation': 320,
    'totalCansAsset': 800,
    'waterTds': '112 PPM',
    'phLevel': '7.4 pH',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A), // Deep Executive Navy
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SHODASHA OWNER CONSOLE',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14.5, letterSpacing: 0.8),
            ),
            Text(
              'Live Operations • Bhopal Hub',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF94A3B8),
          tabs: const [
            Tab(icon: Icon(Icons.two_wheeler, size: 20), text: 'Riders (3)'),
            Tab(icon: Icon(Icons.people_alt_outlined, size: 20), text: 'Customers'),
            Tab(icon: Icon(Icons.factory_outlined, size: 20), text: 'Plant Hub'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRidersTab(),
          _buildCustomersTab(),
          _buildPlantTab(),
        ],
      ),
    );
  }

  Widget _buildRidersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _riders.length,
      itemBuilder: (context, index) {
        final rider = _riders[index];
        final bool isOnline = rider['isOnline'] as bool;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: isOnline ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                  child: Icon(
                    Icons.directions_bike_rounded,
                    color: isOnline ? const Color(0xFF16A34A) : Colors.grey,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            rider['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF0F172A)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isOnline ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isOnline ? 'ONLINE' : 'OFFLINE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: isOnline ? const Color(0xFF16A34A) : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${rider['vehicle']} • ${rider['phone']}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Status: ${rider['status']}',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isOnline ? const Color(0xFF0284C7) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _customers.length,
      itemBuilder: (context, index) {
        final cust = _customers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cust['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5, color: Color(0xFF0F172A)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${cust['cansActive']} Cans Rented',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF0284C7)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(cust['phone'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                const SizedBox(height: 6),
                Text(
                  cust['address'] as String,
                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cust['planType'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF16A34A))),
                    Text('Last: ${cust['lastOrder']}', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlantTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFFDC2626), size: 18),
                    SizedBox(width: 6),
                    Text('CENTRAL BOTTLING UNIT', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _plantData['hubName'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildPurityChip('TDS', _plantData['waterTds'] as String),
                    const SizedBox(width: 10),
                    _buildPurityChip('pH', _plantData['phLevel'] as String),
                    const SizedBox(width: 10),
                    _buildPurityChip('BIS Standard', 'IS 14543'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('CAN ASSET RECONCILIATION', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF64748B), letterSpacing: 0.8)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  'Filled Cans',
                  '${_plantData['filledCansAvailable']}',
                  'Ready to Dispatch',
                  const Color(0xFF16A34A),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricTile(
                  'Empty Cans',
                  '${_plantData['emptyCansInCirculation']}',
                  'In Bhopal Market',
                  const Color(0xFFD97706),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMetricTile(
            'Total Fleet Asset',
            '${_plantData['totalCansAsset']} Cans',
            'Total 20L Inventory Owned by Shodasha',
            const Color(0xFF0284C7),
          ),
        ],
      ),
    );
  }

  Widget _buildPurityChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
      ),
    );
  }

  Widget _buildMetricTile(String title, String count, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}