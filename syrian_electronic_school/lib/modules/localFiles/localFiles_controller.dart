import 'dart:io';
import 'dart:isolate';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import './localFiles_service.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class LocalFilesController extends GetxController {
  LocalFilesservice service = LocalFilesservice();
  var pdfFiles = <FileSystemEntity>[].obs;
  var videoFiles = <FileSystemEntity>[].obs;

  var isloading = true.obs;

  void onReady() async {
    isloading(false);

    super.onReady();
  }

  @override
  void onInit() async {
    super.onInit();
    await checkAndCreateDirectories();
    listPdfFiles();
    listVideoFiles();
  }

  Future<void> checkAndCreateDirectories() async {
    final baseDir = await getApplicationDocumentsDirectory();
    final pdfDirPath = '${baseDir.path}/PdfFiles';
    final videoDirPath = '${baseDir.path}/Videos';

    await _createDirectoryIfNotExists(pdfDirPath);
    await _createDirectoryIfNotExists(videoDirPath);
  }

  Future<void> _createDirectoryIfNotExists(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
      print("Directory created: $path");
    }
  }

  Future<void> listPdfFiles() async {
    final dir =
        await getApplicationDocumentsDirectory(); // Changed to use application documents directory
    final pdfDir = Directory("${dir.path}/PdfFiles");
    print('Here comes the path : ');
    print(pdfDir);
    final files =
        pdfDir.listSync().where((item) => item.path.endsWith('.pdf')).toList();
    pdfFiles.assignAll(files);
  }

  Future<void> listVideoFiles() async {
    final dir =
        await getApplicationDocumentsDirectory(); // Changed to use application documents directory
    final videoDir = Directory("${dir.path}/Videos");
    print("Directory ::: :: ");
    print(videoDir);
    if (!videoDir.existsSync()) {
      // If the directory does not exist, you might want to handle this case.
      print("Directory does not exist");
      return;
    }
    final files = videoDir
        .listSync()
        .where((item) =>
            item.path.endsWith('.mp4') ||
            item.path.endsWith('.mov') ||
            item.path.endsWith('.webm') ||
            item.path.endsWith('.MP4'))
        .toList();
    videoFiles.assignAll(files);
    print("Videos showing now : ");
    print(videoFiles.length);
  }
}
