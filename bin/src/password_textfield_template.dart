/// Provides template for a password textfield component
String getPasswordTextfieldTemplate(String className) {
  return '''
import 'package:flutter/material.dart';

class $className extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final bool autofocus;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool obscureTextByDefault;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? iconColor;
  final double borderRadius;
  final double borderWidth;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final TextStyle? helperStyle;
  final bool enableSuggestions;
  final bool autocorrect;
  final TextInputAction? textInputAction;
  final TextInputType keyboardType;
  final int? maxLength;
  final bool showCounter;
  final bool enabled;

  const $className({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.autofocus = false,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.obscureTextByDefault = true,
    this.fillColor,
    this.textColor,
    this.hintColor,
    this.borderColor,
    this.focusedBorderColor,
    this.iconColor,
    this.borderRadius = 8.0,
    this.borderWidth = 1.0,
    this.contentPadding,
    this.style,
    this.hintStyle,
    this.labelStyle,
    this.errorStyle,
    this.helperStyle,
    this.enableSuggestions = false,
    this.autocorrect = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.visiblePassword,
    this.maxLength,
    this.showCounter = false,
    this.enabled = true,
  });

  @override
  State<$className> createState() => _${className}State();
}

class _${className}State extends State<$className> {
  late bool _obscureText;
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureTextByDefault;
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextColor = widget.textColor ?? Colors.black;
    final defaultHintColor = widget.hintColor ?? Colors.black54;
    final defaultBorderColor = widget.borderColor ?? Colors.black;
    final defaultFocusedBorderColor = widget.focusedBorderColor ?? Colors.black;
    final defaultIconColor = widget.iconColor ?? Colors.black;
    final defaultFillColor = widget.fillColor ?? Colors.white;

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      enableSuggestions: widget.enableSuggestions,
      autocorrect: widget.autocorrect,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLength: widget.maxLength,
      style: widget.style ?? TextStyle(color: defaultTextColor),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        errorText: widget.errorText,
        filled: true,
        fillColor: defaultFillColor,
        counterText: widget.showCounter ? null : '',
        contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        hintStyle: widget.hintStyle ?? TextStyle(color: defaultHintColor),
        labelStyle: widget.labelStyle ?? TextStyle(color: defaultHintColor),
        errorStyle: widget.errorStyle ?? TextStyle(color: Colors.red),
        helperStyle: widget.helperStyle ?? TextStyle(color: defaultHintColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: defaultBorderColor, width: widget.borderWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: defaultBorderColor, width: widget.borderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: defaultFocusedBorderColor, width: widget.borderWidth),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: defaultIconColor,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      validator: widget.validator,
    );
  }
}

// Example usage
class ${className}Example extends StatelessWidget {
  const ${className}Example({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            $className(
              controller: passwordController,
              hintText: 'Enter your password',
              labelText: 'Password',
              helperText: 'Password must be at least 8 characters',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            $className(
              hintText: 'Custom Style Password',
              fillColor: Colors.black,
              textColor: Colors.white,
              hintColor: Colors.white70,
              borderColor: Colors.white,
              focusedBorderColor: Colors.white,
              iconColor: Colors.white,
              borderRadius: 12.0,
              borderWidth: 2.0,
            ),
          ],
        ),
      ),
    );
  }
}
''';
}
