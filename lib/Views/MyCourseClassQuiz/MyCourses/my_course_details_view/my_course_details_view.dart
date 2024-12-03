// Dart imports:
import 'dart:math' as math;

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Package imports:

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/myCourse_controller.dart';
import 'package:lms_flutter_app/Controller/my_course_details_tab_controller.dart';
import 'package:lms_flutter_app/Service/permission_service.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyCourses/my_course_details_view/widgets/curriculum_widget.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyCourses/my_course_details_view/widgets/files_widget.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyCourses/my_course_details_view/widgets/questions_answer_widget.dart';

import 'package:lms_flutter_app/utils/SliverAppBarTitleWidget.dart';
import 'package:lms_flutter_app/utils/styles.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:octo_image/octo_image.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../../../utils/widgets/course_details_flexible_space_bar.dart';

// ignore: must_be_immutable
class MyCourseDetailsView extends StatefulWidget {
  @override
  _MyCourseDetailsViewState createState() => _MyCourseDetailsViewState();
}

class _MyCourseDetailsViewState extends State<MyCourseDetailsView> {
  final MyCourseController controller = Get.put(MyCourseController());
  GetStorage userToken = GetStorage();

  String tokenKey = "token";

  double width = 0;

  double percentageWidth = 0;

  double height = 0;

  double percentageHeight = 0;

  bool playing = false;

  String youtubeID = "";

  var progress = "${stctrl.lang["Download"]}";

  var received;

  math.Random random = math.Random();

  void initCheckPermission() async {
    final _handler = PermissionsService();
    await _handler.requestPermission(
      Permission.storage,
      onPermissionDenied: () => setState(
        () => debugPrint("Error: "),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initCheckPermission();
  }

  @override
  void dispose() {
    controller.commentController.text = "";
    controller.selectedLessonID.value = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyCourseDetailsTabController _tabx =
        Get.put(MyCourseDetailsTabController());

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // ignore: unused_local_variable
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;

    return Scaffold(
      body: SafeArea(
        child: LoaderOverlay(
          useDefaultLoading: false,
          overlayWidgetBuilder: (_) => Center(
            child: SpinKitPulse(
              color: Get.theme.primaryColor,
              size: 30.0,
            ),
          ),
          // overlayWidget: Center(
          //   child: SpinKitPulse(
          //     color: Get.theme.primaryColor,
          //     size: 30.0,
          //   ),
          // ),
          child: Obx(() {
            if (controller.isMyCourseLoading.value)
              return Center(
                child: CupertinoActivityIndicator(),
              );
            return NestedScrollView(
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
                              '${controller.myCourseDetails.value.title ?? controller.myCourseDetails.value.title}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Get.textTheme.titleMedium?.copyWith(
                                color: Get.textTheme.titleMedium?.color,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        background: CourseDetailsFlexilbleSpaceBar(
                            controller.myCourseDetails.value)),
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
                    // padding: EdgeInsets.zero,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabx.controller,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        curriculumWidget(controller, percentageHeight),
                        filesWidget(controller),
                        questionsAnswerWidget(controller, percentageWidth),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  String getExtention(String url) {
    var parts = url.split("/");
    return parts[parts.length - 1];
  }
}
