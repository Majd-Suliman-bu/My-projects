import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_medical_clinic/config/server_config.dart';
import 'package:smart_medical_clinic/main.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/view/screens/chat_page.dart';

Widget getImageNetwork({
  required String url,
  required double? width,
  required double? height,
  Color color = Colors.transparent,
  Color? imageColor,
  BoxFit fit = BoxFit.cover,
  bool needAErrorBackgroundColor = true,
  bool fromBackEnd = true,
}) {
  // return const SizedBox();
  if (fromBackEnd) {
    url = ServerConfig.imageurl + url;
  }

  return Container(
    width: width,
    color: color,
    height: height,
    child: Image.network(
      url,
      color: imageColor,
      alignment: Alignment.center,
      fit: fit,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null ||
            loadingProgress.expectedTotalBytes == null) {
          return child; // Image is loaded or the total size is not determined.
        }
        if (loadingProgress.cumulativeBytesLoaded <
            loadingProgress.expectedTotalBytes!) {
          return buildLoadingShimmer(
              width ?? responsiveUtil.screenWidth,
              height ??
                  responsiveUtil
                      .screenHeight); // Show shimmer when image is loading
        }
        return child; // Image has finished loading
      },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        print('the error while opening the image: $error');
        return buildErrorBody(needAErrorBackgroundColor, width, height);
      },
    ),
  );
}

Shimmer buildLoadingShimmer(double? width, double? height) {
  return Shimmer.fromColors(
    baseColor: Colors.black,
    highlightColor: Colors.black54,
    child: Container(
      width: width,
      height: height,
      color: Colors.black54,
    ),
  );
}

Container buildErrorBody(
    bool needAErrorBackgroundColor, double? width, double? height) {
  return Container(
    color: needAErrorBackgroundColor ? Colors.black : null,
    width: width,
    height: height,
    child: const Center(
      child: Icon(
        Icons.error,
      ),
    ),
  );
}
