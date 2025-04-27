import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syrian_electronic_school/modules/courseContent/courseContent_controller.dart';
import 'package:syrian_electronic_school/modules/downloads.dart/downloads.dart';
import 'package:syrian_electronic_school/modules/downloads.dart/downloads_controller.dart';

import '../../config/constant.dart';
import '../../models/Course.dart';
import '../../models/file.dart';
import '../../models/video.dart';
import '../courseVideo/courseVideo.dart';
import '../courseVideo/courseVideo_Controller.dart';
import '../courseVideo/pdfScreen.dart';
import '../quiz/quiz.dart';

class CourseContent extends StatefulWidget {
  @override
  State<CourseContent> createState() => _CourseContentState();
}

class _CourseContentState extends State<CourseContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CourseContentController controller = Get.find();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3,
        vsync: this); // Adjust length according to the number of tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Course"),
        ),
        body: Obx(() {
          if (controller.isloading.isTrue) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: six,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 16.0,
                          top: 16.0,
                          child: Image.network(
                            'https://via.placeholder.com/150',
                            width: 100,
                            height: 100,
                          ),
                        ),
                        Positioned(
                          right: 16.0,
                          top: 16.0,
                          child: Text(
                            controller.data.title,
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.white),
                          ),
                        ),
                        Positioned(
                          right: 16.0,
                          top: 60.0,
                          child: Text(
                            "Teacher : ${controller.data.teacher.name}",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.white),
                          ),
                        ),
                        Positioned(
                          left: 16.0,
                          top: 130.0,
                          child: Text(
                            controller.data.aboutTheCourse,
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: BottomSheetWidget(tabController: _tabController),
                ),
              ],
            );
          }
        }));
  }
}

class BottomSheetWidget extends StatelessWidget {
  final TabController tabController;
  BottomSheetWidget({required this.tabController});

  final List<String> yourStringList = [
    'first qu',
    'second qu',
    'third qu',
  ];

  final List<PDFFile> yourFileList = [
    PDFFile(
        name: 'first',
        size: 2,
        url:
            "https://freetestdata.com/wp-content/uploads/2022/11/Free_Test_Data_10.5MB_PDF.pdf"),
    PDFFile(name: 'second', size: 4, url: "https://link.testfile.org/PDF20MB"),
    PDFFile(name: 'third', size: 4, url: "https://link.testfile.org/PDF40MB"),
  ];

