import "../secrets.dart";
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import '../theme.dart';
import '../widgets/custom_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                interactionOptions: InteractionOptions(flags: InteractiveFlag.none),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/dark-v11/tiles/{z}/{x}/{y}?access_token=$mapboxToken',
                  userAgentPackageName: 'com.nets_dispatch.customer_app',
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
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.primaryRed, width: 2),
                          image: const DecorationImage(
                            image: AssetImage('assets/moodboard/biker01.jpeg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'T. Balogun',
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(TablerIcons.crown, color: Colors.blueAccent, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                'Premium Customer',
                                style: TextStyle(fontFamily: 'Inter', 
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
                      _buildStatCell('1', 'ACTIVE', TablerIcons.box),
                      _buildStatCell('₦12.4k', 'SPENT', TablerIcons.cash),
                      _buildStatCell('3', 'ADDRESSES', TablerIcons.map_pin),
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
                      color: Colors.blue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          TablerIcons.info_circle,
                          color: Colors.blue,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "You have 1 active delivery in progress.",
                            style: TextStyle(fontFamily: 'IBM Plex Mono', 
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
                
                // Active Delivery Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: _buildActiveDeliveryBanner(context),
                ),

                const SizedBox(height: 12),

                // Book a Delivery Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/create_delivery'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppTheme.redGradientStart, AppTheme.redGradientEnd]),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [BoxShadow(color: AppTheme.primaryRed.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 8))],
                      ),
                      child: Center(
                        child: Text(
                          'BOOK A NEW DELIVERY', 
                          style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.5)
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 100), // Spacing for bottom navbar
              ],
            ),
          ),

          const Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CustomBottomNav(currentIndex: 0),
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

  Widget _buildActiveDeliveryBanner(BuildContext context) {
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
                    'IN TRANSIT',
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
                'ETA: 12 mins',
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
            'Drop-off: 14 Allen Avenue',
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
                  'Order NLG-88201',
                  style: TextStyle(fontFamily: 'IBM Plex Mono', 
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/tracking');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.redGradientStart, AppTheme.redGradientEnd],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'TRACK ORDER',
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
}
