import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'delivery_confirmation_screen.dart';

class PickupConfirmationScreen extends StatefulWidget {
  const PickupConfirmationScreen({super.key});

  @override
  State<PickupConfirmationScreen> createState() => _PickupConfirmationScreenState();
}

class _PickupConfirmationScreenState extends State<PickupConfirmationScreen> {
  bool _arrived = false;
  bool _photoCaptured = false;

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
          'Confirm Pickup',
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
              color: Colors.black.withOpacity(0.93),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  
                  // Stage Notice
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STAGE 1: PICKUP CONFIRMATION',
                          style: TextStyle(fontFamily: 'IBM Plex Mono', 
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primaryRed,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Please verify you have arrived, pick up the package, and capture a photo before departing.',
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Photo Capture Upload Box
                  Text(
                    'PACKAGE PHOTO PROOF',
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  GestureDetector(
                    onTap: _arrived 
                      ? () {
                          setState(() {
                            _photoCaptured = true;
                          });
                        }
                      : null,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _photoCaptured 
                              ? Colors.green.withOpacity(0.4) 
                              : Colors.white.withOpacity(0.08),
                          width: 1.5,
                        ),
                      ),
                      child: _photoCaptured
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.asset(
                                      'moodboard/biker03.jpeg', // Simulated package photo
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Container(color: Colors.black.withOpacity(0.2)),
                                  ),
                                  const Positioned(
                                    bottom: 12,
                                    right: 12,
                                    child: Icon(TablerIcons.circle_check_filled, color: Colors.green, size: 24),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  TablerIcons.camera,
                                  color: _arrived ? AppTheme.primaryRed : AppTheme.textMuted,
                                  size: 40,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _arrived ? 'Tap to capture package photo' : 'Confirm arrival to take photo',
                                  style: TextStyle(fontFamily: 'Inter', 
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _arrived ? Colors.white : AppTheme.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Required to verify handoff integrity',
                                  style: TextStyle(fontFamily: 'Inter', 
                                    fontSize: 11,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Status buttons
                  if (!_arrived)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _arrived = true;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF7A0000),
                                        Color(0xFFFF2A2A),
                                        Color(0xFF7A0000),
                                      ],
                                    ),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryRed.withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "I'VE ARRIVED AT VENDOR",
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: _photoCaptured
                        ? () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const DeliveryConfirmationScreen()),
                            );
                          }
                        : null,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: _photoCaptured ? null : AppTheme.inputBackground,
                          gradient: _photoCaptured 
                              ? LinearGradient(
                                  colors: [Colors.green, Colors.green.shade700],
                                )
                              : null,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: _photoCaptured
                              ? [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            "CONFIRM PICKUP & DEPART",
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: _photoCaptured ? Colors.white : AppTheme.textMuted,
                              letterSpacing: 1.0,
                            ),
                          ),
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
}
