import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_navigation_screen.dart';

class VerificationStatusScreen extends StatefulWidget {
  final String? userId;
  const VerificationStatusScreen({super.key, this.userId});

  @override
  State<VerificationStatusScreen> createState() => _VerificationStatusScreenState();
}

class _VerificationStatusScreenState extends State<VerificationStatusScreen> {
  Timer? _timer;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    if (widget.userId != null && widget.userId!.isNotEmpty) {
      _startPolling();
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _checkStatus();
    });
  }

  Future<void> _checkStatus() async {
    if (widget.userId == null || widget.userId!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Missing User ID. Please log in or register again.'), backgroundColor: Colors.red),
        );
      }
      return;
    }
    
    try {
      final response = await http.get(Uri.parse('https://nets-logistics-api.onrender.com/riders/profile/${widget.userId!.trim()}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status']?.toString().toLowerCase();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Status check: ${data['status']}'), duration: const Duration(seconds: 2)),
          );
        }

        if (status == 'active') {
          _timer?.cancel();
          if (mounted) {
            setState(() {
              _isActive = true;
            });
            // Automatically navigate to Main app
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                  (route) => false,
                );
              }
            });
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.statusCode} - ${response.body}'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      debugPrint("Polling error: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                      color: _isActive ? Colors.green.withOpacity(0.08) : AppTheme.accentRed.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _isActive ? Colors.green.withOpacity(0.3) : AppTheme.accentRed.withOpacity(0.15)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(_isActive ? TablerIcons.check : TablerIcons.clock, color: _isActive ? Colors.green : AppTheme.accentRed, size: 24),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isActive ? 'Application Approved' : 'Application Under Review',
                                style: TextStyle(fontFamily: 'Inter', 
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _isActive 
                                  ? 'Your account has been activated! Redirecting you to your dashboard...' 
                                  : 'Your application is under review. This usually takes 24–48 hours. Please wait here or check back later.',
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
                    status: _isActive ? TimelineStatus.completed : TimelineStatus.active,
                  ),
                  _buildTimelineLine(_isActive),
                  _buildTimelineStep(
                    index: 3,
                    title: 'Account Activation',
                    subtitle: 'Get approved and start delivering',
                    status: _isActive ? TimelineStatus.completed : TimelineStatus.pending,
                  ),
                  
                  const Spacer(),
                  
                  // Manual Refresh Button
                  if (!_isActive)
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Checking status...'), duration: Duration(seconds: 1)),
                          );
                          _checkStatus();
                        },
                        icon: const Icon(TablerIcons.refresh, color: AppTheme.textSecondary, size: 18),
                        label: const Text(
                          'Refresh Status',
                          style: TextStyle(fontFamily: 'Inter', color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
                        ),
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
