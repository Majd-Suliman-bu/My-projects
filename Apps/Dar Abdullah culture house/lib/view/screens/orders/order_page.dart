import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_app/constant/sizes.dart';
import 'package:worker_app/view/widget/order_card.dart';
import 'orders_contrller.dart';

Widget buildOrderList(Sizes size) {
   OrderController controller=Get.find();
  return GetBuilder<OrderController>(builder: (context) {
    return ListView.builder(
        itemCount: controller.finalListData.length,
        itemBuilder: ((context, index) => orderCard(
           controller,index,
            context,
            size,
            )));
  });
}
