import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _orderUpdates = true;
  bool _promotions = false;
  bool _systemAlerts = true;

  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user');
    
    if (userStr != null) {
      try {
        final userData = jsonDecode(userStr);
        _userId = userData['id'];
        
        if (_userId != null) {
          final response = await http.get(
            Uri.parse('https://nets-logistics-api.onrender.com/users/$_userId/settings/notifications'),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            setState(() {
              _pushEnabled = data['pushEnabled'] ?? true;
              _emailEnabled = data['emailEnabled'] ?? true;
              _orderUpdates = data['orderUpdates'] ?? true;
              _promotions = data['promotions'] ?? false;
              _systemAlerts = data['systemAlerts'] ?? true;
            });
          }
        }
      } catch (e) {
        debugPrint('Failed to load settings: $e');
      }
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSettings() async {
    if (_userId == null) return;
    
    setState(() => _isSaving = true);
    
    try {
      final response = await http.patch(
        Uri.parse('https://nets-logistics-api.onrender.com/users/$_userId/settings/notifications'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'pushEnabled': _pushEnabled,
          'emailEnabled': _emailEnabled,
          'orderUpdates': _orderUpdates,
          'promotions': _promotions,
          'systemAlerts': _systemAlerts,
        }),
      );

      if (response.statusCode == 200 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully'), backgroundColor: Colors.green),
        );
      } else {
        throw Exception('Failed to save settings');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.screenBackground,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
          'Notification Settings',
          style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          if (_isSaving)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(color: AppTheme.primaryRed, strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: Icon(TablerIcons.device_floppy, color: AppTheme.primaryRed),
              onPressed: _saveSettings,
            )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('DELIVERY METHODS'),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),
                child: Column(
                  children: [
                    _buildSwitchTile(
                      'Push Notifications',
                      'Receive alerts directly on your device',
                      TablerIcons.device_mobile,
                      _pushEnabled,
                      (val) => setState(() => _pushEnabled = val),
                    ),
                    const Divider(color: Colors.white10, height: 1),
                    _buildSwitchTile(
                      'Email Notifications',
                      'Receive daily summaries and critical alerts via email',
                      TablerIcons.mail,
                      _emailEnabled,
                      (val) => setState(() => _emailEnabled = val),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              _buildSectionHeader('NOTIFICATION TYPES'),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),
                child: Column(
                  children: [
                    _buildSwitchTile(
                      'Order & Delivery Updates',
                      'Get notified about status changes and assignments',
                      TablerIcons.refresh,
                      _orderUpdates,
                      (val) => setState(() => _orderUpdates = val),
                    ),
                    const Divider(color: Colors.white10, height: 1),
                    _buildSwitchTile(
                      'System Alerts',
                      'Security notices and platform maintenance',
                      TablerIcons.shield,
                      _systemAlerts,
                      (val) => setState(() => _systemAlerts = val),
                    ),
                    const Divider(color: Colors.white10, height: 1),
                    _buildSwitchTile(
                      'Promotions & News',
                      'Platform updates and special offers',
                      TablerIcons.tag,
                      _promotions,
                      (val) => setState(() => _promotions = val),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white70, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.white.withOpacity(0.5)),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryRed,
        activeTrackColor: AppTheme.primaryRed.withOpacity(0.3),
        inactiveThumbColor: Colors.white54,
        inactiveTrackColor: Colors.white10,
      ),
    );
  }
}
