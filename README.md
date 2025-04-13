# Flutwid UI

A Flutter UI component library inspired by shadcn, providing reusable and customizable UI components for Flutter applications.

## Features

- Pre-built, customizable UI components
- CLI tool for generating new components
- Modern design with Material 3 support
- Easy to integrate into any Flutter project

## Installation

```bash
flutter pub add flutwid_ui
```

## Usage

### Import the package

```dart
import 'package:flutwid_ui/flutwid_ui.dart';
```

### Use components in your app

```dart
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutwid UI Example')),
      body: Center(
        child: MyButton(),
      ),
    );
  }
}
```

## CLI Usage

Flutwid UI comes with a CLI tool that helps you generate new components for your project.

```bash
# First, add the package to your project
flutter pub add flutwid_ui

# Then, add a new button component to your project
dart run flutwid_ui:flutwid_ui add my_button
```

No global installation, PATH modifications, or template files needed! The component will be created in `lib/components/ui/` of your project.

## Available Components

- **MyButton**: A customizable button component

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
