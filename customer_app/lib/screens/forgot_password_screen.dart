import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.primaryRed,
          content: Text(
            'Please enter your email address',
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
        Uri.parse('http://localhost:8080/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Reset link sent to your email',
              style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
        Navigator.pushReplacementNamed(context, '/reset_password');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.primaryRed,
            content: Text(
              'Failed to send link: ${response.body}',
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
      backgroundColor: AppTheme.screenBackground,
      body: Stack(
        children: [
          // Background motorbiker illustration/gradient overlay
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
          
          // Stylized background motorbike light trails/shape
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryRed.withOpacity(0.08),
                    blurRadius: 100,
                  ),
                ],
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
                            
                            // Brand Logo / Title
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Reset',
                                  style: TextStyle(fontFamily: 'Inter', 
                                    fontSize: 48,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: -1.0,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Password',
                                  style: TextStyle(fontFamily: 'Inter', 
                                    fontSize: 48,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryRed,
                                    letterSpacing: -1.0,
                                  ),
                                ),
                              ],
                            ),
                            
                            Text(
                              'CREATE NEW PASSWORD',
                              style: TextStyle(fontFamily: 'Inter', 
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textSecondary,
                                letterSpacing: 1.5,
                              ),
                            ),
                            
                            const Spacer(flex: 3),
                            
                            // Email Input
                            Text(
                              'Email Address',
                              style: TextStyle(fontFamily: 'Inter', 
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
                                controller: _emailController,
                                onSubmitted: (_) => _handleForgotPassword(),
                                style: TextStyle(fontFamily: 'Inter', color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Email address',
                                  hintStyle: TextStyle(fontFamily: 'Inter', color: AppTheme.textMuted, fontSize: 14),
                                  prefixIcon: const Icon(TablerIcons.mail, color: AppTheme.textSecondary, size: 20),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                              ),
                            ),
                            
                            const Spacer(flex: 4),

                            // Reset Button
                            GestureDetector(
                              onTap: _isLoading ? null : _handleForgotPassword,
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
                                          'SEND RESET TOKEN',
                                          style: TextStyle(fontFamily: 'Inter', 
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                ),
                              ),
                            ),

                            const Spacer(flex: 2),

                            // Divider
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.white.withOpacity(0.08))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'REMEMBER YOUR PASSWORD?',
                                    style: TextStyle(fontFamily: 'Inter', 
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textMuted,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                                Expanded(child: Divider(color: Colors.white.withOpacity(0.08))),
                              ],
                            ),

                            const Spacer(flex: 3),

                            // Login link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Back to ',
                                  style: TextStyle(fontFamily: 'Inter', 
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(fontFamily: 'Inter', 
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
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
