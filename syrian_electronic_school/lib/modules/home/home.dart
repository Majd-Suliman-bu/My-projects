import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syrian_electronic_school/config/user_info.dart';
import '../../component/customButton.dart';
import '../../component/customTextInput.dart';
import '../../component/DrawerV2.dart';
import '../../component/gridItems.dart';
import '../../component/testing_home_item.dart';
import '../../config/constant.dart';
import './home_controller.dart';

class Home extends StatelessWidget {
  HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: red,
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) => red,
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [Text("education level "), Icon(Icons.school)],
                ),
                Text(UserInfo.className)
              ],
            ),
            onPressed: () {
              _showClassSelectionBottomSheet(context);
            },
          )
        ],
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
        if (controller.courses.isEmpty) {
          return Center(
            child: Text(
              "There is No subjects for this class ",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: refreshData,
          child: GridView.builder(
            itemCount: controller.courses.length,
            itemBuilder: (ctx, index) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: GridItem(
                    courseImage: "https://via.placeholder.com/150",
                    courseName: controller.courses[index].title,
                    onTap: () {
                      UserInfo.courseId = controller.courses[index].courseId;
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
    controller.getAllSubjects();
  }

  void _showClassSelectionBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * .50,
        child: Container(
          width: MediaQuery.of(context).size.width * .4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 20),
              Text("select Another Class:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width * .35,
                child: Obx(() {
                  return ListView.builder(
                    itemCount: controller.classes.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        child: Text(controller.classes[index].name),
                        onPressed: () {
                          //.changeClass(controller.classes[index]);
                          Navigator.pop(context); // Close the bottom sheet
                        },
                      );
                      //   ListTile(
                      //   title: Text(controller.classes[index].name),
                      //   onTap: () {
                      //     //.changeClass(controller.classes[index]);
                      //     Navigator.pop(context); // Close the bottom sheet
                      //   },
                      // );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      backgroundColor: white,
    );
  }
}

  final List<String> avatarUrls = [
    "https://example.com/avatar1.jpg",
    "https://example.com/avatar2.jpg",
    "https://example.com/avatar3.jpg",
    "https://example.com/avatar4.jpg",
    "https://example.com/avatar5.jpg",
    "https://example.com/avatar6.jpg",
    "https://example.com/avatar7.jpg",
    "https://example.com/avatar8.jpg",
    "https://example.com/avatar9.jpg",
    "https://example.com/avatar10.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: avatarUrls
            .map((url) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(url),
                    radius: 30,
                  ),
                ))
            .toList(),
      ),
    );
  }

