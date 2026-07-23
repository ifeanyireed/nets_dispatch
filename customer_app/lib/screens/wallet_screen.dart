import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../theme.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double _walletBalance = 0.0;

  @override
  void initState() {
    super.initState();
    // Simulate fetching wallet balance
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _walletBalance = 4500.00;
        });
      }
    });
  }

  void _fundWallet(BuildContext context) async {
    final secretKey = dotenv.env['PAYSTACK_SECRET_KEY'];
    
    if (secretKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment gateway configuration missing')),
      );
      return;
    }

    try {
      await FlutterPaystackPlus.openPaystackPopup(
        context: context,
        customerEmail: 'customer@netslogistics.com',
        amount: '500000', // ₦5000 in kobo
        reference: 'NetsLogistics_${DateTime.now().millisecondsSinceEpoch}',
        secretKey: secretKey,
        callBackUrl: 'https://netslogistics.com/callback',
        currency: 'NGN',
        onSuccess: () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Wallet funded successfully!'), backgroundColor: Colors.green),
            );
            setState(() {
              _walletBalance += 5000.0;
            });
          }
        },
        onClosed: () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment cancelled.'), backgroundColor: Colors.orange),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Error: $e'), backgroundColor: Colors.red),
        );
      }
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
                      onPressed: () => _fundWallet(context),
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
                      onTap: () => _fundWallet(context),
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
