// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';

class ClassDetailsTabController extends GetxController with GetTickerProviderStateMixin {
  var myTabs;

  TabController? controller;

  @override
  void onInit() {
    super.onInit();
    myTabs = <Tab>[
      // Tab(text: "${stctrl.lang["Schedule"]}"),
      // Tab(text: "${stctrl.lang["Instructor"]}"),
      // Tab(text: "${stctrl.lang["Reviews"]}"),

      Tab(
        child: Container(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: Text("${stctrl.lang["Schedule"]}"),
        ),
      ),

      Tab(
        child: Container(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: Text("${stctrl.lang["Instructor"]}"),
        ),
      ),

      Tab(
        child: Container(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: Text("${stctrl.lang["Reviews"]}"),
        ),
      ),

    ];
    controller = TabController(vsync: this, length: myTabs.length,initialIndex: 0);
  }

  @override
  void onClose() {
    controller?.dispose();
    super.onClose();
  }
}
