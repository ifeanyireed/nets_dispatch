import "../secrets.dart";
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../theme.dart';
import '../services/mapbox_service.dart';

class CreateDeliveryScreen extends StatefulWidget {
  const CreateDeliveryScreen({super.key});

  @override
  State<CreateDeliveryScreen> createState() => _CreateDeliveryScreenState();
}

class _CreateDeliveryScreenState extends State<CreateDeliveryScreen> {
  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();
  final _pickupFocus = FocusNode();
  final _dropoffFocus = FocusNode();
  
  bool _isLoadingRoute = false;
  bool _isGettingLocation = false;
  
  LatLng? _pickupLatLng;
  LatLng? _dropoffLatLng;
  List<LatLng> _polyline = [];
  
  String _distanceText = '--';
  String _durationText = '--';
  String _priceText = '--';
  
  String _selectedCategory = 'Document';
  final Map<String, double> _categoryMultipliers = {
    'Document': 1.0,
    'Parcel / Small Box': 1.2,
    'Food / Perishables': 1.5,
    'Fragile / Electronics': 2.0,
    'Large / Bulky': 2.5,
  };

  final MapController _mapController = MapController();
  
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }
  
  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    _pickupFocus.dispose();
    _dropoffFocus.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable them in settings.')));
        return;
      }
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions were denied.')));
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied. Please enable in settings.')));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      
      String? address = await MapboxService.reverseGeocode(currentLatLng);
      
      if (mounted) {
        setState(() {
          _pickupLatLng = currentLatLng;
          _pickupController.text = address ?? '${position.latitude}, ${position.longitude}';
          _mapController.move(currentLatLng, 15.0);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  Future<void> _calculateRouteAndRate({bool silent = false}) async {
    final pickup = _pickupController.text.trim();
    final dropoff = _dropoffController.text.trim();

    if (pickup.isEmpty || dropoff.isEmpty) {
      if (!silent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter both pickup and drop-off addresses')),
        );
      }
      return;
    }

    setState(() => _isLoadingRoute = true);

    try {
      // Always geocode to ensure we match the current text in the field
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
              
              // Base price logic: 500 + 100 per km * multiplier
              final multiplier = _categoryMultipliers[_selectedCategory] ?? 1.0;
              final price = (500 + (distKm * 150)) * multiplier;
              _priceText = '₦${price.toStringAsFixed(0)}';
            });
            
            // Adjust map view to fit route
            final bounds = LatLngBounds.fromPoints(_polyline);
            _mapController.fitCamera(CameraFit.bounds(
              bounds: bounds,
              padding: const EdgeInsets.all(50.0),
            ));
          }
        } else {
          if (!silent) _showError('Could not find a route between these locations.');
        }
      } else {
        if (!silent) _showError('Could not find coordinates for one of the addresses.');
      }
    } catch (e) {
      if (!silent) _showError('An error occurred while calculating route.');
    } finally {
      if (mounted) setState(() => _isLoadingRoute = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _proceedToPayment() {
    if (_polyline.isEmpty || _priceText == '--') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please calculate the route first.')),
      );
      return;
    }
    
    Navigator.pushNamed(context, '/payment', arguments: {
      'priceText': _priceText,
      'polyline': _polyline,
      'pickupLatLng': _pickupLatLng,
      'dropoffLatLng': _dropoffLatLng,
      'durationText': _durationText,
      'distanceText': _distanceText,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('New delivery', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Map
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(6.5244, 3.3792), // Default Lagos
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
          
          // Draggable Bottom Form
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.screenBackground,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, spreadRadius: 5),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24.0),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    
                    // Stats Row (Shows if route is calculated)
                    if (_polyline.isNotEmpty) ...[
                      Row(
                        children: [
                          Expanded(child: _buildStat(_distanceText, 'Distance')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildStat(_durationText, 'Est. time')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildStat(_priceText, 'Fee')),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],

                    _buildAddressAutocomplete('Pickup address', TablerIcons.map_pin, AppTheme.primaryRed, _pickupController, _pickupFocus,
                      suffixIcon: _isGettingLocation ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : IconButton(
                        icon: const Icon(TablerIcons.current_location, color: Colors.white54),
                        onPressed: _getCurrentLocation,
                      )
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Pickup name', TablerIcons.user, AppTheme.textSecondary)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('Phone', TablerIcons.phone, AppTheme.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildAddressAutocomplete('Drop-off address', TablerIcons.map_pin, Colors.blue, _dropoffController, _dropoffFocus),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Drop-off name', TablerIcons.user, AppTheme.textSecondary)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('Phone', TablerIcons.phone, AppTheme.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildTextField('Package description', null, null, maxLines: 3),
                    const SizedBox(height: 16),
                    
                    // Category Dropdown
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.inputBackground,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          dropdownColor: AppTheme.cardBackground,
                          icon: const Icon(TablerIcons.chevron_down, color: AppTheme.textSecondary),
                          isExpanded: true,
                          style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 15),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedCategory = newValue;
                              });
                              // Recalculate price if we already have a route
                              if (_polyline.isNotEmpty) {
                                _calculateRouteAndRate();
                              }
                            }
                          },
                          items: _categoryMultipliers.keys.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    if (_polyline.isEmpty)
                      GestureDetector(
                        onTap: _isLoadingRoute ? null : _calculateRouteAndRate,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppTheme.redGradientStart, AppTheme.redGradientEnd]),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [BoxShadow(color: AppTheme.primaryRed.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 8))],
                          ),
                          child: Center(
                            child: _isLoadingRoute 
                                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : Text('CALCULATE ROUTE', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.5)),
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: _proceedToPayment,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 8))],
                          ),
                          child: Center(
                            child: Text('PROCEED TO PAYMENT', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.5)),
                          ),
                        ),
                      ),
                      
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }



  Widget _buildAddressAutocomplete(String label, IconData icon, Color iconColor, TextEditingController controller, FocusNode focusNode, {Widget? suffixIcon}) {
    return RawAutocomplete<String>(
      textEditingController: controller,
      focusNode: focusNode,
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.length < 3) {
          return const Iterable<String>.empty();
        }
        return await MapboxService.autocompletePlaces(textEditingValue.text);
      },
      onSelected: (String selection) {
        controller.text = selection;
        if (_pickupController.text.trim().isNotEmpty && _dropoffController.text.trim().isNotEmpty) {
          _calculateRouteAndRate(silent: true);
        }
      },
      fieldViewBuilder: (context, textController, focus, onFieldSubmitted) {
        return _buildTextField(label, icon, iconColor, controller: textController, focusNode: focus, suffixIcon: suffixIcon);
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width - 48,
              margin: const EdgeInsets.only(top: 8),
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
                boxShadow: [
                  BoxShadow(color: Colors.black54, blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    leading: const Icon(TablerIcons.map_pin, color: AppTheme.textSecondary, size: 20),
                    title: Text(option, style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, IconData? icon, Color? iconColor, {int maxLines = 1, TextEditingController? controller, Widget? suffixIcon, FocusNode? focusNode}) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      style: TextStyle(fontFamily: 'Inter', color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontFamily: 'Inter', color: AppTheme.textSecondary),
        prefixIcon: icon != null ? Icon(icon, color: iconColor) : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppTheme.inputBackground,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: const BorderSide(color: AppTheme.primaryRed)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(color: AppTheme.inputBackground, borderRadius: BorderRadius.circular(100)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontFamily: 'IBM Plex Mono', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
