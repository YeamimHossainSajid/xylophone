import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/xylophone_note.dart';

class XylophoneKey extends StatefulWidget {
  final XylophoneNote note;
  final NoteDisplayMode displayMode;
  final bool isHighlighted;
  final VoidCallback onTap;

  const XylophoneKey({
    super.key,
    required this.note,
    required this.displayMode,
    this.isHighlighted = false,
    required this.onTap,
  });

  @override
  State<XylophoneKey> createState() => _XylophoneKeyState();
}

class _XylophoneKeyState extends State<XylophoneKey> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.note;
    final isStruck = _isPressed || widget.isHighlighted;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.5, horizontal: 8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barWidth = constraints.maxWidth * note.widthRatio;

            return Center(
              child: AnimatedScale(
                scale: _isPressed ? 0.98 : 1.0,
                duration: const Duration(milliseconds: 90),
                curve: Curves.easeOutCubic,
                child: GestureDetector(
                  onTapDown: _handleTapDown,
                  onTapUp: _handleTapUp,
                  onTapCancel: _handleTapCancel,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    width: barWidth,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isStruck
                            ? [
                                Colors.white,
                                note.primaryColor,
                                note.secondaryColor,
                              ]
                            : [
                                note.primaryColor,
                                note.secondaryColor,
                              ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: isStruck
                              ? note.primaryColor.withOpacity(0.9)
                              : note.secondaryColor.withOpacity(0.4),
                          offset: isStruck ? const Offset(0, 0) : const Offset(0, 4),
                          blurRadius: isStruck ? 16 : 6,
                          spreadRadius: isStruck ? 2 : 0,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Left pin grommet (acoustic mount)
                        Positioned(
                          left: 18,
                          child: _buildPin(),
                        ),
                        // Right pin grommet
                        Positioned(
                          right: 18,
                          child: _buildPin(),
                        ),
                        // Centered note label
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              note.labelFor(widget.displayMode),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black38,
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            if (widget.displayMode != NoteDisplayMode.letters) ...[
                              const SizedBox(width: 8),
                              Text(
                                '(${note.letter})',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPin() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1E293B),
        border: Border.all(
          color: Colors.white.withOpacity(0.7),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }
}
