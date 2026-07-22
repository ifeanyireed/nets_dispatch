import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BikeFinancingScreen extends StatefulWidget {
  const BikeFinancingScreen({super.key});

  @override
  State<BikeFinancingScreen> createState() => _BikeFinancingScreenState();
}

class _BikeFinancingScreenState extends State<BikeFinancingScreen> {
  String _selectedModel = 'Bajaj Pulsar 150';
  String _selectedPlan = '12 Months Payout Plan';
  bool _applied = false;

  final List<String> _models = [
    'Bajaj Pulsar 150',
    'TVS HLX 150',
    'Honda Ace 125',
    'Suzuki Haojue 110',
  ];

  final List<String> _plans = [
    '6 Months Payout Plan',
    '12 Months Payout Plan',
    '18 Months Payout Plan',
  ];

  void _handleApply() {
    setState(() {
      _applied = true;
    });
    
    // Show snackbar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green.shade900,
        content: Text(
          'Financing application submitted successfully!',
          style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

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
          'Bike Financing',
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  
                  // Eligibility Banner Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.withOpacity(0.15)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(TablerIcons.shield_check, color: Colors.green, size: 24),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "You're Eligible for Bike Loans",
                                style: TextStyle(fontFamily: 'Inter', 
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Repay easily in small weekly deductions from your delivery payouts. No upfront deposit required.',
                                style: TextStyle(fontFamily: 'Inter', 
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 28),
                  
                  // Application Form Details
                  if (!_applied) ...[
                    Text(
                      'FINANCING APPLICATION',
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    
                    _buildFieldLabel('Preferred Motorcycle Model'),
                    _buildDropdownField(
                      value: _selectedModel,
                      items: _models,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedModel = val);
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    _buildFieldLabel('Repayment Duration Plan'),
                    _buildDropdownField(
                      value: _selectedPlan,
                      items: _plans,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedPlan = val);
                      },
                    ),
                    
                    const SizedBox(height: 36),
                    
                    // Apply button
                    GestureDetector(
                      onTap: _handleApply,
                      child: Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF7A0000),
                                        Color(0xFFFF2A2A),
                                        Color(0xFF7A0000),
                                      ],
                                    ),
                          borderRadius: BorderRadius.circular(27),
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
                            'SUBMIT FINANCING APPLICATION',
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Status Timeline details
                    Text(
                      'LOAN STATUS TRACKING',
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildStatusTimeline(),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: TextStyle(fontFamily: 'Inter', 
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.inputBackground,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppTheme.cardBackground,
          style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          icon: const Icon(TablerIcons.chevron_down, color: AppTheme.textSecondary),
          isExpanded: true,
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusTimeline() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        children: [
          _buildTimelineStep('Financing Request Submitted', 'Under technical review by Net Finance desk', true, true),
          _buildTimelineDivider(true),
          _buildTimelineStep('Rider Account Risk Assessment', 'Verifying rider history & average weekly earnings', false, true),
          _buildTimelineDivider(false),
          _buildTimelineStep('Motorcycle Disbursement Approved', 'Authorized and ready for dealer pickup', false, false),
          _buildTimelineDivider(false),
          _buildTimelineStep('Financing Agreement Active', 'Bajaj Pulsar dispatched & weekly billing active', false, false),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String title, String subtitle, bool isDone, bool isActive) {
    Color dotColor = AppTheme.textMuted;
    Widget dotWidget = Container();

    if (isDone) {
      dotColor = Colors.green;
      dotWidget = const Icon(TablerIcons.check, color: Colors.white, size: 10);
    } else if (isActive) {
      dotColor = AppTheme.primaryRed;
      dotWidget = Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
          child: Center(child: dotWidget),
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
                  fontWeight: FontWeight.w700,
                  color: isDone || isActive ? Colors.white : AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(fontFamily: 'Inter', 
                  fontSize: 10,
                  color: AppTheme.textMuted,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineDivider(bool isGreen) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 9, top: 4, bottom: 4),
        width: 2,
        height: 24,
        color: isGreen ? Colors.green : AppTheme.inputBackground,
      ),
    );
  }
}
