import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'navigation_screen.dart';

class DeliveryDetailScreen extends StatelessWidget {
  const DeliveryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.screenBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(TablerIcons.chevron_left, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Delivery Details',
          style: TextStyle(fontFamily: 'Inter', 
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background biker image
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  
                  // Active Job Info Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.primaryRed.withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        const Icon(TablerIcons.truck, color: AppTheme.primaryRed, size: 22),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Order NLG-88231 • Accepted & Active',
                            style: TextStyle(fontFamily: 'IBM Plex Mono', 
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Section 1: Pickup Information
                  _buildSectionHeader('PICKUP FROM VENDOR'),
                  _buildInfoCard(
                    title: 'Chicken Republic (Ikeja)',
                    details: '14 Awolowo Rd, Ikeja Mall, Lagos',
                    contact: '0803 987 6543',
                    actionLabel: 'CALL VENDOR',
                    icon: TablerIcons.building_store,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Section 2: Delivery Drop-off Information
                  _buildSectionHeader('DELIVER TO CUSTOMER'),
                  _buildInfoCard(
                    title: 'T. Balogun',
                    details: '22 Allen Avenue, Ikeja, Lagos',
                    contact: '0805 111 2233',
                    actionLabel: 'CALL CUSTOMER',
                    icon: TablerIcons.user,
                    instructions: 'Special Note: Ring the bell. Call on arrival.',
                  ),
                  
                  const Spacer(),
                  
                  // Start Navigation Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const NavigationScreen()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF7A0000),
                                        Color(0xFFFF2A2A),
                                        Color(0xFF7A0000),
                                      ],
                                    ),
                        borderRadius: BorderRadius.circular(27),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryRed.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(TablerIcons.navigation, color: Colors.white, size: 18),
                          const SizedBox(width: 10),
                          Text(
                            'START NAVIGATION',
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: TextStyle(fontFamily: 'Inter', 
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: AppTheme.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String details,
    required String contact,
    required String actionLabel,
    required IconData icon,
    String? instructions,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppTheme.primaryRed, size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      details,
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (instructions != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.inputBackground,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                instructions,
                style: TextStyle(fontFamily: 'Inter', 
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 16),
          const Divider(color: Colors.white10),
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                contact,
                style: TextStyle(fontFamily: 'Inter', 
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white70,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Simulate Call action
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Row(
                    children: [
                      const Icon(TablerIcons.phone, color: Colors.white70, size: 12),
                      const SizedBox(width: 6),
                      Text(
                        actionLabel,
                        style: TextStyle(fontFamily: 'Inter', 
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
