import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' show EdgeInsets;

extension Flatten on List {
  List<T> flatten<T>() {
    return expand<T>((element) => element).toList();
  }
}

extension ListExtensions<T> on List<T> {
  List<T> reverseList(bool condition) {
    return condition ? reversed.toList() : toList();
  }
}

extension Merge on EdgeInsets {
  EdgeInsets merge(EdgeInsets? other) {
    return copyWith(
      left: other?.left != 0 ? other?.left : left,
      right: other?.right != 0 ? other?.right : right,
      top: other?.top != 0 ? other?.top : top,
      bottom: other?.bottom != 0 ? other?.bottom : bottom,
    );
  }
}

extension CustomDateFormat on DateTime {
  String iSO8601Format() {
    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    return formatter.format(this);
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension SublistExtension<T> on List<T> {
  List<T> getSublistUpTo(T element) {
    final index = indexOf(element);
    if (index != -1) {
      return sublist(0, index + 1);
    } else {
      return [];
    }
  }
}

extension DateTimeParser on String {
  DateTime toDate() {
    return DateTime.parse(this);
  }
}
