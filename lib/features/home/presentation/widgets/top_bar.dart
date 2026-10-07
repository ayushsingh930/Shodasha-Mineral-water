import '../../../orders/presentation/cart_checkout_sheet.dart';
import '../notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../core/constants/app_constants.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  String _selectedAddress = 'Delivery Location Not Set';
  String _selectedSlot = 'Morning (8:00 AM - 3:00 PM)';
  bool _isCustomTime = false;
  String _customTimeStr = '';
  bool _isGpsLoading = false;

  final List<String> _savedAddresses = [
    'Home: Flat 402, Arera Colony, Bhopal',
    'Office: Zone-1, MP Nagar, Bhopal',
    'Plant Hub: Govindpura Industrial Area Pick-up',
  ];

  @override
  void initState() {
    super.initState();
    _selectedAddress = _savedAddresses[0];
  }

  // REAL HARDWARE GPS FETCH (WORLDWIDE AUTHENTIC)
  Future<void> _fetchRealWorldwideGps(StateSetter setModalState) async {
    setModalState(() => _isGpsLoading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        setModalState(() => _isGpsLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setModalState(() => _isGpsLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        setModalState(() => _isGpsLoading = false);
        return;
      }

      // Fetch Real Device Coordinates
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      // Reverse Geocode into Real Postal Address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String formattedRealAddress = 'GPS: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        List<String> parts = [];
        if (place.name != null && place.name!.isNotEmpty) parts.add(place.name!);
        if (place.subLocality != null && place.subLocality!.isNotEmpty) parts.add(place.subLocality!);
        if (place.locality != null && place.locality!.isNotEmpty) parts.add(place.locality!);
        if (place.postalCode != null && place.postalCode!.isNotEmpty) parts.add(place.postalCode!);
        if (place.country != null && place.country!.isNotEmpty) parts.add(place.country!);

        if (parts.isNotEmpty) {
          formattedRealAddress = 'GPS: ${parts.join(', ')}';
        }
      }

      setModalState(() {
        _isGpsLoading = false;
        if (!_savedAddresses.contains(formattedRealAddress)) {
          _savedAddresses.insert(0, formattedRealAddress);
        }
        _selectedAddress = formattedRealAddress;
      });

      setState(() {
        if (!_savedAddresses.contains(formattedRealAddress)) {
          _savedAddresses.insert(0, formattedRealAddress);
        }
        _selectedAddress = formattedRealAddress;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF15803D),
            content: Text('Real GPS Detected: $formattedRealAddress'),
          ),
        );
      }
    } catch (e) {
      setModalState(() => _isGpsLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('GPS Sensor Note: $e'),
          ),
        );
      }
    }
  }

  Future<void> _pickCustomTime(BuildContext modalCtx, StateSetter setModalState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: modalCtx,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      helpText: 'SELECT YOUR PREFERRED WATER DELIVERY TIME',
    );

    if (picked != null) {
      final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      final minute = picked.minute.toString().padLeft(2, '0');
      final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
      final formatted = 'Custom: $hour:$minute $period';

      setModalState(() {
        _isCustomTime = true;
        _customTimeStr = formatted;
        _selectedSlot = formatted;
      });
      setState(() {
        _isCustomTime = true;
        _customTimeStr = formatted;
        _selectedSlot = formatted;
      });
    }
  }

  void _editAddressDialog(int index, StateSetter setModalState) {
    final editCtrl = TextEditingController(text: _savedAddresses[index]);
    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        title: const Text('Edit Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: TextField(
          controller: editCtrl,
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter updated address...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dlgCtx), child: const Text('CANCEL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              if (editCtrl.text.trim().isNotEmpty) {
                final updated = editCtrl.text.trim();
                setModalState(() {
                  _savedAddresses[index] = updated;
                  _selectedAddress = updated;
                });
                setState(() {
                  _savedAddresses[index] = updated;
                  _selectedAddress = updated;
                });
                Navigator.pop(dlgCtx);
              }
            },
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );
  }

  void _openAddressSheet() {
    final TextEditingController manualAddrCtrl = TextEditingController();
    bool showManualField = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (modalCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 18,
                right: 18,
                top: 18,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
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
                          'Delivery Location & Schedule',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(modalCtx),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const Divider(height: 18),

                    // REAL WORLD GPS BUTTON
                    InkWell(
                      onTap: _isGpsLoading ? null : () => _fetchRealWorldwideGps(setModalState),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBBF7D0), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            if (_isGpsLoading)
                              const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF16A34A)),
                              )
                            else
                              const Icon(Icons.my_location_rounded, color: Color(0xFF16A34A), size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isGpsLoading ? 'Fetching Real GPS Sensors...' : 'Detect Real Device Location (GPS)',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                                  ),
                                  Text(
                                    _isGpsLoading ? 'Querying satellites & reverse geocoding...' : 'Live sensor GPS coordinates & postal address worldwide',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF166534)),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF16A34A), size: 14),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('SAVED DELIVERY ADDRESSES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
                        Text('${_savedAddresses.length} saved', style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),

                    ...List.generate(_savedAddresses.length, (idx) {
                      final addr = _savedAddresses[idx];
                      final isSelected = _selectedAddress == addr;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 1.5 : 1),
                        ),
                        child: ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          leading: Icon(
                            addr.startsWith('GPS') ? Icons.my_location_rounded : (addr.startsWith('Home') ? Icons.home_rounded : Icons.location_on_outlined),
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            size: 22,
                          ),
                          title: Text(
                            addr,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12.5, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, color: AppColors.textPrimary),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected) const Padding(padding: EdgeInsets.only(right: 6), child: Icon(Icons.check_circle, color: AppColors.primary, size: 20)),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => _editAddressDialog(idx, setModalState),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  setModalState(() {
                                    _savedAddresses.removeAt(idx);
                                    if (_savedAddresses.isNotEmpty) _selectedAddress = _savedAddresses[0];
                                    else _selectedAddress = 'No Address Selected';
                                  });
                                  setState(() {
                                    if (_savedAddresses.isNotEmpty) _selectedAddress = _savedAddresses[0];
                                    else _selectedAddress = 'No Address Selected';
                                  });
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            setModalState(() => _selectedAddress = addr);
                            setState(() => _selectedAddress = addr);
                          },
                        ),
                      );
                    }),

                    if (!showManualField)
                      TextButton.icon(
                        onPressed: () => setModalState(() => showManualField = true),
                        icon: const Icon(Icons.add_circle_outline, size: 18, color: AppColors.primary),
                        label: const Text('+ Add / Type Manual Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.primary, width: 1.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Enter Full Address Details:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: manualAddrCtrl,
                              autofocus: true,
                              decoration: const InputDecoration(hintText: 'Enter street, locality, city...', border: InputBorder.none, isDense: true),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(onPressed: () => setModalState(() => showManualField = false), child: const Text('CANCEL')),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                                  onPressed: () {
                                    final text = manualAddrCtrl.text.trim();
                                    if (text.isNotEmpty) {
                                      final newEntry = 'Manual: $text';
                                      setModalState(() {
                                        _savedAddresses.add(newEntry);
                                        _selectedAddress = newEntry;
                                        showManualField = false;
                                      });
                                      setState(() => _selectedAddress = newEntry);
                                    }
                                  },
                                  child: const Text('SAVE & SELECT'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 16),
                    const Text('PREFERRED DELIVERY TIME SLOT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              const morning = 'Morning (8:00 AM - 3:00 PM)';
                              setModalState(() { _isCustomTime = false; _selectedSlot = morning; });
                              setState(() { _isCustomTime = false; _selectedSlot = morning; });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              decoration: BoxDecoration(
                                color: (!_isCustomTime && _selectedSlot.startsWith('Morning')) ? const Color(0xFFFEF9C3) : AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: (!_isCustomTime && _selectedSlot.startsWith('Morning')) ? const Color(0xFFFDE047) : AppColors.border, width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.wb_sunny_rounded, size: 20, color: (!_isCustomTime && _selectedSlot.startsWith('Morning')) ? const Color(0xFF854D0E) : AppColors.textSecondary),
                                  const SizedBox(height: 4),
                                  const Text('Morning Slot', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  const Text('8:00 AM - 3:00 PM', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              const evening = 'Evening (5:00 PM - 10:30 PM)';
                              setModalState(() { _isCustomTime = false; _selectedSlot = evening; });
                              setState(() { _isCustomTime = false; _selectedSlot = evening; });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              decoration: BoxDecoration(
                                color: (!_isCustomTime && _selectedSlot.startsWith('Evening')) ? const Color(0xFFFEF9C3) : AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: (!_isCustomTime && _selectedSlot.startsWith('Evening')) ? const Color(0xFFFDE047) : AppColors.border, width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.nights_stay_rounded, size: 20, color: (!_isCustomTime && _selectedSlot.startsWith('Evening')) ? const Color(0xFF854D0E) : AppColors.textSecondary),
                                  const SizedBox(height: 4),
                                  const Text('Evening Slot', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  const Text('5:00 PM - 10:30 PM', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: _isCustomTime ? AppColors.primary : AppColors.border, width: 1.5),
                      ),
                      onPressed: () => _pickCustomTime(ctx, setModalState),
                      icon: const Icon(Icons.access_time_rounded, size: 18),
                      label: Text(_isCustomTime ? 'Custom Time: $_customTimeStr' : 'Set Exact Specific Delivery Time (Tap to Pick)', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                        onPressed: () {
                          Navigator.pop(modalCtx);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: AppColors.primaryDark, content: Text('Scheduled: $_selectedSlot')));
                        },
                        child: const Text('CONFIRM ADDRESS & TIME', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
    String displayAddress = _selectedAddress.split(':')[0].toUpperCase();
    if (displayAddress.contains('(')) {
      displayAddress = displayAddress.split('(')[0].trim();
    }

    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.water_drop, color: Colors.white, size: 26),
                  SizedBox(width: 8),
                  Text('SHODASHA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.white)),
                ],
              ),
              Row(
                children: [
                  Container(
  height: 36,
  width: 36,
  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
  child: IconButton(
    padding: EdgeInsets.zero,
    icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NotificationsScreen()),
      );
    },
  ),
),
const SizedBox(width: 8),
Container(height: 36, width: 36, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.person, color: Colors.white, size: 20)),
                  const SizedBox(width: 8),
                  GestureDetector(
  onTap: () {
    CartCheckoutSheet.show(
      context,
      onOrderSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF15803D),
            content: Text('Cart order confirmed! Track in My Orders tab.'),
          ),
        );
      },
    );
  },
  child: Container(
    height: 36,
    width: 36,
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
    child: Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
        Positioned(right: 4, top: 4, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle), constraints: const BoxConstraints(minWidth: 14, minHeight: 14), child: const Text('2', style: TextStyle(color: AppColors.textOnAccent, fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center))),
      ],
    ),
  ),
),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _openAddressSheet,
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 14),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'DELIVERY: $displayAddress • $_selectedSlot ▾',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 44,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Row(
              children: [
                Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                SizedBox(width: 8),
                Text('Search water cans, brands...', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}