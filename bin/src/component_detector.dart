/// Detects the component type based on the component name
class ComponentDetector {
  /// Detects the component type based on the component name
  static String detectComponentType(String componentName) {
    final name = componentName.toLowerCase();
    
    if (name.contains('elevated') || name.contains('custom_button') || name.contains('custombutton') || name.contains('padded')) {
      return 'elevated_button';
    } else if (name.contains('slide') || name.contains('slide_to_act')) {
      return 'slide_button';
    } else if (name.contains('time') || name.contains('picker')) {
      return 'time_picker';
    } else if (name.contains('password') || name.contains('pwd') || name.contains('pass_field') || name.contains('passfield')) {
      return 'password_textfield';
    } else {
      return 'button';
    }
  }
}
