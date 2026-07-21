import "../secrets.dart";
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/mapbox_service.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  LatLng? _pickupLatLng;
  LatLng? _dropoffLatLng;
  List<LatLng> _polyline = [];
  String _distanceText = '0 km';
  String _durationText = '0 min';
  String _priceText = '₦0';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading && _pickupLatLng == null) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('pickup') && args.containsKey('dropoff')) {
        _loadRoute(args['pickup'], args['dropoff']);
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadRoute(String pickup, String dropoff) async {
    final pLatLng = await MapboxService.geocodeAddress(pickup);
    final dLatLng = await MapboxService.geocodeAddress(dropoff);

    if (pLatLng != null && dLatLng != null) {
      final route = await MapboxService.getRoute(pLatLng, dLatLng);
      if (route != null) {
        if (mounted) {
          setState(() {
            _pickupLatLng = pLatLng;
            _dropoffLatLng = dLatLng;
            _polyline = route['polyline'];
            
            final distMeters = route['distance'] as double;
            final distKm = distMeters / 1000.0;
            _distanceText = '${distKm.toStringAsFixed(1)} km';
            
            final durSeconds = route['duration'] as double;
            final durMins = (durSeconds / 60.0).round();
            _durationText = '$durMins min';
            
            // Simple pricing: base 500 + 100 per km
            final price = 500 + (distKm * 150);
            _priceText = '₦${price.toStringAsFixed(0)}';
            
            _isLoading = false;
          });
        }
        return;
      }
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Quote', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/moodboard/biker09.jpeg', fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.92),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildStat(_distanceText, 'Distance')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStat(_durationText, 'Est. time')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStat(_priceText, 'Delivery fee')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: AppTheme.cardBackground, borderRadius: BorderRadius.circular(24)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryRed))
                            : _hasError
                                ? Center(
                                    child: Text('Could not calculate route.\nPlease try specific locations in Lagos.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: 'Inter', color: Colors.white70)))
                                : FlutterMap(
                                    options: MapOptions(
                                      initialCenter: _polyline.isNotEmpty ? _polyline[(_polyline.length / 2).floor()] : const LatLng(6.5244, 3.3792),
                                      initialZoom: 12.0,
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/dark-v11/tiles/{z}/{x}/{y}?access_token=$mapboxToken',
                                        userAgentPackageName: 'com.nets_dispatch.customer_app',
                                        maxZoom: 19,
                                      ),
                                      if (_polyline.isNotEmpty)
                                        PolylineLayer(
                                          polylines: [
                                            Polyline(
                                              points: _polyline,
                                              color: AppTheme.primaryRed,
                                              strokeWidth: 4.0,
                                            ),
                                          ],
                                        ),
                                      MarkerLayer(
                                        markers: [
                                          if (_pickupLatLng != null)
                                            Marker(
                                              point: _pickupLatLng!,
                                              width: 40,
                                              height: 40,
                                              child: const Icon(TablerIcons.map_pin_filled, color: AppTheme.primaryRed, size: 32),
                                            ),
                                          if (_dropoffLatLng != null)
                                            Marker(
                                              point: _dropoffLatLng!,
                                              width: 40,
                                              height: 40,
                                              child: const Icon(TablerIcons.map_pin_filled, color: Colors.blue, size: 32),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/payment', arguments: {
                        'priceText': _priceText,
                        'polyline': _polyline,
                        'pickupLatLng': _pickupLatLng,
                        'dropoffLatLng': _dropoffLatLng,
                        'durationText': _durationText,
                        'distanceText': _distanceText,
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppTheme.redGradientStart, AppTheme.redGradientEnd]),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [BoxShadow(color: AppTheme.primaryRed.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 8))],
                      ),
                      child: Center(
                        child: Text('CONFIRM & PAY', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.inputBackground, borderRadius: BorderRadius.circular(100)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontFamily: 'IBM Plex Mono', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
