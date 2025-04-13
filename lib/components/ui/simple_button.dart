import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  const SimpleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Button'),
    );
  }
}
