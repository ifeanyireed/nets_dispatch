import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final String riderName;
  final String? avatarImage;
  final bool showBackButton;

  const ChatScreen({
    super.key,
    this.riderName = 'Mike Johnson',
    this.avatarImage,
    this.showBackButton = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'them',
      'text': 'Hey there! Thanks for connecting. Are you planning to ride this weekend?',
      'time': '2m ago',
      'hasHeart': true,
    },
    {
      'sender': 'me',
      'text': 'Hi Alex! Yes, I\'m thinking about hitting the Forest Park trails on Saturday morning. Would you like to join?',
      'time': '10m ago',
      'isRead': true,
    },
    {
      'type': 'divider',
      'text': 'YESTERDAY',
    },
    {
      'sender': 'them',
      'text': 'That sounds perfect! I know some great trails there. What time were you thinking?',
      'time': '10:28 AM',
    },
    {
      'sender': 'me',
      'text': 'How about 8:00 AM? We could meet at the Thurman Street entrance.',
      'time': '10m ago',
      'isRead': true,
    },
  ];

  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'me',
        'text': text,
        'time': 'Just now',
        'isRead': true,
      });
      _textController.clear();
    });

    // Auto scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.screenBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.cardBackground,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              if (widget.showBackButton || Navigator.canPop(context))
                IconButton(
                  icon: const Icon(TablerIcons.chevron_left, color: Colors.white, size: 18),
                  onPressed: () => Navigator.maybePop(context),
                ),
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(widget.avatarImage ?? 'moodboard/biker06.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.riderName,
                    style: TextStyle(fontFamily: 'Inter', 
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Online',
                        style: TextStyle(fontFamily: 'Inter', 
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(TablerIcons.phone, color: Colors.white70, size: 20),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
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
              color: Colors.black.withOpacity(0.92),
            ),
          ),
          Column(
            children: [
          // Chat messages area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, idx) {
                final msg = _messages[idx];
                
                // Yesterday date divider
                if (msg['type'] == 'divider') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        msg['text']!,
                        style: TextStyle(fontFamily: 'Inter', 
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textMuted,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  );
                }

                final isMe = msg['sender'] == 'me';
                final hasHeart = msg['hasHeart'] ?? false;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        // Message Bubble
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.76,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isMe ? const Color(0xFF4A1A1A) : AppTheme.cardBackground,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
                              bottomRight: isMe ? Radius.zero : const Radius.circular(20),
                            ),
                            border: Border.all(
                              color: isMe ? Colors.white.withOpacity(0.04) : Colors.white.withOpacity(0.05),
                            ),
                          ),
                          child: Text(
                            msg['text']!,
                            style: TextStyle(fontFamily: 'Inter', 
                              fontSize: 13,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Timestamp / Icons Row
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                msg['time']!,
                                style: TextStyle(fontFamily: 'Inter', 
                                  fontSize: 10,
                                  color: AppTheme.textMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (isMe) ...[
                                const SizedBox(width: 4),
                                const Icon(TablerIcons.checks, color: Colors.blueAccent, size: 12),
                              ],
                              if (hasHeart) ...[
                                const SizedBox(width: 6),
                                const Icon(TablerIcons.heart, color: AppTheme.primaryRed, size: 11),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Empty space for the floating input box and nav bar
          const SizedBox(height: 180),
        ],
      ),
          // Message Input Field (Floating)
          Positioned(
            bottom: 96,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground.withOpacity(0.95),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(TablerIcons.paperclip, color: Colors.white70, size: 20),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.inputBackground,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white.withOpacity(0.03)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _textController,
                        style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Enter comment',
                          hintStyle: TextStyle(fontFamily: 'Inter', color: AppTheme.textMuted, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.redGradientStart, AppTheme.redGradientEnd],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          TablerIcons.send,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
