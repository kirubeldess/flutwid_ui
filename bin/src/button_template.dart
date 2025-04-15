/// Provides template for a basic button component
String getButtonTemplate(String className) {
  return '''
import 'package:flutter/material.dart';

class $className extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  
  const $className({
    super.key, 
    this.onPressed,
    this.text = 'Button',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed ?? () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(text),
    );
  }
}
''';
}
