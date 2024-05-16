import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class ApmEdit extends StatefulWidget {
  const ApmEdit({super.key});

  @override
  State<StatefulWidget> createState() => _ApmEditState();
}

class _ApmEditState extends State<ApmEdit> {
  @override
  Widget build(BuildContext context) {
    // final appBar = AppBar(
    //   title: const Text('Sing Up'),
    //   backgroundColor: const Color(0XFFe0dfda),
    // );
    Color selectedColor = Colors.blueAccent;
    MaterialStatesController colorPickerBtnController = MaterialStatesController();
    Future<void> _openColorPicker() async {
      bool pickedColor = await ColorPicker(
        color: selectedColor,
        onColorChanged: (Color newColor) {
          setState(() {
            selectedColor = newColor;
          });
        },
        width: 40,
        height: 40,
        borderRadius: 20,
        spacing: 10,
        runSpacing: 10,
        heading: const Text('Pick a color'),
        subheading: const Text('Select a color for your widget'),
        wheelDiameter: 200,
        wheelWidth: 20,

      ).showPickerDialog(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Event Name',
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Start Time',
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'End Time',
              ),
            ),
            const SizedBox(height: 12.0),
            const Text(
              "Color",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4.0),
            OutlinedButton(
              statesController: colorPickerBtnController,
              onPressed: _openColorPicker,
              style: OutlinedButton.styleFrom(
                // Not Fix yet!!!!!!
                backgroundColor: selectedColor,
              ),
              child: const Row(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
