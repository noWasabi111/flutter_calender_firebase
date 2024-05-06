//import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_calender_firebase/test_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<StatefulWidget> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  final CalendarController _controller = CalendarController();

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
                    colors: [Color(0xFF073763), Color(0xFF341c74), ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
              ),
              child: SfCalendar(
                backgroundColor: Colors.transparent,
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
                      ..style=PaintingStyle.fill
                      ..color=Colors.white
                  ),
                ),
                view: CalendarView.month,
                //showNavigationArrow: true,
                allowedViews: const [
                  CalendarView.month,
                  CalendarView.schedule,
                ],
                viewHeaderStyle: const ViewHeaderStyle(
                  backgroundColor: Colors.transparent,
                  dayTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                showDatePickerButton: true,
                scheduleViewSettings:  const ScheduleViewSettings(
                  monthHeaderSettings: MonthHeaderSettings(
                    backgroundColor: Colors.white12
                  )
                ),
                // MouthCellDesign
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
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
                controller: _controller,
                dataSource: MeetingDataSource(_getDataSource()),
                firstDayOfWeek: 7,
                // onViewChanged: viewChanged,
                monthViewSettings: const MonthViewSettings(
                  //appointmentDisplayCount: 3,
                  //numberOfWeeksInView: 4, //Will conflict with showTrailingAndLeadingDates
                  //navigationDirection: MonthNavigationDirection.horizontal,
                  dayFormat: 'EEE',
                  appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                  showTrailingAndLeadingDates: false,
                  showAgenda: true,
                  agendaStyle: AgendaStyle(
                    backgroundColor: Colors.transparent,
                  ),
                  monthCellStyle: MonthCellStyle(

                  ),
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

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2, days: 5));
    meetings.add(Meeting(
        '測試用', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
