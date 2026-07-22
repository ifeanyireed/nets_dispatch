import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _meetRadiusNotifications = true;
  double _distanceRadius = 100.0;
  bool _directMessages = true;
  bool _meetupInvites = true;
  bool _likesAndMatches = false;

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
          'Notification Settings',
          style: TextStyle(fontFamily: 'Inter', 
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Distance Notifications Section
              _buildSectionHeader('DISTANCE NOTIFICATIONS'),
              const SizedBox(height: 12),
              
              // Toggle Switch Row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'New meet in distance radius',
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Switch(
                          value: _meetRadiusNotifications,
                          activeColor: AppTheme.primaryRed,
                          activeTrackColor: AppTheme.primaryRed.withOpacity(0.3),
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.white.withOpacity(0.05),
                          onChanged: (val) {
                            setState(() {
                              _meetRadiusNotifications = val;
                            });
                          },
                        ),
                      ],
                    ),
                    
                    if (_meetRadiusNotifications) ...[
                      const SizedBox(height: 20),
                      Divider(color: Colors.white.withOpacity(0.04)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Distance radius',
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            '${_distanceRadius.round()} m',
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryRed,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppTheme.primaryRed,
                          inactiveTrackColor: Colors.white.withOpacity(0.05),
                          thumbColor: Colors.white,
                          overlayColor: AppTheme.primaryRed.withOpacity(0.2),
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        ),
                        child: Slider(
                          value: _distanceRadius,
                          min: 10.0,
                          max: 100.0,
                          onChanged: (val) {
                            setState(() {
                              _distanceRadius = val;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('10 m', style: TextStyle(fontFamily: 'IBM Plex Mono', fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.bold)),
                            Text('100 m', style: TextStyle(fontFamily: 'IBM Plex Mono', fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Activity Notifications Section
              _buildSectionHeader('ACTIVITY NOTIFICATIONS'),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),
                child: Column(
                  children: [
                    _buildSwitchRow(
                      title: 'Direct Messages',
                      value: _directMessages,
                      onChanged: (val) => setState(() => _directMessages = val),
                    ),
                    Divider(color: Colors.white.withOpacity(0.04)),
                    _buildSwitchRow(
                      title: 'Meetup Invites',
                      value: _meetupInvites,
                      onChanged: (val) => setState(() => _meetupInvites = val),
                    ),
                    Divider(color: Colors.white.withOpacity(0.04)),
                    _buildSwitchRow(
                      title: 'Likes & Matches',
                      value: _likesAndMatches,
                      onChanged: (val) => setState(() => _likesAndMatches = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Save Settings Action Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF7A0000),
                                        Color(0xFFFF2A2A),
                                        Color(0xFF7A0000),
                                      ],
                                    ),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Center(
                    child: Text(
                      'SAVE SETTINGS',
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String label) {
    return Text(
      label,
      style: TextStyle(fontFamily: 'Inter', 
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppTheme.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontFamily: 'Inter', 
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Switch(
            value: value,
            activeColor: AppTheme.primaryRed,
            activeTrackColor: AppTheme.primaryRed.withOpacity(0.3),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.white.withOpacity(0.05),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
