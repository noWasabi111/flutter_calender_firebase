import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:async';
import 'calender.dart';
import 'login_page.dart';
import 'sign_up_page.dart';
import 'constColor.dart';
import 'appointmentEditor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'AppointmentModel.dart';
import 'package:flutter_calender_firebase/toast_set/toast.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      routes: {
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => MyApp(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //static GlobalKey<CalenderState> sfkey = GlobalKey();
  static GlobalKey<CalenderState> sfkey = GlobalKey<CalenderState>();
  late final FloatingActionButton floatingActionButton;
  ApmEdit apmEditor = ApmEdit();
  Calender sfcalender = Calender(
    key: sfkey,
  );
  //  SomeSliderPanelSettings
  PanelController sliderController = PanelController();
  @override
  void initState()
  {
    floatingActionButton = FloatingActionButton(
      backgroundColor: eventColor,
      onPressed: fabOnPress,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
    super.initState();
    //print('sfkey initialized: ${sfkey != null}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sliderController.hide();
      //sfkey.currentState?.setWidget(floatingActionButton);
    });
    _loadAppointments();
  }
  bool _showFAB = true;
  void showFAB(){
    setState(() {
      _showFAB = !_showFAB;
    });
  }
  Future<void> showSlider() async {
    if (!sliderController.isPanelShown){
      await sliderController.show();
    }
    sliderController.open();
  }
  void fabOnPress(){
    apmEditor.apmEditSet.clearEditor();
    showFAB();
    showSlider();
  }


  Future<void> saveAppointment()  async {
    if (apmEditor.apmEditSet.editing){
      debugPrint("Try Delete");
      sfkey.currentState?.appointmentDataSource.appointments?.removeAt(
          sfkey.currentState!.appointmentDataSource.appointments!.indexOf(apmEditor.apmEditSet.app)
      );
      sfkey.currentState?.appointmentDataSource.notifyListeners(
          CalendarDataSourceAction.remove,
          <Appointment?>[apmEditor.apmEditSet.app]
      );
    }
    sfkey.currentState?.appointmentDataSource.appointments?.add(apmEditor.apmEditSet.app);
    sfkey.currentState?.appointmentDataSource.notifyListeners(
        CalendarDataSourceAction.add, <Appointment?>[apmEditor.apmEditSet.app]);
    apmEditor.apmEditSet.editing = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    List<AppointmentModel>? appointmentModels = sfkey.currentState?.appointmentDataSource.appointments?.map((appointment) => AppointmentModel.fromAppointment(appointment)).toList();
    String appointmentsJson = json.encode(appointmentModels?.map((model) => model.toJson()).toList());
    await prefs.setString('appointments', appointmentsJson);
  }

  _loadAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? appointmentsJson = prefs.getString('appointments');
    if (appointmentsJson != null) {
      List<dynamic> jsonList = json.decode(appointmentsJson);
      List<AppointmentModel> appointmentModels = jsonList.map((json) => AppointmentModel.fromJson(json)).toList();
      for(var appointmentM in appointmentModels){
        setState(() {
          sfkey.currentState?.appointmentDataSource.appointments?.add(appointmentM.toAppointment());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var currentUser = FirebaseAuth.instance.currentUser;

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
                debugPrint('Before Navigator.pop');
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
                debugPrint('After Navigator.pop');
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
            Column(
              children: [
                ExpansionTile(
                  title: const Text('Accounts'),
                  tilePadding: const EdgeInsets.fromLTRB(16, 0, 20, 0),
                  children: currentUser != null ? [
                    ListTile(
                      title: Text(
                        currentUser.email!.length > 5 ? "${currentUser.email!.substring(0, 5)}..." : currentUser.email!,
                        style: TextStyle(color: Colors.black),
                      ),
                      leading: const Icon(
                        Icons.account_circle,
                        color: TextColor,
                      ),
                      onTap: () {
                        //
                      },
                    ),
                  ] : [
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
                                builder: (context) => const LoginPage()));
                      },
                    ),
                  ],
                ),
                if (currentUser != null)
                  ListTile(
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.black),
                    ),
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      currentUser = null;
                        if (currentUser == null) {
                        showToast(message: "User is successfully logout");
                        Navigator.pushNamed(context, "/home");
                        } else {
                        showToast(message: "some error occured");

                      }
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
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        //onPanelSlide: onPanelChange,
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
                    onPressed: () async {
                      await saveAppointment();
                      sliderController.hide();
                      showFAB();
                    },
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
      floatingActionButton: _showFAB ? floatingActionButton : null,
    );
  }

}

