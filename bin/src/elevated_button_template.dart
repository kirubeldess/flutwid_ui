/// Provides template for an elevated button component
String getElevatedButtonTemplate(String className) {
  return '''
import 'package:flutter/material.dart';

class $className extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? overlayColor;
  final TextStyle? textStyle;
  final Color? textColor;
  final FontWeight? textFontWeight;
  final double? fontSize;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final MainAxisSize? mainAxisSize;
  final double? elevation;
  final BorderSide? borderSide;
  final Size? minimumSize;
  final Size? fixedSize;
  final Size? maximumSize;
  final bool fullWidth;

  const $className({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.overlayColor,
    this.textStyle,
    this.textColor,
    this.textFontWeight,
    this.fontSize,
    this.borderRadius,
    this.padding,
    this.leadingIcon,
    this.trailingIcon,
    this.mainAxisSize,
    this.elevation,
    this.borderSide,
    this.minimumSize,
    this.fixedSize,
    this.maximumSize,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: elevation != null ? WidgetStatePropertyAll<double>(elevation!) : null,
        shadowColor: backgroundColor != null 
            ? WidgetStatePropertyAll<Color>(backgroundColor!.withAlpha(128)) 
            : WidgetStatePropertyAll<Color>(Colors.black.withAlpha(128)),
        backgroundColor: backgroundColor != null 
            ? WidgetStatePropertyAll<Color>(backgroundColor!) 
            : WidgetStatePropertyAll<Color>(Colors.black),
        foregroundColor: textColor != null 
            ? WidgetStatePropertyAll<Color>(textColor!) 
            : WidgetStatePropertyAll<Color>(Colors.white),
        padding: padding != null 
            ? WidgetStatePropertyAll<EdgeInsetsGeometry>(padding!) 
            : const WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0)),
        minimumSize: minimumSize != null ? WidgetStatePropertyAll<Size>(minimumSize!) : null,
        fixedSize: fixedSize != null ? WidgetStatePropertyAll<Size>(fixedSize!) : null,
        maximumSize: maximumSize != null ? WidgetStatePropertyAll<Size>(maximumSize!) : null,
        shape: WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            side: borderSide ?? BorderSide.none,
          ),
        ),
        overlayColor: overlayColor != null 
            ? WidgetStatePropertyAll<Color>(overlayColor!) 
            : WidgetStatePropertyAll<Color>(Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: mainAxisSize ?? MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            leadingIcon!,
            const SizedBox(width: 8.0),
          ],
          Text(
            text,
            style: textStyle ??
                TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: fontSize ?? 16.0,
                  fontWeight: textFontWeight ?? FontWeight.w600,
                ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 8.0),
            trailingIcon!,
          ],
        ],
      ),
    );
    
    // If fullWidth is true, wrap the button in a SizedBox.expand
    return fullWidth 
        ? SizedBox(
            width: double.infinity,
            child: button,
          )
        : button;
  }
}

// Example usage
class ${className}Example extends StatelessWidget {
  const ${className}Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            $className(
              text: 'Primary Button',
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            $className(
              text: 'Custom Button',
              onPressed: () {},
              backgroundColor: Colors.white,
              textColor: Colors.black,
              borderRadius: 12.0,
            ),
            const SizedBox(height: 16),
            $className(
              text: 'Outlined Button',
              onPressed: () {},
              backgroundColor: Colors.transparent,
              textColor: Colors.black,
              borderSide: const BorderSide(color: Colors.black, width: 2),
              elevation: 0,
            ),
            const SizedBox(height: 16),
            $className(
              text: 'Non-Full Width Button',
              onPressed: () {},
              fullWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}
''';
}
