import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class ApmEdit extends StatefulWidget {
  const ApmEdit({super.key});

  @override
  State<StatefulWidget> createState() => ApmEditState();
}

class ApmEditState extends State<ApmEdit> {
  String eventName = "New Event";
  Color selectedColor = Colors.blueAccent;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {




    Future<bool> openColorPicker() async {
      return ColorPicker(
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
            TextField(
              controller: textEditingController,
              decoration: const InputDecoration(
                labelText: 'Event Name',
              ),
              onChanged: (_) {
                if (textEditingController.text != ''){
                  setState(() {
                    eventName = textEditingController.text;
                  });
                } else {
                  setState(() {
                    eventName = "New Event";
                  });
                }
              },
            ),
            const SizedBox(height: 12.0),
            const Text(
              "Start Time",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4.0),
            ElevatedButton(
              onPressed: () async {
                DateTime? dateTime = await showOmniDateTimePicker(context: context);
                if (dateTime != null){
                  setState(() {
                    endTime = dateTime;
                  });
                }
              },
              child: Row(
                children: [
                  Text(DateFormat('yyyy-MM-dd HH:mm').format(startTime).toString())
                ],
              )
            ),
            const SizedBox(height: 12.0),
            const Text(
              "End Time",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4.0),
            ElevatedButton(
                  onPressed: () async {
                  DateTime? dateTime = await showOmniDateTimePicker(context: context);
                  if (dateTime != null){
                    setState(() {
                      endTime = dateTime;
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(DateFormat('yyyy-MM-dd HH:mm').format(endTime).toString())
                  ],
                )
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
            ElevatedButton(
              onPressed: () async {
                 final beforeDialog = selectedColor;
                 if (!(await openColorPicker())) {
                   setState(() {
                     selectedColor = beforeDialog;
                   });
                 }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedColor
              ),
              child: const Row(),
            ),
          ],
        ),
      ),
    );
  }
}
