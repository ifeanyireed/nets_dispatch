import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'bike_financing_screen.dart';
import 'welcome_screen.dart';

class RiderProfileScreen extends StatefulWidget {
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
  State<RiderProfileScreen> createState() => _RiderProfileScreenState();
}

class _RiderProfileScreenState extends State<RiderProfileScreen> {
  String _name = "Guest Rider";
  String _email = "Not provided";
  String _phone = "Not provided";
  String _vehicle = "Not provided";

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = widget.name ?? prefs.getString('name') ?? "Guest Rider";
      _email = prefs.getString('email') ?? "Not provided";
      _phone = prefs.getString('phone') ?? "Not provided";
      _vehicle = widget.bike ?? prefs.getString('vehicle') ?? "Motorcycle (Bajaj Pulsar)";
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
  }

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
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          // Background Decorators
          Positioned.fill(
            child: Image.asset(
              'moodboard/biker09.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.95),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          // Glow effect
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryRed.withOpacity(0.15),
                // ignore: prefer_const_constructors
                boxShadow: [
                  BoxShadow(color: AppTheme.primaryRed.withOpacity(0.2), blurRadius: 100, spreadRadius: 50)
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Top Avatar header card
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.primaryRed, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryRed.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                                image: DecorationImage(
                                  image: AssetImage(widget.image ?? 'moodboard/biker01.jpeg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  // TODO: Handle photo update
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryRed,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black, width: 2),
                                  ),
                                  child: const Icon(
                                    TablerIcons.camera,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _name,
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green.withOpacity(0.3)),
                          ),
                          child: Text(
                            'VERIFIED RIDER',
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Colors.greenAccent,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Personal Info Card
                  _buildSectionHeader('PERSONAL INFORMATION'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Column(
                      children: [
                        _buildProfileKV('Phone Number', _phone),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: Colors.white10, height: 1),
                        ),
                        _buildProfileKV('Email Address', _email),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: Colors.white10, height: 1),
                        ),
                        _buildProfileKV('Dispatch Zone', 'Lagos, Nigeria'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 28),
                  
                  // Vehicle Card
                  _buildSectionHeader('VEHICLE DETAILS'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Column(
                      children: [
                        _buildProfileKV('Vehicle', _vehicle),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: Colors.white10, height: 1),
                        ),
                        _buildProfileKV('Ownership', 'Registered Rider'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 28),
                  
                  // Support Action Banner
                  GestureDetector(
                    onTap: () {
                      // Navigate to support
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryRed.withOpacity(0.15),
                            AppTheme.primaryRed.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryRed.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(TablerIcons.headset, color: AppTheme.primaryRed, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Help & Support',
                                  style: TextStyle(fontFamily: 'Inter', 
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Contact dispatch for issues with deliveries or your account.',
                                  style: TextStyle(fontFamily: 'Inter', 
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(TablerIcons.chevron_right, color: AppTheme.primaryRed, size: 20),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Logout Button
                  GestureDetector(
                    onTap: _logout,
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: Center(
                        child: Text(
                          'LOG OUT',
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.white70,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
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
        padding: const EdgeInsets.only(bottom: 12, left: 4),
        child: Text(
          label,
          style: TextStyle(fontFamily: 'Inter', 
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: AppTheme.textSecondary,
            letterSpacing: 1.0,
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
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontFamily: 'IBM Plex Mono', 
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(BuildContext context, IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent, // to make the whole row clickable
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.inputBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white70, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(TablerIcons.chevron_right, color: AppTheme.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }
}
