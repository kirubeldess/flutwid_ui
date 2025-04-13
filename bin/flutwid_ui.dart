import 'dart:io';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addCommand('generate');
  final argResults = parser.parse(arguments);

  if (argResults.command?.name == 'generate') {
    generateComponent(argResults.command?.rest ?? []);
  }
}

void generateComponent(List<String> args) {
  if (args.isEmpty) {
    print('Error: You must provide a component name.');
    return;
  }

  final componentName = args[0];

  // Define the path to the predefined component in your package
  final predefinedComponentPath = 'lib/components/$componentName.dart';
  final userComponentPath = 'lib/components/$componentName.dart';

  // Check if the predefined component exists in your package
  final predefinedComponentFile = File(predefinedComponentPath);
  if (!predefinedComponentFile.existsSync()) {
    print('Error: Component $componentName does not exist in the package.');
    return;
  }

  // Copy the predefined component to the user's project
  final userComponentFile = File(userComponentPath);
  try {
    predefinedComponentFile.copySync(userComponentFile.path);
    print('Component $componentName.dart generated successfully!');
  } catch (e) {
    print('Error generating component: $e');
  }
}
