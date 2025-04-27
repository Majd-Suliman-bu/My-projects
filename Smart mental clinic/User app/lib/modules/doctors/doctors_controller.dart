import 'package:get/get.dart';
import './doctorsService.dart';
import '../../models/doctorsList.dart';

class DoctorsController extends GetxController {
  var doctorsList = Rxn<DoctorsList>();
  var filteredDoctorsList = Rxn<DoctorsList>(); // Add filtered list
  final DoctorService _doctorService = DoctorService();

  @override
  void onInit() {
    fetchDoctors();
    super.onInit();
  }

  void fetchDoctors() async {
    var result = await _doctorService.getDoctors();
    if (result != null) {
      doctorsList.value = result;
      filteredDoctorsList.value = result; // Initialize filtered list
    }
  }

  void filterDoctors(String query, String criteria) {
    if (query.isEmpty) {
      filteredDoctorsList.value = doctorsList.value;
    } else {
      filteredDoctorsList.value = DoctorsList(
        data: doctorsList.value!.data.where((doctor) {
          if (criteria == 'name') {
            return doctor.name.toLowerCase().contains(query.toLowerCase());
          } else if (criteria == 'city') {
            return doctor.city.toLowerCase().contains(query.toLowerCase());
          }
          return false;
        }).toList(),
      );
    }
  }
}
