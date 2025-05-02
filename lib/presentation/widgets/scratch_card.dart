import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

class ScratchCardPopup extends StatefulWidget {
  @override
  _ScratchCardPopupState createState() => _ScratchCardPopupState();
}

class _ScratchCardPopupState extends State<ScratchCardPopup> {
  final GlobalKey<ScratcherState> _scratchKey = GlobalKey<ScratcherState>();
  bool _isScratched = false;
  late String randomMessage;

  final List<String> messages = [
    "Luck is on your side today! 🌟",
    "A surprise awaits you soon! 🍀",
    "Good vibes are coming your way! 🌈",
    "Your dreams are closer than you think! 💫",
    "Success is just around the corner! 🚀",
    "Happiness is blooming in your life! 🌸",
    "Something amazing is about to happen! 🔮",
    "You are destined for greatness! 🏆",
    "Abundance is flowing your way! 💰",
    "You are on the right path! 🎯",
    "Magic happens when you believe! ✨",
    "Joy and celebration are near! 🎉",
    "A bright future awaits you! ☀️",
    "Your energy attracts success! 🔥",
    "Adventure is calling your name! 🌍",
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the message once to keep it the same before and after revealing
    randomMessage = messages[Random().nextInt(messages.length)];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      
      backgroundColor: Colors.transparent,
      content: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 260,
                    height: 260,
                    child: Scratcher(
                      key: _scratchKey,
                      brushSize: 50,
                      threshold: 50,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Color(0XFFBACD92)
                          : Colors.grey[850]!,
                      image: Image.asset(
                        'assets/scratch_icon.png',
                        fit: BoxFit.cover,
                      ),
                      onThreshold: () {
                        setState(() {
                          _isScratched = true;
                        });
                        _scratchKey.currentState?.reveal();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.grey[800],
                        child: Text(
                          randomMessage, // Same message before and after reveal
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
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
}
