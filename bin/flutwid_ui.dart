import 'dart:io';
import 'package:args/args.dart';

void main(List<String> arguments) {
  // Parse arguments
  final parser = ArgParser();
  final argResults = parser.parse(arguments);
  
  // Check if command is 'add'
  if (argResults.rest.isEmpty || argResults.rest[0] != 'add') {
    print('Flutwid UI - Flutter Component Generator');
    print('');
    print('Usage:');
    print('  flutwid_ui add <component_name>');
    print('');
    print('Examples:');
    print('  flutwid_ui add my_button       # Creates a button component named MyButton');
    print('  flutwid_ui add custom_card     # Creates a card component named CustomCard');
    print('  flutwid_ui add my_slide_to_act # Creates a SlideToAct component named MySlideToAct');
    print('');
    print('The component will be created in lib/components/ui/ of your current project.');
    return;
  }
  
  // Check if component name is provided
  if (argResults.rest.length < 2) {
    print('Please provide a component name.');
    print('Example: flutwid_ui add my_button');
    return;
  }
  
  // Get component name and convert to PascalCase for class name
  final componentName = argResults.rest[1];
  final className = componentName.split('_')
      .map((word) => word.isNotEmpty 
          ? word[0].toUpperCase() + word.substring(1) 
          : '')
      .join('');
  
  // Create the output directory if it doesn't exist
  final componentsDir = Directory('${Directory.current.path}/lib/components/ui');
  if (!componentsDir.existsSync()) {
    componentsDir.createSync(recursive: true);
    print('Created directory ${componentsDir.path}');
  }
  
  // Create the component file
  final outputFile = File('${componentsDir.path}/$componentName.dart');
  
  // Check if component type is slide_to_act
  String componentCode;
  if (componentName.contains('slide') || componentName.contains('slide_to_act')) {
    // Generate the custom SlideToAct component code
    componentCode = '''
import 'package:flutter/material.dart';

class $className extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color thumbColor;
  final Color textColor;
  final IconData icon;
  final Function onConfirm;

  const $className({
    Key? key,
    this.text = 'Slide to confirm',
    this.backgroundColor = Colors.amber,
    this.thumbColor = Colors.white,
    this.textColor = Colors.black,
    this.icon = Icons.arrow_forward,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<$className> createState() => _${className}State();
}

class _${className}State extends State<$className> {
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
class ${className}Example extends StatelessWidget {
  const ${className}Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: $className(
        onConfirm: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Action confirmed!')),
          );
        },
      ),
    );
  }
}
''';
  } else {
    // Default button component code
    componentCode = '''
import 'package:flutter/material.dart';

class $className extends StatelessWidget {
  const $className({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Button'),
    );
  }
}
''';
  }
  
  try {
    // Write the component file
    outputFile.writeAsStringSync(componentCode);
    print('✅ Generated ${outputFile.path}');
    print('');
    print('Success! You can now import this component in your Flutter app.');
  } catch (e) {
    print('❌ Error generating component: $e');
  }
}
