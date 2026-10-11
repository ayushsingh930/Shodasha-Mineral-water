import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class AddressModel {
  final String id;
  final String title;
  final String fullAddress;
  final String contact;
  bool isDefault;

  AddressModel({
    required this.id,
    required this.title,
    required this.fullAddress,
    required this.contact,
    this.isDefault = false,
  });
}

class AddressStateService extends ChangeNotifier {
  AddressStateService._();
  static final AddressStateService instance = AddressStateService._();

  final List<AddressModel> addresses = [
    AddressModel(
      id: 'addr_1',
      title: 'Home (Primary)',
      fullAddress: 'Flat 402, Royal Palms, Arera Colony, Bhopal, MP - 462016',
      contact: '+91 98930 12345',
      isDefault: true,
    ),
    AddressModel(
      id: 'addr_2',
      title: 'Office / Business',
      fullAddress: 'Plot 12, Zone 1, MP Nagar, Bhopal, MP - 462011',
      contact: '+91 98930 12345',
      isDefault: false,
    ),
  ];

  // Active address getter for checkout & order placement
  AddressModel get activeAddress {
    return addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => addresses.first,
    );
  }

  void setActiveAddress(String id) {
    for (var a in addresses) {
      a.isDefault = (a.id == id);
    }
    notifyListeners();
  }

  void addAddress(String title, String fullAddress, String contact) {
    addresses.add(
      AddressModel(
        id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        fullAddress: fullAddress,
        contact: contact,
      ),
    );
    notifyListeners();
  }
}

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'SAVED ADDRESSES',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white, letterSpacing: 0.8),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: AddressStateService.instance,
        builder: (context, _) {
          final list = AddressStateService.instance.addresses;
          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              final item = list[i];
              return InkWell(
                onTap: () => AddressStateService.instance.setActiveAddress(item.id),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                    border: Border.all(
                      color: item.isDefault ? AppColors.primary : AppColors.border,
                      width: item.isDefault ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary)),
                          if (item.isDefault)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                              child: const Text('DEFAULT', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFF15803D))),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(item.fullAddress, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.3)),
                      const SizedBox(height: 4),
                      Text(item.contact, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}