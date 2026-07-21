import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.screenBackground,
      extendBodyBehindAppBar: true,
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
              'assets/moodboard/biker09.jpeg',
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
                            image: const DecorationImage(
                              image: AssetImage('assets/moodboard/biker01.jpeg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'T. Balogun',
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
                            color: Colors.blue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.withOpacity(0.3)),
                          ),
                          child: Text(
                            'PREMIUM CUSTOMER',
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Colors.blue,
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
                        _buildProfileKV('Phone Number', '0805 123 4502'),
                        const SizedBox(height: 12),
                        _buildProfileKV('Email Address', 't.balogun@example.com'),
                        const SizedBox(height: 12),
                        _buildProfileKV('Default Area', 'Lekki Phase 1, Lagos'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Saved Addresses & Payment Methods
                  _buildSectionHeader('ACCOUNT SETTINGS'),
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
                        _buildActionRow(context, TablerIcons.map_pin, 'Saved Addresses', 'Manage your delivery locations'),
                        const SizedBox(height: 16),
                        const Divider(color: AppTheme.inputBackground, height: 1),
                        const SizedBox(height: 16),
                        _buildActionRow(context, TablerIcons.credit_card, 'Payment Methods', 'Manage your cards and wallet'),
                        const SizedBox(height: 16),
                        const Divider(color: AppTheme.inputBackground, height: 1),
                        const SizedBox(height: 16),
                        _buildActionRow(context, TablerIcons.bell, 'Notifications', 'Manage alerts and updates'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Support Action Banner
                  GestureDetector(
                    onTap: () {
                      // Navigate to support
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
                          const Icon(TablerIcons.headset, color: AppTheme.primaryRed, size: 24),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Help & Support',
                                  style: TextStyle(fontFamily: 'Inter', 
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Contact us for issues with your deliveries or account.',
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
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false),
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
          const Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CustomBottomNav(currentIndex: 3),
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

  Widget _buildActionRow(BuildContext context, IconData icon, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        // Handle action tap
      },
      child: Container(
        color: Colors.transparent, // to make the whole row clickable
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.inputBackground,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(icon, color: Colors.white70, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(TablerIcons.chevron_right, color: AppTheme.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }
}

