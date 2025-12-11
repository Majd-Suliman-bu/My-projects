import 'dart:math';

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_medical_clinic/main.dart';

Widget followingPageshimmer(PreferredSize f) {
  return Scaffold(
    backgroundColor: Colors.blue,
    appBar: f,
    body: Column(
      children: [
        Expanded(
          child: Shimmer.fromColors(
              baseColor: Colors.black,
              highlightColor: Colors.blue,
              child: ListView.builder(
                  itemCount: 10, // Number of shimmer items
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 12, right: 12, bottom: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        height: 200, // Adjust based on your content
                      ),
                    );
                  })),
        ),
      ],
    ),
  );
}

Widget buildListOfShimmerForProfilePage() {
  return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.blue,
      child: ListView.builder(
          itemCount: 10, // Number of shimmer items
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 12, right: 12, bottom: 15),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                height: 120, // Adjust based on your content
              ),
            );
          }));
}

Widget buildListOfShimmerForViewAllPage() {
  return Column(
      children:
          List.generate(8, (index) => generalElementForEachCardShimmer()));
}

Widget mediumSizeCardShimmer() {
  return Column(
    children: [
      Expanded(
        child: Shimmer.fromColors(
            baseColor: Colors.black,
            highlightColor: Colors.blue,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(6, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      height: 160, // Adjust based on your content
                    ),
                  );
                }),
              ),
            )),
      ),
    ],
  );
}

Widget smallSizeCardShimmer() {
  return Column(
    children: [
      Expanded(
        child: Shimmer.fromColors(
            baseColor: Colors.black,
            highlightColor: Colors.blue,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(6, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),

                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    height: 100, // Adjust based on your content
                  );
                }),
              ),
            )),
      ),
    ],
  );
}

Widget imageWithNameShimmer() {
  return SizedBox(
    width: double.infinity,
    height: responsiveUtil.scaleHeight(60),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: responsiveUtil.scaleWidth(10)),
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          width: 150, // Adjust the width as needed
          height: 20,
          // color: customColors.secondaryBackGround,
        ),
      ],
    ),
  );
}

Widget messageShimmer(bool isFirstMessage, bool isSender) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.blue,
      child: BubbleSpecialOne(
        text: generateRandomEmptyString(),
        textStyle: const TextStyle(color: Colors.transparent), // Hide text
        tail: isFirstMessage,
        // color: customColors.secondaryBackGround,

        isSender: isSender,
      ),
    ),
  );
}

String generateRandomEmptyString() {
  Random random = Random();
  int length =
      random.nextInt(10) + 5; // Generate a random length between 1 and 20
  return '         ' * length; // Fill the string with spaces
}

Widget messageListShimmer() {
  return ListView.builder(
    itemCount: 10,
    itemBuilder: (context, index) {
      bool isFirstMessage = index == 0 || index == 6;
      bool isSender = index > 5;
      return messageShimmer(isFirstMessage, isSender);
    },
  );
}

Widget generalElementForEachCardShimmer() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.blue,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: customColors.secondaryBackGround,
        ),
        width: double.infinity,
        height: responsiveUtil.scaleHeight(150),
      ),
    ),
  );
}
