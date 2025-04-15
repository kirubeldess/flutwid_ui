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
    print('  flutwid_ui add time_picker     # Creates a beautiful time picker component');
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
  
  // Check if component type is time picker
  String componentCode;
  if (componentName.contains('time') || componentName.contains('picker')) {
    // Generate the time picker component code
    componentCode = '''
import 'package:flutter/material.dart';

class $className extends StatefulWidget {
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;
  final Color selectedBackgroundColor;
  final ValueChanged<DateTime>? onTimeChanged;

  const $className({
    Key? key,
    this.accentColor = Colors.blue,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.selectedBackgroundColor = Colors.grey,
    this.onTimeChanged,
  }) : super(key: key);

  @override
  _${className}State createState() => _${className}State();
}

class _${className}State extends State<$className> with SingleTickerProviderStateMixin {
  late final FixedExtentScrollController _hourController;
  late final FixedExtentScrollController _minuteController;
  late final FixedExtentScrollController _ampmController;
  late DateTime _selectedTime;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _selectedTime = DateTime.now();
    _initializeControllers();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _animationController.forward();
  }

  void _initializeControllers() {
    int currentHour = _selectedTime.hour % 12;
    if (currentHour == 0) currentHour = 12;
    int currentMinute = _selectedTime.minute;
    int ampmIndex = _selectedTime.hour >= 12 ? 1 : 0;

    _hourController = FixedExtentScrollController(initialItem: currentHour - 1);
    _minuteController = FixedExtentScrollController(initialItem: currentMinute);
    _ampmController = FixedExtentScrollController(initialItem: ampmIndex);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _ampmController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onHourChanged(int index) {
    int hour = index + 1;
    if (hour == 12) hour = 0;
    if (_selectedTime.hour >= 12) hour += 12;
    
    final newTime = DateTime(
      _selectedTime.year,
      _selectedTime.month,
      _selectedTime.day,
      hour,
      _selectedTime.minute,
    );
    
    setState(() {
      _selectedTime = newTime;
    });
    
    if (widget.onTimeChanged != null) {
      widget.onTimeChanged!(newTime);
    }
  }

  void _onMinuteChanged(int index) {
    final newTime = DateTime(
      _selectedTime.year,
      _selectedTime.month,
      _selectedTime.day,
      _selectedTime.hour,
      index,
    );
    
    setState(() {
      _selectedTime = newTime;
    });
    
    if (widget.onTimeChanged != null) {
      widget.onTimeChanged!(newTime);
    }
  }

  void _onAmpmChanged(int index) {
    int hour = _selectedTime.hour % 12;
    if (index == 1) {
      // PM
      if (hour != 12) hour += 12;
    } else {
      // AM
      if (hour == 12) hour = 0;
    }
    
    final newTime = DateTime(
      _selectedTime.year,
      _selectedTime.month,
      _selectedTime.day,
      hour,
      _selectedTime.minute,
    );
    
    setState(() {
      _selectedTime = newTime;
    });
    
    if (widget.onTimeChanged != null) {
      widget.onTimeChanged!(newTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Select Time',
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPicker(
                  _hourController,
                  12,
                  _onHourChanged,
                  (index) => (index + 1).toString().padLeft(2, '0'),
                  'Hours',
                  const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                _buildSeparator(),
                _buildPicker(
                  _minuteController,
                  60,
                  _onMinuteChanged,
                  (index) => index.toString().padLeft(2, '0'),
                  'Minutes',
                  BorderRadius.zero,
                ),
                _buildSeparator(),
                _buildPicker(
                  _ampmController,
                  2,
                  _onAmpmChanged,
                  (index) => index == 0 ? 'AM' : 'PM',
                  'AM/PM',
                  const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Current: \${_formatTime(_selectedTime)}',
              style: TextStyle(
                color: widget.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '\$hour:\$minute \$period';
  }

  Widget _buildSeparator() {
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(vertical: 55),
      child: Text(
        ':',
        style: TextStyle(
          color: widget.accentColor,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPicker(
    FixedExtentScrollController controller,
    int itemCount,
    ValueChanged<int> onSelectedItemChanged,
    String Function(int) formatLabel,
    String semanticLabel,
    BorderRadius borderRadius,
  ) {
    return Container(
      width: 75,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: widget.backgroundColor.withOpacity(0.3),
      ),
      child: Stack(
        children: [
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 40,
            diameterRatio: 1.5,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onSelectedItemChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  child: _TimePickerTile(
                    time: formatLabel(index),
                    isSelected: false,
                    textColor: widget.textColor,
                  ),
                );
              },
              childCount: itemCount,
            ),
          ),
          Center(
            child: Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.selectedBackgroundColor.withOpacity(0.3),
                borderRadius: borderRadius,
                border: Border.all(
                  color: widget.accentColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimePickerTile extends StatelessWidget {
  final String time;
  final bool isSelected;
  final Color textColor;

  const _TimePickerTile({
    Key? key,
    required this.time,
    required this.isSelected,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          time,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

// Example usage
class ${className}Example extends StatelessWidget {
  const ${className}Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: $className(
          accentColor: Colors.deepPurple,
          onTimeChanged: (time) {
            print('Selected time: \${time.hour}:\${time.minute}');
          },
        ),
      ),
    );
  }
}
''';
  } else if (componentName.contains('slide') || componentName.contains('slide_to_act')) {
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
