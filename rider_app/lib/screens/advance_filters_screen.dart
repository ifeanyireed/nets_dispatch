import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AdvanceFiltersScreen extends StatefulWidget {
  const AdvanceFiltersScreen({super.key});

  @override
  State<AdvanceFiltersScreen> createState() => _AdvanceFiltersScreenState();
}

class _AdvanceFiltersScreenState extends State<AdvanceFiltersScreen> {
  double _distanceValue = 100.0;
  String _selectedAroundYou = 'Most Popular';
  String _selectedRideType = 'All';
  String _selectedExperience = 'Expert';
  String _selectedStyle = 'Daily';
  String _selectedMeetup = "Today's Hotspots";

  final List<String> _aroundYouOpts = ['Most Popular', 'Nearby', 'Recent'];
  
  final List<String> _rideTypes = [
    'All', 'Cruiser', 'Sport', 'Adventure', 'Touring', 'Naked', 'Dirt', 'Scooter'
  ];

  final List<String> _experienceTypes = ['Expert', 'Intermediate', 'Beginner'];

  final List<String> _styleOpts = ['Daily', 'Weekend', 'Track', 'Offroad'];

  final List<String> _meetupOpts = [
    "Today's Hotspots", 'Upcoming Meetups', 'Past Meetups'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.screenBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      height: MediaQuery.of(context).size.height * 0.88,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Advance Filters',
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Discover rider in your city',
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    TablerIcons.x,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Scrollable Filter Fields
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search by name
                  _buildSectionHeader('SEARCH BY NAME'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.inputBackground,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: TextField(
                      style: TextStyle(fontFamily: 'Inter', color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search rider...',
                        hintStyle: TextStyle(fontFamily: 'Inter', color: AppTheme.textMuted, fontSize: 13),
                        prefixIcon: const Icon(TablerIcons.search, color: AppTheme.textSecondary, size: 18),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Distance Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionHeader('DISTANCE'),
                      Text(
                        '${_distanceValue.round()} m',
                        style: TextStyle(fontFamily: 'Inter', 
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryRed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppTheme.primaryRed,
                      inactiveTrackColor: Colors.white.withOpacity(0.08),
                      thumbColor: Colors.white,
                      overlayColor: AppTheme.primaryRed.withOpacity(0.2),
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    ),
                    child: Slider(
                      value: _distanceValue,
                      min: 10.0,
                      max: 100.0,
                      onChanged: (val) {
                        setState(() {
                          _distanceValue = val;
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
                  const SizedBox(height: 24),

                  // Around You Choice
                  _buildSectionHeader('AROUND YOU'),
                  _buildPillsSelector(_aroundYouOpts, _selectedAroundYou, (val) {
                    setState(() => _selectedAroundYou = val);
                  }),
                  const SizedBox(height: 24),

                  // Ride Type Choice
                  _buildSectionHeader('RIDE TYPE'),
                  _buildPillsSelector(_rideTypes, _selectedRideType, (val) {
                    setState(() => _selectedRideType = val);
                  }),
                  const SizedBox(height: 24),

                  // Type (Experience Level)
                  _buildSectionHeader('TYPE'),
                  _buildPillsSelector(_experienceTypes, _selectedExperience, (val) {
                    setState(() => _selectedExperience = val);
                  }),
                  const SizedBox(height: 24),

                  // Style Choice
                  _buildSectionHeader('STYLE'),
                  _buildPillsSelector(_styleOpts, _selectedStyle, (val) {
                    setState(() => _selectedStyle = val);
                  }),
                  const SizedBox(height: 24),

                  // Meetups Choice
                  _buildSectionHeader('MEETUPS'),
                  _buildPillsSelector(_meetupOpts, _selectedMeetup, (val) {
                    setState(() => _selectedMeetup = val);
                  }),
                  const SizedBox(height: 32),

                  // Apply Filter Button
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
                          'APPLY FILTERS',
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: TextStyle(fontFamily: 'Inter', 
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppTheme.textSecondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildPillsSelector(List<String> options, String selectedValue, ValueChanged<String> onSelected) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = selectedValue == opt;
        return GestureDetector(
          onTap: () => onSelected(opt),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryRed : AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.06),
              ),
            ),
            child: Text(
              opt,
              style: TextStyle(fontFamily: 'Inter', 
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
