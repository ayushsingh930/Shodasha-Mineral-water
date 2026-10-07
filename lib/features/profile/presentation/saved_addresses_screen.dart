import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _addressList = [
    {
      'tag': 'Home',
      'title': 'Flat 402, Arera Colony',
      'landmark': 'Near 10 No. Market, E-Sector',
      'city': 'Bhopal - 462016',
      'floor': '4th Floor (Lift Available)',
      'isLift': true,
      'icon': Icons.home_rounded,
    },
    {
      'tag': 'Office',
      'title': 'Cabin 12, MP Nagar Zone 2',
      'landmark': 'Opposite City Center Mall',
      'city': 'Bhopal - 462011',
      'floor': '2nd Floor (Stairs only)',
      'isLift': false,
      'icon': Icons.business_rounded,
    },
  ];

  void _showAddAddressSheet() {
    final titleCtrl = TextEditingController();
    final landmarkCtrl = TextEditingController();
    final floorCtrl = TextEditingController();
    String currentTag = 'Home';
    bool liftAvailable = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Delivery Location',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(sheetCtx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: ['Home', 'Office', 'Shop'].map((tag) {
                        final isSel = currentTag == tag;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(tag, style: TextStyle(color: isSel ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                            selected: isSel,
                            selectedColor: AppColors.primary,
                            onSelected: (val) {
                              if (val) setSheetState(() => currentTag = tag);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        labelText: 'House / Flat / Shop Number',
                        hintText: 'e.g. House 45, Shahpura Sector B',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: landmarkCtrl,
                      decoration: InputDecoration(
                        labelText: 'Landmark & Area',
                        hintText: 'e.g. Near Kaliyasot Dam Road',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: floorCtrl,
                      decoration: InputDecoration(
                        labelText: 'Floor Details',
                        hintText: 'e.g. 2nd Floor, Door 201',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Lift available for 20L delivery trolley', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                      value: liftAvailable,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setSheetState(() => liftAvailable = val),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (titleCtrl.text.trim().isEmpty) return;
                          setState(() {
                            _addressList.add({
                              'tag': currentTag,
                              'title': titleCtrl.text.trim(),
                              'landmark': landmarkCtrl.text.trim().isEmpty ? 'Central Bhopal' : landmarkCtrl.text.trim(),
                              'city': 'Bhopal, MP',
                              'floor': floorCtrl.text.trim().isEmpty ? (liftAvailable ? 'Lift Available' : 'Stairs Only') : '${floorCtrl.text.trim()} (${liftAvailable ? 'Lift' : 'Stairs'})',
                              'isLift': liftAvailable,
                              'icon': currentTag == 'Office' ? Icons.business_rounded : Icons.location_on_rounded,
                            });
                          });
                          Navigator.pop(sheetCtx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Color(0xFF15803D),
                              content: Text('Delivery address saved successfully!'),
                            ),
                          );
                        },
                        child: const Text('SAVE LOCATION', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'DELIVERY ADDRESSES',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.1, color: Colors.white),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border))),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _showAddAddressSheet,
          icon: const Icon(Icons.add_location_alt_rounded),
          label: const Text('ADD NEW ADDRESS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: _addressList.length,
        itemBuilder: (context, index) {
          final addr = _addressList[index];
          final isSel = _selectedIndex == index;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSel ? const Color(0xFFF0FDF4) : AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              border: Border.all(
                color: isSel ? const Color(0xFF16A34A) : AppColors.border,
                width: isSel ? 1.6 : 1.0,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFFDCFCE7) : AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(addr['icon'] as IconData, color: isSel ? const Color(0xFF16A34A) : AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFF16A34A) : AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              addr['tag'] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w900),
                            ),
                          ),
                          if (isSel) ...[
                            const SizedBox(width: 8),
                            const Text('ACTIVE FOR ORDERS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF15803D))),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        addr['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${addr['landmark']}, ${addr['city']}',
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.elevator_outlined, size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            addr['floor'] as String,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Radio<int>(
                  value: index,
                  groupValue: _selectedIndex,
                  activeColor: const Color(0xFF16A34A),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedIndex = val);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}