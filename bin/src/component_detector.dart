/// Detects the component type based on the component name
class ComponentDetector {
  /// Detects the component type based on the component name
  static String detectComponentType(String componentName) {
    final name = componentName.toLowerCase();
    
    if (name.contains('elevated') || name.contains('custom_button') || name.contains('custombutton')) {
      return 'elevated_button';
    } else if (name.contains('slide') || name.contains('slide_to_act')) {
      return 'slide_button';
    } else if (name.contains('time') || name.contains('picker')) {
      return 'time_picker';
    } else {
      return 'button';
    }
  }
}
