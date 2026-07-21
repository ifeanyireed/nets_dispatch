import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'advance_filters_screen.dart';
import 'notification_settings_screen.dart';
import 'create_meetup_screen.dart';
import 'rider_profile_screen.dart';

class RiderMatchScreen extends StatefulWidget {
  final Function(int)? onNavigate;

  const RiderMatchScreen({super.key, this.onNavigate});

  @override
  State<RiderMatchScreen> createState() => _RiderMatchScreenState();
}

class _RiderMatchScreenState extends State<RiderMatchScreen> {
  double _distanceValue = 100.0;
  String _selectedCategory = 'All';
  int _selectedExperienceIndex = 0; // 0: Expert, 1: Intermediate, 2: Beginner
  
  final List<String> _categories = [
    'All', 'Cruiser', 'Sport', 'Adventure', 'Touring', 'Naked', 'Dirt', 'Scooter'
  ];

  final List<String> _experiences = ['Expert', 'Intermediate', 'Beginner'];

  // Map to track requested riders by their name to show dynamic UI feedback
  final Map<String, bool> _requestedRiders = {};

  final List<Map<String, String>> _riders = [
    {
      'name': 'Alex Morgan',
      'bike': 'Ducati Monster 821',
      'avatarColor': '0xFF3E1B1B',
      'badge': 'Ducati',
      'image': 'moodboard/biker05.jpeg',
    },
    {
      'name': 'Mike Johnson',
      'bike': 'Harley Davidson Iron',
      'avatarColor': '0xFF1B2E3E',
      'badge': 'Harley',
      'image': 'moodboard/biker06.jpeg',
    },
    {
      'name': 'James Lee',
      'bike': 'Kawasaki Ninja ZX-10R',
      'avatarColor': '0xFF1B3E22',
      'badge': 'Kawasaki',
      'image': 'moodboard/biker07.jpeg',
    },
    {
      'name': 'Marcus Johnson',
      'bike': 'BMW R1250GS Adventure',
      'avatarColor': '0xFF3E3C1B',
      'badge': 'BMW',
      'image': 'moodboard/biker08.jpeg',
    },
    {
      'name': 'Sarah Connor',
      'bike': 'Honda Rebel 500',
      'avatarColor': '0xFF3A1B3E',
      'badge': 'Honda',
      'image': 'moodboard/biker09.jpeg',
    },
    {
      'name': 'Chris Evans',
      'bike': 'Yamaha YZF-R6',
      'avatarColor': '0xFF1B3E3E',
      'badge': 'Yamaha',
      'image': 'moodboard/biker10.jpeg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.screenBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'moodboard/biker09.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.9),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rider Match',
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Discover rider in your city',
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Filter Toggle
                          IconButton(
                            icon: const Icon(TablerIcons.adjustments, color: Colors.white, size: 22),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => const AdvanceFiltersScreen(),
                              );
                            },
                          ),
                          // Notifications Bell
                          IconButton(
                            icon: const Icon(TablerIcons.bell, color: Colors.white, size: 22),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search rider textfield
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
                        hintStyle: TextStyle(fontFamily: 'Inter', color: AppTheme.textMuted, fontSize: 14),
                        prefixIcon: const Icon(TablerIcons.search, color: AppTheme.textSecondary, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Distance Slider Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Distance',
                        style: TextStyle(fontFamily: 'Inter', 
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        '${_distanceValue.round()} m',
                        style: TextStyle(fontFamily: 'Inter', 
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryRed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppTheme.primaryRed,
                      inactiveTrackColor: Colors.white.withOpacity(0.08),
                      thumbColor: Colors.white,
                      overlayColor: AppTheme.primaryRed.withOpacity(0.2),
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('10 m', style: TextStyle(fontFamily: 'IBM Plex Mono', fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.bold)),
                        Text('100 m', style: TextStyle(fontFamily: 'IBM Plex Mono', fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Category Selector (Horizontal Scroll)
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _categories.length,
                      itemBuilder: (context, idx) {
                        final cat = _categories[idx];
                        final isSelected = _selectedCategory == cat;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primaryRed : Colors.transparent,
                              borderRadius: BorderRadius.circular(19),
                              border: Border.all(
                                color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.08),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                cat,
                                style: TextStyle(fontFamily: 'Inter', 
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Experience Pills Segmented Toggle
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.inputBackground,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white.withOpacity(0.03)),
                    ),
                    child: Row(
                      children: List.generate(_experiences.length, (idx) {
                        final exp = _experiences[idx];
                        final isSelected = _selectedExperienceIndex == idx;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedExperienceIndex = idx),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.cardBackground : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    : [],
                              ),
                              child: Center(
                                child: Text(
                                  exp,
                                  style: TextStyle(fontFamily: 'Inter', 
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Today's Hotspots Title
                  Text(
                    "Today's Hotspots",
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2-Column Rider Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.76,
                    ),
                    itemCount: _riders.length,
                    itemBuilder: (context, idx) {
                      final rider = _riders[idx];
                      final name = rider['name']!;
                      final bike = rider['bike']!;
                      final badge = rider['badge']!;
                      final avatarColor = Color(int.parse(rider['avatarColor']!));
                      final isRequested = _requestedRiders[name] ?? false;

                      return GestureDetector(
                        onTap: () {
                          // Tap opens Rider Profile Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RiderProfileScreen(
                                name: name,
                                bike: bike,
                                image: rider['image'],
                                onSendRequest: () {
                                  setState(() {
                                    _requestedRiders[name] = true;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.cardBackground,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.05)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar / Custom Rider Image placeholder
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                      image: AssetImage(rider['image']!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.6),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            badge,
                                            style: TextStyle(fontFamily: 'Inter', 
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              
                              // Rider Details
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontFamily: 'Inter', 
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                bike,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontFamily: 'Inter', 
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Send Request Button
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _requestedRiders[name] = !isRequested;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isRequested ? AppTheme.primaryRed : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isRequested ? Colors.transparent : Colors.white.withOpacity(0.12),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      isRequested ? 'REQUESTED' : 'SEND REQUEST',
                                      style: TextStyle(fontFamily: 'Inter', 
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: isRequested ? Colors.white : Colors.white70,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Floating plus button
            Positioned(
              right: 20,
              bottom: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateMeetupScreen()),
                  );
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.redGradientStart, AppTheme.redGradientEnd],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryRed.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    TablerIcons.plus,
                    color: Colors.white,
                    size: 28,
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
}
