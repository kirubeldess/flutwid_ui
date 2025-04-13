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
  
  // Try to find the template in multiple possible locations
  String templatePath;
  final List<String> possiblePaths = [];
  
  // Current script directory (for direct usage)
  final scriptDir = path.dirname(Platform.script.toFilePath());
  final packageRoot = path.dirname(scriptDir);
  
  // Add possible template locations
  possiblePaths.add(path.join(packageRoot, 'lib', 'templates', 'my_button.dart.mustache'));
  possiblePaths.add(path.join(scriptDir, '..', 'lib', 'templates', 'my_button.dart.mustache'));
  possiblePaths.add(path.join(Directory.current.path, 'lib', 'templates', 'my_button.dart.mustache'));
  possiblePaths.add(path.join(Directory.current.path, 'packages', 'flutwid_ui', 'lib', 'templates', 'my_button.dart.mustache'));
  
  // Find the first path that exists
  templatePath = possiblePaths.firstWhere(
    (p) => File(p).existsSync(),
    orElse: () => path.join(packageRoot, 'lib', 'templates', 'my_button.dart.mustache'),
  );
  
  // Output path in the user's current directory
  final outputPath = path.join(Directory.current.path, 'lib', 'components', 'ui', '$componentName.dart');

  if (!File(templatePath).existsSync()) {
    print('Template my_button.dart.mustache not found!');
    print('Searched in the following locations:');
    for (final p in possiblePaths) {
      print('  - $p');
    }
    print('');
    print('Please make sure the template exists in one of these locations or create it manually.');
    print('You can also copy the template from: https://github.com/kirubeldess/flutwid_ui/blob/main/lib/templates/my_button.dart.mustache');
    return;
  }

  final templateString = File(templatePath).readAsStringSync();
  final template = Template(templateString, htmlEscapeValues: false);
  final output = template.renderString({'className': className});

  try {
    // Ensure the output directory exists
    final outputDir = Directory(path.dirname(outputPath));
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
      print('Created directory ${outputDir.path}');
    }

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
