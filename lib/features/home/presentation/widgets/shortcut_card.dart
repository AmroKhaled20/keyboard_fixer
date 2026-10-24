import 'package:flutter/material.dart';

class ShortcutCard extends StatefulWidget {
  final String title;
  final List<String> keys;

  const ShortcutCard({super.key, required this.title, required this.keys});

  @override
  State<ShortcutCard> createState() => _ShortcutCardState();
}

class _ShortcutCardState extends State<ShortcutCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        width: 340,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -5.0 : 0.0)
          ..scale(_isHovered ? 1.02 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xFFF5F3FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered ? const Color(0xFFDDD6FE) : Colors.grey.shade200,
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0xFFDDD6FE).withOpacity(0.6)
                  : Colors.black.withOpacity(0.03),
              blurRadius: _isHovered ? 15 : 10,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _isHovered
                    ? const Color(0xFF5B21B6)
                    : const Color(0xFF334155),
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: widget.keys
                    .map((keyLabel) => _buildKeycap(keyLabel))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeycap(String label) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _isHovered ? Colors.white : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: _isHovered ? const Color(0xFFDDD6FE) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: _isHovered ? Colors.black12 : Colors.transparent,
            offset: const Offset(0, 1.5),
            blurRadius: _isHovered ? 2 : 0,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: _isHovered ? const Color(0xFF5B21B6) : const Color(0xFF475569),
          fontFamily: 'Consolas',
        ),
      ),
    );
  }
}
