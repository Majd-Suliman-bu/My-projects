import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String courseName;
  final String courseImage;
  final Function()? onTap;

  const CourseCard(
      {required this.courseName,
      required this.courseImage,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double boxImageSize =
        ((MediaQuery.of(context).size.width) - 24) / 2 - 12;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap!();
      },
      child: Container(

        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  courseImage,
                  width: boxImageSize,
                  height: boxImageSize,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseName,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
