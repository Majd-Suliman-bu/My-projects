import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syrian_electronic_school/config/user_info.dart';
import '../../component/customButton.dart';
import '../../component/customTextInput.dart';
import '../../component/DrawerV2.dart';
import '../../component/gridItems.dart';
import '../../component/testing_home_item.dart';
import '../../config/constant.dart';
import './mySubscriptions_controller.dart';

class MySubscriptions extends StatelessWidget {
  MySubscriptionsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: red,

      ),
      backgroundColor: white,
      drawer: MyDrawer(),
      body: Obx(() {
        if (controller.isloading.isTrue) {
          return const Center(
            child: CircularProgressIndicator(
              color: six,
            ),
          );
        }
        if (controller.myCourses.isEmpty) {
          return Center(
            child: Text(
              "No subscriptions",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: refreshData,
          child:
          GridView.builder(
            itemCount: controller.myCourses.length,
            itemBuilder: (ctx, index) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: GridItem(
                    courseImage: "https://via.placeholder.com/150",
                    courseName: controller.myCourses[index].courseTitle,
                    onTap: () {
                      UserInfo.courseId = controller.myCourses[index].courseId;
                      Get.toNamed("CourseContent");
                    }),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
          ),
        );
      }),
    );
  }

  Future refreshData() async {
    controller.getAllSubscriptions();
  }



}

