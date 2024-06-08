import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class AppointmentModel {
  DateTime startTime;
  DateTime endTime;
  String subject;
  Color color;
  bool isAllDay;
  String? notes;

  AppointmentModel({required this.startTime, required this.endTime, required this.subject, required this.color, required this.isAllDay, required this.notes});

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      subject: json['subject'],
      color: Color(json['color']),
      isAllDay: json['isAllDay'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'subject': subject,
      'color': color.value,
      'isAllDay': isAllDay,
      'notes': notes,
    };
  }

  Appointment toAppointment() {
    return Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: subject,
      color: color,
      isAllDay: isAllDay,
      notes: notes,
    );
  }

  factory AppointmentModel.fromAppointment(Appointment appointment) {
    return AppointmentModel(
      startTime: appointment.startTime,
      endTime: appointment.endTime,
      subject: appointment.subject,
      color: appointment.color,
      isAllDay: appointment.isAllDay,
      notes: appointment.notes,
    );
  }
}
