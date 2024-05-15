//import 'package:intl/intl.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'constColor.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<StatefulWidget> createState() => CalenderState();
}


class CalenderState extends State<Calender> {
  late CalendarDataSource appointmentDataSource = getCalendarDataSource();

  final CalendarController _controller = CalendarController();
  get controller => _controller;
  void viewMon() {
    _controller.view = CalendarView.month;
  }
  void viewSche() {
    _controller.view = CalendarView.schedule;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [backgroundColor, lighter],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              child: SfCalendar(
                backgroundColor: Colors.transparent,
                controller: _controller,
                // HEADER
                // to use custom header, set H to 0
                headerHeight: 64,
                headerDateFormat: 'MMMM',
                headerStyle: CalendarHeaderStyle(
                  backgroundColor: Colors.transparent,
                  textStyle: TextStyle(
                      //Don't use this, it will change the bottom's text color.
                      //color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      foreground: Paint()
                        ..style = PaintingStyle.fill
                        ..color = TextColor),
                ),
                view: CalendarView.month,
                //showNavigationArrow: true,
                // allowedViews: const [
                //   CalendarView.month,
                //   CalendarView.schedule,
                // ],
                viewHeaderStyle: const ViewHeaderStyle(
                  backgroundColor: Colors.transparent,
                  dayTextStyle: TextStyle(
                    color: TextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // Some options
                showDatePickerButton: true,
                showTodayButton: true,
                allowDragAndDrop: true,
                //Not effect mobile in month view.

                //SCHEDULE
                scheduleViewSettings: const ScheduleViewSettings(
                    monthHeaderSettings:
                        MonthHeaderSettings(backgroundColor: Colors.white12)),
                // MouthCellDesign

                //MONTH
                monthCellBuilder:
                    (BuildContext buildContext, MonthCellDetails details) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      details.date.day.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: TextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
                dataSource: appointmentDataSource,
                firstDayOfWeek: 7,
                // onViewChanged: viewChanged,
                monthViewSettings: const MonthViewSettings(
                  //appointmentDisplayCount: 3,
                  //numberOfWeeksInView: 4, //Will conflict with showTrailingAndLeadingDates
                  //navigationDirection: MonthNavigationDirection.horizontal,
                  dayFormat: 'EEE',
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                  showTrailingAndLeadingDates: false,
                  showAgenda: true,
                  agendaStyle: AgendaStyle(
                    backgroundColor: Colors.transparent,
                  ),
                  monthCellStyle: MonthCellStyle(),
                ),
              ),
            ),
          ),
          // SizedBox(height: 16), // 添加一個間距，以便與日曆之間有一些空白
          // ElevatedButton(
          //   onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage())),
          //   child: Text('Accounts'),
          // ),
        ],
      ),
    );
  }
  AppointmentDataSource getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    return AppointmentDataSource(appointments);
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source){
    appointments = source;
  }
}