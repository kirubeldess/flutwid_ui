import 'package:args/args.dart';
import 'src/component_generator.dart';

/// Main entry point for the CLI tool
void main(List<String> arguments) {
  // Parse arguments
  final parser = ArgParser();
  final argResults = parser.parse(arguments);
  
  // Check if command is 'add'
  if (argResults.rest.isEmpty || argResults.rest[0] != 'add') {
    printUsage();
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
  
  try {
    // Generate the component using the component generator
    final outputFile = ComponentGenerator.generateComponent(componentName, className);
    
    print('✅ Generated ${outputFile.path}');
    print('');
    print('Success! You can now import this component in your Flutter app.');
  } catch (e) {
    print('❌ Error generating component: $e');
  }
}

/// Prints usage information
void printUsage() {
  print('Flutwid UI - Flutter Component Generator');
  print('');
  print('Usage:');
  print('  flutwid_ui add <component_name>');
  print('');
  print('Examples:');
  print('  flutwid_ui add my_button           # Creates a basic button component');
  print('  flutwid_ui add custom_elevated     # Creates a customizable elevated button');
  print('  flutwid_ui add my_slide_to_act     # Creates a SlideToAct component');
  print('  flutwid_ui add time_picker         # Creates a beautiful time picker component');
  print('');
  print('The component will be created in lib/components/ui/ of your current project.');
}
