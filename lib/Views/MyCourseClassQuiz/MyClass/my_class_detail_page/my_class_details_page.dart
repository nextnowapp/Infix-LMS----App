// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/class_controller.dart';
import 'package:lms_flutter_app/Controller/class_details_tab_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyClass/my_class_detail_page/widgets/instructor_widget.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyClass/my_class_detail_page/widgets/review_widget.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyClass/my_class_detail_page/widgets/schedule_widget.dart';

import 'package:lms_flutter_app/utils/SliverAppBarTitleWidget.dart';
import 'package:lms_flutter_app/utils/styles.dart';

import '../../../../utils/widgets/course_details_flexible_space_bar.dart';

// ignore: must_be_immutable
class MyClassDetailsPage extends StatelessWidget {
  final DashboardController dashboardController =
      Get.put(DashboardController());
  GetStorage userToken = GetStorage();

  String tokenKey = "token";

  double width = 0;

  double percentageWidth = 0;

  double height = 0;

  double percentageHeight = 0;

  bool isReview = false;

  bool isSignIn = true;

  bool playing = false;

  @override
  Widget build(BuildContext context) {
    final ClassController controller = Get.put(ClassController());

    final DashboardController dashboardController =
        Get.put(DashboardController());

    final ClassDetailsTabController _tabx =
        Get.put(ClassDetailsTabController());

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // ignore: unused_local_variable
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;

    return Scaffold(
      body: Obx(() {
        if (controller.isClassLoading.value)
          return Center(
            child: CupertinoActivityIndicator(),
          );

        return NestedScrollView(
          // floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 280.0,
                automaticallyImplyLeading: false,
                titleSpacing: 20,
                title: SliverAppBarTitleWidget(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.classDetails.value.title ??
                              controller.classDetails.value.title!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Get.textTheme.titleMedium,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: CourseDetailsFlexilbleSpaceBar(
                        controller.classDetails.value)),
              ),
            ];
          },
          // pinnedHeaderSliverHeightBuilder: () {
          //   return pinnedHeaderHeight;
          // },
          body: Column(
            children: <Widget>[
              TabBar(
                labelColor: Colors.white,
                tabs: _tabx.myTabs,
                unselectedLabelColor: AppStyles.unSelectedTabTextColor,
                controller: _tabx.controller,
                indicator: Get.theme.tabBarTheme.indicator,
                automaticIndicatorColorAdjustment: true,
                isScrollable: false,
                labelStyle: Get.textTheme.titleSmall,
                unselectedLabelStyle: Get.textTheme.titleSmall,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabx.controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    scheduleWidget(
                        controller: controller,
                        dashboardController: dashboardController,
                        tokenKey: tokenKey,
                        userToken: userToken),
                    instructorWidget(
                        controller: controller,
                        dashboardController: dashboardController,
                        percentageWidth: percentageWidth),
                    reviewWidget(
                        controller: controller,
                        dashboardController: dashboardController,
                        percentageHeight: percentageHeight,
                        percentageWidth: percentageWidth,
                        tokenKey: tokenKey,
                        userToken: userToken),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
