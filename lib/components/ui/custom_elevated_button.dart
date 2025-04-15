import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
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

  const CustomElevatedButton({
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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: elevation != null ? WidgetStatePropertyAll<double>(elevation!) : null,
        shadowColor: backgroundColor != null 
            ? WidgetStatePropertyAll<Color>(backgroundColor!.withAlpha(128)) 
            : WidgetStatePropertyAll<Color>(theme.colorScheme.primary.withAlpha(128)),
        backgroundColor: backgroundColor != null 
            ? WidgetStatePropertyAll<Color>(backgroundColor!) 
            : WidgetStatePropertyAll<Color>(theme.colorScheme.primary),
        foregroundColor: textColor != null 
            ? WidgetStatePropertyAll<Color>(textColor!) 
            : WidgetStatePropertyAll<Color>(theme.colorScheme.onPrimary),
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
            : WidgetStatePropertyAll<Color>(Colors.black12),
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
                  color: textColor ?? theme.colorScheme.onPrimary,
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
  }
}

// Example usage
class CustomElevatedButtonExample extends StatelessWidget {
  const CustomElevatedButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomElevatedButton(
              text: 'Primary Button',
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            CustomElevatedButton(
              text: 'Custom Button',
              onPressed: () {},
              backgroundColor: Colors.amber,
              textColor: Colors.black,
              borderRadius: 12.0,
              leadingIcon: const Icon(Icons.star, color: Colors.black),
            ),
            const SizedBox(height: 16),
            CustomElevatedButton(
              text: 'Outlined Button',
              onPressed: () {},
              backgroundColor: Colors.transparent,
              textColor: Colors.blue,
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              elevation: 0,
            ),
          ],
        ),
      ),
    );
  }
}