  @override
  Widget build(BuildContext context) {
    final CourseContentController controller = Get.find();
    DownloadsController controller2 = Get.put(DownloadsController());

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            labelColor: Colors.black, // Assuming you have defined this color
            controller: tabController,
            tabs: const [
              Tab(text: 'Videos'),
              Tab(text: 'Quiz'),
              Tab(text: 'Addons'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Center(
                  child: ListView.separated(
                    padding: EdgeInsets.all(10),
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: controller.data.units.length,
                    itemBuilder: (context, index) {
                      final unitState = UnitState();
                      return InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () => unitState.isTapped.toggle(),
                        onHighlightChanged: (value) =>
                            unitState.isExpanded(value),
                        child: Obx(() {
                          final validVideos = controller
                              .data.units[index].lectures
                              .where((lecture) =>
                                  lecture.videos?.title != null &&
                                  lecture.videos?.videoId != null)
                              .toList();

                          return AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            height: unitState.isTapped.value
                                ? (unitState.isExpanded.value ? 65 : 90)
                                : (unitState.isExpanded.value ? 225 : 230),
                            width: unitState.isExpanded.value ? 385 : 390,
                            decoration: BoxDecoration(
                              color: const Color(0xff6F12E8),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff6F12E8).withOpacity(0.5),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.data.units[index].title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Icon(
                                      unitState.isTapped.value
                                          ? Icons.keyboard_arrow_down
                                          : Icons.keyboard_arrow_up,
                                      color: Colors.white,
                                      size: 27,
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: validVideos.isEmpty
                                      ? Center(
                                          child: Text(
                                            'No videos',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: validVideos.length,
                                          itemBuilder: (context, subIndex) {
                                            final video =
                                                validVideos[subIndex].videos;

                                            return ListTile(
                                              title: Text(
                                                video!.title,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              subtitle: Text(
                                                'Duration: ${video.videoId.toString()}',
                                                style: TextStyle(
                                                    color: Colors.white70),
                                              ),
                                              onTap: () {
                                                Lecture lecture =
                                                    validVideos[subIndex];

                                                if (Get.currentRoute ==
                                                    '/CourseVideo') {
                                                  // If already on CourseVideo page, update the lecture
                                                  CourseVideoController
                                                      courseVideoController =
                                                      Get.find();
                                                  courseVideoController
                                                      .updateVideo(lecture);
                                                } else {
                                                  // Navigate to CourseVideo page
                                                  Get.to(() => CourseVideo(),
                                                      binding:
                                                          BindingsBuilder(() {
                                                    Get.put(
                                                        CourseVideoController(
                                                            initialLecture:
                                                                lecture));
                                                  }));
                                                }
                                              },
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
                Center(
                  child: ListView.separated(
                    padding: EdgeInsets.all(10),
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: controller.data.units.length,
                    itemBuilder: (context, index) {
                      final unitState = UnitState();
                      return InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () => unitState.isTapped.toggle(),
                        onHighlightChanged: (value) =>
                            unitState.isExpanded(value),
                        child: Obx(() {
                          final validQuizes = controller
                              .data.units[index].lectures
                              .where((lecture) =>
                                  lecture.questions != null &&
                                  lecture.questions.isNotEmpty)
                              .toList();

                          return AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            height: unitState.isTapped.value
                                ? (unitState.isExpanded.value ? 65 : 90)
                                : (unitState.isExpanded.value ? 225 : 230),
                            width: unitState.isExpanded.value ? 385 : 390,
                            decoration: BoxDecoration(
                              color: const Color(0xff6F12E8),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff6F12E8).withOpacity(0.5),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.data.units[index].title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Icon(
                                      unitState.isTapped.value
                                          ? Icons.keyboard_arrow_down
                                          : Icons.keyboard_arrow_up,
                                      color: Colors.white,
                                      size: 27,
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: validQuizes.isEmpty
                                      ? Center(
                                          child: Text(
                                            'No quizes',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: validQuizes.length,
                                          itemBuilder: (context, subIndex) {
                                            final quiz =
                                                validQuizes[subIndex].questions;

                                            return ListTile(
                                              title: Text(
                                                "Quiz ${quiz[0].lectureId.toString()}",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onTap: () {
                                                Get.to(() => QuizPage(),
                                                    arguments: quiz);
                                              },
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
                Center(
                  child: ListView.separated(
                    padding: EdgeInsets.all(10),
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: controller.data.units.length,
                    itemBuilder: (context, index) {
                      final unitState = UnitState();
                      return InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () => unitState.isTapped.toggle(),
                        onHighlightChanged: (value) =>
                            unitState.isExpanded(value),
                        child: Obx(() {
                          final validFiles = controller
                              .data.units[index].lectures
                              .where((lecture) =>
                                  lecture.pdf?.title != null &&
                                  lecture.pdf?.pdfId != null)
                              .toList();

                          return AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            height: unitState.isTapped.value
                                ? (unitState.isExpanded.value ? 65 : 90)
                                : (unitState.isExpanded.value ? 225 : 230),
                            width: unitState.isExpanded.value ? 385 : 390,
                            decoration: BoxDecoration(
                              color: const Color(0xff6F12E8),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff6F12E8).withOpacity(0.5),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.data.units[index].title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Icon(
                                      unitState.isTapped.value
                                          ? Icons.keyboard_arrow_down
                                          : Icons.keyboard_arrow_up,
                                      color: Colors.white,
                                      size: 27,
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: validFiles.isEmpty
                                      ? Center(
                                          child: Text(
                                            'No files',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: validFiles.length,
                                          itemBuilder: (context, subIndex) {
                                            final file =
                                                validFiles[subIndex].pdf;

                                            return ListTile(
                                              title: Text(
                                                file!.title,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              subtitle: Text(
                                                'Size: ${file.size.toString()}',
                                                style: TextStyle(
                                                    color: Colors.white70),
                                              ),
                                              trailing: IconButton(
                                                icon: Icon(Icons.download),
                                                onPressed: () async {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Download started! You can check progress in the download icon")));

                                                  // Start the download without waiting for it to finish
                                                  controller2.downloadPdf(
                                                      file.url, file.title);
                                                },
                                              ),
                                              onTap: () async {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext
                                                          context) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                );

                                                // Assuming `downloadPdf` now also handles opening the PDF after download
                                                File? downloadedFile =
                                                    await controller2
                                                        .downloadPdf(file.url,
                                                            file.title);

                                                Navigator.pop(
                                                    context); // Close the loading dialog

                                                if (downloadedFile != null) {
                                                  Get.to(() => PDFScreen(
                                                      path:
                                                          downloadedFile.path));
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Failed to open ${yourFileList[subIndex].name}")));
                                                }
                                              },
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UnitState {
  RxBool isTapped = true.obs;
  RxBool isExpanded = false.obs;

  UnitState({bool isTapped = true, bool isExpanded = false}) {
    this.isTapped.value = isTapped;
    this.isExpanded.value = isExpanded;
  }
}
