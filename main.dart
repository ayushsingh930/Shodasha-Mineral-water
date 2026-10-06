import 'package:flutter/material.dart';

void main() {
  runApp(const ShodashaApp());
}

class ShodashaApp extends StatelessWidget {
  const ShodashaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shodasha Mineral Water',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const MasterHubScreen(),
    );
  }
}

class MasterHubScreen extends StatefulWidget {
  const MasterHubScreen({super.key});

  @override
  State<MasterHubScreen> createState() => _MasterHubScreenState();
}

class _MasterHubScreenState extends State<MasterHubScreen> {
  int _currentTab = 0;

  static const Color tealPrimary = Color(0xFF0D9488);
  static const Color solarYellow = Color(0xFFFACC15);
  static const Color textDark = Color(0xFF0F172A);

  int pendingCans = 2;
  int returnedCans = 2;
  bool isDispatched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tealPrimary,
        elevation: 0,
        title: const Text(
          'Shodasha Mineral Water',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  _navPill(0, 'Customer Home'),
                  _navPill(1, 'Wallet & Ledger'),
                  _navPill(2, 'Order Routing'),
                  _navPill(3, 'Vendor Portal'),
                  _navPill(4, 'Rider Partner'),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                _buildCustomerHome(),
                _buildWalletLedger(),
                _buildRoutingView(),
                _buildVendorPortal(),
                _buildRiderView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navPill(int index, String title) {
    final bool isSelected = _currentTab == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : textDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
        selected: isSelected,
        selectedColor: tealPrimary,
        backgroundColor: const Color(0xFFF1F5F9),
        onSelected: (_) => setState(() => _currentTab = index),
      ),
    );
  }

  Widget _buildCustomerHome() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _statusCard('Customer App Live', Icons.check_circle),
        const SizedBox(height: 16),
        const Text(
          'Choose Your Schedule',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _orderCard('⚡ Instant Refill', 'One-time delivery', true)),
            const SizedBox(width: 12),
            Expanded(child: _orderCard('🔄 Auto-Refill', 'Weekly regular plan', false)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              const Icon(Icons.water_drop, size: 40, color: tealPrimary),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('20L Mineral Water Jar', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('₹80 per can', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: solarYellow),
                onPressed: () {},
                child: const Text('Order Now', style: TextStyle(color: textDark, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWalletLedger() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _statusCard('Ledger & Wallet Synchronized', Icons.account_balance_wallet),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _balanceTile('Security Deposit', '₹1,500.00', tealPrimary)),
            const SizedBox(width: 12),
            Expanded(child: _balanceTile('Rewards Wallet', '₹450.00', solarYellow, textColor: textDark)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Empty Can Tracker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 12),
              Text('Pending with Customer: $pendingCans Cans'),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: tealPrimary),
                onPressed: () {
                  if (pendingCans > 0) {
                    setState(() {
                      pendingCans--;
                      returnedCans++;
                    });
                  }
                },
                icon: const Icon(Icons.sync, color: Colors.white),
                label: const Text('Confirm Return of 1 Can', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoutingView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _statusCard('Geofencing & Allocation Online', Icons.alt_route),
        const SizedBox(height: 16),
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: const Icon(Icons.factory, color: tealPrimary),
          title: const Text('Green Springs Plant (Assigned)', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('1.2 km away • Stock: 45 Cans'),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: solarYellow),
            onPressed: () => setState(() => isDispatched = true),
            child: const Text('Dispatch', style: TextStyle(color: textDark, fontWeight: FontWeight.bold)),
          ),
        ),
        if (isDispatched) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 12),
                Text('Order Dispatched! ETA: 15 Mins', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVendorPortal() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _statusCard('Plant Online - Receiving Orders', Icons.storefront),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Today's Settlement", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Orders Completed: 28 Cans', style: TextStyle(color: Colors.grey)),
              Text('Pending Settlement: ₹2,240.00', style: TextStyle(color: tealPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRiderView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _statusCard('Rider Duty Active', Icons.two_wheeler),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Active Delivery: Sector 4', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('Items: 2x 20L Water Jars', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: solarYellow),
                onPressed: () {},
                child: const Text('Confirm Drop-Off', style: TextStyle(color: textDark, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusCard(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: tealPrimary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: tealPrimary),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: tealPrimary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _orderCard(String title, String subtitle, bool highlighted) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: highlighted ? tealPrimary : const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _balanceTile(String title, String amount, Color color, {Color textColor = Colors.white}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: textColor.withOpacity(0.9), fontSize: 12)),
          const SizedBox(height: 4),
          Text(amount, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}