import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  List<Map<String, dynamic>> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? addressesJson = prefs.getString('saved_addresses');
    if (addressesJson != null) {
      final List<dynamic> decoded = json.decode(addressesJson);
      setState(() {
        _addresses = List<Map<String, dynamic>>.from(decoded);
        _isLoading = false;
      });
    } else {
      setState(() {
        _addresses = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_addresses', json.encode(_addresses));
  }

  void _deleteAddress(int index) {
    setState(() {
      _addresses.removeAt(index);
    });
    _saveAddresses();
  }

  void _showAddressDialog({int? index}) {
    final bool isEditing = index != null;
    final Map<String, dynamic> currentAddress = isEditing ? _addresses[index] : {'title': '', 'address': '', 'type': 'home'};
    
    final titleController = TextEditingController(text: currentAddress['title']);
    final addressController = TextEditingController(text: currentAddress['address']);
    String selectedType = currentAddress['type'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: AppTheme.cardBackground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing ? 'Edit Address' : 'Add New Address',
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
                      decoration: InputDecoration(
                        labelText: 'Label (e.g., Home, Office)',
                        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: addressController,
                      style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Full Address',
                        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Type', style: TextStyle(color: Colors.white70, fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildTypeSelector('home', TablerIcons.home, selectedType, () => setStateDialog(() => selectedType = 'home')),
                        const SizedBox(width: 12),
                        _buildTypeSelector('briefcase', TablerIcons.briefcase, selectedType, () => setStateDialog(() => selectedType = 'briefcase')),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (titleController.text.trim().isEmpty || addressController.text.trim().isEmpty) return;
                          
                          final newAddr = {
                            'title': titleController.text.trim(),
                            'address': addressController.text.trim(),
                            'type': selectedType,
                          };

                          setState(() {
                            if (isEditing) {
                              _addresses[index] = newAddr;
                            } else {
                              _addresses.add(newAddr);
                            }
                          });
                          _saveAddresses();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryRed,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(isEditing ? 'Save Changes' : 'Add Address', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildTypeSelector(String type, IconData icon, String selectedType, VoidCallback onTap) {
    final bool isSelected = type == selectedType;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryRed.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppTheme.primaryRed : Colors.transparent),
        ),
        child: Icon(icon, color: isSelected ? AppTheme.primaryRed : Colors.white60, size: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.screenBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(TablerIcons.arrow_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Saved Addresses',
          style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Background Decorators
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryRed.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(color: AppTheme.primaryRed.withOpacity(0.2), blurRadius: 100, spreadRadius: 50),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manage your delivery locations for faster checkout.',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.white60, height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  
                  Expanded(
                    child: _isLoading 
                      ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryRed))
                      : _addresses.isEmpty
                        ? const Center(
                            child: Text(
                              'No saved addresses found.',
                              style: TextStyle(fontFamily: 'Inter', color: Colors.white54, fontSize: 16),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: _addresses.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final address = _addresses[index];
                              return _buildAddressCard(address, index);
                            },
                          ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Add New Address Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showAddressDialog(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        foregroundColor: Colors.white,
                        elevation: 10,
                        shadowColor: AppTheme.primaryRed.withOpacity(0.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(TablerIcons.map_pin_plus, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Add New Address',
                            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> address, int index) {
    IconData icon = TablerIcons.map_pin;
    if (address['type'] == 'home') icon = TablerIcons.home;
    if (address['type'] == 'briefcase') icon = TablerIcons.briefcase;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryRed.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryRed.withOpacity(0.3)),
            ),
            child: Icon(icon, color: AppTheme.primaryRed, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address['title']!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  address['address']!,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.6),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              IconButton(
                icon: const Icon(TablerIcons.edit, color: Colors.white70, size: 20),
                onPressed: () => _showAddressDialog(index: index),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 16),
              IconButton(
                icon: Icon(TablerIcons.trash, color: AppTheme.primaryRed.withOpacity(0.8), size: 20),
                onPressed: () => _deleteAddress(index),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
