import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'bike_financing_screen.dart';
import 'welcome_screen.dart';

class RiderProfileScreen extends StatelessWidget {
  final String? name;
  final String? bike;
  final String? image;
  final VoidCallback? onSendRequest;

  const RiderProfileScreen({
    super.key,
    this.name,
    this.bike,
    this.image,
    this.onSendRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.screenBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(fontFamily: 'Inter', 
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'moodboard/biker09.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.92),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  
                  // Top Avatar header card
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.primaryRed, width: 3),
                            image: DecorationImage(
                              image: AssetImage(image ?? 'moodboard/biker01.jpeg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          name ?? 'Ade Ogundele',
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.withOpacity(0.3)),
                          ),
                          child: Text(
                            'VERIFIED RIDER',
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Colors.green,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Personal Info Card
                  _buildSectionHeader('PERSONAL INFORMATION'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    child: Column(
                      children: [
                        _buildProfileKV('Phone Number', '0803 987 6543'),
                        const SizedBox(height: 12),
                        _buildProfileKV('Email Address', 'ade.o@netlogistics.ng'),
                        const SizedBox(height: 12),
                        _buildProfileKV('Dispatch Zone', 'Ikeja / Mainland, Lagos'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Vehicle Card
                  _buildSectionHeader('VEHICLE DETAILS'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    child: Column(
                      children: [
                        _buildProfileKV('Vehicle Type', bike ?? 'Motorcycle (Bajaj Pulsar)'),
                        const SizedBox(height: 12),
                        _buildProfileKV('Plate Number', 'KJA-224-XY'),
                        const SizedBox(height: 12),
                        _buildProfileKV('Ownership', 'Leased (NETS Logistics Financing)'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Bike Financing Action Banner
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BikeFinancingScreen()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryRed.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(TablerIcons.motorbike, color: AppTheme.primaryRed, size: 24),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bike Financing Option',
                                  style: TextStyle(fontFamily: 'Inter', 
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Apply for a new motorcycle loan repaid from weekly payouts.',
                                  style: TextStyle(fontFamily: 'Inter', 
                                    fontSize: 11,
                                    color: AppTheme.textSecondary,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(TablerIcons.chevron_right, color: AppTheme.primaryRed, size: 14),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Logout Button
                  GestureDetector(
                    onTap: () {
                      // Navigate back to WelcomeScreen and clear state
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                        (route) => false,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: Colors.white.withOpacity(0.12)),
                      ),
                      child: Center(
                        child: Text(
                          'LOG OUT',
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white70,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // padding for navbar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 4),
        child: Text(
          label,
          style: TextStyle(fontFamily: 'Inter', 
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: AppTheme.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileKV(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: TextStyle(fontFamily: 'Inter', 
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontFamily: 'IBM Plex Mono', 
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
