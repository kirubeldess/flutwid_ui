// // import 'dart:io';
// // import 'package:args/args.dart';

// // void main(List<String> arguments) {
// //   final parser = ArgParser();
// //   parser.addCommand('generate');
// //   final argResults = parser.parse(arguments);

// //   if (argResults.command?.name == 'generate') {
// //     generateComponent(argResults.command?.rest ?? []);
// //   }
// // }

// // void generateComponent(List<String> args) {
// //   if (args.isEmpty) {
// //     print('Error: You must provide a component name.');
// //     return;
// //   }

// //   final componentName = args[0];

// //   // Define the path to the predefined component in your package
// //   final predefinedComponentPath = 'lib/components/$componentName.dart';
// //   final userComponentPath = 'lib/components/$componentName.dart';

// //   // Check if the predefined component exists in your package
// //   final predefinedComponentFile = File(predefinedComponentPath);
// //   if (!predefinedComponentFile.existsSync()) {
// //     print('Error: Component $componentName does not exist in the package.');
// //     return;
// //   }

// //   // Copy the predefined component to the user's project
// //   final userComponentFile = File(userComponentPath);
// //   try {
// //     predefinedComponentFile.copySync(userComponentFile.path);
// //     print('Component $componentName.dart generated successfully!');
// //   } catch (e) {
// //     print('Error generating component: $e');
// //   }
// // }

// import 'dart:io';
// import 'package:args/args.dart';
// import 'package:mustache_template/mustache_template.dart';
// import 'package:path/path.dart' as p;

// void main(List<String> arguments) {
//   final parser = ArgParser();
//   parser.addCommand('add'); // Command for adding new components

//   final ArgResults argResults = parser.parse(arguments);

//   if (argResults.command != null) {
//     final command = argResults.command!;
//     if (command.name == 'add') {
//       final componentName = command.rest.isNotEmpty ? command.rest[0] : '';
//       if (componentName.isNotEmpty) {
//         generateComponent(componentName);
//       } else {
//         print('Please provide a valid component name.');
//       }
//     }
//   } else {
//     print(
//         'Invalid command. Use "add <component_name>" to add a new component.');
//   }
// }

// void generateComponent(String componentName) {
//   final templateFile = File(p.join(
//       Directory.current.path, 'lib', 'components', 'my_button.dart.mustache'));
//   final templateContent = templateFile.readAsStringSync();

//   final template = Template(templateContent);
//   final renderedContent = template.renderString({'className': componentName});

//   final outputDir =
//       Directory(p.join(Directory.current.path, 'lib', 'components', 'ui'));
//   if (!outputDir.existsSync()) {
//     outputDir.createSync(recursive: true);
//   }

//   final outputFile = File(p.join(outputDir.path, '$componentName.dart'));
//   outputFile.writeAsStringSync(renderedContent);

//   print(
//       'Component $componentName generated successfully at lib/components/ui/$componentName.dart');
// }

import 'dart:io';
import 'package:args/args.dart';
import 'package:mustache_template/mustache_template.dart';

void main(List<String> arguments) async {
  final parser = ArgParser();
  final argResults = parser.parse(arguments);

  if (argResults.rest.isEmpty ||
      argResults.rest.length < 2 ||
      argResults.rest[0] != 'add') {
    print('Usage: flutwid_ui add <component_name>');
    return;
  }

  final componentName = argResults.rest[1];
  // Convert to PascalCase for class name
  final className = componentName.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join('');
  final templatePath = 'lib/templates/my_button.dart.mustache';
  final outputPath = 'lib/components/ui/$componentName.dart';

  if (!File(templatePath).existsSync()) {
    print(
        '❌ Template my_button.dart.mustache not found in lib/templates/');
    return;
  }

  final templateString = File(templatePath).readAsStringSync();
  final template = Template(templateString, htmlEscapeValues: false);
  final output = template.renderString({'className': className});

  final outFile = File(outputPath);
  outFile.createSync(recursive: true);
  outFile.writeAsStringSync(output);

  print('✅ Generated $outputPath');
}
