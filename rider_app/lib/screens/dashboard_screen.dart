import "../secrets.dart";
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import 'delivery_request_screen.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onNotificationTap;

  const DashboardScreen({
    super.key,
    required this.onNotificationTap,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isOnline = true;
  bool _showIncomingRequestAlert = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.screenBackground,
      body: Stack(
        children: [
          // Background Map representation
          Positioned.fill(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(6.6018, 3.3515), // Ikeja, Lagos
                initialZoom: 13.5,
                interactionOptions: InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/dark-v11/tiles/{z}/{x}/{y}?access_token=$mapboxToken',
                  userAgentPackageName: 'com.nets_dispatch.rider_app',
                  maxZoom: 19,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: const LatLng(6.6018, 3.3515),
                      width: 40,
                      height: 40,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(color: AppTheme.primaryRed.withOpacity(0.2), shape: BoxShape.circle),
                          ),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(color: AppTheme.primaryRed, shape: BoxShape.circle),
                          ),
                        ],
                      ),
                    ),
                    Marker(
                      point: const LatLng(6.5900, 3.3600),
                      width: 40,
                      height: 40,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), shape: BoxShape.circle),
                          ),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Gradient overlays to preserve text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.85),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.4, 0.95],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Profile row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.primaryRed, width: 2),
                              image: const DecorationImage(
                                image: AssetImage('moodboard/biker01.jpeg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ade Ogundele',
                                style: TextStyle(fontFamily: 'Inter', 
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(TablerIcons.star_filled, color: Colors.amber, size: 12),
                                  const SizedBox(width: 4),
                                  Text(
                                    '4.9 Gold Rider',
                                    style: TextStyle(fontFamily: 'IBM Plex Mono', 
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Online / Offline Switch
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isOnline = !_isOnline;
                            if (_isOnline) {
                              _showIncomingRequestAlert = true;
                            } else {
                              _showIncomingRequestAlert = false;
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isOnline ? Colors.green.withOpacity(0.12) : AppTheme.cardBackground,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _isOnline ? Colors.green.withOpacity(0.3) : Colors.white.withOpacity(0.08),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _isOnline ? Colors.green : AppTheme.textMuted,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isOnline ? 'ONLINE' : 'OFFLINE',
                                style: TextStyle(fontFamily: 'Inter', 
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: _isOnline ? Colors.green : AppTheme.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Stats Card Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.15,
                    children: [
                      _buildStatCell('₦12,400', "TODAY'S EARN", TablerIcons.cash),
                      _buildStatCell('6', 'DELIVERIES', TablerIcons.truck),
                      _buildStatCell('4.9', 'RATING', TablerIcons.star),
                    ],
                  ),
                ),
                
                const SizedBox(height: 18),
                
                // Live notice banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _isOnline ? Colors.green.withOpacity(0.08) : Colors.amber.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isOnline ? Colors.green.withOpacity(0.15) : Colors.amber.withOpacity(0.15),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isOnline ? TablerIcons.circle_check : TablerIcons.wifi_off,
                          color: _isOnline ? Colors.green : Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _isOnline 
                                ? "You're online — new dispatch requests will alert instantly." 
                                : "You are offline. Go online to start accepting delivery jobs.",
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),
                
                // Simulated Incoming Request Alert Overlay
                if (_showIncomingRequestAlert)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: _buildIncomingRequestBanner(),
                  ),
                
                const SizedBox(height: 90), // Spacing for bottom navbar
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCell(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppTheme.primaryRed, size: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(fontFamily: 'IBM Plex Mono', 
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(fontFamily: 'Inter', 
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncomingRequestBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'NEW REQUEST INCOMING',
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryRed,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              Text(
                '30s left',
                style: TextStyle(fontFamily: 'IBM Plex Mono', 
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Pickup: Chicken Republic (Ikeja)',
            style: TextStyle(fontFamily: 'Inter', 
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Drop-off: 14 Allen Avenue (4.6 km · 12 mins)',
            style: TextStyle(fontFamily: 'IBM Plex Mono', 
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Fee: ₦1,850',
                  style: TextStyle(fontFamily: 'IBM Plex Mono', 
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DeliveryRequestScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF7A0000),
                                        Color(0xFFFF2A2A),
                                        Color(0xFF7A0000),
                                      ],
                                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'VIEW DETAILS',
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapBackground() {
    return const SizedBox(); // Not used anymore
  }
}
