import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import '../../component/DrawerV2.dart';
import '../../config/constant.dart';
import '../courseVideo/pdfScreen.dart';
import 'localFiles_controller.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class LocalFiles extends StatefulWidget {
  const LocalFiles({super.key});

  @override
  State<LocalFiles> createState() => _LocalFilesState();
}

class _LocalFilesState extends State<LocalFiles>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final LocalFilesController controller =
      Get.put(LocalFilesController()); // Your controller for LocalFiles

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            pinned: true,
            expandedHeight: 160.0,
            backgroundColor: red,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Downloaded List"),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                tabs: const [
                  Tab(text: 'Local Videos'),
                  Tab(text: 'Local Documents'),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildVideosTab(), // Adapted from MyFiles
                buildPdfTab(), // Adapted from MyFiles
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Adapted from MyFiles, assuming controller setup is similar
  Widget buildPdfTab() {
    return Obx(() => ListView.builder(
          itemCount: controller.pdfFiles.length,
          itemBuilder: (context, index) {
            final file = controller.pdfFiles[index] as File;
            return ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text(file.path.split('/').last),
              onTap: () {
                Get.to(() => PDFScreen(path: file.path));
              },
            );
          },
        ));
  }

  // Adapted from MyFiles, assuming controller setup is similar
  Widget buildVideosTab() {
    return Obx(() => ListView.builder(
          itemCount: controller.videoFiles.length,
          itemBuilder: (context, index) {
            final file = controller.videoFiles[index] as File;
            return ListTile(
              leading: Icon(Icons.video_library),
              title: Text(file.path.split('/').last),
              onTap: () {
                showVideoPlayerOverlay(context, file.path);
              },
            );
          },
        ));
  }

  // Ensure this function is accessible within LocalFiles
  void showVideoPlayerOverlay(BuildContext context, String videoPath) async {
    _showLoadingOverlay(context); // Show loading overlay

    // Directly create a FlickManager with the video file
    FlickManager flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(File(videoPath)),
    );

    // Show the video player dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            child: FlickVideoPlayer(flickManager: flickManager),
          ),
        );
      },
    ).then((_) {
      flickManager.dispose();
      Navigator.of(context).pop(); // Remove loading overlay
    });
  }

  void _showLoadingOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // User must not dismiss the dialog by tapping outside of it
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async =>
              false, // Prevent back button from closing the dialog
          child: SimpleDialog(
            backgroundColor: Colors.black54,
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(), // Loading circle
                    SizedBox(height: 20), // Space between the circle and text
                    Text("Loading", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  _TabBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Colors.white, // Set the background color of the TabBar
      child: child,
    );
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
