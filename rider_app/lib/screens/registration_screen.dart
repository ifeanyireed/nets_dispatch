import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme/app_theme.dart';
import 'verification_status_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _activeTabIndex = 0;
  bool _ownBike = true;
  
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _plateController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _activeTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _plateController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (_activeTabIndex < 2) {
      _tabController.animateTo(_activeTabIndex + 1);
    } else {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.primaryRed,
            content: const Text('Please fill out all required personal details'),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
            'role': 'rider'
          }),
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          if (response.statusCode == 200 || response.statusCode == 201) {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Registration successful'),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const VerificationStatusScreen()),
            );
          } else {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppTheme.primaryRed,
                content: Text('Registration failed: ${response.body}'),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppTheme.primaryRed,
              content: Text('Network error: $e'),
            ),
          );
        }
      }
    }
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
          'Sign Up',
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
          // Background biker image (extremely low opacity to stay readable)
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
                const SizedBox(height: 12),
                // Custom Tab Bar Indicator header
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.04)),
                  ),
                  child: TabBar(
                    controller: _tabController,
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
                      Tab(child: Text('Personal', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                      Tab(child: Text('Vehicle', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                      Tab(child: Text('Documents', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Personal
                      _buildPersonalTab(),
                      // Tab 2: Vehicle
                      _buildVehicleTab(),
                      // Tab 3: Documents
                      _buildDocumentsTab(),
                    ],
                  ),
                ),
                
                // Bottom Continue button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: GestureDetector(
                    onTap: _handleContinue,
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
                        child: _isLoading 
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text(
                              _activeTabIndex == 2 ? 'SUBMIT APPLICATION' : 'CONTINUE',
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Details',
            style: TextStyle(fontFamily: 'Inter', 
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Let us know who you are. This information will be verified against your official ID.',
            style: TextStyle(fontFamily: 'Inter', 
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          
          _buildFieldLabel('Full Name'),
          _buildTextField(_nameController, 'e.g. Ade Ogundele', TablerIcons.user),
          const SizedBox(height: 18),
          
          _buildFieldLabel('Phone Number'),
          _buildTextField(_phoneController, 'e.g. 0803 123 4567', TablerIcons.device_mobile),
          const SizedBox(height: 18),
          
          _buildFieldLabel('Email Address'),
          _buildTextField(_emailController, 'e.g. ade@netlogistics.ng', TablerIcons.mail),
          const SizedBox(height: 18),
          
          _buildFieldLabel('Password'),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.inputBackground,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.white.withOpacity(0.04)),
            ),
            child: TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(fontFamily: 'Inter', color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(fontFamily: 'Inter', color: AppTheme.textMuted, fontSize: 13),
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
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _buildVehicleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vehicle details',
            style: TextStyle(fontFamily: 'Inter', 
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Specify your delivery vehicle. NETS Logistics provides financing plans if you do not own a motorcycle.',
            style: TextStyle(fontFamily: 'Inter', 
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          
          // Switch Own a bike
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.04)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Own a motorcycle?',
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Select no if you need bike financing',
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _ownBike,
                  onChanged: (val) {
                    setState(() {
                      _ownBike = val;
                    });
                  },
                  activeColor: AppTheme.primaryRed,
                  activeTrackColor: AppTheme.primaryRed.withOpacity(0.3),
                  inactiveThumbColor: AppTheme.textSecondary,
                  inactiveTrackColor: AppTheme.inputBackground,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          if (_ownBike) ...[
            _buildFieldLabel('Plate Number'),
            _buildTextField(_plateController, 'e.g. KJA-224-XY', TablerIcons.pin),
            const SizedBox(height: 18),
            _buildFieldLabel('Motorcycle Make / Model'),
            _buildTextField(TextEditingController(text: 'Bajaj Pulsar 150'), 'e.g. Honda Rebel', TablerIcons.motorbike),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryRed.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  const Icon(TablerIcons.info_circle, color: AppTheme.primaryRed, size: 24),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'No problem! You will be automatically eligible for our NETS Logistics bike financing option once registered.',
                      style: TextStyle(fontFamily: 'Inter', 
                        fontSize: 12,
                        color: Colors.white70,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Documents Upload',
            style: TextStyle(fontFamily: 'Inter', 
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Upload clear photos of your credentials to speed up verification review.',
            style: TextStyle(fontFamily: 'Inter', 
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          
          _buildUploadBox("Driver's License", 'PDF or JPEG format', true),
          const SizedBox(height: 14),
          _buildUploadBox('National ID Card / NIN', 'Clear photo of front & back', false),
          const SizedBox(height: 14),
          if (_ownBike) ...[
            _buildUploadBox('Vehicle Registration papers', 'Proof of ownership docs', false),
            const SizedBox(height: 14),
          ],
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

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.inputBackground,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: TextField(
        controller: controller,
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

  Widget _buildUploadBox(String title, String subtitle, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green.withOpacity(0.1) : AppTheme.inputBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? TablerIcons.circle_check : TablerIcons.cloud_upload,
                  color: isCompleted ? Colors.green : AppTheme.textSecondary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 10,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green.withOpacity(0.08) : Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isCompleted ? Colors.green.withOpacity(0.2) : Colors.white.withOpacity(0.08),
              ),
            ),
            child: Text(
              isCompleted ? 'UPLOADED' : 'UPLOAD',
              style: TextStyle(fontFamily: 'Inter', 
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: isCompleted ? Colors.green : Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
