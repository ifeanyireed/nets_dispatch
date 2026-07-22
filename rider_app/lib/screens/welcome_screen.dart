import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'signin_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.screenBackground,
      body: Stack(
        children: [
          // Background Biker Image
          Positioned.fill(
            child: Image.asset(
              'moodboard/biker09.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // Dark Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                    Colors.black,
                  ],
                  stops: const [0.0, 0.5, 0.9],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Brand Header
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'NETS Dispatch',
                        style: TextStyle(fontFamily: 'Inter', 
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 3),
                  
                  // Text Content
                  Text(
                    'Deliver with\nNETS Dispatch',
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Flexible hours, weekly payouts. Ride when you want, earn what you need. Join the largest logistics network in Lagos.',
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  
                  const Spacer(flex: 2),

                  // Actions
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInScreen()),
                      );
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
                          'LOG IN',
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                      );
                    },
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
                          'CREATE ACCOUNT',
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
