import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/constants/app_constants.dart';

class AddressItem {
  final String id;
  String tag;
  String title;
  String landmark;
  String city;
  String floor;
  bool isLift;

  AddressItem({
    required this.id,
    required this.tag,
    required this.title,
    required this.landmark,
    required this.city,
    required this.floor,
    required this.isLift,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'tag': tag,
    'title': title,
    'landmark': landmark,
    'city': city,
    'floor': floor,
    'isLift': isLift,
  };

  factory AddressItem.fromJson(Map<String, dynamic> json) => AddressItem(
    id: json['id'] ?? '',
    tag: json['tag'] ?? 'Home',
    title: json['title'] ?? '',
    landmark: json['landmark'] ?? '',
    city: json['city'] ?? '',
    floor: json['floor'] ?? '',
    isLift: json['isLift'] ?? true,
  );
}

class AddressStateService extends ChangeNotifier {
  static final AddressStateService instance = AddressStateService._internal();
  AddressStateService._internal() {
    _loadFromDisk();
  }

  int selectedIndex = 0;
  List<AddressItem> addresses = [
    AddressItem(
      id: 'ADDR-1',
      tag: 'Home',
      title: 'Flat 402, Arera Colony',
      landmark: 'Near 10 No. Market, E-Sector',
      city: 'Bhopal - 462016',
      floor: '4th Floor (Lift Available)',
      isLift: true,
    ),
    AddressItem(
      id: 'ADDR-2',
      tag: 'Office',
      title: 'Cabin 12, MP Nagar Zone 2',
      landmark: 'Opposite City Center Mall',
      city: 'Bhopal - 462011',
      floor: '2nd Floor (Stairs only)',
      isLift: false,
    ),
  ];

  AddressItem get activeAddress => addresses[selectedIndex.clamp(0, addresses.length - 1)];

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/shodasha_addresses.json');
  }

