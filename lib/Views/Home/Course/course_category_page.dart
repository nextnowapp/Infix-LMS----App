// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

import 'package:get/get.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';
import 'package:lms_flutter_app/Controller/myCourse_controller.dart';
import 'package:lms_flutter_app/NewControllerAndModels/controllers/course_by_category_controller.dart';
import 'package:lms_flutter_app/Views/Home/Course/course_details_page/course_details_page.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyCourses/my_course_details_view/my_course_details_view.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/DefaultLoadingWidget.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';
import 'package:lms_flutter_app/utils/widgets/SingleCardItemWidget.dart';
import 'package:loader_overlay/loader_overlay.dart';

// ignore: must_be_immutable
class CourseCategoryPage extends StatelessWidget {
  String title;
  int catIndex;

  CourseCategoryPage(this.title, this.catIndex);

  double? width;
  double? percentageWidth;
  double? height;
  double? percentageHeight;
  final CourseByCategoryIdNewController _controller =
      Get.put(CourseByCategoryIdNewController());
  final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    // Fetch courses on widget build
    _controller.fetchCourses(catIndex);

    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidgetBuilder: (_) => defaultLoadingWidget,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBarWidget(
            showSearch: true,
            goToSearch: true,
            showBack: true,
            showFilterBtn: true,
          ),
          body: Obx(() {
            if (_controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else if (_controller.courses.isEmpty) {
              return Center(child: Text('No Data Available'));
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  mainAxisExtent: 210,
                ),
                itemCount: _controller.courses.length,
                itemBuilder: (context, index) {
                  final course = _controller.courses[index];
                  return SingleItemCardWidget(
                    showPricing: true,
                    image: course.image,
                    title: course.title,
                    price: course.price,
                    discountPrice: course.discountPrice,
                    onTap: () async {
                      context.loaderOverlay.show();

                      _homeController.courseID.value = course.id;
                      await _homeController.getCourseDetails();

                      if (_homeController.isCourseBought.value) {
                        final MyCourseController myCoursesController =
                            Get.put(MyCourseController());

                        myCoursesController.courseID.value = course.id;
                        myCoursesController.selectedLessonID.value = 0;
                        myCoursesController
                            .myCourseDetailsTabController.controller?.index = 0;

                        await myCoursesController.getCourseDetails();
                        Get.to(() => MyCourseDetailsView());
                        context.loaderOverlay.hide();
                      } else {
                        Get.to(() => CourseDetailsPage());
                        context.loaderOverlay.hide();
                      }
                    },
                  );
                },
              );
            }
          }),
        ),
      ),
    );
  }
}
