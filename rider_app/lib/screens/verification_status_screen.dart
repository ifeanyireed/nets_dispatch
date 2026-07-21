import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_navigation_screen.dart';

class VerificationStatusScreen extends StatelessWidget {
  const VerificationStatusScreen({super.key});

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
          'Verification',
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
                  const SizedBox(height: 20),
                  
                  // Alert Notice Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppTheme.accentRed.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.accentRed.withOpacity(0.15)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(TablerIcons.clock, color: AppTheme.accentRed, size: 24),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Application Under Review',
                                style: TextStyle(fontFamily: 'Inter', 
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Your application is under review. This usually takes 24–48 hours. We will notify you via SMS once approved.',
                                style: TextStyle(fontFamily: 'IBM Plex Mono', 
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                  height: 1.45,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 36),
                  
                  Text(
                    'Application Timeline',
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Timeline Widget
                  _buildTimelineStep(
                    index: 1,
                    title: 'Documents Submitted',
                    subtitle: 'All documents uploaded successfully',
                    status: TimelineStatus.completed,
                  ),
                  _buildTimelineLine(true),
                  _buildTimelineStep(
                    index: 2,
                    title: 'Background Verification',
                    subtitle: 'Verifying details against official records',
                    status: TimelineStatus.active,
                  ),
                  _buildTimelineLine(false),
                  _buildTimelineStep(
                    index: 3,
                    title: 'Account Activation',
                    subtitle: 'Get approved and start delivering',
                    status: TimelineStatus.pending,
                  ),
                  
                  const Spacer(),
                  
                  // Simulator Shortcut note
                  Center(
                    child: Text(
                      'DEVELOPER SIMULATION CONTROL',
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryRed,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Enter Dashboard Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                        (route) => false,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.redGradientStart, AppTheme.redGradientEnd],
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
                          'SIMULATE APPROVAL & ENTER APP',
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
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

  Widget _buildTimelineStep({
    required int index,
    required String title,
    required String subtitle,
    required TimelineStatus status,
  }) {
    Color dotColor = AppTheme.textMuted;
    Widget dotWidget = Text(
      index.toString(),
      style: TextStyle(fontFamily: 'Inter', 
        color: Colors.white70,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );

    if (status == TimelineStatus.completed) {
      dotColor = Colors.green;
      dotWidget = const Icon(TablerIcons.check, color: Colors.white, size: 12);
    } else if (status == TimelineStatus.active) {
      dotColor = AppTheme.primaryRed;
      dotWidget = Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            boxShadow: status == TimelineStatus.active
                ? [
                    BoxShadow(
                      color: AppTheme.primaryRed.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Center(child: dotWidget),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontFamily: 'Inter', 
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: status == TimelineStatus.pending ? AppTheme.textSecondary : Colors.white,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(fontFamily: 'Inter', 
                  fontSize: 11,
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineLine(bool isActive) {
    return Container(
      margin: const EdgeInsets.only(left: 11, top: 4, bottom: 4),
      width: 2,
      height: 32,
      color: isActive ? Colors.green : AppTheme.cardBackground,
    );
  }
}

enum TimelineStatus { completed, active, pending }
