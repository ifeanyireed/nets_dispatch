import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final priceText = args?['priceText'] ?? '₦2,100';

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Payment', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
          Positioned.fill(child: Image.asset('assets/moodboard/biker09.jpeg', fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.92),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Total to pay',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Inter', color: AppTheme.textSecondary, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    priceText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'IBM Plex Mono', color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 48),
                  
                  // Paystack Only Option
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.primaryRed,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(TablerIcons.device_mobile_dollar, color: AppTheme.primaryRed, size: 28),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Paystack',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryRed,
                          ),
                          child: const Icon(TablerIcons.check, color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 32),
                    decoration: BoxDecoration(
                      color: AppTheme.inputBackground,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(TablerIcons.shield_check, color: Colors.green),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'You will be redirected to Paystack to complete this transaction securely.',
                            style: TextStyle(fontFamily: 'Inter', color: AppTheme.textSecondary, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context, 
                        '/tracking', 
                        (route) => route.settings.name == '/home',
                        arguments: args,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.redGradientStart, AppTheme.redGradientEnd],
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
                          'CONTINUE WITH PAYSTACK',
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
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
