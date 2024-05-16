import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'calender.dart';
import 'test_page.dart';
import 'constColor.dart';
import 'appointmentEditor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calender',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: selectColor),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static GlobalKey<CalenderState> sfkey = GlobalKey();
  static Calender sfcalender = Calender(
    key: sfkey,
  );
  //  SomeSliderPanelSettings
  PanelController sliderController = PanelController();
  @override
  void initState()
  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sliderController.hide();
    });
  }
  bool _showFAB = true;
  double _roundCorner = 0.0;
  void showFAB(){
    setState(() {
      _showFAB = !_showFAB;
    });
  }
  void onPanelChange(double pos) {
    setState(() {
      if (sliderController.isPanelOpen){
        _roundCorner = 0.0;
      } else {
        _roundCorner = 24.0;
      }
    });
  }

  ApmEdit apmEditor = const ApmEdit();
  //  SomeSliderPanelSettingsEnd
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Future<void> showSlider() async {
      if (!sliderController.isPanelShown){
        await sliderController.show();
      }
      sliderController.open();
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: TextColor,
      ),
      drawerDragStartBehavior: DragStartBehavior.start,
      drawerEdgeDragWidth: 40,
      drawer: Drawer(
        width: 150,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: TextColor,
                ),
                child: Text(
                  '日程行事曆',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              title: const Text('Month'),
              leading: const Icon(Icons.calendar_month),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
                sfkey.currentState?.viewMon();
              },
            ),
            ListTile(
              title: const Text('Schedule'),
              leading: const Icon(Icons.schedule),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
                sfkey.currentState?.viewSche();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const MySeparator(
              height: 0.5,
              width: 8,
            ),
            const SizedBox(
              height: 10,
            ),
            ExpansionTile(
              title: const Text('Accounts'),
              tilePadding: const EdgeInsets.fromLTRB(16, 0, 20, 0),
              children: [
                ListTile(
                  title: const Text(
                    'Add...',
                    style: TextStyle(color: Colors.grey),
                  ),
                  leading: const Icon(
                    Icons.add,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    // Update the state of the app
                    // Then close the drawer
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TestPage()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      body: SlidingUpPanel(
        minHeight: 150,
        maxHeight: screenSize.height,
        controller: sliderController,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_roundCorner),
          topRight: Radius.circular(_roundCorner),
        ),
        onPanelSlide: onPanelChange,
        header: SizedBox(
          width: screenSize.width,
          //color: Colors.blueAccent,
          child: Column(
            children: [
              const SizedBox(height: 8,),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CloseButton(
                    onPressed: () {
                      sliderController.hide();
                      showFAB();
                    },
                  ),
                  Container(
                    height: 4,
                    width: screenSize.width - 240,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.black38
                    ),
                  ),
                  IconButton(
                    onPressed: () {  },
                    icon: const Icon(
                      Icons.save,
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
        panel: Container(
          padding: const EdgeInsets.only(top: 48),
          child: apmEditor,
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [backgroundColor, lighter],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
          child: sfcalender,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _showFAB ? FloatingActionButton(
        backgroundColor: eventColor,
        onPressed: () {
          //  Under progress
          showSlider();
          showFAB();
          //  Under progress
          final Appointment app = Appointment(
              startTime: sfkey.currentState?.controller.displayDate!,
              endTime: sfkey.currentState?.controller.displayDate!
                  .add(const Duration(hours: 2)),
              subject: 'Add Appointment',
              color: Colors.blueAccent);
          sfkey.currentState?.appointmentDataSource.appointments?.add(app);
          sfkey.currentState?.appointmentDataSource.notifyListeners(
              CalendarDataSourceAction.add, <Appointment>[app]);

        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ) : null,
    );
  }
}
