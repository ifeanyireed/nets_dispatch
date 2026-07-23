import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _tokenController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    final token = _tokenController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    if (token.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.primaryRed,
          content: Text(
            'Please fill all required fields',
            style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://nets-logistics-api.onrender.com/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'newPassword': newPassword,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Password reset successfully',
              style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.primaryRed,
            content: Text(
              'Reset failed: ${response.body}',
              style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.primaryRed,
          content: Text(
            'Error: $e',
            style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: AppTheme.screenBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/moodboard/biker09.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.85),
                    Colors.black,
                  ],
                  stops: const [0.0, 0.5, 0.9],
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            Text(
                              'Reset\nPassword',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.1,
                                letterSpacing: -1.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Enter your token and new password to reset it.',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                                height: 1.4,
                              ),
                            ),
                            const Spacer(flex: 2),
                            
                            // Token Input
                            Text(
                              'Reset Token',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.inputBackground,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Colors.white.withOpacity(0.05)),
                              ),
                              child: TextField(
                                controller: _tokenController,
                                style: TextStyle(fontFamily: 'Inter', color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Token',
                                  hintStyle: TextStyle(fontFamily: 'Inter', color: AppTheme.textMuted, fontSize: 14),
                                  prefixIcon: const Icon(TablerIcons.key, color: AppTheme.textSecondary, size: 20),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Password Input
                            Text(
                              'New Password',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.inputBackground,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Colors.white.withOpacity(0.05)),
                              ),
                              child: TextField(
                                controller: _newPasswordController,
                                obscureText: _obscurePassword,
                                onSubmitted: (_) => _handleResetPassword(),
                                style: TextStyle(fontFamily: 'Inter', color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'New Password',
                                  hintStyle: TextStyle(fontFamily: 'Inter', color: AppTheme.textMuted, fontSize: 14),
                                  prefixIcon: const Icon(TablerIcons.lock, color: AppTheme.textSecondary, size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? TablerIcons.eye_off : TablerIcons.eye,
                                      color: AppTheme.textSecondary,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                              ),
                            ),
                            const Spacer(flex: 3),
                            GestureDetector(
                              onTap: _isLoading ? null : _handleResetPassword,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF7A0000),
                                      Color(0xFFFF2A2A),
                                      Color(0xFF7A0000),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryRed.withOpacity(0.3),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Text(
                                          'RESET PASSWORD',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
