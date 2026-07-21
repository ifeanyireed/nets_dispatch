import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_bottom_nav.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _periodTabController;
  int _activePeriodIndex = 1; // Default to Weekly

  @override
  void initState() {
    super.initState();
    _periodTabController = TabController(length: 3, vsync: this, initialIndex: _activePeriodIndex);
    _periodTabController.addListener(() {
      setState(() {
        _activePeriodIndex = _periodTabController.index;
      });
    });
  }

  @override
  void dispose() {
    _periodTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.screenBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'History',
          style: TextStyle(fontFamily: 'Inter', 
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/moodboard/biker09.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.92),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  
                  // Period Tabs
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    child: TabBar(
                      controller: _periodTabController,
                      indicatorColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                      unselectedLabelColor: AppTheme.textSecondary,
                      indicator: BoxDecoration(
                        color: AppTheme.primaryRed.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      labelColor: AppTheme.primaryRed,
                      tabs: const [
                        Tab(child: Text('Today', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                        Tab(child: Text('Weekly', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                        Tab(child: Text('Monthly', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Spend stats card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.04)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _activePeriodIndex == 0 ? "TODAY'S SPEND" : _activePeriodIndex == 1 ? "WEEKLY SPEND" : "MONTHLY SPEND",
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _activePeriodIndex == 0 ? '₦2,100' : _activePeriodIndex == 1 ? '₦18,400' : '₦54,100',
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Divider(color: Colors.white10),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'COMPLETED ORDERS',
                                    style: TextStyle(fontFamily: 'Inter', 
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _activePeriodIndex == 0 ? '1 delivery' : _activePeriodIndex == 1 ? '9 deliveries' : '28 deliveries',
                                    style: TextStyle(fontFamily: 'Inter', 
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'AVERAGE FEE',
                                    style: TextStyle(fontFamily: 'Inter', 
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₦2,044',
                                    style: TextStyle(fontFamily: 'IBM Plex Mono', 
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Spend Trend Bar Chart
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      height: 160,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.04)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DAILY SPEND TREND',
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildBar('M', 20),
                              _buildBar('T', 40),
                              _buildBar('W', 10),
                              _buildBar('T', 60),
                              _buildBar('F', 80),
                              _buildBar('S', 30),
                              _buildBar('S', 50),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Recent Orders List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RECENT ORDERS',
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildHistoryItem('NLG-88201', 'Ikeja → Yaba · Today', '₦2,100'),
                        const SizedBox(height: 12),
                        _buildHistoryItem('NLG-88177', 'Lekki → VI · Jul 12', '₦1,750'),
                        const SizedBox(height: 12),
                        _buildHistoryItem('NLG-87990', 'Surulere → Ikeja · Jul 05', '₦3,200'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 100), // padding for floating navigation
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CustomBottomNav(currentIndex: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String day, double heightPercent) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 80 * (heightPercent / 100),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.redGradientStart, AppTheme.redGradientEnd],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: TextStyle(fontFamily: 'Inter', 
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String id, String details, String price) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.inputBackground,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(TablerIcons.box, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(id, style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                const SizedBox(height: 4),
                Text(details, style: TextStyle(fontFamily: 'Inter', color: AppTheme.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: TextStyle(fontFamily: 'IBM Plex Mono', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.darkRedBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'DELIVERED',
                  style: TextStyle(fontFamily: 'Inter', color: AppTheme.primaryRed, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
