/// Provides template for a toast component
String getToastTemplate(String className) {
  return '''
import 'package:flutter/material.dart';

class $className extends StatefulWidget {
  final String message;
  final Duration duration;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onDismissed;
  final bool showProgress;
  final ToastPosition position;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final double? width;

  const $className({
    super.key,
    required this.message,
    this.duration = const Duration(seconds: 3),
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.borderRadius = 8.0,
    this.icon,
    this.iconColor,
    this.onDismissed,
    this.showProgress = false,
    this.position = ToastPosition.bottom,
    this.elevation = 4.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    this.width,
  });

  /// Shows a toast message
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    double borderRadius = 8.0,
    IconData? icon,
    Color? iconColor,
    VoidCallback? onDismissed,
    bool showProgress = false,
    ToastPosition position = ToastPosition.bottom,
    double elevation = 4.0,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    double? width,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => $className(
        message: message,
        duration: duration,
        backgroundColor: backgroundColor,
        textColor: textColor,
        borderRadius: borderRadius,
        icon: icon,
        iconColor: iconColor,
        onDismissed: onDismissed,
        showProgress: showProgress,
        position: position,
        elevation: elevation,
        padding: padding,
        width: width,
      ),
    );

    overlay.insert(overlayEntry);

    // Auto dismiss after duration
    if (!showProgress) {
      Future.delayed(duration, () {
        overlayEntry.remove();
        if (onDismissed != null) {
          onDismissed();
        }
      });
    }
  }

  @override
  State<$className> createState() => _${className}State();
}

enum ToastPosition { top, center, bottom }

class _${className}State extends State<$className> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Different slide animations based on position
    final Offset beginOffset;
    switch (widget.position) {
      case ToastPosition.top:
        beginOffset = const Offset(0.0, -0.5);
        break;
      case ToastPosition.center:
        beginOffset = const Offset(0.0, 0.0);
        break;
      case ToastPosition.bottom:
        beginOffset = const Offset(0.0, 0.5);
        break;
    }

    _slideAnimation = Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();

    // Auto dismiss after duration
    if (!widget.showProgress) {
      Future.delayed(widget.duration, () {
        if (mounted) {
          _animationController.reverse().then((_) {
            if (widget.onDismissed != null) {
              widget.onDismissed!();
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: widget.position == ToastPosition.top ? MediaQuery.of(context).viewPadding.top + 16 : null,
      bottom: widget.position == ToastPosition.bottom ? MediaQuery.of(context).viewPadding.bottom + 16 : null,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: widget.width,
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.85,
                    ),
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(38),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: widget.padding,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[  
                          Icon(
                            widget.icon,
                            color: widget.iconColor ?? widget.textColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (widget.showProgress) ...[  
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(widget.textColor),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            widget.message,
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Example usage
class ${className}Example extends StatelessWidget {
  const ${className}Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                $className.show(
                  context,
                  message: 'This is a simple toast message',
                );
              },
              child: const Text('Show Simple Toast'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                $className.show(
                  context,
                  message: 'Success! Your action was completed',
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                  position: ToastPosition.top,
                );
              },
              child: const Text('Show Success Toast'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                $className.show(
                  context,
                  message: 'Error! Something went wrong',
                  icon: Icons.error,
                  iconColor: Colors.red,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                );
              },
              child: const Text('Show Error Toast'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                $className.show(
                  context,
                  message: 'Loading...',
                  showProgress: true,
                  duration: const Duration(seconds: 10),
                );
              },
              child: const Text('Show Loading Toast'),
            ),
          ],
        ),
      ),
    );
  }
}
''';
}
