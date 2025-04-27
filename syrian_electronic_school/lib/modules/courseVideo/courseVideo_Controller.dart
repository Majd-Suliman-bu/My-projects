import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flick_video_player/flick_video_player.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../models/Course.dart';
import '../../models/encryptParams.dart';

class CourseVideoController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final RxBool isExpanded = false.obs;
  Rxn<FlickManager> flickManager = Rxn<FlickManager>();
  var uniqueKey = UniqueKey().obs;
  var currentLecture = Rxn<Lecture>();
  late TabController tabController;

  void toggleExpansion() {
    isExpanded.value = !isExpanded.value;
  }

  CourseVideoController({Lecture? initialLecture}) {
    if (initialLecture != null) {
      currentLecture.value = initialLecture;
      flickManager.value = FlickManager(
        videoPlayerController:
            VideoPlayerController.network(initialLecture.videos!.url),
        autoPlay: false,
      );
    } else {
      flickManager.value = FlickManager(
        videoPlayerController: VideoPlayerController.network(''),
        autoPlay: false,
      );
    }
  }

  void playVideo(String url) {
    currentLecture.value!.videos!.url = url;
    flickManager.value?.handleChangeVideo(VideoPlayerController.network(url));
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    requestStoragePermission();
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    flickManager.value
        ?.dispose(); // Use the null-aware operator to safely call dispose
    super.onClose();
  }

  void updateVideo(Lecture lecture) {
    currentLecture.value = lecture; // Update the current video URL
    flickManager.value?.dispose(); // Dispose the current FlickManager
    print(lecture.videos!.url);
    flickManager.value = FlickManager(
      videoPlayerController: VideoPlayerController.network(lecture.videos!.url),
      autoPlay: true, // Automatically play the new video
    );
    uniqueKey.value =
        UniqueKey(); // Update the unique key to force widget rebuild
  }
}
