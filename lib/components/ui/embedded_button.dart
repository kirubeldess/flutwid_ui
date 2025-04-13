import 'package:flutter/material.dart';

class EmbeddedButton extends StatelessWidget {
  const EmbeddedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Button'),
    );
  }
}
