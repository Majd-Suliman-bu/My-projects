import 'package:get/get.dart';
import '../../config/user_info.dart';

import '../dump_data/subjects.dart';
import './home_service.dart';
import '../../models/courses_model.dart';
import '../../models/classes.dart';

import '../../native_service/secure_storage.dart';

class HomeController extends GetxController {
  List<subject> subjects = [
    subject(image: "assets/images/geometry.jpg", name: "رياضيات - جبر"),
    subject(image: "assets/images/geometry.jpg", name: "رياضيات - هندسة"),
  ];
  late List<course> courses;
  var classes = <Class>[].obs; // Observable list of classes
  var selectedClass; // Selected class
  Homeservice service = Homeservice();

  var isloading = true.obs;

  void onReady() async {
    getAllSubjects();

    super.onReady();
  }

  Future<void> fetchClasses() async {
    try {
      var fetchedClasses = await service.fetchClasses();
      classes.assignAll(
          fetchedClasses); // Assign fetched classes to the observable list
    } catch (e) {
      // Handle error if needed
    }
  }

  void getAllSubjects() async {
    courses = await service.getAllSubjectsForLevel();
    isloading(false);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    print(UserInfo.classID);
    fetchClasses();
    super.onInit();
  }
}
