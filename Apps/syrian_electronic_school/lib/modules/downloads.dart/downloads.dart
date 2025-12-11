import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/constant.dart';
import 'downloads_controller.dart';

class Downloads extends StatelessWidget {
  final DownloadsController controller = Get.put(DownloadsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: red,
        title: Text('Downloads'),
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.video_library), text: "Videos"),
            Tab(icon: Icon(Icons.picture_as_pdf), text: "PDFs"),
          ],
          controller: controller.tabController,
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          Obx(() {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: controller.videoDownloads.entries.map((entry) {
                  String name =
                      controller.videoDownloadNames[entry.key] ?? 'Unknown';
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircularProgressIndicator(
                        value: entry.value,
                      ),
                      title: Text(
                        "$name: ${(entry.value * 100).toStringAsFixed(0)}% completed",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          controller.cancelDownload(entry.key, true);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
          Obx(() {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: controller.pdfDownloads.entries.map((entry) {
                  String name =
                      controller.pdfDownloadNames[entry.key] ?? 'Unknown';
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircularProgressIndicator(
                        value: entry.value,
                      ),
                      title: Text(
                        "$name: ${(entry.value * 100).toStringAsFixed(0)}% completed",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          controller.cancelDownload(entry.key, false);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
