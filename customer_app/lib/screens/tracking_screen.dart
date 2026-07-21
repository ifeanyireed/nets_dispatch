import "../secrets.dart";
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final List<LatLng> polyline = args?['polyline'] ?? [];
    final LatLng? pickupLatLng = args?['pickupLatLng'];
    final LatLng? dropoffLatLng = args?['dropoffLatLng'];
    final String durationText = args?['durationText'] ?? '9 min';
    final String distanceText = args?['distanceText'] ?? '2.4 km';
    
    final LatLng center = polyline.isNotEmpty 
        ? polyline[(polyline.length / 2).floor()] 
        : const LatLng(6.5244, 3.3792);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.5),
            child: IconButton(
              icon: const Icon(TablerIcons.arrow_left, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Map
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/dark-v11/tiles/{z}/{x}/{y}?access_token=$mapboxToken',
                  userAgentPackageName: 'com.nets_dispatch.customer_app',
                  maxZoom: 19,
                ),
                if (polyline.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: polyline,
                        color: AppTheme.primaryRed,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    if (dropoffLatLng != null)
                      Marker(
                        point: dropoffLatLng,
                        width: 40,
                        height: 40,
                        child: const Icon(TablerIcons.map_pin_filled, color: Colors.blue, size: 36),
                      ),
                    if (pickupLatLng != null)
                      Marker(
                        point: pickupLatLng, // Rider is currently at pickup
                        width: 50,
                        height: 50,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.primaryRed,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 4))],
                          ),
                          child: const Icon(TablerIcons.motorbike, color: Colors.white, size: 24),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          // Draggable Bottom Sheet for Tracking Details
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.25,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.screenBackground.withOpacity(0.85),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                      border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      children: [
                        // Drag Handle
                        Center(
                          child: Container(
                            width: 48,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Status & ETA
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Arriving in $durationText',
                                  style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$distanceText away',
                                  style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryRed.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppTheme.primaryRed.withOpacity(0.3)),
                              ),
                              child: Text(
                                'On the way',
                                style: TextStyle(fontFamily: 'Inter', color: AppTheme.primaryRed, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Rider Info Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.cardBackground,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.05)),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: const AssetImage('assets/moodboard/biker09.jpeg'), // Mock avatar
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('David O.', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 2),
                                    Text('Yamaha • ABC-123', style: TextStyle(fontFamily: 'Inter', color: AppTheme.textSecondary, fontSize: 13)),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  _buildActionIcon(TablerIcons.message_circle, Colors.blue, () {
                                    Navigator.pushNamed(context, '/chat');
                                  }),
                                  const SizedBox(width: 12),
                                  _buildActionIcon(TablerIcons.phone, Colors.green, () {}),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Timeline
                        Text(
                          'Delivery Status',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        
                        _buildTimelineStep('Order confirmed', '10:30 AM', true, isLast: false),
                        _buildTimelineStep('Rider assigned', '10:32 AM', true, isLast: false),
                        _buildTimelineStep('Package picked up', '10:45 AM', true, isLast: false),
                        _buildTimelineStep('On the way', 'Expected in $durationText', true, isActive: true, isLast: false),
                        _buildTimelineStep('Delivered', 'Pending', false, isLast: true),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildTimelineStep(String title, String subtitle, bool isDone, {bool isActive = false, bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppTheme.primaryRed : (isDone ? AppTheme.primaryRed.withOpacity(0.5) : AppTheme.cardBackground),
                border: Border.all(
                  color: isActive ? AppTheme.primaryRed.withOpacity(0.3) : Colors.transparent,
                  width: isActive ? 6 : 0,
                ),
              ),
              child: isDone && !isActive 
                  ? const Icon(TablerIcons.check, size: 14, color: Colors.white) 
                  : (isActive ? Center(child: Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle))) : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isDone ? AppTheme.primaryRed.withOpacity(0.5) : AppTheme.cardBackground,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: isDone || isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.white : (isDone ? Colors.white70 : AppTheme.textSecondary),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: isActive ? AppTheme.primaryRed : AppTheme.textSecondary,
                ),
              ),
              if (!isLast) const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
