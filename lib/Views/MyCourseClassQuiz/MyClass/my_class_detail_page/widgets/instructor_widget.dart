import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/class_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/widgets/StarCounterWidget.dart';

Widget instructorWidget(
    {required ClassController controller,
    required DashboardController dashboardController,
    required double percentageWidth}) {
  return ExtendedVisibilityDetector(
    uniqueKey: const Key('Tab1'),
    child: Scaffold(
      body: Container(
        width: percentageWidth * 100,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundColor: Color(0xFFD7598F),
              backgroundImage: controller.classDetails.value.user?.avatar
                          ?.contains('public/') ??
                      false
                  ? NetworkImage(
                      '${controller.classDetails.value.user?.avatar}')
                  : NetworkImage(
                      controller.classDetails.value.user?.avatar ?? '',
                    ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  cartTotal('${controller.classDetails.value.user?.name}'),
                  courseStructure(
                    (controller.classDetails.value.user?.headline == null
                            ? ''
                            : controller.classDetails.value.user?.headline) ??
                        '',
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  StarCounterWidget(
                    value: controller.classDetails.value.user?.totalRating
                            ?.toDouble() ??
                        0,
                    color: Color(0xffFFCF23),
                    size: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  courseStructure(
                    (controller.classDetails.value.user?.about == null
                            ? ''
                            : controller.classDetails.value.user?.about) ??
                        '',
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
