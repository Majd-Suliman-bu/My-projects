import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:syrian_electronic_school/modules/courseContent/courseContent_controller.dart';
import 'package:syrian_electronic_school/modules/downloads.dart/downloads.dart';
import 'package:syrian_electronic_school/modules/downloads.dart/downloads_controller.dart';
import '../../models/file.dart';
import '../../models/video.dart';
import '../courseContent/courseContent.dart';
import 'courseVideo_Controller.dart';
import 'pdfScreen.dart';

class CourseVideo extends StatelessWidget {
  CourseVideoController controller = Get.find();
  DownloadsController controller3 = Get.put(DownloadsController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            _buildVideoPlayer(context),
            Row(
              children: [
                TextButton(
                    onPressed: () => Get.toNamed('/Downloads'),
                    child: Text('Downlaods')),
                TextButton(
                    onPressed: () => Get.toNamed('/LocalFiles'),
                    child: Text('LocalFiles')),
              ],
            ),
            Expanded(
                child:
                    BottomSheetWidget(tabController: controller.tabController))
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red,
      title: Text('Course Video page', style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: Icon(Icons.download),
          onPressed: () {
            Get.to(() => Downloads());
          },
        ),
      ],
    );
  }

  Widget _buildVideoPlayer(BuildContext context) {
    return Column(
      children: [
        Obx(() => Container(
              key: controller.uniqueKey.value,
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: controller.flickManager.value != null
                  ? FlickVideoPlayer(
                      flickManager: controller.flickManager.value!)
                  : Center(child: CircularProgressIndicator()),
            )),
        SizedBox(
          height: 20,
        ),
        Obx(() {
          var currentLecture = controller.currentLecture.value;
          return controller.flickManager.value != null
              ? Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentLecture!.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            currentLecture.lectureId
                                .toString(), // Static duration for now
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Get.snackbar('Download started',
                              'You can monitor the progress through the download icon in the appbar',
                              backgroundColor: Colors.green,
                              snackPosition: SnackPosition.TOP);
                          try {
                            await controller3.downloadVideo(
                                currentLecture.videos!.url,
                                currentLecture.title);
                          } catch (e) {
                            if (e == 'Download cancelled') {
                              Get.snackbar('Download cancelled',
                                  'The download was cancelled.',
                                  backgroundColor: Colors.red,
                                  snackPosition: SnackPosition.TOP);
                            } else {
                              Get.snackbar('Download error',
                                  'An error occurred during the download.',
                                  backgroundColor: Colors.red,
                                  snackPosition: SnackPosition.TOP);
                            }
                          }
                        },
                        child: Text('Download'),
                      )
                    ],
                  ),
                )
              : Container();
        }),
      ],
    );
  }
}
