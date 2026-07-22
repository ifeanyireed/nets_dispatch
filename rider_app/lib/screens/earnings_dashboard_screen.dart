import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'earnings_history_screen.dart';

class EarningsDashboardScreen extends StatefulWidget {
  const EarningsDashboardScreen({super.key});

  @override
  State<EarningsDashboardScreen> createState() => _EarningsDashboardScreenState();
}

class _EarningsDashboardScreenState extends State<EarningsDashboardScreen> with SingleTickerProviderStateMixin {
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
          'Earnings',
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
              'moodboard/biker09.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.92),
            ),
          ),
          SafeArea(
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
                
                // Earnings stats card
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
                          _activePeriodIndex == 0 ? "TODAY'S PAYOUT" : _activePeriodIndex == 1 ? "WEEKLY EARNINGS" : "MONTHLY EARNINGS",
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _activePeriodIndex == 0 ? '₦12,400' : _activePeriodIndex == 1 ? '₦84,200' : '₦382,100',
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
                                  'COMPLETED JOBS',
                                  style: TextStyle(fontFamily: 'Inter', 
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _activePeriodIndex == 0 ? '6 deliveries' : _activePeriodIndex == 1 ? '46 deliveries' : '182 deliveries',
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
                                  'AVERAGE PER JOB',
                                  style: TextStyle(fontFamily: 'Inter', 
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₦2,060',
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
                
                // Earnings Trend Bar Chart
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
                          'DAILY REVENUE TREND',
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
                            _buildBar('M', 40),
                            _buildBar('T', 60),
                            _buildBar('W', 30),
                            _buildBar('T', 73),
                            _buildBar('F', 100),
                            _buildBar('S', 46),
                            _buildBar('S', 86),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // View history & withdraw actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EarningsHistoryScreen()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.4)),
                      ),
                      child: Center(
                        child: Text(
                          'VIEW TRANSACTION HISTORY',
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryRed,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 100), // padding for floating navigation
              ],
            ),
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
                                      colors: [
                                        Color(0xFF7A0000),
                                        Color(0xFFFF2A2A),
                                        Color(0xFF7A0000),
                                      ],
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
}
