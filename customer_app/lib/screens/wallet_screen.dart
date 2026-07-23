import 'package:flutter/material.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(TablerIcons.chevron_left, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Wallet & Payments',
          style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryRed,
                      AppTheme.primaryRed.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryRed.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Available Balance',
                          style: TextStyle(fontFamily: 'Inter', color: Colors.white.withOpacity(0.8), fontSize: 14),
                        ),
                        const Icon(TablerIcons.wallet, color: Colors.white, size: 24),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '₦${_walletBalance.toStringAsFixed(2)}',
                      style: const TextStyle(fontFamily: 'IBM Plex Mono', color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _processPayment(context, amountKobo: 500000, isAddingCard: false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryRed,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(TablerIcons.plus, size: 18),
                          SizedBox(width: 8),
                          Text('Fund Wallet', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              const Text(
                'PAYMENT METHODS',
                style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: Colors.white54),
              ),
              const SizedBox(height: 16),
              
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(TablerIcons.credit_card, color: Colors.white70, size: 20),
                      ),
                      title: const Text('Add New Card', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                      subtitle: Text('Powered by Paystack', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.white.withOpacity(0.5))),
                      trailing: const Icon(TablerIcons.chevron_right, color: Colors.white38, size: 20),
                      onTap: () => _processPayment(context, amountKobo: 5000, isAddingCard: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
