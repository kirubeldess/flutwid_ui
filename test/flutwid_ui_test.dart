import 'package:flutter_test/flutter_test.dart';
import 'package:flutwid_ui/flutwid_ui.dart';

void main() {
  group('Component Tests', () {
    testWidgets('MyButton exists and can be instantiated', (WidgetTester tester) async {
      // Verify that MyButton can be instantiated
      const button = MyButton();
      expect(button, isA<MyButton>());
    });
  });
}
