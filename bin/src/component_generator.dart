import 'dart:io';
import 'component_detector.dart';
import 'button_template.dart';
import 'elevated_button_template.dart';
import 'slide_button_template.dart';
import 'time_picker_template.dart';
import 'password_textfield_template.dart';

/// Handles component generation
class ComponentGenerator {
  /// Gets the template content for the specified component type
  static String getTemplateContent(String componentType, String className) {
    switch (componentType) {
      case 'elevated_button':
        return getElevatedButtonTemplate(className);
      case 'slide_button':
        return getSlideButtonTemplate(className);
      case 'time_picker':
        return getTimePickerTemplate(className);
      case 'password_textfield':
        return getPasswordTextfieldTemplate(className);
      case 'button':
      default:
        return getButtonTemplate(className);
    }
  }

  /// Generates a component file based on the component name
  static File generateComponent(String componentName, String className) {
    // Create the output directory if it doesn't exist
    final componentsDir = Directory('${Directory.current.path}/lib/components/ui');
    if (!componentsDir.existsSync()) {
      componentsDir.createSync(recursive: true);
      print('Created directory ${componentsDir.path}');
    }
    
    // Create the component file
    final outputFile = File('${componentsDir.path}/$componentName.dart');
    
    // Detect component type and get template content
    final componentType = ComponentDetector.detectComponentType(componentName);
    final componentCode = getTemplateContent(componentType, className);
    
    // Write the component file
    outputFile.writeAsStringSync(componentCode);
    
    return outputFile;
  }
}
