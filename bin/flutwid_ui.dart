import 'dart:io';
import 'package:args/args.dart';
import 'package:mustache_template/mustache_template.dart';
import 'package:path/path.dart' as path;

void main(List<String> arguments) async {
  final parser = ArgParser();
  final argResults = parser.parse(arguments);

  if (argResults.rest.isEmpty || argResults.rest[0] != 'add') {
    print('Flutwid UI - A Flutter UI Component Library');
    print('');
    print('Usage:');
    print('  flutwid_ui add <component_name>');
    print('');
    print('Examples:');
    print('  flutwid_ui add my_button       # Creates a button component named MyButton');
    print('  flutwid_ui add custom_card      # Creates a card component named CustomCard');
    print('');
    print('The component will be created in lib/components/ui/ of your current project.');
    return;
  }

  if (argResults.rest.length < 2) {
    print('Please provide a component name.');
    print('Example: flutwid_ui add my_button');
    return;
  }

  final componentName = argResults.rest[1];
  // Convert to PascalCase for class name
  final className = componentName.split('_').map((word) => 
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '').join('');
  
  // Output path in the user's current directory
  final outputPath = path.join(Directory.current.path, 'lib', 'components', 'ui', '$componentName.dart');

  // Create the output directory if it doesn't exist
  final outputDir = Directory(path.dirname(outputPath));
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
    print('Created directory ${outputDir.path}');
  }

  // Embed the template directly in the code instead of loading from a file
  // This ensures the template is always available regardless of how the package is used
  final templateString = '''
import 'package:flutter/material.dart';

class {{className}} extends StatelessWidget {
  const {{className}}({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Button'),
    );
  }
}
''';
  final template = Template(templateString, htmlEscapeValues: false);
  final output = template.renderString({'className': className});

  try {
    // Write the component file
    final outFile = File(outputPath);
    outFile.writeAsStringSync(output);

    print('Generated $outputPath');
    print('');
    print('Success! You can now import this component in your Flutter app.');
  } catch (e) {
    print('Error generating component: $e');
  }
}
