import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../theme.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _paystackPlugin = PaystackPlugin();
  bool _isPaystackInitialized = false;
  double _walletBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _initializePaystack();
    // Simulate fetching wallet balance
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _walletBalance = 4500.00;
        });
      }
    });
  }

  Future<void> _initializePaystack() async {
    final publicKey = dotenv.env['PAYSTACK_PUBLIC_KEY'];
    if (publicKey != null) {
      await _paystackPlugin.initialize(publicKey: publicKey);
      setState(() {
        _isPaystackInitialized = true;
      });
    }
  }

  String _getReference() {
    return 'NetsLogistics_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _processPayment(BuildContext context, {required int amountKobo, required bool isAddingCard}) async {
    if (!_isPaystackInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment gateway not initialized')),
      );
      return;
    }

    final charge = Charge()
      ..amount = amountKobo
      ..reference = _getReference()
      ..email = 'customer@netslogistics.com'
      ..currency = 'NGN';

    final response = await _paystackPlugin.checkout(
      context,
      method: CheckoutMethod.card, // Only use card method to skip modal options if needed, but it shows native UI
      charge: charge,
      fullscreen: false,
      logo: const Icon(TablerIcons.wallet, color: AppTheme.primaryRed, size: 40),
    );

    if (response.status == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAddingCard ? 'Card added successfully!' : 'Wallet funded successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      if (!isAddingCard) {
        setState(() {
          _walletBalance += (amountKobo / 100);
        });
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.screenBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(TablerIcons.chevron_left, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Wallet',
          style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background ambient light
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryRed.withOpacity(0.15),
                // blur
                boxShadow: [
                  BoxShadow(color: AppTheme.primaryRed.withOpacity(0.2), blurRadius: 100, spreadRadius: 50),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wallet Balance Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryRed,
                          const Color(0xFFE53935), // slightly darker red
                          AppTheme.primaryRed.withOpacity(0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryRed.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                    ),
                    child: Stack(
                      children: [
                        // Decorative pattern rings
                        Positioned(
                          right: -40,
                          top: -40,
                          child: Icon(TablerIcons.circle_filled, size: 150, color: Colors.white.withOpacity(0.05)),
                        ),
                        Positioned(
                          right: 20,
                          top: 40,
                          child: Icon(TablerIcons.circle, size: 80, color: Colors.white.withOpacity(0.1)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Available Balance',
                                  style: TextStyle(fontFamily: 'Inter', color: Colors.white.withOpacity(0.85), fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(CupertinoIcons.creditcard, color: Colors.white, size: 24),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '₦${_walletBalance.toStringAsFixed(2)}',
                              style: const TextStyle(fontFamily: 'IBM Plex Mono', color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: -1.0),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _processPayment(context, amountKobo: 500000, isAddingCard: false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppTheme.primaryRed,
                                  elevation: 10,
                                  shadowColor: Colors.black.withOpacity(0.3),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(TablerIcons.plus, size: 20),
                                    SizedBox(width: 8),
                                    Text('Fund Wallet', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 15)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  const Text(
                    'PAYMENT SETTINGS',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: Colors.white54),
                  ),
                  const SizedBox(height: 16),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(TablerIcons.credit_card, color: Colors.white, size: 22),
                          ),
                          title: const Text('Add New Card', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('Securely link a debit or credit card', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.white.withOpacity(0.5))),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
                            child: const Icon(TablerIcons.chevron_right, color: Colors.white54, size: 18),
                          ),
                          onTap: () => _processPayment(context, amountKobo: 5000, isAddingCard: true),
                        ),
                      ],
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
}
