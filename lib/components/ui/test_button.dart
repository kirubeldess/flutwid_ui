import 'package:flutter/material.dart';

class TestButton extends StatelessWidget {
  const TestButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Button'),
    );
  }
}
