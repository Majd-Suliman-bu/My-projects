// To parse this JSON data, do
//
//     final coursesModel = coursesModelFromJson(jsonString);

import 'dart:convert';

CoursesModel coursesModelFromJson(String str) =>
    CoursesModel.fromJson(json.decode(str));

String coursesModelToJson(CoursesModel data) => json.encode(data.toJson());

class CoursesModel {
  bool success;
  String message;
  List<course> data;

  CoursesModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CoursesModel.fromJson(Map<String, dynamic> json) => CoursesModel(
        success: json["success"],
        message: json["message"],
        data: List<course>.from(json["data"].map((x) => course.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class course {
  int courseId;
  String title;
  CourseClass datumClass;
  int courseFee;
  String aboutTheCourse;
  bool finished;
  String photo;
  Teacher teacher;
  List<Unit> units;

  course({
    required this.courseId,
    required this.title,
    required this.datumClass,
    required this.courseFee,
    required this.aboutTheCourse,
    required this.finished,
    required this.photo,
    required this.teacher,
    required this.units,
  });

  factory course.fromJson(Map<String, dynamic> json) => course(
        courseId: json["course_id"],
        title: json["title"],
        datumClass: CourseClass.fromJson(json["class"]),
        courseFee: json["course_fee"],
        aboutTheCourse: json["about_the_course"],
        finished: json["finished"],
        photo: json["photo"],
        teacher: Teacher.fromJson(json["teacher"]),
        units: List<Unit>.from(json["units"].map((x) => Unit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "course_id": courseId,
        "title": title,
        "class": datumClass.toJson(),
        "course_fee": courseFee,
        "about_the_course": aboutTheCourse,
        "finished": finished,
        "photo": photo,
        "teacher": teacher.toJson(),
        "units": List<dynamic>.from(units.map((x) => x.toJson())),
      };
}

class CourseClass {
  int classId;
  String name;

  CourseClass({
    required this.classId,
    required this.name,
  });

  factory CourseClass.fromJson(Map<String, dynamic> json) => CourseClass(
        classId: json["class_id"],
        name: json["name"]!,
      );

  Map<String, dynamic> toJson() => {
        "class_id": classId,
        "name": name,
      };
}

class Teacher {
  int teacherId;
  TeacherName? name;
  TeacherPhoto? photo;

  Teacher({
    required this.teacherId,
    this.name,
    this.photo,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        teacherId: json["teacher_id"],
        name: teacherNameValues.map[json["name"]],
        photo: teacherPhotoValues.map[json["photo"]],
      );

  Map<String, dynamic> toJson() => {
        "teacher_id": teacherId,
        "name": teacherNameValues.reverse[name],
        "photo": teacherPhotoValues.reverse[photo],
      };
}

enum TeacherName { TEACHER_53 }

final teacherNameValues = EnumValues({"teacher 53": TeacherName.TEACHER_53});

enum TeacherPhoto { STORAGE_AVATAR_DEFAULT_AVATAR_JPG }

final teacherPhotoValues = EnumValues({
  "storage/avatar/default-avatar.jpg":
      TeacherPhoto.STORAGE_AVATAR_DEFAULT_AVATAR_JPG
});

class Unit {
  int unitId;
  String title;
  int unitNumber;
  int courseId;
  List<Lecture> lectures;

  Unit({
    required this.unitId,
    required this.title,
    required this.unitNumber,
    required this.courseId,
    required this.lectures,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        unitId: json["unit_id"],
        title: json["title"],
        unitNumber: json["unit_number"],
        courseId: json["course_id"],
        lectures: List<Lecture>.from(
            json["lectures"].map((x) => Lecture.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "unit_id": unitId,
        "title": title,
        "unit_number": unitNumber,
        "course_id": courseId,
        "lectures": List<dynamic>.from(lectures.map((x) => x.toJson())),
      };
}

class Lecture {
  int lectureId;
  String title;
  int lectureNumber;
  String lectureDesc;
  Pdf? videos;
  Pdf? pdf;
  List<Question> questions;

  Lecture({
    required this.lectureId,
    required this.title,
    required this.lectureNumber,
    required this.lectureDesc,
    required this.videos,
    required this.pdf,
    required this.questions,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) => Lecture(
        lectureId: json["lecture_id"],
        title: json["title"],
        lectureNumber: json["lecture_number"],
        lectureDesc: json["lecture_desc"],
        videos: json["videos"] == null ? null : Pdf.fromJson(json["videos"]),
        pdf: json["pdf"] == null ? null : Pdf.fromJson(json["pdf"]),
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lecture_id": lectureId,
        "title": title,
        "lecture_number": lectureNumber,
        "lecture_desc": lectureDesc,
        "videos": videos?.toJson(),
        "pdf": pdf?.toJson(),
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}

class Pdf {
  int? pdfId;
  String title;
  int lectureId;
  int unitId;
  int courseId;
  int size;
  String url;
  int? videoId;

  Pdf({
    this.pdfId,
    required this.title,
    required this.lectureId,
    required this.unitId,
    required this.courseId,
    required this.size,
    required this.url,
    this.videoId,
  });

  factory Pdf.fromJson(Map<String, dynamic> json) => Pdf(
        pdfId: json["pdf_id"],
        title: json["title"],
        lectureId: json["lecture_id"],
        unitId: json["unit_id"],
        courseId: json["course_id"],
        size: json["size"],
        url: json["url"],
        videoId: json["video_id"],
      );

  Map<String, dynamic> toJson() => {
        "pdf_id": pdfId,
        "title": title,
        "lecture_id": lectureId,
        "unit_id": unitId,
        "course_id": courseId,
        "size": size,
        "url": url,
        "video_id": videoId,
      };
}

class Question {
  int questionId;
  String question;
  int lectureId;
  int unitId;
  int courseId;
  List<Choice> choices;

  Question({
    required this.questionId,
    required this.question,
    required this.lectureId,
    required this.unitId,
    required this.courseId,
    required this.choices,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionId: json["question_id"],
        question: json["question"],
        lectureId: json["lecture_id"],
        unitId: json["unit_id"],
        courseId: json["course_id"],
        choices:
            List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "question": question,
        "lecture_id": lectureId,
        "unit_id": unitId,
        "course_id": courseId,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
      };
}

class Choice {
  int choiceId;
  String choice;
  bool isCorrect;
  int questionId;

  Choice({
    required this.choiceId,
    required this.choice,
    required this.isCorrect,
    required this.questionId,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        choiceId: json["choice_id"],
        choice: json["choice"],
        isCorrect: json["is_correct"],
        questionId: json["question_id"],
      );

  Map<String, dynamic> toJson() => {
        "choice_id": choiceId,
        "choice": choice,
        "is_correct": isCorrect,
        "question_id": questionId,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
