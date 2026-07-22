import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Create account',
          style: TextStyle(fontFamily: 'Inter', 
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/moodboard/biker09.jpeg', fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.92),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'Personal Details',
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Let us know who you are. This helps us customize your dispatch experience.',
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        _buildFieldLabel('Full Name'),
                        _buildTextField(_nameController, 'e.g. Ade Ogundele', TablerIcons.user, TextInputType.name),
                        const SizedBox(height: 18),
                        
                        _buildFieldLabel('Phone Number'),
                        _buildTextField(_phoneController, 'e.g. 0803 123 4567', TablerIcons.device_mobile, TextInputType.phone),
                        const SizedBox(height: 18),
                        
                        _buildFieldLabel('Email Address'),
                        _buildTextField(_emailController, 'e.g. ade@netlogistics.ng', TablerIcons.mail, TextInputType.emailAddress),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
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
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(color: AppTheme.primaryRed.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'CREATE ACCOUNT',
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, TextInputType type) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.inputBackground,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        style: TextStyle(fontFamily: 'Inter', color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontFamily: 'Inter', color: AppTheme.textMuted, fontSize: 13),
          prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
