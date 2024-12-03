import 'dart:convert';

class CourseLevel {
  CourseLevel({
    this.id,
    this.title,
  });

  int? id;
  String? title;

  factory CourseLevel.fromJson(Map<String, dynamic> json) =>
      CourseLevel(id: json["id"] ?? 0, title: json["title"] ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
