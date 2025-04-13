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
  
  // Generate the component code
  final componentCode = '''
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
