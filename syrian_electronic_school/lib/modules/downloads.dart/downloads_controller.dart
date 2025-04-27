import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var videoDownloads =
      <String, double>{}.obs; // Map to track video download progress
  var pdfDownloads =
      <String, double>{}.obs; // Map to track PDF download progress
  var videoDownloadNames =
      <String, String>{}.obs; // Map to track video download names
  var pdfDownloadNames =
      <String, String>{}.obs; // Map to track PDF download names
  var videoDownloadCancelTokens = <String, StreamController<void>>{}
      .obs; // Map to track video download cancel tokens
  var pdfDownloadCancelTokens =
      <String, CancelToken>{}.obs; // Map to track PDF download cancel tokens

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    requestStoragePermission();
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<File?> downloadPdf(String url, String name) async {
    try {
      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // Get the directory to save the file
      final dir = await getApplicationDocumentsDirectory();
      final pdfDir = Directory("${dir.path}/PdfFiles");

      if (!await pdfDir.exists()) {
        await pdfDir.create(recursive: true);
      }

      final filename = url.split('/').last;
      final filePath = "${pdfDir.path}/$filename";

      // Initialize download tracking
      pdfDownloads[url] = 0.0;
      pdfDownloadNames[url] = name;
      var cancelToken = CancelToken();
      pdfDownloadCancelTokens[url] = cancelToken;

      // Download the file
      Dio dio = Dio();
      Completer<File> completer = Completer<File>();

      dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (cancelToken.isCancelled) return;
          if (total != -1) {
            pdfDownloads[url] = received / total;
            print("PDF Download progress: ${pdfDownloads[url]}");
          }
        },
        cancelToken: cancelToken,
      ).then((_) async {
        if (cancelToken.isCancelled) return;
        print("PDF saved to $filePath");
        pdfDownloads.remove(url);
        pdfDownloadNames.remove(url);
        pdfDownloadCancelTokens.remove(url);
        completer.complete(File(filePath));
      }).catchError((e) {
        if (cancelToken.isCancelled) return;
        print("Error downloading PDF: $e");
        pdfDownloads.remove(url);
        pdfDownloadNames.remove(url);
        pdfDownloadCancelTokens.remove(url);
        completer.completeError(e);
      });

      return completer.future;
    } catch (e) {
      print("Error downloading PDF: $e");
      return null;
    }
  }

  Future<void> downloadVideo(String url, String name) async {
    try {
      final Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();
      String appDocPath = appDocumentsDir.path;
      String videoDirPath = '$appDocPath/Videos';
      String filePath = '$videoDirPath/${url.split('/').last}';

      final directory = Directory(videoDirPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
        print("Directory created: $videoDirPath");
      }

      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      List<int> bytes = [];
      int downloaded = 0;
      int total = response.contentLength!;
      Completer<void> completer = Completer<void>();
      bool isCancelled = false;

      videoDownloads[url] = 0.0;
      videoDownloadNames[url] = name;
      var cancelToken = StreamController<void>();
      videoDownloadCancelTokens[url] = cancelToken;

      response.listen(
        (List<int> newBytes) {
          if (isCancelled) return;
          bytes.addAll(newBytes);
          downloaded += newBytes.length;
          videoDownloads[url] = downloaded / total;
          print("Download progress: ${videoDownloads[url]}");
        },
        onDone: () async {
          if (isCancelled) return;
          File file = File(filePath);
          await file.writeAsBytes(bytes, flush: true);
          print("Video saved to $filePath");
          videoDownloads.remove(url);
          videoDownloadNames.remove(url);
          videoDownloadCancelTokens.remove(url);
          completer.complete();
        },
        onError: (e) {
          if (isCancelled) return;
          print("Error downloading video: $e");
          videoDownloads.remove(url);
          videoDownloadNames.remove(url);
          videoDownloadCancelTokens.remove(url);
          completer.completeError(e);
        },
        cancelOnError: true,
      );

      cancelToken.stream.listen((_) {
        isCancelled = true;
        response.detachSocket().then((socket) {
          socket.destroy();
          videoDownloads.remove(url);
          videoDownloadNames.remove(url);
          videoDownloadCancelTokens.remove(url);
          completer.completeError('Download cancelled');
        });
      });

      return completer.future;
    } catch (e) {
      if (e == 'Download cancelled') {
        print("Download cancelled: $url");
      } else {
        print("Error downloading video: $e");
      }
      return null;
    }
  }

  void cancelDownload(String url, bool isVideo) {
    if (isVideo) {
      videoDownloadCancelTokens[url]?.add(null);
      videoDownloads.remove(url); // Remove from videoDownloads
      videoDownloadNames.remove(url); // Remove from videoDownloadNames
      videoDownloadCancelTokens
          .remove(url); // Remove from videoDownloadCancelTokens
    } else {
      pdfDownloadCancelTokens[url]?.cancel("Download cancelled");
      pdfDownloads.remove(url); // Remove from pdfDownloads
      pdfDownloadNames.remove(url); // Remove from pdfDownloadNames
      pdfDownloadCancelTokens
          .remove(url); // Remove from pdfDownloadCancelTokens
    }
  }
}
