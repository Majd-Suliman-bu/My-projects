import 'package:flutter/material.dart';

RefreshIndicator customRefreshIndicator(
    Future<void> Function() onRefresh, Widget child) {
  return RefreshIndicator(
      backgroundColor: Colors.white,
      color: Colors.black,
      onRefresh: onRefresh,
      child: child);
}
