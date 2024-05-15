import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'calender.dart';
import 'test_page.dart';
import 'constColor.dart';

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

  @override
  Widget build(BuildContext context) {
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: eventColor,
        onPressed: () {
          // Under progress
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
