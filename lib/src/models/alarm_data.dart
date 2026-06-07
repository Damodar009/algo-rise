import 'package:flutter/material.dart';

class AlarmData {
  final String id;
  String time;
  String period;
  List<bool> repeatDays;
  bool active;
  String mode;
  String? language;
  List<String> tags;
  Color themeColor;

  AlarmData({
    required this.id,
    required this.time,
    required this.period,
    required this.repeatDays,
    required this.active,
    required this.mode,
    this.language,
    required this.tags,
    required this.themeColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'period': period,
      'repeatDays': repeatDays,
      'active': active,
      'mode': mode,
      'language': language,
      'tags': tags,
      'themeColorValue': themeColor.value,
    };
  }

  factory AlarmData.fromJson(Map<String, dynamic> json) {
    return AlarmData(
      id: json['id'] as String,
      time: json['time'] as String,
      period: json['period'] as String,
      repeatDays: List<bool>.from(json['repeatDays'] as List),
      active: json['active'] as bool,
      mode: json['mode'] as String,
      language: json['language'] as String?,
      tags: List<String>.from(json['tags'] as List),
      themeColor: Color(json['themeColorValue'] as int),
    );
  }
}