  Future<void> _loadFromDisk() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> decoded = jsonDecode(content);
        if (decoded.isNotEmpty) {
          addresses = decoded.map((e) => AddressItem.fromJson(Map<String, dynamic>.from(e))).toList();
          notifyListeners();
        }
      }
    } catch (_) {}
  }

  Future<void> _saveToDisk() async {
    try {
      final file = await _getFile();
      final list = addresses.map((e) => e.toJson()).toList();
      await file.writeAsString(jsonEncode(list));
    } catch (_) {}
  }

  void addAddress(AddressItem item) {
    addresses.add(item);
    _saveToDisk();
    notifyListeners();
  }

  void updateAddress(int index, AddressItem updated) {
    if (index >= 0 && index < addresses.length) {
      addresses[index] = updated;
      _saveToDisk();
      notifyListeners();
    }
  }

  void deleteAddress(int index) {
    if (addresses.length <= 1) return;
    addresses.removeAt(index);
    if (selectedIndex >= addresses.length) {
      selectedIndex = addresses.length - 1;
    }
    _saveToDisk();
    notifyListeners();
  }

  void selectDefault(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final AddressStateService _addressService = AddressStateService.instance;

  @override
  void initState() {
    super.initState();
    _addressService.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _addressService.removeListener(_refresh);
    super.dispose();
  }

  void _openAddressForm({AddressItem? existingItem, int? editIndex}) {
    final bool isEditing = existingItem != null && editIndex != null;
    final titleCtrl = TextEditingController(text: existingItem?.title ?? '');
    final landmarkCtrl = TextEditingController(text: existingItem?.landmark ?? '');
    final floorCtrl = TextEditingController(text: existingItem?.floor ?? '');
    String currentTag = existingItem?.tag ?? 'Home';
    bool liftAvailable = existingItem?.isLift ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEditing ? 'Edit Customer Address' : 'Add New Delivery Address',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(sheetCtx),
                        ),
                      ],
                    ),
                    const Text(
                      'Protected & Stored On-Device • Only you can modify or delete',
                      style: TextStyle(fontSize: 11, color: Color(0xFF16A34A), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: ['Home', 'Office', 'Shop', 'Other'].map((tag) {
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
                    const SizedBox(height: 14),
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        labelText: 'House / Flat / Building No.',
                        hintText: 'e.g. Flat 102, Silver Heights',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: landmarkCtrl,
                      decoration: InputDecoration(
                        labelText: 'Landmark & Area',
                        hintText: 'e.g. Near Habibganj Station / Arera Colony',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: floorCtrl,
                      decoration: InputDecoration(
                        labelText: 'Floor & Delivery Instruction',
                        hintText: 'e.g. 3rd Floor, Bell on left',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Lift available for 20L heavy can trolley', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                      value: liftAvailable,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setSheetState(() => liftAvailable = val),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (titleCtrl.text.trim().isEmpty) return;

                          final newItem = AddressItem(
                            id: isEditing ? existingItem.id : 'ADDR-${DateTime.now().millisecondsSinceEpoch}',
                            tag: currentTag,
                            title: titleCtrl.text.trim(),
                            landmark: landmarkCtrl.text.trim().isEmpty ? 'Bhopal Central' : landmarkCtrl.text.trim(),
                            city: 'Bhopal, MP',
                            floor: floorCtrl.text.trim().isEmpty ? (liftAvailable ? 'Lift Available' : 'Stairs Only') : floorCtrl.text.trim(),
                            isLift: liftAvailable,
                          );

                          if (isEditing) {
                            _addressService.updateAddress(editIndex, newItem);
                          } else {
                            _addressService.addAddress(newItem);
                          }

                          Navigator.pop(sheetCtx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF15803D),
                              content: Text(isEditing ? 'Address updated and saved to phone!' : 'Address saved permanently to phone!'),
                            ),
                          );
                        },
                        child: Text(
                          isEditing ? 'SAVE CHANGES' : 'CONFIRM & SAVE PERMANENTLY',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
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

  void _confirmDelete(int index) {
    if (_addressService.addresses.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one delivery address must remain active.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Address?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: const Text(
          'Are you sure you want to remove this delivery location? This cannot be undone.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgCtx),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(dlgCtx);
              _addressService.deleteAddress(index);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address deleted permanently.')),
              );
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _addressService.addresses;
    final selIdx = _addressService.selectedIndex;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'SAVED ADDRESSES',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => _openAddressForm(),
          icon: const Icon(Icons.add_location_alt_rounded),
          label: const Text('ADD NEW ADDRESS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final addr = list[index];
          final isSel = selIdx == index;

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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFFDCFCE7) : AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        addr.tag == 'Office' ? Icons.business_rounded : Icons.home_rounded,
                        color: isSel ? const Color(0xFF16A34A) : AppColors.primary,
                        size: 20,
                      ),
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
                                  addr.tag,
                                  style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w900),
                                ),
                              ),
                              if (isSel) ...[
                                const SizedBox(width: 8),
                                const Text('ACTIVE DISPATCH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF15803D))),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            addr.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${addr.landmark}, ${addr.city}',
                            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.elevator_outlined, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                '${addr.floor} (${addr.isLift ? 'Lift Available' : 'No Lift'})',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Radio<int>(
                      value: index,
                      groupValue: selIdx,
                      activeColor: const Color(0xFF16A34A),
                      onChanged: (val) {
                        if (val != null) _addressService.selectDefault(val);
                      },
                    ),
                  ],
                ),
                const Divider(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rider/Vendor Access: Read-Only',
                      style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            foregroundColor: AppColors.primary,
                          ),
                          onPressed: () => _openAddressForm(existingItem: addr, editIndex: index),
                          icon: const Icon(Icons.edit_outlined, size: 15),
                          label: const Text('Edit', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 4),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            foregroundColor: const Color(0xFFDC2626),
                          ),
                          onPressed: () => _confirmDelete(index),
                          icon: const Icon(Icons.delete_outline_rounded, size: 15),
                          label: const Text('Delete', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}