import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool isLast;

  const ActionButton({super.key, 
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.isLast = false,
  });

  @override
  State<ActionButton> createState() => ActionButtonState();
}

class ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _elevationAnim;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 300),
    );

    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.88,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _elevationAnim = Tween<double>(
      begin: 6.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    HapticFeedback.selectionClick();
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(_) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: widget.isLast ? 0 : 4),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnim.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon container
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _isPressed
                          ? widget.color
                          : widget.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withOpacity(
                            _isPressed ? 0.45 : 0.22,
                          ),
                          blurRadius: _elevationAnim.value + 4,
                          spreadRadius: _isPressed ? 1 : 0,
                          offset: Offset(0, _elevationAnim.value * 0.4),
                        ),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        widget.icon,
                        key: ValueKey(_isPressed),
                        size: 22,
                        color: _isPressed ? Colors.white : widget.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Label
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: _isPressed
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: _isPressed ? widget.color : Colors.grey.shade600,
                      letterSpacing: 0.2,
                    ),
                    child: Text(widget.label),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
