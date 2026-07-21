import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EarningsHistoryScreen extends StatelessWidget {
  const EarningsHistoryScreen({super.key});

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
          'History',
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              children: [
                const SizedBox(height: 10),
                
                // History Items List
                _buildHistoryRow(
                  title: 'Delivery NLG-88231',
                  date: 'Completed • Today 2:41 PM',
                  amount: '+₦1,850',
                  isPositive: true,
                  icon: TablerIcons.truck,
                ),
                const SizedBox(height: 12),
                _buildHistoryRow(
                  title: 'Weekly Payout Bonus',
                  date: 'Completion streak reward',
                  amount: '+₦2,000',
                  isPositive: true,
                  icon: TablerIcons.gift,
                ),
                const SizedBox(height: 12),
                _buildHistoryRow(
                  title: 'Withdrawal to GTBank',
                  date: 'Bank account •••••2291',
                  amount: '-₦40,000',
                  isPositive: false,
                  icon: TablerIcons.wallet,
                ),
                const SizedBox(height: 12),
                _buildHistoryRow(
                  title: 'Delivery NLG-88210',
                  date: 'Completed • Yesterday 5:12 PM',
                  amount: '+₦2,100',
                  isPositive: true,
                  icon: TablerIcons.truck,
                ),
                const SizedBox(height: 12),
                _buildHistoryRow(
                  title: 'Delivery NLG-88204',
                  date: 'Completed • Jul 19, 11:30 AM',
                  amount: '+₦1,900',
                  isPositive: true,
                  icon: TablerIcons.truck,
                ),
                const SizedBox(height: 12),
                _buildHistoryRow(
                  title: 'Delivery NLG-88190',
                  date: 'Completed • Jul 18, 4:50 PM',
                  amount: '+₦1,850',
                  isPositive: true,
                  icon: TablerIcons.truck,
                ),
                const SizedBox(height: 12),
                _buildHistoryRow(
                  title: 'Withdrawal to GTBank',
                  date: 'Bank account •••••2291',
                  amount: '-₦35,000',
                  isPositive: false,
                  icon: TablerIcons.wallet,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryRow({
    required String title,
    required String date,
    required String amount,
    required bool isPositive,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPositive ? Colors.green.withOpacity(0.08) : AppTheme.inputBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isPositive ? Colors.green : Colors.white70,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontFamily: 'Inter', 
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  date,
                  style: TextStyle(fontFamily: 'Inter', 
                    fontSize: 10,
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(fontFamily: 'IBM Plex Mono', 
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: isPositive ? Colors.green : AppTheme.primaryRed,
            ),
          ),
        ],
      ),
    );
  }
}
