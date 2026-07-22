import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CreateMeetupScreen extends StatefulWidget {
  const CreateMeetupScreen({super.key});

  @override
  State<CreateMeetupScreen> createState() => _CreateMeetupScreenState();
}

class _CreateMeetupScreenState extends State<CreateMeetupScreen> with SingleTickerProviderStateMixin {
  final _meetupNameController = TextEditingController();
  String _selectedRideType = 'Sport';
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _meetupNameController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.screenBackground,
      body: Stack(
        children: [
          // 1. Dark GPS Vector Map Background (Custom Painted)
          Positioned.fill(
            child: Container(
              color: const Color(0xFF0C0E14),
              child: CustomPaint(
                painter: _GPSMapPainter(pulseValue: _pulseController),
              ),
            ),
          ),

          // 2. Custom App Bar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(TablerIcons.chevron_left, color: Colors.white, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Column(
                    children: [
                      Text(
                        'Create New Meetup',
                        style: TextStyle(fontFamily: 'Inter', 
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Drop a pin or search for a location',
                        style: TextStyle(fontFamily: 'Inter', 
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(TablerIcons.dots_vertical, color: Colors.white, size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // 3. Floating Red Pin Drop in the center of the screen
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer pulse circle
                          Container(
                            width: 60 * _pulseController.value,
                            height: 60 * _pulseController.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primaryRed.withOpacity(1.0 - _pulseController.value),
                            ),
                          ),
                          // Location Pin Icon
                          Transform.translate(
                            offset: const Offset(0, -12),
                            child: const Icon(
                              TablerIcons.map_pin,
                              color: AppTheme.primaryRed,
                              size: 42,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 4. Slide-up bottom card containing meetup configuration
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground.withOpacity(0.95),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Meetup Details',
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Meetup Name input
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.inputBackground,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _meetupNameController,
                      style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Enter meetup title (e.g. Forest Trails)',
                        hintStyle: TextStyle(fontFamily: 'Inter', color: AppTheme.textMuted, fontSize: 13),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Ride Type Category Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ride Type',
                        style: TextStyle(fontFamily: 'Inter', 
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      DropdownButton<String>(
                        dropdownColor: AppTheme.cardBackground,
                        underline: const SizedBox(),
                        value: _selectedRideType,
                        style: TextStyle(fontFamily: 'Inter', 
                          color: AppTheme.primaryRed,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                        items: <String>['Sport', 'Cruiser', 'Adventure', 'Touring']
                            .map<DropdownMenuItem<String>>((String val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            if (val != null) _selectedRideType = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Create Meetup Button
                  GestureDetector(
                    onTap: () {
                      final name = _meetupNameController.text.trim();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppTheme.primaryRed,
                          content: Text(
                            name.isNotEmpty
                                ? 'Meetup "$name" Created Successfully!'
                                : 'Meetup Location Dropped Successfully!',
                            style: TextStyle(fontFamily: 'Inter', 
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF7A0000),
                                        Color(0xFFFF2A2A),
                                        Color(0xFF7A0000),
                                      ],
                                    ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Text(
                          'CONFIRM MEETUP LOCATION',
                          style: TextStyle(fontFamily: 'Inter', 
                            fontSize: 12,
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
        ],
      ),
    );
  }
}

class _GPSMapPainter extends CustomPainter {
  final Animation<double> pulseValue;

  _GPSMapPainter({required this.pulseValue}) : super(repaint: pulseValue);

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = const Color(0xFF0F111A)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = const Color(0xFF1E2330)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final thinRoadPaint = Paint()
      ..color = const Color(0xFF181C26)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final routeLinePaint = Paint()
      ..color = const Color(0xFFE53935).withOpacity(0.3)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw Main Freeways / Routes (Verbatim names from mockup)
    // Road 1 (Bridgewater to Southbury)
    final road1 = Path()
      ..moveTo(size.width * 0.1, size.height * 0.2)
      ..cubicTo(size.width * 0.3, size.height * 0.4, size.width * 0.7, size.height * 0.3, size.width * 0.9, size.height * 0.7);
    canvas.drawPath(road1, roadPaint);

    // Road 2 (Roxbury to Woodbury)
    final road2 = Path()
      ..moveTo(size.width * 0.2, size.height * 0.8)
      ..cubicTo(size.width * 0.4, size.height * 0.5, size.width * 0.6, size.height * 0.6, size.width * 0.8, size.height * 0.1);
    canvas.drawPath(road2, roadPaint);

    // Road 3 (Cross highway)
    final road3 = Path()
      ..moveTo(0, size.height * 0.45)
      ..lineTo(size.width, size.height * 0.45);
    canvas.drawPath(road3, roadPaint);

    // Draw thin streets grid
    for (int i = 1; i <= 6; i++) {
      canvas.drawLine(
        Offset(0, size.height * (i / 7)),
        Offset(size.width, size.height * (i / 7) + 20),
        thinRoadPaint,
      );
      canvas.drawLine(
        Offset(size.width * (i / 7), 0),
        Offset(size.width * (i / 7) - 30, size.height),
        thinRoadPaint,
      );
    }

    // Highlight route
    final route = Path()
      ..moveTo(size.width * 0.5, size.height * 0.5)
      ..lineTo(size.width * 0.7, size.height * 0.3)
      ..lineTo(size.width * 0.9, size.height * 0.7);
    canvas.drawPath(route, routeLinePaint);

    // Town Labels Text Styles
    const textStyle = TextStyle(
      color: Color(0xFF6B728E),
      fontSize: 10,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0,
    );

    _drawText(canvas, 'Roxbury', size.width * 0.35, size.height * 0.28, textStyle);
    _drawText(canvas, 'Bridgewater', size.width * 0.15, size.height * 0.76, textStyle);
    _drawText(canvas, 'Woodbury', size.width * 0.82, size.height * 0.32, textStyle);
    _drawText(canvas, 'Southbury', size.width * 0.78, size.height * 0.88, textStyle);
  }

  void _drawText(Canvas canvas, String text, double x, double y, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
