import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ApmEdit extends StatefulWidget {
  ApmEdit({super.key} );

  late Appointment app = Appointment(
    subject: "New Event",
    startTime: DateTime.now(),
    endTime: DateTime.now(),
    color: Colors.blueAccent,
    isAllDay: false,
  );
  late bool editing = false;

  void clearEdiror(){
    app = Appointment(
      subject: "New Event",
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      color: Colors.blueAccent,
      isAllDay: false,
    );
    editing = false;
  }
  @override
  State<StatefulWidget> createState() => ApmEditState();
}

class ApmEditState extends State<ApmEdit> {

  // void clearEditor(){
  //   debugPrint("clear it");
  //   setState(() {
  //     widget.editing = false;
  //     widget.app = Appointment(
  //       subject: "New Event",
  //       startTime: DateTime.now(),
  //       endTime: DateTime.now(),
  //       color: Colors.blueAccent,
  //       isAllDay: false,
  //     );
  //   });
  // }

  FocusNode textFieldlFocusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  Future<bool> openColorPicker() async {
    return ColorPicker(
      color: widget.app.color,
      onColorChanged: (Color newColor) {
        setState(() {
          widget.app.color = newColor;
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
  TextEditingController diglogController = TextEditingController();
  Future<void> showNotesContent() async {
    if (widget.editing){
      diglogController.text = widget.app.notes!;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Notes'),
              const SizedBox(width: 12,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        diglogController.text = '';
                        widget.app.notes = null;
                      });
                    },
                    icon: const Icon(Icons.delete,),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.app.notes = diglogController.text;
                      });
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.save,),
                  ),
                ],
              ),
            ],
          ),
          content:  SingleChildScrollView(
            child: TextField(
              controller: diglogController,
              onChanged: (String value) {
                diglogController.text = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Add description',
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    if(widget.app.subject != "New Event"){
      textEditingController.text = widget.app.subject;
    }
    return Scaffold(
      appBar: AppBar(
        leading: Visibility(
          visible: widget.editing,
          child: IconButton(
              onPressed: (){
                widget.clearEdiror();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_rounded, size: 28,)),
        ),
        title: const Text('New Event'),
        actions: [
          Visibility(
            visible: widget.editing,
            child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save_as, size: 28,)),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              focusNode: textFieldlFocusNode,
              controller: textEditingController,
              style: const TextStyle(
                fontSize: 18
              ),
              decoration: const InputDecoration(
                labelText: 'Event Name',
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
              onChanged: (_) {
                if (textEditingController.text != ''){
                  setState(() {
                    widget.app.subject = textEditingController.text;
                  });
                } else {
                  setState(() {
                    widget.app.subject = "New Event";
                  });
                }
              },
              onTapOutside: (_) {
                textFieldlFocusNode.unfocus();
              },
            ),
            ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: const Icon(
                  Icons.access_time,
                  color: Colors.black54,
                ),
                title: Row(children: <Widget>[
                  const Expanded(
                    child: Text('All-day'),
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Switch(
                            //Can be for Debug
                            value: widget.app.isAllDay,
                            onChanged: (bool value) {
                              setState(() {
                                widget.app.isAllDay = value;
                              });
                            },
                          ))),
                ])),
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
                    widget.app.startTime = dateTime;
                  });
                }
              },
              child: Row(
                children: [
                  Text(
                    widget.app.isAllDay? DateFormat('yyyy-MM-dd').format(widget.app.startTime).toString()
                        : DateFormat('yyyy-MM-dd HH:mm').format(widget.app.startTime).toString(),
                  )
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
                      widget.app.endTime = dateTime;
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(
                      widget.app.isAllDay? DateFormat('yyyy-MM-dd').format(widget.app.endTime).toString()
                          : DateFormat('yyyy-MM-dd HH:mm').format(widget.app.endTime).toString(),
                    )
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
                 final beforeDialog = widget.app.color;
                 if (!(await openColorPicker())) {
                   setState(() {
                     widget.app.color = beforeDialog;
                   });
                 }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.app.color
              ),
              child: const Row(),
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              onTap: showNotesContent,
              leading: const Icon(
                Icons.subject,
                color: Colors.black87,
              ),
              title: Text(
                diglogController.text != ''? diglogController.text
                    : "Edit Notes",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,),
                textAlign: TextAlign.start,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
