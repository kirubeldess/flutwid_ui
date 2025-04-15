import 'package:flutter/material.dart';

class TestSlideButton extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color thumbColor;
  final Color textColor;
  final IconData icon;
  final Function onConfirm;

  const TestSlideButton({
    Key? key,
    this.text = 'Slide to confirm',
    this.backgroundColor = Colors.amber,
    this.thumbColor = Colors.white,
    this.textColor = Colors.black,
    this.icon = Icons.arrow_forward,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<TestSlideButton> createState() => _TestSlideButtonState();
}

class _TestSlideButtonState extends State<TestSlideButton> {
  double _position = 0;
  bool _confirmed = false;
  final double _thumbSize = 60;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 40;
    
    return Container(
      height: 80,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: widget.backgroundColor,
      ),
      child: Stack(
        children: [
          // Text
          Align(
            alignment: Alignment.center,
            child: _confirmed 
              ? const Text('') 
              : Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          
          // Draggable thumb
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: _position,
            top: 10,
            bottom: 10,
            child: GestureDetector(
              onPanUpdate: (details) {
                if (_confirmed) return;
                
                setState(() {
                  _position += details.delta.dx;
                  if (_position < 0) _position = 0;
                  if (_position > width - _thumbSize) {
                    _position = width - _thumbSize;
                    _confirmed = true;
                    widget.onConfirm();
                    
                    // Reset after a delay
                    Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) {
                        setState(() {
                          _position = 0;
                          _confirmed = false;
                        });
                      }
                    });
                  }
                });
              },
              child: Container(
                width: _thumbSize,
                height: _thumbSize,
                decoration: BoxDecoration(
                  color: widget.thumbColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: widget.backgroundColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Example usage
class TestSlideButtonExample extends StatelessWidget {
  const TestSlideButtonExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TestSlideButton(
        onConfirm: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Action confirmed!')),
          );
        },
      ),
    );
  }
}
