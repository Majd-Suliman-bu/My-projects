import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:smart_medical_clinic/models/doctorsList.dart';
import 'package:smart_medical_clinic/modules/profile/custom_refresh_indicator.dart';
import '../../config/server_config.dart';
import 'doctors_controller.dart';

class Doctors extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  final RxString searchCriteria = 'name'.obs; // Add search criteria

  @override
  Widget build(BuildContext context) {
    final DoctorsController doctorsController = Get.find();
    FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back button
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width *
                    0.6, // Adjust width as needed
                child: Obx(() {
                  return TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by ${searchCriteria.value}'.tr,
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    onChanged: (query) {
                      doctorsController.filterDoctors(
                          query, searchCriteria.value);
                    },
                  );
                }),
              ),
              Obx(() {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: searchCriteria.value,
                    dropdownColor: Colors.blue,
                    icon: Icon(Icons.arrow_downward, color: Colors.white),
                    underline: SizedBox(), // Remove the underline
                    onChanged: (String? newValue) {
                      searchCriteria.value = newValue!;
                      // Update the hint text and filter the list based on the new criteria
                      searchController.clear();
                      doctorsController.filterDoctors('', searchCriteria.value);
                    },
                    items: <String>['name', 'city']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value.tr,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (doctorsController.filteredDoctorsList.value == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (doctorsController.filteredDoctorsList.value!.data.isEmpty) {
          return customRefreshIndicator(
            () async {
              doctorsController.filteredDoctorsList.value = null;
              doctorsController.onInit();
            },
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: Text(
                        "No doctors".tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return customRefreshIndicator(
            () async {
              doctorsController.filteredDoctorsList.value = null;
              doctorsController.onInit();
            },
            ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount:
                  doctorsController.filteredDoctorsList.value!.data.length,
              itemBuilder: (context, index) {
                var doctor =
                    doctorsController.filteredDoctorsList.value!.data[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(doctor.photo),
                      radius: 30,
                    ),
                    title: Text(doctor.name),
                    subtitle: Text(doctor.city),
                    trailing: ElevatedButton(
                      onPressed: () {
                        flutterSecureStorage.write(
                            key: 'doctorId', value: doctor.id.toString());
                        Get.toNamed('/DoctorProfile');
                      },
                      child: Text("Profile".tr),
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}
