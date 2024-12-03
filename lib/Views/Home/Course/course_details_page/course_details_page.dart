// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/course_details_tab_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';

import 'package:lms_flutter_app/Service/iap_service.dart';
import 'package:lms_flutter_app/Views/Home/Course/course_details_page/widgets/curriculum_widget.dart';
import 'package:lms_flutter_app/Views/Home/Course/course_details_page/widgets/description_widget.dart';
import 'package:lms_flutter_app/Views/Home/Course/course_details_page/widgets/review_widget.dart';

import 'package:lms_flutter_app/utils/SliverAppBarTitleWidget.dart';
import 'package:lms_flutter_app/utils/styles.dart';
import 'package:lms_flutter_app/utils/widgets/course_details_flexible_space_bar.dart';
import 'package:loader_overlay/loader_overlay.dart';

// ignore: must_be_immutable
class CourseDetailsPage extends StatefulWidget {
  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  GetStorage userToken = GetStorage();

  String tokenKey = "token";

  double width = 0;

  double percentageWidth = 0;

  double height = 0;

  double percentageHeight = 0;

  bool isReview = false;

  bool isSignIn = true;

  bool playing = false;

  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    if (Platform.isIOS) {
      controller.isPurchasingIAP.value = false;
      IAPService().initPlatformState();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.put(DashboardController());

    final CourseDetailsTabController _tabx =
        Get.put(CourseDetailsTabController());

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // ignore: unused_local_variable
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;

    return Scaffold(
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidgetBuilder: (_) => Center(
          child: SpinKitPulse(
            color: Get.theme.primaryColor,
            size: 30.0,
          ),
        ),
        child: Obx(() {
          if (controller.isCourseLoading.value)
            return Center(
              child: CupertinoActivityIndicator(),
            );
          return NestedScrollView(
            // floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 280.0,
                  automaticallyImplyLeading: false,
                  titleSpacing: 20,
                  title: SliverAppBarTitleWidget(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Icon(
                            Icons.arrow_back_outlined,
                            color: Get.textTheme.titleMedium?.color,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            controller.courseDetails.value.title ??
                                "${controller.courseDetails.value.title}",
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
                          controller.courseDetails.value)),
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
                      descriptionWidget(
                          controller: controller,
                          dashboardController: dashboardController,
                          context: context,
                          percentageHeight: percentageHeight,
                          percentageWidth: percentageWidth),
                      curriculumWidget(controller, dashboardController),
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
      ),
    );
  }
}
