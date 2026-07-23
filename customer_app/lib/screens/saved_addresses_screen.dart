import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../theme.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  // Mock data for now
  final List<Map<String, String>> _addresses = [
    {
      'title': 'Home',
      'address': 'Plot 4, Admiralty Way, Lekki Phase 1, Lagos',
      'type': 'home'
    },
    {
      'title': 'Office',
      'address': 'Landmark Centre, Water Corporation Drive, Victoria Island, Lagos',
      'type': 'briefcase'
    },
  ];

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
                    child: _addresses.isEmpty
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
                              return _buildAddressCard(address);
                            },
                          ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Add New Address Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to add address map
                      },
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

  Widget _buildAddressCard(Map<String, String> address) {
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
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 16),
              IconButton(
                icon: Icon(TablerIcons.trash, color: AppTheme.primaryRed.withOpacity(0.8), size: 20),
                onPressed: () {},
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
